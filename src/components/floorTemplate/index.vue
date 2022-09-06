<template>
    <div class="floor-list-box">
        <!-- 
            模块样式(1.单排3个，2.单排4个，3.单排5个，4.双排8个，5.双排16个（仅PC），6.不规则9个（仅PC）) 
            展示位置{
                乐赛仙：[1.限时促销模块,2新品抢购,3热销推荐,4底部],
                佐安堂：[1成药口服模块,2成药外用模块,3医疗器械模块,4个人护理模块,5生活用品模块,6热销推荐,7底部],
                处方药：[1成药口服模块,2成药外用模块,3医疗器械模块,4个人护理模块,5生活用品模块,6底部]
            }
            俱乐部(0处方药，1乐赛仙，2佐安堂)
            展示端：0 移动端、1 PC端
        -->
        <template v-for="item in list">
            <div v-if="item.showLocation === position" :key="item" :class="item.showLocationName === '底部' ? 'last-box box' : 'box'">
                <template v-if="item.type === 7">
                    <van-swipe :autoplay="7000">
                        <van-swipe-item
                            v-for="value in item.homePageModuleContentRefList"
                            :key="value"
                            @click="goPage(value.jumpType, value.jumpValue)"
                        >
                            <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="value.imgUrl" />
                        </van-swipe-item>
                    </van-swipe>
                </template>
                <template v-else>
                    <div class="floor-title">
                        <span>{{ item.name }}</span>
                    <!-- <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt=""> -->
                    </div>
                    <div :class="item.className+' floor-box'">
                        <div v-for="content in item.homePageModuleContentRefList" :key="content" class="content-box" @click="goPage(content.jumpType, content.jumpValue)">
                            <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="content.imgUrl" />
                        </div>
                    </div>
                </template>
            </div>
        </template>
    </div>
</template>

<script>
var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);
import imageLoad from '@/components/imageLoad/index'
export default {
    name: 'FloorTemplate',
    components: {
        imageLoad
    },
    props: {
        list: {
            type: Array,
            default: () => {
                return {

                }
            }
        },
        position: {
            type: Number,
            default: null
        }
    },
    data(){
        return {

        }
    },
    watch: {
        list: function(val, oldVal){
            this.list.forEach(item => {
                switch (item.type){
                    case 1:
                        item.className = 'floor-theme-1'
                        break;
                    case 2:
                        item.className = 'floor-theme-2'
                        break;
                    case 3:
                        item.className = 'floor-theme-3'
                        break;
                    case 4:
                        item.className = 'floor-theme-4'
                        break;
                }
            })
        }
    },
    created(){
    },
    methods: {
        // 点击跳转对应页面
        goPage(type, link) {
            localStorage.setItem("scrollPosition", document.documentElement.scrollTop || document.body.scrollTop)
            if (type === 1) {
                this.goInnerPage(link)
            } else if (type === 2) {
                if (link.indexOf('?') !== -1){
                    window.location.href = link + '&source=h5'
                } else {
                    window.location.href = link + '?source=h5'
                }
            } else if (type === 3) {
                this.$route.name === 'Smart-mall' ? this.$router.push('/smart-mall/menu?firstSid=' + JSON.parse(link).parentTypeId + "&secondSid=" + JSON.parse(link).typeId) : this.$router.push('/menu?firstSid=' + JSON.parse(link).parentTypeId + "&secondSid=" + JSON.parse(link).typeId)
            } else if (type === 4){
                this.$router.push('/activity/activity-theme?symptomSidList=' + JSON.parse(link).sid + '&title=' + JSON.parse(link).name + '&source=h5')
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
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "新品抢购" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '4': // 即将到货
                    linkUrl = '/product/coming-soon';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "即将到货" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '5': // 处方药首页
                    linkUrl = '/smart-mall/index';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "处方药首页" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '6': // 即将上涨
                    linkUrl = '/product/get-rise';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "即将上涨" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '7': // 宣传物料
                    linkUrl = '/product/materials';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "宣传物料" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '8': // 我的优惠券
                    linkUrl = '/personal/coupon';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "我的优惠券" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '9': // 预售专区
                    if (localStorage.getItem("isShowNeedKnow") === 'true'){
                        linkUrl = '/product/needToknow?source=h5'
                    } else {
                        linkUrl = '/product/preSale';
                    }
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "预售专区" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '10': // 领券中心
                    linkUrl = '/couponList/index';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "领券中心" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '11': // 恒昌资讯
                    linkUrl = '/news/index';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "恒昌资讯" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '12': // 新品收集
                    linkUrl = '/personal/collectNew?source=h5&title=新品收集';
                    break;
            }
            this.$router.push(linkUrl)
        }
    }
}
</script>

<style lang="scss">
    .floor-list-box{
        .box{
            .floor-title{
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: .24rem .24rem .22rem .4rem;
                span{
                    font-size: .32rem;
                    color: #333;
                    font-weight: 600;
                    line-height: .52rem;
                    height: .44rem;
                }
                img{
                    width: .32rem;
                    height: .32rem;
                }
            }
            &.last-box{
                border-bottom: none;
            }
            .floor-name{
                color: #333333;
                font-size: .36rem;
                font-weight:600;
                line-height: .36rem;
            }
            .floor-box{
                display: flex;
                justify-content: space-between;
                background: #ffffff;
                margin: 0 .2rem;
                border-radius: .16rem;
                padding: .2rem;
                .content-box{
                    .van-image{
                        width: 100%;
                        height: 100%;
                        img{
                            border-radius: .08rem;
                        }
                    }
                }
                &.floor-theme-1{
                    .content-box{
                        width: 2.2rem;
                        height: 3rem;
                    }
                }
                &.floor-theme-2{
                    .content-box{
                        width: 1.64rem;
                        height: 2.16rem;
                    }
                }
                &.floor-theme-3{
                    .content-box{
                        width: 1.28rem;
                        height: 1.76rem;
                    }
                }
                &.floor-theme-4{
                    flex-wrap: wrap;
                    .content-box{
                        width: 1.64rem;
                        height: 1.64rem;
                        margin-bottom: .04rem;
                        &:nth-child(5),&:nth-child(6),&:nth-child(7),&:nth-child(8){
                            margin: 0;
                        }
                    }
                }
            }
            .van-swipe{ 
                margin: .2rem .2rem 0 .2rem;
                border-radius: .16rem;
                height: 1.8rem;
                overflow: hidden;
                .van-swipe__track{
                    padding-bottom: 0!important;
                }
                .van-swipe__indicators {
                    bottom: .1rem!important;
                }
                .van-swipe__indicator {
                    opacity: .2;
                    background-color: #ffffff!important;
                    &.van-swipe__indicator--active{
                        opacity: 1;
                    }
                }
                .van-image{
                    width: 100%;
                }
                img{
                    height: 1.8rem;
                    border-radius: .16rem;
                }
            }
        }
    }
</style>
