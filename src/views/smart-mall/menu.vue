<template>
    <div class="Page-menu-index2">
        <div v-show="showMore" class="classBox">
            <div class="close-class-box">
                <img src="@/assets/images/icon-login-8.png" alt="" @click="showMore=false">
            </div>
            <div class="class-label">
                <span v-for="(item, index) in activeTabsList" :key="index" :class="activeTabs === index ? 'activeLabel' : ''" @click="clickTabs(index)">{{ item.className }}</span>
            </div>
        </div>
        <div class="search-input">
            <router-link :to="'/smart-mall/index'"><img src="../../assets/images/icon-goback-b.png" alt=""></router-link>
            <van-field :value="value" :clearable="true" left-icon="search" placeholder="商品名/首字母/商品ID/厂家/标签/商标" :border="false" @focus="goSearch" />
            <van-icon class-prefix="iconfont icon-gouwuche" @click="goCart" />
        </div>
        
        <div class="classification-box">
            <ul class="all-class-box" :style="[{'height': height-100 + 'px'}]">
                <li
                    v-for="(item, ind) in allClass"
                    :key="item.className"
                    :class="['first-class', item.isOpen?'active-first-class':'other-first-class']"
                >
                    <p
                        :class="['p',(item.active && item.isOpen)?'open-first':'', (item.active && !item.isOpen) ?'checked-first':'']"
                        @click="selectFirst(item, ind)"
                    >{{ item.className }}</p>
                    <div v-show="item.isOpen">
                        <div
                            v-for="secondItem in item.childrenList"
                            :key="secondItem.className"
                            :class="['div', secondItem.isOpen?'active':'']"
                            @click="selectSecond(item.sid, secondItem)"
                        >
                            {{ secondItem.className }}
                            <i v-if="secondItem.isOpen" class="img" />
                        </div>
                        <p v-if="item.childrenList&&item.childrenList.length" class="bottom-shadow" />
                    </div>
                </li>
                <li style="width:1.6rem;flex:1;background: #F3F4F6;" />
            </ul>
            <div class="goods-list-box">
                <div class="sort-box">
                    <div v-for="(item, index) in sortText" :key="index" :class="ischecked === index ? 'row checked-row' : 'row'" @click="checkRow(index)">
                        <p>{{ item }}</p>
                        <p v-if="index === 1 " class="triangle-box">
                            <span>
                                <img v-if="ischecked !== index" src="@/assets/images/icon-grey.png">
                                <div v-if="ischecked === index" class="icon" />
                            </span>
                        </p>
                        <p v-if="index === 2 " class="triangle-box">
                            <span :class="(ischecked === index && !sortTop) ? 'triangle triangle-top triangle-top-red' : 'triangle triangle-top'" />
                            <span :class="(ischecked === index && sortTop) ? 'triangle triangle-bottom triangle-bottom-red' : 'triangle triangle-bottom'" />
                        </p>
                        <p v-if="index === 3 " class="triangle-box">
                            <span :class="(ischecked === index ) ? 'triangle triangle-left triangle-left-red' : 'triangle triangle-left'" />
                        </p>
                    </div>
                </div>
                <div id="scrollView" class="scroll-view" :style="[{'height': height-153 + 'px'}]" @scroll="handleScroll($event)">
                    <div v-if="scrollLoding && goodsList.length === 0" class="doge">
                        <van-loading size="24px">加载中...</van-loading>
                    </div>
                    <template v-if="goodsList.length != 0">
                        <p v-if="prevSecondClassObj && moveDirection === 'down'" class="prev-text">下滑进入{{ prevSecondClassObj.className }}</p>
                        <van-list id="goodsList" v-model="loading" :finished="finished" :finished-text="'我是有底线的哦！'" :offset="50" @load="onLoad">
                            <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :card-type="'menu'" :current-type="1" :theme="'theme-1'" />
                        </van-list>
                        <p v-if="finished" class="prev-text">上滑进入{{ nextSecondClassObj.className }}</p>
                    </template>
                    <template v-else-if="goodsList.length === 0 && !loading && noPage">
                        <div v-if="refreshFlag" class="no-data">
                            <img src="@/assets/images/refresh.png">
                            <span>数据获取失败，请尝试刷新!</span>
                            <van-button @click="resh"><p>重新刷新</p></van-button>       
                        </div>
                        <div v-if="!refreshFlag" class="no-data">
                            <img src="@/assets/images/emptyCart.png">
                            <span>暂无商品！</span>       
                        </div>
                    </template>
                </div>
                <pagination ref="refPagination" :current="current" :dom-div="'scroll-view'" />
            </div>
        </div>
        <van-tabbar
            v-model="activeTabbar"
            class="smart-mall-tabbar"
            :active-color="activeColor"
            inactive-color="#999999"
        >
            <van-tabbar-item
                v-for="item in tabbarData"
                :key="item.id"
                :to="item.linkUrl"
                :info="item.info === 0 ? '' : item.info"
            >
                <span>{{ item.tabbarName }}</span>
                <img slot="icon" slot-scope="props" :src="props.active ? item.icon.active : item.icon.normal">
            </van-tabbar-item>
        </van-tabbar>
        <div class="bottom" />
        <win-screen
            ref="refScreen"
            :popup="popup"
            :label-list-facet="labelListFacet"
            @closePopup="closePopup"
            @save="saveValue"
        />
    </div>
