<template>
    <div class="image-box" @click="goDetail">
        <van-image v-if="!finishLoadFlag" :mode="mode" :src="defaultImage" />
        <van-image
            :class="finishLoadFlag ? '' : 'before-load'"
            :mode="mode"
            :src="!isAuto ? (ossUrl + replaceUrl(ossUrl, originalImage) + '?x-oss-process=image/resize,m_fill,h_'+ ossHeight +',w_' + ossWidth + watermark) : ossUrl + replaceUrl(ossUrl,originalImage)"
            :original="original"
            @load="finishLoad"
            @error="errorImg"
        />
        <img
            v-if="('isUnScope' in item && item.isUnScope) || (!('isUnScope' in item) && isUnScope(item.businessScope))"
            src="@/assets/images/not_range.png"
            class="has_not_range"
            alt=""
        >
        <template v-else>
            <img v-if="item.stock <= 0 && !item.preSale" class="sold-out" src="@/assets/images/soldOut.png">
            <img v-if="item.preSaleStock <= 0 && item.preSale" class="sold-out" src="@/assets/images/preSale-out.png">
        </template>
    </div>
</template>  

<script>
import { replaceUrl } from '@/utils/util'
var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    props: {
        defaultImage: {
            type: String,
            default: ''
        },
        originalImage: {
            type: String,
            default: ''
        },
        original: {
            type: String,
            default: ''
        },
        mode: {
            type: String,
            default: ''
        },
        sid: {
            type: Number,
            default: 0
        },
        item: {
            type: Object,
            default: function(){
                return {}
            }
        },
        ossWidth: {
            type: Number,
            default: 344
        },
        ossHeight: {
            type: Number,
            default: 308
        },
        source: {
            type: String,
            default: 'h5'
        },
        isAuto: {
            type: Boolean,
            default: false
        },
        isProductImg: {
            type: Boolean,
            default: false
        },
        pageName: {
            type: String,
            default: ''
        }
    },
    data() {
        return {
            finishLoadFlag: false,
            watermark: this.isProductImg ? this.ossWidth === 800 ? '/watermark,image_ZmVkL2IyYi1jb21tb24vc3lfODAweDgwMC5wbmc=,t_100' : '/watermark,image_ZmVkL2IyYi1jb21tb24vc3lfMjAweDIwMC5wbmc=,t_100' : '',
            replaceUrl: replaceUrl
        }
    },
    computed: {
        ossUrl(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.oss : 'https://imga.hnhcyy.com/'
        },
        userInfoScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.userInfoScope : [];
        }
    },
    mounted() {
        
    },
    methods: {
        finishLoad: function() {
            this.finishLoadFlag = true
        },
        errorImg: function(e) {
            this.finishLoadFlag = false
        },
        goDetail(){
            if (this.sid === 'hasNotDetail' || this.pageName === 'comingSoon') return;
            const sid = this.sid
            const item = this.item
            if (sid !== 0){
                if (this.source !== 'app'){
                    this.$router.push(`/product/detail/${sid}`)
                } else {
                    const loacationType = navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) ? 'hcjkpay' : 'hcyy'
                    window.location.href = loacationType + '://commodity/commodityDetail?proSid=' + sid
                }
                if (item.commodityName){
                    _czc.push(["_trackEvent", "点击商品", "goods_click", 'goodsName:' + item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType])
                }
            } else if (item !== {}){
                if (item.mobileType === 1){
                    this.$router.push(`/product/detail/${item.mobileBusinessValue}`)
                } else if (item.mobileType === 2){
                    this.goInnerPage(item.mobileBusinessValue)
                    // this.$router.push('/product/promotion')
                } else if (item.mobileType === 3){
                    if (item.mobileBusinessValue === '' || item.mobileBusinessValue == null){
                        return
                    }
                    if (item.mobileBusinessValue.indexOf('?') !== -1){
                        window.location.href = item.mobileBusinessValue + '&source=h5'
                    } else {
                        window.location.href = item.mobileBusinessValue + '?source=h5'
                    }
                } else if (item.mobileType === 4){
                    const firstSid = JSON.parse(item.mobileBusinessValue).parentTypeId
                    const secondSid = JSON.parse(item.mobileBusinessValue).typeId
                    this.$route.name === 'Smart-mall' ? this.$router.push('/smart-mall/menu?firstSid=' + firstSid + "&secondSid=" + secondSid) : this.$router.push('/menu?firstSid=' + firstSid + "&secondSid=" + secondSid)
                }
            }
            if (this.original === 'banner'){
                _czc.push(["_trackEvent", "点击轮播广告", "banner_click", "首页banner" + ";club:" + this.$store.getters.userInfo.currentType])
            }
        },
        /**
         * 跳转内部链接
         */
        goInnerPage(url){
            let linkUrl = ''
            switch (url){
                case '1': // 近期已采
                    // linkUrl = '/quick/index';
                    // localStorage.setItem("quickType", 1);
                    linkUrl = '/quick/index?quickType=1'
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "近期已采" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '2': // 近期未采
                    // linkUrl = '/quick/index';
                    // localStorage.setItem("quickType", 2);
                    linkUrl = '/quick/index?quickType=2'
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "近期未采" + ";club:" + this.$store.getters.userInfo.currentType])
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
                    if (localStorage.getItem("isShowNeedKnow") === 'true'){
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
         * 判断是主店否有经营范围
         */
        isUnScope(businessScope) {
            if (businessScope || businessScope === 0) {
                const data = this.userInfoScope.filter(v => v.isMain === 1)[0];
                return (data.scopeSidSet || []).indexOf(businessScope) === -1;
            } else {
                return false;
            }
        }
    }
}
</script>

<style lang="scss">
.image-box{
    width: 100%;
    height: 100%;
    position: relative;
    z-index: 1;
    .has_not_range,
    .sold-out{
        position: absolute;
        height: auto;
        width: 80%;
        top: 50%;
        left: 50%;
        margin-left: -40%;
        margin-top: -40%;
    }
}
.before-load {
    width: 0 !important;
    height: 0 !important;
    opacity: 0 !important;
}
</style>
