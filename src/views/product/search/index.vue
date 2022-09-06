<template>
    <div class="search-box">
        <div class="search-input">
            <img src="@/assets/images/icon-goback-b.png" alt="" @click="$router.go(-1)">
            <div class="input-box">
                <input
                    v-model.trim="keywords"
                    type="text"
                    placeholder="商品名/首字母/商品ID/厂家/标签/商标"
                    @input="onChange"
                >
                <img v-show="keywords" class="empty-word" src="@/assets/images/empty-word.png" @click="emptyValue">
            </div>
        </div>
        <div v-if="isShowHotword" class="history-box">
            <div class="row row-1">
                <span>搜索历史</span>
                <div v-if="historyWordList && historyWordList.length>0" class="delete-box">
                    <img
                        v-if="!showDelete"
                        src="@/assets/images/icon-delete.png"
                        class="delete-icon"
                        @click="showDelete = true"
                    >
                    <template v-else>
                        <i class="delete-all" @click="delHistory(0)">全部删除</i>
                        <i class="delete-complete" @click="showDelete=false">完成</i>
                    </template>
                </div>
            </div>
            <div class="row row-2" :class="showHistory ? '': 'row-history-hide'">
                <template v-for="(item,index) in historyWordList">
                    <span :key="index" class="history-word" @click="searchGoods(item)">
                        {{ item }}
                        <img v-show="showDelete" src="@/assets/images/close-word.png" alt="" @click.stop="delHistory(1,item)">
                    </span>
                </template>
                <span v-if="historyWordList && historyWordList.length>0" class="show-more">
                    <img v-if="showHistory" src="@/assets/images/close_history_icon.png" alt="" @click="handdleHistory">
                    <img v-else src="@/assets/images/open_history_icon.png" alt="" @click="handdleHistory">
                </span>
            </div>
        </div>
        <template v-if="isShowHotword">
            <div class="added-list-row" @click="gotoQuick">
                <img class="icon-added-list" src="@/assets/images/icon-added-list.png" alt="">
                <span>常购清单</span>
                <div>点击查看常购商品</div>
                <img class="icon-added-btn" src="@/assets/images/icon-more-added.png" alt="">
            </div>
            <div class="history-records">
                <div class="history-title">
                    <img class="search-discovery" src="@/assets/images/search-discovery.png" alt="">
                    <div>搜索发现</div>
                    <img v-if="showHotWords" src="@/assets/images/icon-login-6.png" class="icon-login-6" @click="changeShowHotWords">
                    <img v-else src="@/assets/images/icon-login-5.png" class="icon-login-5" @click="changeShowHotWords">
                </div>
                <div v-if="showHotWords" class="hotword-box">
                    <template v-for="(item,index) in hotword">
                        <div :key="index" @click="searchGoods(item.word)">
                            <img class="bar" src="@/assets/images/search-indicator-bar.png" alt="">
                            <span>{{ item.word }}</span>
                            <img class="more-search" src="@/assets/images/icon-more-search.png" alt="">
                        </div>
                    </template>
                </div>
            </div>
        </template>
        <div v-else class="goods-list">
            <!-- <div class="sort-box">
                <div v-for="(item, index) in sortText" :key="index" :class="ischecked === index ? 'row checked-row' : 'row'" @click="checkRow(index)">
                    <p>{{ item }}</p>
                    <p v-if="index !== 0" class="triangle-box">
                        <span :class="(ischecked === index && !sortTop) ? 'triangle triangle-top triangle-top-red' : 'triangle triangle-top'" />
                        <span :class="(ischecked === index && sortTop) ? 'triangle triangle-bottom triangle-bottom-red' : 'triangle triangle-bottom'" />
                    </p>
                </div>
            </div> -->
            <div class="have-data">
                <van-list
                    v-model="loading"
                    :finished="finished"
                    :finished-text="'人家是有底线的哦！'"
                    :immediate-check="false"
                    :offset="50"
                    @load="onLoad"
                >
                    <product-list :goods-list="goodsList" />
                </van-list>
            </div>
            <div v-if="goodsList.length <= 0" class="no-data">
                <img src="@/assets/images/emptyCart.png">
                <span>搜索无记录</span>
            </div>
        </div>
    </div>