</template>
<script>
import productCard from '@/components/productCard/index'
import Api from '@/api/smart-mall/menu'
import pagination from '@/components/pagination/index'
import { comfirmPage } from '@/utils/util'
import winScreen from '@/views/menu/dialog/index.vue'
// import { Toast } from 'vant'

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'Menu',
    components: {
        productCard,
        pagination,
        winScreen
    },
    data() {
        return {
            active: 0,
            activeTabs: 0,
            activeTabsList: [],
            list: [],
            goodsList: [],
            noMoreData: false,
            loading: false,
            finished: false,
            refreshFlag: false,
            activeTabbar: 1,
            /*  tabbarData: [
                {
                    tabbarName: '首页',
                    linkUrl: '/smart-mall',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-' + (this.currentClub + 1)  + '.png'
                    },
                    info: 0
                },
                {
                    tabbarName: '分类',
                    linkUrl: '/smart-mall/menu',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-' + (this.currentClub + 1) + '.png'
                    },
                    info: 0
                }
            ], */
            page: 1,
            sid: 0,
            ischecked: 0,
            sortTop: true,
            isAll: true,
            sortText: [
                '综合',
                '销量',
                '首字母',
                '筛选'
            ],
            showMore: false,
            noPage: false,
            scrollLoding: false,
            scrollHeight: 0,
            currentPage: [],
            positionArr: [],
            current: 1,
            allClass: [],
            firstClassSid: '',
            secondClassSid: '',
            nextSecondClassObj: '',
            nextFirstClassObj: '',
            prevSecondClassObj: '',
            prevFirstClassObj: '',
            end: '',
            upEnd: true,
            startY: 0,
            showPullUpLoad: 0,
            pullUpLoadHeight: 0,
            moveClientY: 0,
            moveDirection: "",
            preUpHeightTime: 0,
            popup: false,
            minPrice: '',
            maxPrice: '',
            searchTypeList: [],
            labelVal: [],
            labelListFacet: []
        }
    },
    computed: {
        height: function() {
            return this.$store.getters.winHeight
        },
        firstSid: function() {
            return this.$store.getters.firstSid
        },
        currentClub: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : null
        },
        activeColor: function() {
            if (this.currentClub === 1){
                return '#FF4646';
            } else if (this.currentClub === 2) {
                return '#01924D';
            } else if (this.currentClub === 3) {
                return '#DC3264';
            } else if (this.currentClub === 4) {
                return '#149FE5';
            } else if (this.currentClub === 6) {
                return '#2F5DFF';
            } else if (this.currentClub === 7) {
                return '#3760BF';
            } else {
                return '#082692';
            }
        },
        tabbarData: function() {
            return [
                {
                    tabbarName: '首页',
                    linkUrl: '/smart-mall',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-' + 5  + '.png'
                    },
                    info: 0
                },
                {  
                    tabbarName: '分类',
                    linkUrl: '/smart-mall/menu',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-' + (this.currentClub + 1) + '.png'
                    },
                    info: 0
                }
            ]
        }
    },
    watch: {
        page: function(val){
            if (val > 1){
                this.currentPage.push({
                    page: val - 1,
                    scrollPosition: this.scrollHeight
                })
                this.positionArr.push(this.scrollHeight)
            }
        },
        '$store.getters.userInfo.currentType': function(val){
            this.currentClub = val
        }
    },
    mounted() {
        this.getIndustry(this.onLoad);
        this.touch();
    },
    methods: {
        touch() {
            const el = document.getElementById('scrollView');
            el.addEventListener('touchstart', e => {
                const goodsList = document.getElementById('goodsList');
                const height = goodsList ? goodsList.clientHeight : 0;
                this.startY = e.changedTouches[0].clientY
                this.showPullUpLoad = el.clientHeight + document.getElementById('scrollView').scrollTop >= height;
                this.pullUpLoadHeight = this.startY - e.changedTouches[0].clientY
            })
            el.addEventListener('touchmove', e => {
                if (this.preUpHeightTime < +new Date() - 100) {
                    this.preUpHeightTime = +new Date()
                    this.pullUpLoadHeight = this.startY - e.changedTouches[0].clientY
                }
                this.moveDirection = e.changedTouches[0].clientY - this.startY > 0 ? "down" : "up"
            })
            el.addEventListener('touchend', e => {
                if (this.showPullUpLoad && this.pullUpLoadHeight >= 10 && this.moveDirection === "up") {
                    // 上拉
                    this.pullUp();
                    this.showPullUpLoad = 0
                }
                if (Math.abs(this.pullUpLoadHeight) >= 10 && document.getElementById('scrollView').scrollTop === 0 && this.moveDirection === "down") {
                    // 下拉
                    this.dropDwon();
                }
                this.moveDirection = '';
            })
        },
        // 下拉
        dropDwon() {
            if (!this.upEnd) {
                this.getClassInfo();
                this.firstClassSid = this.prevFirstClassObj.sid;
                this.secondClassSid = this.prevSecondClassObj.sid;
                this.allClass.forEach((v) => {
                    if (v.sid === this.prevFirstClassObj.sid) {
                        this.$set(v, 'isOpen', true);
                        if (this.prevSecondClassObj) {
                            v.childrenList && v.childrenList.forEach(val => {
                                if (val.sid === this.prevSecondClassObj.sid) {
                                    this.$set(val, 'isOpen', true);
                                } else {
                                    this.$set(val, 'isOpen', false);
                                }
                            })
                        }
                    } else {
                        this.$set(v, 'isOpen', false);
                    }
                })
            
                this.reset();
                this.onLoad(this.getClassInfo);
            }
        },
        // 上拉
        pullUp() {
            if (!this.end) {
                this.getClassInfo();
                this.firstClassSid = this.nextFirstClassObj.sid;
                this.secondClassSid = this.nextSecondClassObj.sid;
                this.allClass.forEach((v) => {
                    if (v.sid === this.nextFirstClassObj.sid) {
                        this.$set(v, 'isOpen', true);
                        if (this.nextSecondClassObj) {
                            v.childrenList && v.childrenList.forEach(val => {
                                if (val.sid === this.nextSecondClassObj.sid) {
                                    this.$set(val, 'isOpen', true);
                                } else {
                                    this.$set(val, 'isOpen', false);
                                }
                            })
                        }
                    } else {
                        this.$set(v, 'isOpen', false);
                    }
                })
                this.reset();
                this.onLoad(this.getClassInfo);
            }
        },
        resh(){
            this.onLoad()
        },
        /**
         * 获取分类信息
         */
        getIndustry(callback) {
            Api.fetchIndustry({
                club: 0,
                parentSid: 0,
                showScene: 1
            }).then(({ data: { data }}) => {
                this.allClass = data.records || [];
                if (this.allClass.length) {
                    if (this.$route.query.firstSid) {
                        // 首页分类跳转
                        this.firstClassSid = this.$route.query.firstSid - 0;
                        this.secondClassSid = '';
                        let ind = '';
                        for (let i = 0; i < this.allClass.length; i++) {
                            if (this.allClass[i].sid === this.$route.query.firstSid - 0) {
                                ind  = i;
                                // this.$set(this.allClass[i], 'isOpen', true);
                                if (!(this.allClass[i].childrenList && this.allClass[i].childrenList.length && this.$route.query.secondSid)) continue;
                                for (let j = 0; j < this.allClass[i].childrenList.length; j++) {
                                    if (this.allClass[i].childrenList[j].sid === this.$route.query.secondSid - 0) {
                                        this.$set(this.allClass[i].childrenList[j], 'isOpen', true);
                                        break;
                                    }
                                }
                                break;
                            }
                        }
                        if (!(this.$route.query.secondSid - 0) && this.allClass[ind].childrenList) {
                            this.secondClassSid = this.allClass[ind].childrenList[0].sid;
                            this.$set(this.allClass[ind].childrenList[0], 'isOpen', true);
                        }
                    } else {
                        this.firstClassSid = this.allClass[0].sid;
                        // this.$set(this.allClass[0], 'isOpen', true);
                        if (this.allClass[0].childrenList && this.allClass[0].childrenList.length) {
                            this.secondClassSid = this.allClass[0].childrenList[0].sid;
                            this.$set(this.allClass[0].childrenList[0], 'isOpen', true);
                        }
                    }
                }
                callback && callback();
                this.getClassInfo();
            })
        },
        /**
         * 点击切换显示隐藏
         */
        showSelectMore(){
            this.showMore = !this.showMore
        },
        /**
         * 切换排序
         */
        checkRow(idx){
            if (this.ischecked !== idx){
                this.sortTop = false
            } else {
                this.sortTop = !this.sortTop
            }
            this.ischecked = idx
            if (this.ischecked === 3){
                this.showPopup()
                return
            } 
            this.finished = false
            this.page = 1
            this.currentPage = []
            this.positionArr = []
            this.current = 1
            this.goodsList = []
            this.onLoad()
        },
        /* 弹窗展示 */
        showPopup() {
            this.popup = !this.popup
            if (this.popup) this.$refs['refScreen'].action = '';
        },
        /* 弹窗关闭 */
        closePopup() {
            this.popup = false;
        },
        /* 提交数据 */
        saveValue(val){
            this.minPrice = val.minPrice;
            this.maxPrice = val.maxPrice;
            this.searchTypeList = val.searchTypeList;
            this.labelVal = val.labelVal;
            this.finished = false
            this.page = 1
            this.currentPage = []
            this.positionArr = []
            this.current = 1
            this.goodsList = []
            this.onLoad(this.closePopup);
        },
        /**
         * 组装查询数据
         */
        searchParams(){
            const obj = {
                current: this.page,
                size: 16,
                medicalInsurance: 0,
                sortType: 0,
                huddleType: 0,
                firstClassSid: this.firstClassSid,
                secondClassSid: this.secondClassSid,
                minPrice: this.minPrice,
                maxPrice: this.maxPrice,
                searchTypeList: this.searchTypeList.join(),
                labelVal: this.labelVal.join()
            }
            switch (this.ischecked){
                case 0:
                    obj.sortType = 0;
                    break;
                case 1:
                    obj.sortType = 1;
                    obj.isAsc = this.sortTop ? 0 : 1;
                    break;
                case 2:
                    obj.sortType = 4;
                    obj.isAsc = this.sortTop ? 0 : 1;
                    break;
            }
            return obj
        },
        /**
         * 加载更多
         */
        onLoad(callback) {
            this.scrollLoding = true
            const obj = this.searchParams();
            Api.fetchGoodsList(obj).then(({ data: { data }}) => {
                this.goodsList = this.goodsList.concat(data.records || [])
                this.loading = false
                this.scrollLoding = false
                this.refreshFlag = false;
                this.noPage = !this.goodsList.length
                if (this.page >= data.pages) {
                    this.finished = true;
                }
                this.page++
                callback && callback();
                this.$refs['refScreen'].loading = false
            }).catch(() => {
                this.$refs['refScreen'].loading = false
                this.loading = false;
                this.refreshFlag = true;
                this.scrollLoding = false
            })
        },
        // 跳转搜索
        goSearch() {
            this.$router.push(`/product/search/${'shs'}`)
            _czc.push(["_trackEvent", "点击搜索框", "search_click", "处方药-分类" + ";club:" + this.$store.getters.userInfo.currentType])
        },
        /**
         * 跳转购物车
         */
        goCart(){
            this.$router.push('/cart/index')
        },
        // 监听滚动
        handleScroll(e){
            this.scrollHeight = e.target.scrollTop
            this.$refs['refPagination'].scrollHeight = e.target.scrollTop
            this.current = comfirmPage(this.positionArr, e.target.scrollTop)
        },
        // 选择一级分类
        selectFirst(item) {
            this.secondClassSid = '';
            this.allClass.forEach(v => {
                if (item.sid === v.sid) {
                    this.$set(item, 'isOpen', !item.isOpen);
                    if (!item.active) {
                        this.$set(item, 'active', true);
                        this.firstClassSid = item.sid;
                        if (v.childrenList && v.childrenList.length) {
                        // 如果没有选中的二级分类默认选择第一个二级分类
                            const arr = v.childrenList.filter(val => val.isOpen === true) || [];
                            if (arr.length === 0) {
                                this.$set(v.childrenList[0], 'isOpen', true);
                                this.secondClassSid = v.childrenList[0].sid;
                            } else {
                                this.secondClassSid = arr[0].sid;
                            }
                        }
                        this.reset();
                        this.onLoad(this.getClassInfo);
                    }
                } else {
                    this.$set(v, 'isOpen', false);
                    this.$set(v, 'active', false);
                }
            })
        },
        // 选择二级分类
        selectSecond(sid, item) {
            if (item.isOpen) return;
            this.secondClassSid = item.sid;
            for (let i = 0; i < this.allClass.length; i++){
                if (this.allClass[i].sid === sid) {
                    this.allClass[i].childrenList.forEach(v => {
                        if (v.sid === item.sid) {
                            this.$set(v, 'isOpen', true);
                            this.reset();
                            this.onLoad();
                        } else {
                            this.$set(v, 'isOpen', false);
                        }
                    })
                    break;
                }
            }
            this.getClassInfo();
        },
        // 重置数据
        reset() {
            this.finished = false;
            this.goodsList = [];
            this.page = 1;
            this.currentPage = [];
            this.positionArr = [];
            this.current = 1;
            document.getElementsByClassName('goods-list-box')[0].scrollTop = 0;
        },
        // 获取上下分类信息
        getClassInfo() {
            this.end = '';
            this.upEnd = '';
            for (let ind = 0; ind < this.allClass.length; ind++){
                if (this.allClass[ind].sid === this.firstClassSid) {
                    this.$set(this.allClass[ind], 'active', true);
                    if (this.allClass[ind].childrenList){
                        for (let i = 0; i < this.allClass[ind].childrenList.length; i++){
                            if (this.allClass[ind].childrenList[i].sid === this.secondClassSid) {
                                if (this.allClass[ind].childrenList[i + 1]) {
                                    this.nextSecondClassObj = this.allClass[ind].childrenList[i + 1];
                                    this.nextFirstClassObj = this.allClass[ind];
                                } else {
                                    if (this.allClass[ind + 1]){
                                        this.nextFirstClassObj = this.allClass[ind + 1];
                                        this.nextSecondClassObj = '';
                                        if (this.allClass[ind + 1].childrenList && this.allClass[ind + 1].childrenList.length) {
                                            this.nextSecondClassObj = this.allClass[ind + 1].childrenList[0];
                                        }
                                    } else {
                                        if (this.allClass[0]) {
                                            this.nextFirstClassObj = this.allClass[0];
                                            this.nextSecondClassObj = '';
                                            if (this.allClass[0].childrenList && this.allClass[0].childrenList.length) {
                                                this.nextSecondClassObj = this.allClass[0].childrenList[0];
                                            }
                                            document.getElementsByClassName('all-class-box')[0].scrollTop = 0;
                                        }
                                    }
                                }
                                if (this.allClass[ind].childrenList[i - 1]) {
                                    this.prevSecondClassObj = this.allClass[ind].childrenList[i - 1]
                                    this.prevFirstClassObj = this.allClass[ind];
                                } else {
                                    if (this.allClass[ind - 1]) {
                                        this.prevFirstClassObj = this.allClass[ind - 1];
                                        this.prevSecondClassObj = ''
                                        if (this.allClass[ind - 1].childrenList && this.allClass[ind - 1].childrenList.length){
                                            this.prevSecondClassObj = this.allClass[ind - 1].childrenList[this.allClass[ind - 1].childrenList.length - 1];
                                        }
                                    } else {
                                        this.upEnd = true;
                                        this.prevSecondClassObj = '';
                                        this.prevFirstClassObj = '';
                                    }
                                }
                                break;
                            }
                        }
                    } else {
                        if (this.allClass[ind + 1]) {
                            this.nextFirstClassObj = this.allClass[ind + 1];
                            this.nextSecondClassObj = '';
                            if (this.allClass[ind + 1].childrenList && this.allClass[ind + 1].childrenList.length) {
                                this.nextSecondClassObj = this.allClass[ind + 1].childrenList[0]
                            }
                        } else {
                            if (this.allClass[0]) {
                                this.nextFirstClassObj = this.allClass[0];
                                this.nextSecondClassObj = '';
                                if (this.allClass[0].childrenList && this.allClass[0].childrenList.length) {
                                    this.nextSecondClassObj = this.allClass[0].childrenList[0];
                                }
                                document.getElementsByClassName('all-class-box')[0].scrollTop = 0;
                            }
                        }
                        if (this.allClass[ind - 1]) {
                            this.prevFirstClassObj = this.allClass[ind - 1];
                            this.prevSecondClassObj = '';
                            if (this.allClass[ind - 1].childrenList && this.allClass[ind - 1].childrenList.length) {
                                this.prevSecondClassObj = this.allClass[ind - 1].childrenList[0]
                            }
                        } else {
                            this.upEnd = true;
                            this.prevSecondClassObj = '';
                            this.prevFirstClassObj = '';
                        }
                    }
                } else {
                    this.$set(this.allClass[ind], 'active', false);
                }
            }
        }
    }
}
</script>
<style lang="scss">
.Page-menu-index2 {
    width: 100%;
    height: 100%;
    // background: #f6f6f6;
    .classBox{
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100vh;
        background: rgba(0,0,0,.5);
        z-index: 99999;
        .close-class-box{
            position: absolute;
            right: .2rem;
            top: .2rem;
            width: .48rem;
            height: .48rem;
            img{
                width: .48rem;
                height: .48rem;
            }
        }
        .class-label{
            width: 100%;
            background: #fff;
            display: flex;
            justify-content: flex-start;
            flex-wrap: wrap;
            padding-top: .88rem;
            padding: .88rem .28rem .24rem;
            span{
                height: .56rem;
                line-height: .56rem;
                padding: 0 .2rem;
                font-size: .28rem;
                border-radius: .28rem;
                background: #EEE;
                margin-left: .16rem;
                margin-bottom: .16rem;
                color: #666666;
                &.activeLabel{
                    background: #FF4646;
                    color: #FFF;
                }
            }
        }
    }
    .smart-mall-tabbar{
        .van-tabbar-item__icon{
            img{
                height: .48rem;
            }
        }
    }

    .van-tabs--line{
        padding-top: 0;
    }

    .theme {
        height: 100%;
    }

    .search-input {
        background: #f6f6f6;
        padding: .07rem .2rem .14rem .2rem;
        height: 7%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        a{
            margin-right: .16rem;
            img{
                width: .48rem;
                height: .48rem;
            }
        }
        i{
            font-size: .48rem;
            color: #333333;
            margin-left: .2rem;
        }

        .van-cell {
            background: #ffffff;
            border-radius: 1rem;
            color: #999999;
            padding: 0.14rem 0.2rem;

            .van-icon {
                font-size: 0.4rem;
                margin-left: 0;
            }

            .van-field__input {
                font-size: 0.28rem;
            }
            .van-field__body{
                input{
                    font-size: .26rem;
                }
            }
        }
    }

    .tabs {
        height: 6%;
        position: relative;
        [class*=van-hairline]::after{
            content: none;
        }
        img {
            position: absolute;
            width: .42rem;
            height: .42rem;
            right: .12rem;
            top: .2rem;
        }
    }

    .sort-box{
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: .32rem .2rem;
        background: #ffffff;
        height: 51px;
        box-sizing: border-box;
        .row{
            font-size: .28rem;
            color: #666666;
            display: flex;
            align-items: center;
            &.checked-row{
                color: #ed3129;
            }
            .triangle-box{
                display: flex;
                flex-direction: column;
                img {
                    width: .12rem;
                    height: .16rem;
                    margin-left: .08rem;
                }
                .icon {
                    background: url("~@/assets/images/icon-arrow.png") no-repeat;
                    background-size: 100% auto;
                    width: .12rem;
                    height: .16rem;
                    margin-left: .08rem;
                }
                .triangle{
                    margin-left: .06rem;
                    float: left;
                    width: 0; 
                    height: 0;
                    border-width: .08rem;
                    border-style: solid;
                    border-color:transparent transparent transparent transparent;
                    &.triangle-top{
                        border-bottom-color: #D8D8D8;
                        margin-bottom: .06rem;
                        border-bottom-width: .1rem;
                    }
                    &.triangle-bottom{
                        border-top-color: #D8D8D8;
                        border-top-width: .1rem;
                    }
                     &.triangle-left{
                        border-left-color: #D8D8D8;
                        border-left-width: .1rem;
                    }
                    &.triangle-top-red{
                        border-bottom-color: #ed3129;
                    }
                    &.triangle-bottom-red{
                        border-top-color: #ed3129;
                    }
                    &.triangle-left-red{
                        border-left-color: #ed3129;
                    }
                }
            }
        }
        .row::before {
            content: "|";
            color: #EEEEEE;
            margin-right: .25rem;
        }
        .row:first-child::before {
            content: "";
        }
    }

    .classification-box {
        display: flex;
        height: 85%;
        overflow: hidden;
        .all-class-box{
            display: flex;
            flex-direction: column;
            width: 1.74rem;
            overflow-y: auto;
            .first-class{
                width: 1.6rem;
                font-size: .28rem;
                line-height: .4rem;
                text-align: center;
                color: #333333;
                background: #F3F4F6;
                .p{
                    height: 1.12rem;
                    box-sizing: border-box;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .div{
                    height: .92rem;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                }
            }
            .active-first-class{
                width: 1.74rem;
                background: url(https://imga.hnhcyy.com/fed/b2b-wechat/class-repeat-bg.png?v=1);
                background-size: 100% 100%;
                border-bottom-right-radius: .08rem;
            }
            .bottom-shadow{
                width: 1.68rem;
                height: .08rem;
                box-shadow: 0px 4px 4px #E7E9EC;
            }
            .checked-first{
                width: 1.68rem;
                background: url(https://imga.hnhcyy.com/fed/b2b-wechat/close-class.gif) no-repeat;
                background-size: 100%;
                color: #ffffff;
                padding-bottom: .36rem;
            }
            .open-first{
                width: 1.68rem;
                background: url(https://imga.hnhcyy.com/fed/b2b-wechat/open-class.gif) no-repeat;
                background-size: 100%;
                color: #ffffff;
                padding-bottom: .36rem;
            }
            .active{
                color: #FF4646;
            }
            .img{
                position: absolute;
                right: .08rem;
                width: .12rem;
                height: .36rem;
                background: url(https://imga.hnhcyy.com/fed/b2b-wechat/selected-class.png) no-repeat;
                background-size: 100% auto;
            }
        }
        .no-data {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 5.8rem;
            img {
                width: 3.32rem;
                height: 3.13rem;
                margin-top: 2.64rem;
            }

            span {
                color: #333333;
                font-size: .36rem;
                padding-top: .4rem;
            }
        }

    }

    .goods-list-box{
        flex: 1;
        overflow: hidden;
        border-bottom: .02rem dashed #EEEEEE;
        .goods-img{
                .image-box{
                    margin-bottom: 1.04rem;
                    .van-image{
                        height: 100%;
                        width: 100%;
                    }
                }
                .jxq{
                    position: absolute;
                    bottom: 1.36rem;
                    left: 0.24rem;
                    height: 0.4rem;
                    width: 1.12rem;
                    background: #FF7768;
                    border-radius: 0.2rem;
                    line-height: 0.4rem;
                    text-align: center;
                    color: #ffffff;
                    font-size: 0.2rem;
                }
                .icons-jxq{
                    position: absolute;
                    bottom: 1.54rem;
                    left: 0.24rem;
                    height: 0.4rem;
                    width: 1.12rem;
                    background: #FF7768;
                    border-radius: 0.2rem;
                    line-height: 0.4rem;
                    text-align: center;
                    color: #ffffff;
                    font-size: 0.2rem;
                }
                .purchased-span{
                    position: absolute;
                    color: #FF9A38;
                    font-size: 0.24rem;
                    bottom: 0.94rem;
                    left: 0.24rem;
                    height: 0.4rem;
                    width: 1.12rem;
                    background: #FFF3E7;
                    border-radius: 0.24rem;
                    line-height: 0.4rem;
                    text-align: center;
                }
        }
        .goods-info{
            .row-11{
                display: flex;
                margin: .22rem 0 .1rem 0;
            }
        }
    }
    .scroll-view{
        overflow: auto;
        position: relative;
        background: #ffffff;
        .doge {
            width: 2.85rem;
            height: 0.8rem;
            display: flex;
            align-items: center;
            margin-left: 1.8rem;
        }
        .prev-text{
            width: 2.6rem;
            margin: .2rem auto;
            background: #F3F4F6;
            color: #BBBBBB;
            text-align: center;
            font-size: .24rem;
            height: .36rem;
            line-height: .36rem;
            border-radius: .18rem;
        }
    }
}
</style>
