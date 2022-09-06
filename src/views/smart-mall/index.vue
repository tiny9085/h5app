<template>
    <div class="Page-smart-mall">
        <div class="top">
            <div class="floor-1">
                <!-- <span>随你怎么选</span> -->
                <img src="@/assets/images/chfy-icon.png" alt="">
                <!-- <span>越选越划算</span> -->
            </div>
            <div :class="scrollHeight <= 50 ? 'floor-2' : 'floor-2 fixedFloor'">
                <router-link :to="'/'"><img :src="logo" alt=""></router-link>
                <van-cell-group>
                    <!-- <img src="@/assets/images/icon-scan.png" alt=""> -->
                    <van-field placeholder="商品名/首字母/商品ID/厂家/标签/商标" @focus="goSearch" />
                </van-cell-group>
                <van-icon class-prefix="iconfont icon-gouwuche" @click="goCart" />
                <!-- <img :src="message" alt=""> -->
            </div>
        </div>
        <div class="swiper-box">
            <van-swipe :autoplay="3000" indicator-color="#fff">
                <template v-if="bannerList && bannerList.length>0">
                    <van-swipe-item v-for="(item, index) in bannerList" :key="index">
                        <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-banner-tm.png" :original-image="item.mobileImageUrl" :item="item" :oss-width="710" :oss-height="360" />
                    </van-swipe-item>
                </template>
                <van-swipe-item v-else>
                    <image-load
                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-banner-tm.png"
                        original-image=""
                        :oss-width="710"
                        :oss-height="360"
                    />
                </van-swipe-item>
            </van-swipe>
        </div>
        <div class="icon-list">
            <div v-for="(item, index) in iconList" :key="index" class="icon-item" @click="goPage(item.skipType,item.linkUrl)">
                <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.iconUrl" />
                <span>{{ item.title }}</span>
            </div>
        </div>
        <floor-list :list="floorList" :position="1" />
        <div v-if="CWpatentMedicine.length > 1" class="item-list clearfix components-product-card">
            <div class="floor-box">
                <div class="floor-title" @click="goClassifyList(145)">
                    <span>中西成药</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods">
                    <van-swipe-item v-for="aindex in Math.ceil(CWpatentMedicine.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in CWpatentMedicine">
                                <product-card
                                    v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2"
                                    :key="bindex"
                                    :item="item"
                                    :card-type="'smart-mall-index'"
                                    :current-type="1"
                                    :theme="'theme-2'"
                                />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <floor-list :list="floorList" :position="2" />
        <div v-if="oralGoods.length > 1" class="item-list clearfix components-product-card">
            <div class="floor-box">
                <div class="floor-title" @click="goClassifyList(166)">
                    <span>中药饮片</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe>
                    <van-swipe-item v-for="aindex in Math.ceil(oralGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in oralGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <floor-list :list="floorList" :position="3" />
        <div v-if="outGoods.length > 1" class="item-list clearfix components-product-card">
            <div class="floor-box">
                <div class="floor-title" @click="goClassifyList(181)">
                    <span>保健食品</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe>
                    <van-swipe-item v-for="aindex in Math.ceil(outGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in outGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <floor-list :list="floorList" :position="4" />
        <div v-if="medicineGoods.length > 1" class="item-list clearfix components-product-card">
            <div class="floor-box">
                <div class="floor-title" @click="goClassifyList(187)">
                    <span>医疗器械</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe>
                    <van-swipe-item v-for="aindex in Math.ceil(medicineGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in medicineGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <floor-list :list="floorList" :position="5" />
        <div v-if="nutritionGoods.length > 1" class="item-list clearfix components-product-card">
            <div class="floor-box">
                <div class="floor-title" @click="goClassifyList(10)">
                    <span>消毒用品</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe>
                    <van-swipe-item v-for="aindex in Math.ceil(nutritionGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in nutritionGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <floor-list :list="floorList" :position="6" />
        <div v-if="proGoods.length > 1" class="item-list clearfix components-product-card">
            <div class="floor-box">
                <div class="floor-title" @click="goClassifyList(177)">
                    <span>食品百货</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe>
                    <van-swipe-item v-for="aindex in Math.ceil(proGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in proGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <floor-list :list="floorList" :position="7" />
        <van-tabbar 
            v-model="active"
            class="smart-mall-tabbar"
            :active-color="activeColor"
            inactive-color="#999999"
        >
            <van-tabbar-item v-for="item in tabbarData" :key="item.id" :info="item.info === 0 ? '' : item.info" :to="item.linkUrl">
                <span>{{ item.tabbarName }}</span>
                <img slot="icon" slot-scope="props" :src="props.active ? item.icon.active : item.icon.normal">
            </van-tabbar-item>
        </van-tabbar>
        <!-- 弹窗广告 -->
        <van-popup v-model="showPop" @closed="closeBtn">
            <div class="active-box">
                <img :src="winPopInfo.mainImg" alt="" @click="goPopPage(winPopInfo)">
            </div>
            <div class="close-btn">
                <img src="@/assets/images/close.png" alt="" @click="closeBtn">
            </div>
        </van-popup>
        <div class="bottom" />
    </div>
