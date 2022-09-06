<template>
    <app-template @init="init">
        <div :class="isApp ? 'page-subject-index' : 'page-subject-index page-subject-index-h5'" :style="mobileFloorData.style">
            <ul v-if="mobileFloorData.floorData && mobileFloorData.floorData.length" class="subject-item-list">
                <template v-for="item in mobileFloorData.floorData">
                    <!-- 单个图片 -->
                    <li v-if="item.name === 'image-banner'" :key="item">
                        <div class="subject-banner">
                            <!-- 判断是否支持跳转 -->
                            <template v-if="item.data.hasLink===1">
                                <!-- 如果是商品类型 则判断是否被控销 -->
                                <a v-if="item.data.linkType!==1 || (item.data.linkType===1 && item.goodsList.length===1)" @click="imageClick(item.data)">
                                    <image-load 
                                        lazy-load
                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                        :original-image="item.data.src"
                                        :source="isApp ? 'app' : 'h5'"
                                        :is-auto="true"
                                    />
                                </a>
                            </template>
                            <template v-else>
                                <image-load 
                                    lazy-load
                                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                    :original-image="item.data.src"
                                    :source="isApp ? 'app' : 'h5'"
                                    :is-auto="true"
                                />
                            </template>
                        </div>
                    </li>
                    <!-- 文本标题 -->
                    <li v-else-if="item.name ==='text-box'" :key="item">
                        <div :style="item.data.style">{{ item.data.text }}</div>
                    </li>
                    <!-- 一行一个商品 -->
                    <li v-else-if="item.name ==='product-card-1-row-1-col'" :key="item" class="product-card-1-row-1-col">
                        <van-loading v-if="item.loading" type="circular" size="24px" vertical>加载中...</van-loading>
                        <product-card v-for="(good, index) in item.goodsList" :key="index" :item="good" :card-type="'quick'" :source="isApp ? 'app' : 'h5'" :theme="'theme-1'" />
                    </li>
                    <!-- 一行两个商品 -->
                    <li v-else-if="item.name === 'product-card-1-row-2-col'" :key="item" class="product-card-1-row-2-col">
                        <div class="col-left">
                            <template v-for="(goods, bindex) in item.goodsList">
                                <product-card
                                    v-if="bindex%2===0"
                                    :key="bindex"
                                    :item="goods"
                                    theme="newStyle"
                                    :page-name="pageName"
                                    :source="isApp ? 'app' : 'h5'"
                                />
                            </template>
                        </div>
                        <div class="col-right">
                            <template v-for="(goods, bindex) in item.goodsList">
                                <product-card
                                    v-if="bindex%2===1"
                                    :key="bindex"
                                    :item="goods"
                                    theme="newStyle"
                                    :page-name="pageName"
                                    :source="isApp ? 'app' : 'h5'"
                                />
                            </template>
                        </div>
                    </li>
                    <!-- 一行多个滑动 -->
                    <li v-else-if="item.name === 'product-card-1-row-swipe'" :key="item">
                        <van-loading v-if="item.loading" type="circular" size="24px" vertical>加载中...</van-loading>
                        <van-swipe v-if="item.goodsList" :lazy-render="true" :indicator-color="'#ED3129'">
                            <van-swipe-item v-for="aindex in Math.ceil(item.goodsList.length / 2)" :key="aindex">
                                <div class="row-swipe">
                                    <template v-for="(goods, bindex) in item.goodsList">
                                        <div v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" class="item-li">
                                            <div class="item-image">
                                                <image-load
                                                    lazy-load
                                                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                    :original-image="goods.mainImg"
                                                    :sid="goods.sid"
                                                    :source="isApp ? 'app' : 'h5'"
                                                    :item="goods"
                                                    :oss-width="400" 
                                                    :oss-height="400"
                                                />
                                                <span v-if="goods.purchased" class="purchased-span">近期已采</span>
                                                <span v-if="goods.couponsList" class="icon-text">券</span>
                                            </div>
                                            <div class="item-info">
                                                <div class="row row-1 clearfix">
                                                    <span v-if="goods.preSale" class="preSaleText">预售</span>
                                                    <span class="title" @click="goDetail(goods.sid, goods.commodityName)">{{ goods.commodityName }}</span>
                                                </div>
                                                <div class="row row-2">{{ goods.spec }}</div>
                                                <div class="row row-4">{{ goods.manufacturer }}</div>
                                                <div class="row row-3"><span style="color:#999;">效期优于</span> {{ goods.expireDateStr != null ? goods.expireDateStr : '' }}</div>
                                                <div class="row row-7">
                                                    <span v-if="goods.stock <= 0" class="arrivalTimeStr"><van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-time.png" />预计到货</span>
                                                    <span v-if="goods.stock <= 0" class="arrivalTimeStr">{{ goods.arrivalTimeStr ? (goods.arrivalTimeIsOverdue ? '待定' : goods.arrivalTimeStr) : '待定' }}</span>
                                                </div>
                                                <div class="row row-6">
                                                    <div class="price-detail">
                                                        <span>¥</span>
                                                        <span>{{ goods.price }}</span>
                                                        <span class="retailPrice">¥{{ goods.retailPrice }}</span>
                                                    </div>
                                                    <add-to-cart :item="goods" :activity-type="goods.activityType" :source="isApp ? 'app' : 'h5'" />
                                                </div>
                                            </div>
                                        </div>
                                    </template>
                                </div>
                            </van-swipe-item>
                        </van-swipe>
                    </li>
                    <!-- 套餐展示 -->
                    <li v-else-if="item.name === 'product-card-package'" :key="item">
                        <van-loading v-if="item.loading" type="circular" size="24px" vertical>加载中...</van-loading>
                        <div class="package-list-box">
                            <div v-for="(packageGoods, i) in item.goodsList" :key="i" class="package-box">
                                <div v-if="packageGoods.activityType == 2 || packageGoods.activityType == 4 || packageGoods.activityType == 1 || packageGoods.activityType == 3">
                                    <div class="package-box-title">
                                        <span>{{ packageGoods.promotionRule.typeName }}</span>
                                    </div>
                                    <div class="tips">
                                        {{ packageGoods.name }}
                                        <div class="triangle triangle-left" />
                                        <div class="triangle triangle-right" />
                                    </div>
                                    <div v-for="(items, aindex) in packageGoods.promotionProduct" :key="aindex" class="pkg-box">
                                        <div class="pkg-box-item" :style="{borderBottom: aindex + 1 === packageGoods.promotionProduct.length ? 'none': '1px solid #e4e4e4'}">
                                            <div class="col-1 col">
                                                <div class="row-1">
                                                    <image-load
                                                        lazy-load
                                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                        :original-image="items.mainImg"
                                                        :sid="items.proSid"
                                                        :source="isApp ? 'app' : 'h5'"
                                                        :item="items"
                                                        :oss-width="400" 
                                                        :oss-height="400"
                                                    />
                                                </div>
                                            </div>
                                            <div class="col-2 col">
                                                <div class="row row-1">
                                                    <span>{{ items.commodityName }}</span>
                                                </div>
                                                <div class="row row-2">{{ items.spec }}</div>
                                                <div class="row row-4">{{ items.manufacturer }}</div>
                                                <div v-if="items.expireDateStr != null" class="row row-3"><span style="color:#999;">效期优于</span> {{ items.expireDateStr }}</div>
                                            </div>
                                            <div class="col-3 col">
                                                <div class="row-1">
                                                    <span>&times;</span>
                                                    <span>{{ items.proReachNum }}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div v-if="packageGoods.promotionGifts.length !== 0" class="gift-box">
                                        <div v-for="(gift, bindex) in packageGoods.promotionGifts" :key="bindex" class="gift-list">
                                            <div class="brand">赠品</div>
                                            <image-load
                                                lazy-load
                                                class="img-box"
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="gift.mainImg"
                                                :sid="gift.proSid"
                                                :source="isApp ? 'app' : 'h5'"
                                                :item="gift"
                                                :oss-width="400" 
                                                :oss-height="400"
                                            />
                                            <div class="gift-info">
                                                <div class="floor-1">
                                                    <span>{{ gift.commodityName }}</span>
                                                </div>
                                                <div class="floor-2">
                                                    {{ gift.spec }}
                                                    <div class="num">
                                                        <span>×</span>
                                                        <span>{{ gift.count }}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="package-info">
                                        <span>套餐价：</span>
                                        <span>¥</span>
                                        <span>{{ (packageGoods.totalPrice || 0).toFixed(2) }}</span>
                                    </div>
                                    <div class="btn-box">
                                        <template v-if="packageGoods.stockStatus">
                                            <stepper-number
                                                :source="isApp ? 'app' : 'h5'"
                                                :item="packageGoods"
                                                :activity-type="packageGoods.activityType"
                                            />
                                            <add-to-cart :item="packageGoods" :activity-type="packageGoods.activityType" :source="isApp ? 'app' : 'h5'" />
                                        </template>
                                        <template v-else>
                                            <span class="arrivalTimeStr">预计到货：</span>
                                            <span class="arrivalTimeStr">{{ packageGoods.arrivalTimeStr ? (packageGoods.arrivalTimeIsOverdue ? '待定' : packageGoods.arrivalTimeStr) : '待定' }}</span>
                                        </template>
                                    </div>
                                </div>
                            </div>    
                        </div>    
                    </li>
                    <!-- 倒计时 -->
                    <li v-else-if="item.name === 'count-down'" :key="item">
                        <div class="module-count-down module-count-down-mode-h5">
                            <template v-if="item.data.datetime.length===2">
                                <div v-if="item.data.style==='1'" class="count-down-style-1">
                                    <span class="count-down-title">{{ item.timerStatus === 0 ? '活动已结束' : item.timerStatus === 1 ? '距离活动开始还有' : '距离活动结束还剩' }}</span>
                                    <van-count-down :time="item.timer" @finish="finishFn(item)">
                                        <template #default="props">
                                            <span class="count-down-number">{{ transform(props.days) }}</span>
                                            <span class="count-down-span">天</span>
                                            <span class="count-down-number">{{ transform(props.hours) }}</span>
                                            <span class="count-down-span">时</span>
                                            <span class="count-down-number">{{ transform(props.minutes) }}</span>
                                            <span class="count-down-span">分</span>
                                            <span class="count-down-number">{{ transform(props.seconds) }}</span>
                                            <span class="count-down-span">秒</span>
                                        </template>
                                    </van-count-down>
                                </div>
                                <div v-else class="count-down-style-2">
                                    <h2 class="count-down-title">{{ item.timerStatus === 0 ? '活动已结束' : item.timerStatus === 1 ? '距离活动开始还有' : '距离活动结束还剩' }}</h2>
                                    <div class="count-down-timer">
                                        <van-count-down :time="item.timer" @finish="finishFn(item)">
                                            <template #default="props">
                                                <span class="count-down-number"><div class="empty" />{{ transform(props.days) }}</span>
                                                <span class="count-down-span">天</span>
                                                <span class="count-down-number"> <div class="empty" />{{ transform(props.hours) }}</span>
                                                <span class="count-down-span">时</span>
                                                <span class="count-down-number"> <div class="empty" />{{ transform(props.minutes) }}</span>
                                                <span class="count-down-span">分</span>
                                                <span class="count-down-number"> <div class="empty" />{{ transform(props.seconds) }}</span>
                                                <span class="count-down-span">秒</span>
                                            </template>
                                        </van-count-down>
                                    </div>
                                </div>
                            </template>
                        </div>
                    </li>
                    <!-- 视频 -->
                    <li v-else-if="item.name === 'video-box'" :key="item">
                        <div class="module-video-box module-video-box-mode-h5">
                            <template v-if="item.data.src !== ''">
                                <video
                                    :src="ossUrl + replaceUrl(ossUrl, item.data.src)"
                                    poster="@/assets/images/defaultVideo.png"
                                    class="video-avatar"
                                    controls="controls"
                                    x5-playsinline=""
                                    playsinline=""
                                    webkit-playsinline=""
                                >
                                    您的浏览器不支持视频播放
                                </video>
                            </template>
                        </div>
                    </li>
                </template>
            </ul>
        </div>
    </app-template>