</template>

<script>
import Api from '@/api/product/search'
import { Dialog, Toast } from 'vant'
import productList from '@/components/productList'
var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);
export default {
    name: 'Search',
    components: {
        productList
    },
    data() {
        return {
            goodsList: [],
            huddleType: 1,
            loading: false,
            finished: false,
            keywords: '',
            page: 1,
            currentUserName: JSON.parse(localStorage.getItem('loginInfo')).username,
            timer: null,
            hotword: [],
            historyWordList: [],
            historyWords: JSON.parse(localStorage.getItem('historyWords')) ? JSON.parse(localStorage.getItem('historyWords')) : [],
            isShowHotword: true,
            ischecked: 0,
            sortTop: true,
            isAll: true,
            showHotWords: true,
            showHistory: true,
            sortText: [
                '默认排序',
                '上架时间',
                '价格',
                '首字母'
            ],
            showDelete: false
        }
    },
    computed: {

    },
    created() {
        this.$route.params.type === 'bt' ? this.huddleType = 1 : this.huddleType = 2
        this.getHotword()
        const currentUserName = this.currentUserName
        const historyWords = this.historyWords
        historyWords.forEach(item => {
            if (item.username === currentUserName){
                this.historyWordList = item.historyWordList
            }
        })
    },
    methods: {
        /**
         * 监听输入框内容变化
         */
        onChange() {
            if (this.keywords === '') {
                this.isShowHotword = true;
                this.goodsList = []
            } else {
                this.searchGoods(this.keywords)
            }
        },
        emptyValue() {
            this.keywords = '';
            this.onChange();
        },
        /**
         * 搜索商品
         */
        searchGoods(word) {
            if (this.showDelete) return;// 删除时不搜索
            this.page = 1
            this.keywords = word
            if (this.timer) {
                clearTimeout(this.timer)
            }
            const obj = this.searchParams(word, this.page)
            this.timer = setTimeout(() => {
                Toast.loading({
                    message: '加载中...',
                    forbidClick: true,
                    duration: 0
                })
                if (this.keywords === '') {
                    this.goodsList = []
                    Toast.clear()
                    return
                }
                Api.fetchGoods(obj).then(({ data: { data }}) => {
                    this.updateHistory(obj.keyword)
                    this.goodsList = []
                    this.goodsList = data.records
                    this.isShowHotword = false
                    Toast.clear()
                })
            }, 500)
        },
        /**
         * 更新历史搜索
         */
        updateHistory(word){
            const currentUserName = this.currentUserName
            const historyWords = this.historyWords
            const currentHistoryWords = historyWords.length > 0 ? historyWords.filter(item => item.username === currentUserName) : []
            if (currentHistoryWords.length <= 0){
                const obj = {
                    username: currentUserName,
                    historyWordList: [word]
                }
                historyWords.push(obj)
            } else {
                historyWords.forEach(item => {
                    if (item.username === currentUserName && item.historyWordList.indexOf(word) === -1){
                        item.historyWordList.unshift(word);
                    }
                })
            }
            localStorage.setItem('historyWords', JSON.stringify(historyWords))
        },
        /**
         * 切换搜索历史现实隐藏
         */
        handdleHistory(){
            this.showHistory = !this.showHistory
        },
        /**
         * 切换热词显示隐藏
         */
        changeShowHotWords(){
            this.showHotWords = !this.showHotWords
        },
        /**
         * 删除历史搜索
         */
        delHistory(type, word){
            // 单个删除
            if (type === 1) {
                const historyWords = this.historyWords
                historyWords.forEach(item => {
                    if (item.username === this.currentUserName){
                        for (let i = 0; i < item.historyWordList.length; i++) {
                            if (word === item.historyWordList[i]) item.historyWordList.splice(i, 1);
                        }
                        this.historyWordList = item.historyWordList;
                    }
                })
                localStorage.setItem('historyWords', JSON.stringify(historyWords));
                if (this.historyWordList.length < 1) this.showDelete = false;
                return;
            }
            // 全部删除
            Dialog.confirm({
                message: '是否删除搜索历史？'
            }).then(() => {
                // on confirm
                const historyWords = this.historyWords
                historyWords.forEach(item => {
                    if (item.username === this.currentUserName){
                        item.historyWordList = []
                        this.historyWordList = item.historyWordList
                    }
                })
                localStorage.setItem('historyWords', JSON.stringify(historyWords))
                if (this.historyWordList.length < 1) this.showDelete = false;
            }).catch(() => {
                // on cancel
            });
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
            this.finished = false
            this.page = 1
            this.goodsList = []
            this.searchGoods(this.keywords)
        },
        /**
         * 组装查询数据
         */
        searchParams(keywords, page){
            const obj = {
                keyword: keywords, 
                current: page, 
                size: 16, 
                huddleType: this.huddleType,
                medicalInsurance: 0
            }
            switch (this.ischecked){
                case 0:
                    obj.sortType = 0;
                    break;
                case 1:
                    obj.sortType = 2;
                    obj.isAsc = this.sortTop ? 0 : 1;
                    break;
                case 2:
                    obj.sortType = 3;
                    obj.isAsc = this.sortTop ? 0 : 1;
                    break;
                case 3:
                    obj.sortType = 4;
                    obj.isAsc = this.sortTop ? 0 : 1;
                    break;
            }
            return obj
        },
        /**
         * 加载更多
         */
        onLoad() {
            const obj = this.searchParams(this.keywords, this.page + 1)
            Api.fetchGoods(obj).then(({ data: { data }}) => {
                this.goodsList = this.goodsList.concat(data.records || [])
                this.loading = false
                if ((this.page + 1) >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
            })
        },
        /**
         * 获取热门搜索
         */
        getHotword() {
            const params = { current: 1, type: 2, size: 10, word: this.keywords };
            if (this.$route.params.type !== 'bt'){
                params.scene = 'shs'
            }
            Api.gethotword(params).then(data => {
                this.hotword = data.data.data.records || []
            })
        },
        gotoQuick() {
            _czc.push(["_trackEvent", "点击常购清单", "search_go_purchased", "club:" + this.$store.getters.userInfo.currentType])
            this.$router.push('/quick/index');
        }
    }
}
</script>

<style lang="scss">
@mixin overflowText{
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.search-box {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background: #f1f1f1;
    .search-input {
        height: .88rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: #fff;
        padding: .1rem .28rem;
        box-sizing: border-box;
        .input-box{
            position: relative;
            flex: 1;
            height: .68rem;
            border-radius: .08rem;
            input{
                display: block;
                width: 100%;
                padding: 0 .16rem;
                font-size: .28rem;
                border: none;
                outline: none;
                height: .68rem;
                line-height: .68rem;
                background: #F3F4F6;
                border-radius: .08rem;
            }
            .empty-word{
                width: .36rem;
                height: .36rem;
                position: absolute;
                right: 0;
                top: .16rem;
            }
        }
        img {
            margin-right: 0.16rem;
            width: 0.48rem;
            height: 0.48rem;
        }
    }
    .history-box {
        background: #ffffff;
        padding: .4rem .28rem;
        line-height: 1;
        text-align: center;
        font-size: .28rem;
        color: #666;
        border-bottom-left-radius: .16rem;
        border-bottom-right-radius: .16rem;
        .delete-box{
            display: flex;
            align-items: center;
        }
        .delete-icon{
            width: .36rem;
        }
        .delete-complete,.delete-all{
            font-style: normal;
        }
        .delete-complete{
            position: relative;
            color: #FF4646;
            padding-left: .42rem;
        }
        .delete-complete::before{
            content: '';
            position: absolute;
            left: .2rem;
            width: .02rem;
            height: .24rem;
            background: #DDDDDD;
        }
        &:nth-last-child(1){
            padding-top: 0;
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            &.row-1 {
                margin-bottom: .12rem;
                justify-content: space-between;
                span:nth-child(1) {
                    font-size: .32rem;
                    color: #333333;
                    font-weight: 600;
                }
            }
            &.row-2 {
                justify-content: flex-start;
                span {
                    padding: .08rem .24rem;
                    font-size: .28rem;
                    margin: .2rem .2rem 0 0;
                    background: #F8F8FA;
                    border-radius: .08rem;
                    line-height: .4rem;
                }
                .show-more{
                    padding: .12rem .18rem;
                    line-height: 1;
                    img{
                        width: .2rem;
                        height: .28rem;
                    }
                }
                .history-word{
                    img{
                        width: .2rem;
                        height: .2rem;
                        margin-left: .08rem;
                    }
                }
            }
            &.row-history-hide{
                padding-right: .64rem;
                height: .8rem;
                overflow: hidden;
                position: relative;
                .show-more{
                    position: absolute;
                    right: 0;
                    top: 0;
                    margin-right: 0;
                }
            }
        }
    }
    .added-list-row{
        display: flex;
        align-items: center;
        height: .92rem;
        margin: .28rem .28rem 0 .28rem;
        padding: 0 .2rem;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/added-list-bg.png') no-repeat;
        background-size: 100% auto;
        color: #9F5C1D;
        .icon-added-list{
            width: .28rem;
            height: .32rem;
            margin-right: .14rem;
        }
        span{
            font-weight: 600;
        }
        >div{
            flex: 1;
            text-align: right;
            font-size: .24rem;
        }
        .icon-added-btn{
            width: .12rem;
            height: .28rem;
            margin-left: .16rem;
        }
    }
    .history-records{
        margin: .28rem .28rem 0 .28rem;
        background: #ffffff;
        border-radius: .08rem;
        .history-title{
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: .92rem;
            padding: 0 .2rem;
            background: url('https://imga.hnhcyy.com/fed/b2b-wechat/history-records-bg.png') no-repeat;
            background-size: 100% auto;
            color: #9F5C1D;
            .search-discovery{
                width: .32rem;
                height: .32rem;
                margin-right: .14rem;
            }
            >div{
                flex: 1;
                font-weight: 600;
            }
            .icon-login-6,
            .icon-login-5{
                width: .36rem;
                height: .36rem;
            }
        }
        .hotword-box{
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            padding: 0 .2rem .28rem .2rem;
            >div{
                box-sizing: border-box;
                display: flex;
                align-items: center;
                width: 3.16rem;
                height: .64rem;
                margin-top: .2rem;
                padding: 0 .2rem;
                background: #FFF8EF;
                border-radius: .08rem;
                .bar{
                    width: .08rem;
                    height: .2rem;
                    margin-right: .16rem;
                }
                >span{
                    flex: 1;
                    @include overflowText;
                    color:#666666;
                }
                .more-search{
                    width: .12rem;
                    height: .28rem;
                }
            }
        }
    }
    .goods-list {
        flex: 1;
        overflow-y: auto;
        background: #f1f1f1;
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
                        &.triangle-top-red{
                            border-bottom-color: #ed3129;
                        }
                        &.triangle-bottom-red{
                            border-top-color: #ed3129;
                        }
                    }
                }
            }
        }
        .no-data {
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            background: #ffffff;
            img {
                width: 3.32rem;
                height: 3.13rem;
                margin-top: 2.64rem;
            }
            span {
                color: #333333;
                font-size: 0.36rem;
                padding-top: 0.54rem;
            }
        }
    }
}
</style>