</template>

<script>
import logoSrc from '@/assets/images/icon-goback-b.png'
// import messageSrc from '@/assets/images/icon-message.png'
import logoSrcW from '@/assets/images/icon-goback-w.png'
// import messageSrcW from '@/assets/images/icon-message-w.png'
import productCard from '@/components/productCard/index'
import imageLoad from '@/components/imageLoad/index'
import floorList from '@/components/floorTemplate/index'
import Api from '@/api/smart-mall/index'

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    components: {
        productCard,
        imageLoad,
        floorList
    },
    data() {
        return {
            iconList: [],
            bannerList: [],
            oralGoods: [],
            outGoods: [],
            medicineGoods: [],
            nutritionGoods: [],
            proGoods: [],
            floorList: [],
            active: 0,
            winPopInfo: {},
            showPop: false,
            /* tabbarData: [
                {
                    tabbarName: '首页',
                    linkUrl: '/smart-mall',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-2.png'
                    }
                },
                {
                    tabbarName: '分类',
                    linkUrl: '/smart-mall/menu',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-2.png'
                    }
                }
            ], */
            scrollHeight: 0,
            CWpatentMedicine: []
        }
    },
    computed: {
        logo: function() {
            const logo = this.scrollHeight <= 50 ? logoSrc : logoSrcW
            return logo
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
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-' + (this.currentClub + 1)  + '.png'
                    }
                },
                {
                    tabbarName: '分类',
                    linkUrl: '/smart-mall/menu',
                    icon: {
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-1.png',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-' + (this.currentClub + 1) + '.png'
                    }
                }
            ]
        }
        // message: function() {
        //     const message = this.scrollHeight <= 50 ? messageSrc : messageSrcW
        //     return message
        // }
    },
    watch: {
        '$store.getters.userInfo.currentType': function(val){
            this.currentClub = val
        }
    },
    created() {
        window.addEventListener('scroll', this.scroll);
    },
    mounted() {
        this.getIconList()
        this.getIBannerList()
        this.getFloorList()
        this.getGoods(145);
        this.getGoods(166);
        this.getGoods(181);
        this.getGoods(187);
        this.getGoods(10);
        this.getGoods(177);
        this.getPop()
    },
    methods: {
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        // 跳转搜索
        goSearch() {
            this.$router.push(`/product/search/${'shs'}`)
            _czc.push(["_trackEvent", "点击搜索框", "search_click", "处方药" + ";club:" + this.$store.getters.userInfo.currentType])
        },
        /**
         * 获取icon
         */
        getIconList() {
            Api.fetchIcon({ sourceType: 1 }).then(({ data: { data }}) => {
                this.iconList = data
            })
        },
        /**
         * 获取banner
         */
        getIBannerList() {
            Api.fetchBanner({
                source: 0,
                sourceType: 1,
                bannerTypeId: 1
            }).then(({ data: { data }}) => {
                this.bannerList = data
            })
        },
        /**
         * 获取首页楼层
         */
        getFloorList() {
            Api.fetchFloorList({ sourceType: 1 }).then(({ data: { data }}) => {
                this.floorList = data
            })
        },
        /**
         * 获取商品
         */
        getGoods(params) {
            Api.fetchGoods({
                current: 1,
                size: 6,
                firstClassSid: params,
                huddleType: 2
            }).then(({ data: { data }}) => {
                switch (params){
                    case 166: 
                        this.oralGoods = data.records
                        break
                    case 181: 
                        this.outGoods = data.records
                        break
                    case 187: 
                        this.medicineGoods = data.records
                        break
                    case 10: 
                        this.nutritionGoods = data.records
                        break
                    case 177: 
                        this.proGoods = data.records
                        break   
                    case 145: 
                        this.CWpatentMedicine = data.records;
                        break;
                }
            })
        },
        /**
         * 跳转分类
         */
        goClassifyList(params) {
            this.$router.push({
                path: '/smart-mall/menu',
                query: {
                    firstSid: params
                }
            })
        },
        /**
         * 点击icon跳转
         */
        goPage(type, link) {
            if (type === 1) {
                this.goInnerPage(link)
            } else if (type === 2) {
                if (link.indexOf('?') !== -1) {
                    window.location.href = link + '&source=h5'
                } else {
                    window.location.href = link + '?source=h5'
                }
            } else if (type === 3) {
                this.$router.push('/smart-mall/menu?firstSid=' + JSON.parse(link).parentTypeId + '&secondSid=' + JSON.parse(link).typeId)
            }
        },
        /**
         * 跳转内部链接
         */
        goInnerPage(url) {
            let linkUrl = ''
            switch (url) {
                case '1': // 近期已采
                    linkUrl = '/quick/index?quickType=1'
                    // localStorage.setItem("quickType", 1);
                    break;
                case '2': // 近期未采
                    linkUrl = '/quick/index?quickType=2'
                    // localStorage.setItem("quickType", 2);
                    break;
                case '3': // 新品抢购
                    linkUrl = '/product/new-goods';
                    break;
                case '4': // 即将到货
                    linkUrl = '/product/coming-soon';
                    break;
                case '5': // 处方药首页
                    linkUrl = '/smart-mall/index';
                    break;
                case '6': // 即将上涨
                    linkUrl = '/product/get-rise';
                    break;
                case '7': // 宣传物料
                    linkUrl = '/product/materials';
                    break;
                case '8': // 我的优惠券
                    linkUrl = '/personal/coupon';
                    break;
                case '9': // 预售专区
                    if (localStorage.getItem("isShowNeedKnow") === 'true') {
                        linkUrl = '/product/needToknow?source=h5'
                    } else {
                        linkUrl = '/product/preSale';
                    }
                    break;
                case '10': // 领券中心
                    linkUrl = '/couponList/index';
                    break;
                case '11': // 恒昌资讯
                    linkUrl = '/news/index';
                    break;
                case '12': // 新品收集
                    linkUrl = '/personal/collectNew?source=h5&title=新品收集';
                    break;
            }
            this.$router.push(linkUrl)
        },
        /**
         * 跳转购物车
         */
        goCart() {
            this.$router.push('/cart/index')
        },
        /**
         * 弹窗
         */
        getPop() {
            if (!localStorage.getItem('popFlagCfy')) {
                Api.fetchWinPop({ source: 4, sourceType: 1 }).then(({ data: { data }}) => {
                    if (data.length === 0) return
                    this.showPop = true
                    let infoData = data
                    const index = Math.floor(Math.random() * infoData.length)
                    infoData = infoData[index]
                    infoData['mainImg'] = this.$store.getters.userInfo.oss + infoData.mobileImgUrl
                    this.winPopInfo = infoData
                })
            } else {
                this.showPop = false
            }
        },
        /**
         * 弹窗跳转
         */
        goPopPage(item) {
            if (item.mobileType === 1) {
                this.$router.push(`/product/detail/${item.mobileBusinessValue}`)
            } else if (item.mobileType === 2) {
                this.goInnerPage(item.mobileBusinessValue)
                // this.$router.push('/product/promotion')
            } else if (item.mobileType === 3) {
                if (item.mobileBusinessValue === '' || item.mobileBusinessValue == null) {
                    return
                }
                if (item.mobileBusinessValue.indexOf('?') !== -1) {
                    window.location.href = item.mobileBusinessValue + '&source=h5'
                } else {
                    window.location.href = item.mobileBusinessValue + '?source=h5'
                }
            } else if (item.mobileType === 4) {
                const firstSid = JSON.parse(item.mobileBusinessValue).parentTypeId
                const secondSid = JSON.parse(item.mobileBusinessValue).typeId
                this.$router.push('/smart-mall/menu?firstSid=' + firstSid + "&secondSid=" + secondSid)
            }
            localStorage.setItem("popFlagCfy", true)
        },
        /**
         * 关闭弹窗
         */
        closeBtn() {
            this.showPop = false
            localStorage.setItem("popFlagCfy", true)
        }
    }
}
</script>