</template>

<script>
import Api from '@/api/activity/subject'
import AppTemplate from '@/components/appTemplate/Index'
import addToCart from '@/components/addToCart/index'
import imageLoad from '@/components/imageLoad/index'
import productCard from '@/components/productCard/index'
import StepperNumber from '@/components/stepperNumber/index';
import VMnative from '@/utils/VMnative'
import { replaceUrl } from '@/utils/util'
import moment from 'moment'
export default {
    name: 'ActivitySubject',
    components: {
        addToCart,
        AppTemplate,
        imageLoad,
        productCard,
        StepperNumber
    },
    data(){
        return {
            isApp: this.$route.query.source !== 'h5',
            pageName: this.$route.name,
            mobileFloorData: {},
            replaceUrl: replaceUrl,
            searchParams: { 
                current: 1, 
                size: 20
            },
            listFloorData: {
                goodsList: []
            },
            listLoading: false,
            listFinished: false
        }
    },
    computed: {
        ossUrl(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.oss : 'https://imga.hnhcyy.com/'
        }
    },
    created(){
        this.$route.meta.title = this.$route.query.title;
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.$route.meta.title)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                if (this.$route.query.comefrom){
                    responseCallback('0')
                } else {
                    responseCallback('1')
                    this.$router.push('/activity/index?activeTabs=2')
                }
            });
        }
        window.addEventListener('scroll', this.scroll);
    },
    beforeDestroy(){
        if (this.isApp) {
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                if (this.$route.query.comefrom){
                    responseCallback('0')
                } else {
                    responseCallback('1')
                    this.$router.push('/activity/index?activeTabs=2')
                }
            });
        }
    },
    methods: {
        init(isIos){
            this.getTopicInfo();
            this.locationType = isIos ? 'hcjkpay' : 'hcyy'
        },
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        /**
         * 获取专题详情
         */
        getTopicInfo() {
            Api.fetchTopicInfo(this.$route.query.sid).then(({ data: { data: { mobileFloorData }}}) => {
                this.formatFloorData(JSON.parse(mobileFloorData))
            })
        },
        /**
         * 组装楼层数据
         */
        formatFloorData(mobileFloorData){
            mobileFloorData.floorData.forEach(floor => {
                switch (floor.name){
                    case 'image-banner':
                        if ((floor.data.hasLink === 1 || floor.data.hasLink === '1') && (floor.data.linkType === 1 || floor.data.linkType === '1')){
                            floor.goodsList = []
                            // this.fetchGoodsAction({ type: 4, sids: floor.data.linkValue }, floor)
                            this.fetchGoodsInfo({ id: floor.data.linkValue }, floor)
                        }
                        break;
                    case 'count-down' :
                        if (floor.data.datetime.length === 2){
                            const startTime = floor.data.datetime[0]
                            const endTime = floor.data.datetime[1]
                            if (moment().isBefore(moment(startTime))){
                                floor.timer = moment(startTime).diff(moment())
                                floor.timerStatus = 1;
                            } else if (moment().isBefore(endTime)){
                                floor.timer = moment(endTime).diff(moment())
                                floor.timerStatus = 2;
                            } else {
                                floor.timer = 0;
                                floor.timerStatus = 0;
                            }
                        }
                        break;
                    default:
                        floor.goodsList = []
                        this.fetchGoods(floor)
                        break;
                }
            });
            this.$set(this.mobileFloorData, 'style', mobileFloorData.style)
            this.$set(this.mobileFloorData, 'floorData', mobileFloorData.floorData)
        },
        /**
         * 获取商品
         */
        fetchGoods(floor){
            const params = {
                size: 1000,
                current: 1
            }
            this.$set(floor, 'loading', true);
            switch (floor.data.type) {
                case 'PRODUCT_LABEL':
                    params.type = 3;
                    params.sids = this.formatSids(floor.data.selected.labels)
                    this.fetchGoodsAction(params, floor)
                    this.listFloorData = floor
                    // this.listOnLoad(floor)
                    break;
                case 'SPECIFIED_PRODUCT':
                    params.type = 4;
                    params.sids = this.formatSids(floor.data.selected.products)
                    this.fetchGoodsAction(params, floor)
                    break;
                case 'PRODUCT_CATEGORY':
                    params.type = 2;
                    params.sids = this.formatSids(floor.data.selected.classes)
                    this.fetchGoodsAction(params, floor)
                    break;
                case 'PRODUCT_PROMOTION':
                    params.type = floor.data.selected.type === 1 ? 3 : 1;
                    params.sids = this.formatSids(floor.data.selected.promotions)
                    if (floor.name === 'product-card-package'){
                        this.fetchPackage(params, floor)
                    } else {
                        this.fetchPromotionGoods(params, floor)
                    }
                    break;
            }       
        },
        /**
         * 上拉加载更多
         */
        listOnLoad(){
            const params = {
                type: 3, 
                sids: this.formatSids(this.listFloorData.data.selected.labels)
            }
            Api.fetchTopicGoods(Object.assign({}, this.searchParams, params)).then(({ data: { data }}) => {
                this.listFloorData.goodsList = this.listFloorData.goodsList.concat(data.records);
                this.$set(this.listFloorData, 'goodsList', this.listFloorData.goodsList)
                // this.$set(floor, 'loading', false);
                this.listLoading = false
                if (this.searchParams.current >= data.pages) {
                    this.listFinished = true
                } else {
                    this.searchParams.current++
                }
            }).catch(() => {
                // this.$set(floor, 'loading', false);
            })
        },
        /**
         * 获取Sids
         */
        formatSids(arr){
            const sids = []
            arr.forEach(element => {
                sids.push(element.sid)
            });
            return sids.join(",")
        },
        /**
         * 根据分类、标签、商品列表获取商品
         */
        fetchGoodsAction(parmas, floor){
            Api.fetchTopicGoods(parmas).then(({ data: { data }}) => {
                floor.goodsList = data.records || [];
                this.$set(floor, 'goodsList', floor.goodsList)
                this.$set(floor, 'loading', false);
            }).catch(() => {
                this.$set(floor, 'loading', false);
            })
        },
        /**
         * 根据商品ID获取商品
         */
        fetchGoodsInfo(parmas, floor){
            Api.getProductInfoById(parmas).then(({ data: { data }}) => {
                floor.goodsList = data ? [data] : [];
                this.$set(floor, 'goodsList', floor.goodsList)
            })
        },
        /**
         * 根据活动获取商品
         */
        fetchPromotionGoods(params, floor){
            Api.getProductPageByPromotion(params).then(({ data: { data }}) => {
                floor.goodsList = data.records || [];
                this.$set(floor, 'goodsList', floor.goodsList)
                this.$set(floor, 'loading', false);
            }).catch(() => {
                this.$set(floor, 'loading', false);
            })
        },
        /**
         * 获取套餐
         */
        fetchPackage(params, floor){
            Api.getPromotionInfoByIds({
                activityIds: params.sids
            }).then(({ data: { data }}) => {
                floor.goodsList = data || [];
                this.$set(floor, 'goodsList', floor.goodsList)
                this.$set(floor, 'loading', false);
            }).catch(() => {
                this.$set(floor, 'loading', false);
            })
        },
        /**
         * 图片跳转
         */
        imageClick(item){
            switch (item.linkType){
                // 商品详情
                case 1:
                    this.goDetail(item.linkValue)
                    break;
                // 分类地址
                case 4:
                    if (this.isApp){
                        const locationType = this.locationType
                        window.location.href =  `${locationType}://applink/category?parentTypeId=${JSON.parse(item.linkValue).parentTypeId}&typeId=${JSON.parse(item.linkValue).typeId}`
                    } else {
                        this.$router.push('/menu?firstSid=' + JSON.parse(item.linkValue).parentTypeId + '&secondSid=' + JSON.parse(item.linkValue).typeId)
                    }
                    break;
                // 内部地址
                case 2:
                    if (this.isApp){
                        window.location.href = this.getSysHref(item)
                    } else {
                        this.$router.push(this.getH5InnerPage(item))
                    }
                    break;
                // 网页地址
                case 3:
                    if (this.isApp){
                        window.location.href = item.linkValue
                    } else {
                        if (item.linkValue.indexOf('?') !== -1){
                            window.location.href = item.linkValue + '&source=h5'
                        } else {
                            window.location.href = item.linkValue + '?source=h5'
                        }
                    }
                    break;
            }
        },
        // 跳转商品详情
        goDetail(sid, name) {
            if (this.isApp){
                window.location.href = this.locationType + '://commodity/commodityDetail?proSid=' + sid
            } else {
                this.$router.push(`/product/detail/${sid}`)
            }
        },
        // APP内部地址
        getSysHref(item){
            let href = item.linkValue
            switch (item.linkValue){
                case '1':
                    href = this.locationType + `://applink/purchased`
                    break;
                case '2':
                    href = this.locationType + `://applink/nonepurchased`
                    break;
                case '3':
                    href = this.locationType + `://applink/newarrival`
                    break;
                case '4':
                    href = this.locationType + `://applink/futuresarrival`
                    break;
                case '5':
                    href = this.locationType + `://applink/smartmall`
                    break;
                case '6':
                    href = this.locationType + `://applink/markup`
                    break;
                case '7':
                    href = this.locationType + `://applink/advertisematerial`
                    break;
                case '8':
                    href = this.locationType + `://applink/mycoupon`
                    break;
                case '9':
                    href = this.locationType + `://applink/presellcenter`
                    break;
                case '10':
                    href = this.locationType + `://applink/couponcenter`
                    break;
                case '11':
                    href = this.locationType + `://applink/hcmessage`
                    break;
            }
            return href
        },
        /**
         * H5内部页面
         */
        getH5InnerPage(item){
            let href = item.linkValue
            switch (item.linkValue){
                case '1': // 近期已采
                    href = '/quick/index?quickType=1'
                    break;
                case '2': // 近期未采
                    href = '/quick/index?quickType=2'
                    break;
                case '3': // 新品抢购
                    href = '/product/new-goods';
                    break;
                case '4': // 即将到货
                    href = '/product/coming-soon';
                    break;
                case '5': // 处方药首页
                    href = '/smart-mall/index';
                    break;
                case '6': // 即将上涨
                    href = '/product/get-rise';
                    break;
                case '7': // 宣传物料
                    href = '/product/materials';
                    break;
                case '8': // 我的优惠券
                    href = '/personal/coupon';
                    break;
                case '9': // 预售专区
                    if (localStorage.getItem("isShowNeedKnow") === 'true'){
                        href = '/product/needToknow?source=h5'
                    } else {
                        href = '/product/preSale';
                    }
                    break;
                case '10': // 领券中心
                    href = '/couponList/index';
                    break;
                case '11': // 恒昌资讯
                    href = '/news/index';
                    break;
            }
            return href
        },
        /**
         * 小于10加0显示
         */
        transform(value) {
            const digits = value < 10 ? `0${value}` : value;
            return digits;
        },
        // 倒计时组件完成时改变状态
        finishFn(item) {
            item.timerStatus = item.timerStatus === 1 ? 2 : 0;
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
    #app{
        height: 100%;
        .app-wrapper{
            height: 100%;
            .app-main{
                height: 100%;
                .app-page-box{
                    height: 100%;
                }
            }
        }
    }
    .page-subject-index{
        background: #E5E5E5;
        .price-detail{
            display: flex;
            align-items: center;
            span {
                &:nth-child(1) {
                    font-size: .24rem;
                    color: #ed3129;
                    padding-right: .04rem;
                }

                &:nth-child(2) {
                    font-size: 0.36rem;
                    color: #ed3129;
                    font-weight: bold;
                }

                &.retailPrice {
                    width: 1rem;
                    @include overflowText;
                    color: #999999;
                    margin-left: .18rem;
                }
            }
        }
        .van-loading{
            height: 0.92rem;
        }
        &.page-subject-index-h5{
            padding-top: .92rem;
        }
        .before-load{
            display: none;
        }
        .product-card-1-row-1-col {
            padding: 0rem;
            .page-index-productCard {
                border-radius: 0.08rem;
                margin-bottom: -0.1rem;
                overflow: hidden;
                &:last-child {
                    margin-bottom: 0;
                }
            }
        }
        .product-card-1-row-2-col{
            box-sizing: border-box;
            margin: 0 .16rem;
            display: flex;
            justify-content: space-between;
            .col-left,.col-right{
                flex: 1;
                overflow: hidden;
                .new-product-card{
                    width: 100%;
                    .new-item-image{
                        width: 100%;
                    }
                }
            }
            .col-left{
                padding-right: .08rem;
            }
            .col-right{
                padding-left: .08rem;
            }
        }
        .subject-item-list{
            padding-bottom: 0.2rem;
            .van-image{
                width: 100%;
            }
            >li{
                overflow: hidden;
                .floor-banner{
                    img {
                        width: 100%;
                    }
                }
            }
            .subject-banner{
                // padding-bottom: .16rem;
                .image-box{
                    display: flex;
                }
                h6{
                    text-align: center;
                    font-size: .4rem;
                    color: #FFFFFF;
                    font-weight: normal;
                }
            }
            .van-swipe{
                height: 7.6rem;
                .van-swipe__indicators{
                    bottom: .16rem;
                }
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
            .row-swipe{
                width: 100%;
                display: flex;
                align-items: center;
                
            }
            .item-hd {
                width: 100%;
                display: flex;
                flex-wrap: wrap;
                align-items: center;
            }
            .item-li {
                margin-bottom: .2rem;
                margin-left: 0.15rem;
                background: #fff;
                width: calc((100% - 0.45rem) /2 );
                border-radius: .12rem;
                overflow: hidden;
                .item-image {
                    background: #fff;
                    position: relative;
                    .image-box {
                        width: 100%;
                        height: 100%;
                        position: relative;
                        display: flex;
                        justify-content: center;
                    }
                    img {
                        width: 100%;
                        height: 100%;
                    }
                    // .van-image{
                    //     width: 1.88rem;
                    //     height: 100%;
                    // }
                    .sold-out,.has_not_range {
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        margin-left: -.9rem;
                        margin-top: -.9rem;
                        width: 1.8rem;
                        height: 1.8rem;
                        z-index: 2;
                    }

                    .purchased-span{
                        position: absolute;
                        color: #FF9A38;
                        font-size: 0.24rem;
                        bottom: 0;
                        left: 0.34rem;
                        height: 0.36rem;
                        width: 1rem;
                        background: #FFF3E7;
                        border-radius: 0.24rem;
                        line-height: 0.4rem;
                        text-align: center;
                    }
                    .icon-text{
                        position: absolute;
                        bottom: 0;
                        right: 0.36rem;
                        line-height: 1;
                        display: inline-block;
                        font-size: .24rem;
                        color: #FF4646;
                        border: 0.03rem solid #FF4646;
                        border-radius: .08rem;
                        font-weight: 600;
                        padding: .04rem;
                    }
                }

                .item-info {
                    padding: 0 0.14rem 0.24rem;

                    .row-1 {
                        display: flex;
                        align-items: center;
                        padding-top: 0.24rem;
                        margin-bottom: 0.16rem;

                        .title {
                            display: inline-block;
                            color: #333333;
                            font-weight: 500;
                            font-size: 0.32rem;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                            max-width: 2.4rem;
                            margin-left: 0.08rem;
                        }
                        .preSaleText{
                            display: block;
                            height: 0.3rem;
                            width: 0.6rem;
                            color: #ED3129;
                            font-size: 0.24rem;
                            border: 0.02rem solid #FF4646;
                            text-align: center;
                            line-height: 0.32rem;
                            border-radius: 0.04rem;
                        }
                    }

                    .row-2 {
                        font-size: 0.24rem;
                        color: #999;
                        line-height: 1;
                        max-width: 3.3rem;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                        margin-bottom: 0.12rem;
                    }

                    .row-3,
                    .row-4 {
                        color: #333;
                        font-size: 0.24rem;
                    }

                    .row-3 {
                        padding-bottom: 0.24rem;
                    }

                    .row-4 {
                        padding-bottom: 0.12rem;
                        max-width: 2.92rem;
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
                                padding: 0.01rem 0.1rem;
                                color: #ed3129;
                                font-size: 0.2rem;
                                border: .02rem solid #ed3129;
                                border-radius: .16rem;
                                margin-right: 0.2rem;
                                margin-left: .1rem;
                                line-height: 1;
                            }

                            &.retailPrice {
                                font-size: 0.24rem;
                                color: #999999;
                            }
                        }
                        
                        img{
                            width: .56rem;
                        }

                        .van-icon {
                            float: right;
                            font-size: 0.48rem;
                            color: #ed3129;
                            margin-right: 0.2rem;
                        }
                    }

                    .row-6 {
                        display: flex;
                        align-items: center;
                    }
                    .row-7{
                        display: flex;
                        align-items: center;
                        padding: .12rem 0 .16rem 0;
                        min-height: .64rem;
                        line-height: .36rem;
                        .arrivalTimeStr{
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: #ED3129;
                            font-size: .24rem;
                            height: .36rem;
                            line-height: .36rem;
                        }
                        span:nth-child(1){
                            width: 1.4rem;
                            background: #FFEDED;
                            border-radius: .08rem;
                            margin-right: .12rem;
                            .van-icon{
                                width: .24rem;
                                height: .24rem;
                                margin-right: .04rem;
                            }
                        }
                    }
                }
            }
            .package-box {
                background: #fff;
                margin: 0.3rem 0.36rem 0.3rem 0.43rem;
                border-radius: .08rem;
                &:nth-child(1){
                    margin-top: 0;
                }

                .package-box-title {
                    padding: 0.2rem;
                    display: flex;
                    align-items: center;
                    line-height: 1;
                    flex-direction: column;
                    align-items: flex-start;

                    span:nth-child(1) {
                        font-size: 0.36rem;
                        color: #333333;
                        padding: .08rem 0;
                    }

                    span:nth-child(2) {
                        font-size: 0.28rem;
                        line-height: .32rem;
                        color: #666666;
                    }
                }

                .tips{
                    background: #FDEAE9;
                    padding: 0.11rem 0.4rem;
                    color: #ED3129;
                    font-size: .28rem;
                    line-height: .4rem;
                    width: 6.3rem;
                    position: relative;
                    left: -.2rem;
                    text-align: justify;
                    .triangle{
                        position: absolute;
                        border-width: .1rem;
                        border-style: solid;
                        &.triangle-left{
                            bottom: -.2rem;
                            left: 0rem;
                            border-color: #FABCBF #FABCBF transparent transparent;
                        }
                        &.triangle-right{
                            bottom: -.2rem;
                            right: 0;
                            border-color: #FABCBF transparent transparent #FABCBF;
                        }
                    }
                }

                .pkg-name {
                    font-size: 0.28rem;
                    color: #666666;
                    padding: 0 0.4rem;
                }

                .sold-out {
                    position: absolute;
                    top: 0;
                    right: 0;
                    width: 1.6rem;
                    height: 1.6rem;
                }

                .pkg-box {
                    
                    .pkg-box-item {
                        display: flex;
                        padding: 0.32rem 0.2rem 0.2rem;
                        border-bottom: 0.01rem solid #e4e4e4;
                    }

                    .col-1 {
                        margin-right: 0.2rem;

                        .row-1 {
                            width: 1.48rem;
                            height: 1.48rem;
                            position: relative;
                            img {
                                width: 100%;
                                height: 100%;
                            }
                        }
                    }

                    .col-2 {
                        margin-right: 0.6rem;
                        width: 3.9rem;

                        .row-1 {
                            display: flex;
                            align-items: center;

                            span:nth-child(1) {
                                color: #333333;
                                font-size: 0.30rem;
                                max-width: 3.34rem;
                                font-weight: 500;
                                overflow: hidden;
                                white-space: nowrap;
                                text-overflow: ellipsis;
                            }
                        }

                        .row-2 {
                            padding-top: 0.08rem;
                            padding-bottom: 0.19rem;
                            color: #999999;
                            font-size: 0.23rem;
                        }

                        .row-4 {
                            padding-bottom: 0.08rem;
                            max-width: 3.34rem;
                            overflow: hidden;
                            white-space: nowrap;
                            text-overflow: ellipsis;
                        }

                        .row-3,
                        .row-4 {
                            color: #666666;
                            font-size: 0.26rem;
                            font-weight: 500;
                        }
                    }
                    .col-3 {
                        .row-1{
                            display: flex;
                            margin-top: 0.5rem;
                            align-items: center;
                        }

                        span:nth-child(1) {
                            color: #cccccc;
                            font-size: 0.28rem;
                        }

                        span:nth-child(2) {
                            color: #666666;
                            font-size: 0.26rem; 
                        }
                    }
                }

                .package-info {
                    line-height: 1;
                    display: flex;
                    align-items: center;
                    padding: 0.08rem 0 0.2rem 1.9rem;

                    span {
                        color: #ed3129;

                        &:nth-child(1) {
                            font-size: 0.26rem;
                            font-weight: 500;
                        }

                        &:nth-child(2) {
                            font-size: 0.26rem;
                        }

                        &:nth-child(3) {
                            font-size: 0.34rem;
                            font-weight: 600;
                            padding-right: 0.2rem;
                        }

                        &:nth-child(4) {
                            font-size: 0.26rem;
                            font-weight: 500;
                            color: #ccc;
                            text-decoration: line-through;
                            padding-right: 0.44rem;
                        }
                    }

                    van-icon {
                        color: #ed3129;
                        font-size: 0.52rem;
                    }
                }
                .btn-box {
                    display: flex;
                    align-items: center;
                    justify-content: flex-end;
                    padding: 0 0.4rem 0.2rem 0.2rem;
                    margin-bottom: .2rem;
                    padding-left: 1.9rem;
                }

                .gift-list {
                    display: flex;
                    align-items: center;
                    padding: 0.2rem;

                    .van-checkbox {
                        .van-checkbox__icon {
                            width: 0.32rem;
                            height: 0.32rem;
                        }
                    }

                    .brand {
                        font-size: 0.24rem;
                        color: #ffffff;
                        padding: 0 0.08rem;
                        background: #ed3129;
                        opacity: 0.5;
                        margin: 0 0.12rem 0 .2rem;
                    }

                    .img-box {
                        width: 0.6rem;
                        height: 0.6rem;
                        margin-right: 0.2rem;

                        img {
                            width: 0.6rem;
                            height: 0.6rem;
                            margin-right: 0.2rem;
                        }
                    }

                    .gift-info {
                        width: 4.8rem;

                        .floor-1 {
                            display: flex;
                            align-items: center;
                            line-height: 1;
                            padding-bottom: 0.08rem;

                            span:nth-child(1) {
                                color: #666666;
                                font-size: 0.28rem;
                                max-width: 2.8rem;
                                text-overflow: ellipsis;
                                overflow: hidden;
                                white-space: nowrap;
                            }
                        }

                        .floor-2 {
                            color: #999999;
                            font-size: 0.24rem;
                            display: flex;
                            align-items: center;
                            line-height: 1;
                            justify-content: space-between;

                            .num {
                                padding-left: 1rem;
                                display: flex;
                                align-items: center;

                                span:nth-child(1) {
                                    color: #cccccc;
                                    font-size: 0.32rem;
                                    padding-right: 0.08rem;
                                }

                                span:nth-child(2) {
                                    color: #999999;
                                    font-size: 0.22rem;
                                }
                            }
                        }
                    }
                }
            }
        }
        .module-count-down {
            .count-down-style-1 {
                padding: 0.3rem 0.34rem;
                background: #FFFFFF;
                border-radius: 0.08rem;
                span {
                    &.count-down-title {
                        font-size: 0.28rem;
                        font-family: PingFang-SC-Bold, PingFang-SC;
                        font-weight: bold;
                        color: #333333;
                        margin-right: 0.26rem;
                    }
                    &.count-down-number {
                        display: inline-block;
                        width: 0.5rem;
                        height: 0.5rem;
                        font-size: 0.32rem;
                        font-family: PingFang-SC-Heavy, PingFang-SC;
                        font-weight: 800;
                        color: #FFFFFF;
                        background: #ED3129;
                        border-radius: 0.08rem;
                        text-align: center;
                        line-height: 0.5rem;
                    }
                    &.count-down-span {
                        font-size: 0.24rem;
                        font-family: PingFang-SC-Regular, PingFang-SC;
                        font-weight: 400;
                        color: #333333;
                        margin-right: 0.1rem;
                    }
                    &.count-down-span:last-child {
                        margin-right: 0;
                    }
                }
            }
            .count-down-style-2 {
                border-radius: 0.08rem;
                text-align: center;
                position: relative;
                .count-down-title {
                    font-size: 0.32rem;
                    font-family: PingFang-SC-Heavy, PingFang-SC;
                    font-weight: 800;
                    line-height: 1;
                    color: #FFFFFF;
                    padding: 0.4rem 0;
                    margin: 0;
                }
                .count-down-timer {
                    span {
                        .empty{
                            height: 0.04rem;
                            width: 0.44rem;
                            background: #ffffff;
                            border-radius: 1.98rem 1.98rem 0.08rem 0.08rem;
                            position: absolute;
                            top: -0.02rem;
                            left: 0.14rem;
                        }
                        &.count-down-number {
                            display: inline-block;
                            width: 0.72rem;
                            height: 0.78rem;
                            font-size: 0.44rem;
                            font-family: PingFang-SC-Heavy, PingFang-SC;
                            font-weight: 800;
                            color: #FFFFFF;
                            border-radius: 0.08rem;
                            text-align: center;
                            line-height: 0.8rem;
                            position: relative;
                            z-index: 1;
                            i {
                                position: absolute;
                                display: block;
                                top: -0.02rem;
                                z-index: 1;
                                width: 0.48rem;
                                height: 0.04rem;
                                background: #FFFFFF;
                                border-radius: 1.98rem 1.98rem 0.08rem 0.08rem;
                                left: 50%;
                                margin-left: -0.24rem;
                            }
                            &::after {
                                position: absolute;
                                top: 0;
                                left: 0;
                                z-index: -1;
                                content: ' ';
                                width: .72rem;
                                height: .4rem;
                                background: rgba(34, 34, 34, 0.5);
                                border-radius: 0.08rem 0.08rem 0 0;
                            }
                            &::before {
                                position: absolute;
                                bottom: 0;
                                left: 0;
                                z-index: -1;
                                content: ' ';
                                width: .72rem;
                                height: .4rem;
                                background: rgba(34, 34, 34, 0.7);
                                border-radius: 0 0 0.08rem 0.08rem;
                            }
                        }
                        &.count-down-span {
                            font-size: 0.28rem;
                            font-family: PingFang-SC-Regular, PingFang-SC;
                            font-weight: 400;
                            color: #FFFFFF;
                            margin-right: 0.4rem;
                        }
                        &.count-down-span:last-child {
                            margin-right: 0;
                        }
                    }
                }
            }
            .module-nodata-tips {
                font-size: 0.28rem;
                text-align: center;
                padding: 1rem 0;
                span {
                    color: #666;
                    background: #FFF;
                    padding: 0.05rem 0.3rem;
                    border-radius: 0.08rem;
                }
            }

            &.module-count-down-mode-h5 {
                padding: 1.02rem 0.18rem 0.62rem 0.22rem;
            }
            &.module-count-down-mode-pc {
                max-width: 16rem;
                min-width: 16rem;
                margin: auto;
                .count-down-style-1 {
                    padding: 0.56rem 0 0.44rem 0;
                    border-radius: 0.2rem;
                    span {
                        &.count-down-title {
                            font-size: 0.52rem;
                            font-weight: bold;
                            line-height: 1;
                            position: relative;
                        }
                        &.count-down-number {
                            display: inline-block;
                            font-size: 0.84rem;
                            font-weight: bold;
                            font-weight: 800;
                            color: #ED3129;
                            width: auto;
                            line-height: 1;
                            background: transparent;
                            margin-left: 0.36rem;
                            margin-right: 0.26rem;
                            height: 1.08rem;
                            position: relative;
                            border-bottom: 0.08rem solid #ED3129;
                            border-radius: 0;
                            
                        }
                        &.count-down-span {
                            font-size: 0.36rem;
                            font-family: PingFang-SC-Regular, PingFang-SC;
                            font-weight: 400;
                            color: #333333;
                        }
                    }
                }
                .count-down-style-2 {
                    border-radius: 0.08rem;
                    text-align: center;
                    .count-down-title {
                        font-size: 0.72rem;
                        padding: 0.8rem 0;
                    }
                    .count-down-timer {
                        span {
                            &.count-down-number {
                                display: inline-block;
                                width: 1.56rem;
                                height: 1.72rem;
                                font-size: 0.84rem;
                                font-family: PingFang-SC-Heavy, PingFang-SC;
                                font-weight: 800;
                                color: #FFFFFF;
                                border-radius: 0.08rem;
                                text-align: center;
                                line-height: 1.72rem;
                                position: relative;
                                z-index: 1;
                                i {
                                    position: absolute;
                                    display: block;
                                    top: -0.02rem;
                                    z-index: 1;
                                    width: 0.84rem;
                                    height: 0.08rem;
                                    background: #FFFFFF;
                                    border-radius: 0.08rem 0.08rem 0.08rem 0.08rem;
                                    left: 50%;
                                    margin-left: -0.42rem;
                                }
                                &::after {
                                    position: absolute;
                                    top: 0;
                                    left: 0;
                                    z-index: -1;
                                    content: ' ';
                                    width: 1.54rem;
                                    height: 0.86rem;
                                    background: rgba(34, 34, 34, 0.5);
                                    border-radius: 0.08rem 0.08rem 0 0;
                                }
                                &::before {
                                    position: absolute;
                                    bottom: 0;
                                    left: 0;
                                    z-index: -1;
                                    content: ' ';
                                    width: 1.54rem;
                                    height: 0.86rem;
                                    background: rgba(34, 34, 34, 0.7);
                                    border-radius: 0 0 0.08rem 0.08rem;
                                }
                            }
                            &.count-down-span {
                                font-size: 0.36rem;
                                font-family: PingFang-SC-Regular, PingFang-SC;
                                font-weight: 400;
                                color: #FFFFFF;
                            }
                        }
                    }
                }
            }
            .van-count-down{
                display: inline-block;
            }
        }
        .module-video-box {
            padding: 0 0.2rem;
            video {
                display: flex;
                width: 100%;
                max-width: 24rem;
                margin: auto;
            }
            .module-nodata-tips {
                font-size: 0.28rem;
                text-align: center;
                padding: 1rem 0;
                span {
                    color: #666;
                    background: #FFF;
                    padding: 0.1rem 0.3rem;
                    border-radius: 0.08rem;
                }
            }
            text-align: center;
        }
    }
    
</style>