<style lang="scss">
.Page-smart-mall {
    background: #F1F1F1;
    .bottom{
        margin-top: .24rem;
    }
    .smart-mall-tabbar{
        .van-tabbar-item__icon{
            img{
                height: .48rem;
            }
        }
    }
    .floor-title{
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: .14rem 0 .22rem;
        span{
            font-size: .32rem;
            color: #333;
            font-weight: 600;
            line-height: .52rem;
            height: .44rem;
            line-height: .48rem;
        }
        span:nth-child(2){
            display: flex;
            align-items: center;
            span{
                font-size: .26rem;
                color: #BBBBBB;
                font-weight: 400;
            }
        }
        img{
            width: .32rem;
            height: .32rem;
        }
    }
    .van-popup {
        width: 5.6rem;
        height: 8.4rem;
        margin: auto;
        background: transparent;

        .active-box {
            width: 100%;
            height: 7.56rem;

            img {
                width: 100%;
                height: 100%;
            }
        }

        .close-btn {
            width: 0.52rem;
            height: 0.52rem;
            position: absolute;
            bottom: 0.1rem;
            left: 0;
            right: 0;
            margin: auto;
            z-index: 5555;

            img {
                width: 100%;
                height: 100%;
            }
        }
    }
    .top {
        height: 1.48rem;
        background: #fff;
        padding: .1rem 0;
        .floor-1 {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.24rem;
            color: #333333;
            height: 0.6rem;
            padding: 0.06rem 0 0;
            img {
                height: 0.48rem;
                padding: 0 0.22rem;
            }
        }
        .floor-2 {
            display: flex;
            align-items: center;
            padding: 0.16rem 0.2rem;
            img {
                width: 0.48rem;
                height: 0.48rem;
            }
            i {
                font-size: 0.48rem;
                color: #333333;
            }
            .van-cell-group {
                position: relative;
                padding: 0.1rem 0.4rem 0.1rem 0.6rem;
                margin: 0 0.2rem;
                background: #f4f4f4;
                border-radius: 0.68rem;
                width: 80%;
                img {
                    position: absolute;
                    top: 0.1rem;
                    left: 0.4rem;
                }
                .van-cell {
                    padding: 0;
                    background: #f4f4f4;
                    .van-field__control {
                        font-size: 0.24rem;
                        color: #999999;
                    }
                }
            }
            [class*="van-hairline"]::after {
                border: none;
            }
        }
        .fixedFloor {
            position: fixed;
            top: 0;
            left: 0;
            background: #ed3129;
            width: 7.1rem;
            z-index: 9;
            transform: translateZ(0);
            i {
                color: #fff;
            }
        }
    }
    .swiper-box {
        padding: 0.16rem 0.2rem;
        .van-swipe {
            width: 100%;
            height: 3.6rem;
            img {
                width: 100%;
                height: 100%;
                border-radius: .16rem;
            }
            .van-swipe__indicator {
                background-color: rgba(0, 0, 0, 0.5);
                width: 0.08rem;
                height: 0.08rem;
            }
        }
    }
    .icon-list {
        display: flex;
        padding: 0;
        flex-wrap: wrap;
        .icon-item {
            padding: 0.1rem 0.2rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 1.47rem;
            text-align: center;
            img {
                width: 0.76rem;
                height: 0.76rem;
                margin-bottom: 0.12rem;
            }
            span {
                display: block;
                font-size: 0.28rem;
            }
        }
    }
    .item-list {
        .floor-box{
            border-radius: .16rem;
            max-height: 15.4rem;
            margin: .12rem .2rem 0;
        }
        .item-hd{
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            .item-box{
                margin: .12rem;
                background: linear-gradient(136deg, #FFFFFF 0%, #FFF9F9 100%);
                border-radius: .16rem;
                &.item-box-1{
                    background: linear-gradient(136deg, #FFFFFF 0%, #F4FBFF 100%);
                    margin: .12rem .12rem .12rem 0;
                }
                &.item-box-2{
                    background: linear-gradient(136deg, #FFFFFF 0%, #FBF4FF 100%);
                    margin: 0 .12rem .12rem .12rem;
                }
                &.item-box-3{
                    background: linear-gradient(136deg, #FFFFFF 0%, #FFFCF1 100%);
                    margin: 0 .12rem .12rem 0;
                }
                .page-index-productCard-1{
                    width: 3.36rem;
                    height: 6.4rem;
                    padding: .12rem;
                    margin: 0;
                    background: transparent;
                }
            }
        }
        &.item-list-border {
            margin-top: 0.48rem;
            border-bottom: 1px solid rgba(228, 228, 228, 1);
        }

        &.item-list-border:last-child {
            border-bottom: 0 solid rgba(228, 228, 228, 1);
        }

        .item-title {
            display: flex;
            justify-content: space-between;

            .item-tips {
                width: 1.86rem;
                height: 0.48rem;
                border-radius: 0 2rem 2rem 0;
                font-size: 0.36rem;
                color: #fff;
                line-height: 0.48rem;
                text-align: center;
                font-weight: 600;
            }

            .item-text {
                margin-right: 0.18rem;
                font-size: 0.28rem;
                color: rgba(51, 51, 51, 1);
                display: flex;
                align-items: center;

                img {
                    margin-left: 0.08rem;
                    width: 0.28rem;
                    height: 0.28rem;
                }
            }
        }

        .top-banner {
            width: 7.1rem;
            height: 2.2rem;
            margin: .3rem .2rem 0;
            .van-swipe{
                .van-swipe__indicators{
                    bottom: .39rem;
                    .van-swipe__indicator{
                        width: 0.12rem;
                        height: .12rem;
                        border-radius: 50%;
                        &.van-swipe__indicator--active{
                            width: 0.12rem;
                        }
                    }
                }
            }
            img {
                width: 7.1rem;
                height: 2.2rem;
                border-radius: .16rem;
            }
        }
        .van-swipe {
            .van-swipe__track{
                padding-bottom: .12rem;
            }

            .van-swipe__indicators {
                bottom: 0;

                .van-swipe__indicator {
                    width: 0.12rem;
                    height: 0.08rem;
                    border-radius: .04rem;
                    opacity: 0.15;
                    background-color: #FF4646;
                    &.van-swipe__indicator--active{
                        width: .24rem;
                        opacity: 1;
                    }
                }
            }
        }
        .promotion-box{
            background: #fff;
            border-radius: .16rem;
            max-height: 15.4rem;
            margin: .24rem .2rem 0;
            padding-bottom: .4rem;
            .floor-title{
                padding: .28rem .18rem .22rem .28rem;
            }
        }
    }
    .product-card-theme-2 {
        display: flex;
        align-items: center;
        margin-top: 0.2rem;
        .page-index-productCard {
            &:nth-child(1) {
                border-right: 0.01rem solid rgba(228, 228, 228, 1);
            }
            &:last-child {
                border-bottom: 0rem solid rgba(228, 228, 228, 1);
            }
        }
        .item-li {
            position: relative;
            padding: 0 0.2rem 0.2rem 0.2rem;
            box-sizing: border-box;
            width: 3.74rem;
            text-align: left;

            .item-image {
                width: 3rem;
                height: 3rem;
                background: #fff;
                margin-left: 0.15rem;
                position: relative;

                .sold-out {
                    position: absolute;
                    top: 1.2rem;
                    left: 0.8rem;
                    width: 1.4rem;
                    height: 1.4rem;
                    z-index: 1;
                }

                img {
                    width: 100%;
                    height: 100%;
                }

                .perSaleImg {
                    position: absolute;
                    top: 0;
                    left: -0.2rem;
                    width: 0.76rem;
                    height: 0.44rem;
                }

                .purchased-span {
                    position: absolute;
                    font-size: 0.2rem;
                    color: #f19701;
                    bottom: -0.2rem;
                    width: 100%;
                    text-align: center;
                }
            }

            .item-info {
                .row-1 {
                    display: flex;
                    align-items: center;
                    padding-top: 0.08rem;
                    justify-content: space-between;

                    .title {
                        display: inline-block;
                        max-width: 3.35rem;
                        color: #030303;
                        font-size: 0.32rem;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }
                }

                .row-2 {
                    font-size: 0.24rem;
                    color: #999;
                    line-height: 1;
                }

                .row-3,
                .row-4 {
                    color: #000;
                    font-size: 0.24rem;
                }

                .row-3 {
                    padding-top: 0.12rem;
                }

                .row-4 {
                    padding-bottom: 0.12rem;
                    max-width: 3.2rem;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .row-5 {
                    display: flex;
                    align-items: center;

                    span {
                        &:nth-child(1) {
                            font-size: 0.24rem;
                            color: #ed3129;
                            padding-right: 0.04rem;
                        }

                        &:nth-child(2) {
                            font-size: 0.36rem;
                            color: #ed3129;
                            font-weight: bold;
                            margin-right: 0.08rem;
                        }

                        &.activityType {
                            padding: 0 0.1rem;
                            color: #ed3129;
                            font-size: 0.2rem;
                            border: 1px solid #ed3129;
                            border-radius: 8px;
                            margin-right: 0.2rem;
                        }

                        &.retailPrice {
                            font-size: 0.24rem;
                            color: #999999;
                        }
                    }

                    .van-icon {
                        float: right;
                        font-size: 0.48rem;
                        color: #ed3129;
                        margin-right: 0.2rem;
                    }
                }

                // .row-6 {
                //     display: flex;
                //     align-items: center;
                //     justify-content: space-between;

                //     .van-icon {
                //         font-size: .48rem;
                //         color: #ed3129;
                //     }

                //     .sold-out-icon {
                //         color: #666666 !important;
                //     }
                // }
            }
        }
    }
}
</style>
