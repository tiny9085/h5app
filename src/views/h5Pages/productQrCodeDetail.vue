<template>
    <div class="Page-product-qrCode">
        <van-loading size="24px">跳转中...</van-loading>
        <!-- <div v-if="showDetails">
            <van-swipe ref="swiperRef" indicator-color="#fff" :loop="false" @change="changeSwipe($event)">
                <van-swipe-item v-for="(item, index) in goodsBannerList" :key="index">
                    <image-load
                        :is-product-img="true"
                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                        :original-image="item.imgUrl"
                        :oss-width="800"
                        :oss-height="800"
                        :item="item"
                    />
                </van-swipe-item>
                <template #indicator>
                    <div class="custom-indicator">
                        {{ current + 1 }}/{{ goodsBannerList.length }}
                    </div>
                </template>
            </van-swipe>
            <div class="product-info">
                <div class="name">{{ details.commodityName }}</div>
                <div class="row">
                    <p class="row-title">
                        <img src="@/assets/images/price_icon.png" alt="">
                        <span>建议零售价</span>
                    </p>
                    <strong class="price"><span class="price-icon">￥</span>{{ (details.retailPrice || 0).toFixed(2) }}</strong>
                </div>
                <div class="row">
                    <p class="row-title">
                        <img src="@/assets/images/sepecal_icon.png" alt="">
                        <span>规格</span>
                    </p>
                    <p>{{ details.spec }}</p>
                </div>
                <div v-if="details.isCmedicine" class="row">
                    <p class="row-title">
                        <img src="@/assets/images/net_content_icon.png" alt="">
                        <span>净含量</span>
                    </p>
                    <p>{{ details.containedQuantity }}</p>
                </div>
                <div class="row">
                    <p class="row-title">
                        <img src="@/assets/images/manufacturer_icon.png" alt="">
                        <span>生产厂家</span>
                    </p>
                    <p>{{ details.manufacturer }}</p>
                </div>
            </div>
        </div> -->
        <!-- <div v-else class="no-data">{{ details }}</div> -->
    </div>
</template>
<script>

// import Api from '@/api/h5Pages'
// import imageLoad from '@/components/imageLoad/index'
// import VMnative from '@/utils/VMnative'

export default {
    components: {
        // imageLoad
    },
    data() {
        return {
            // isApp: this.$route.query.source === 'app',
            // details: {},
            // goodsBannerList: [],
            // videoStroge: '',
            // current: 0,
            // showDetails: false
        }
    },
    mounted() {
        // if (this.isApp) {
        //     VMnative.callHandler("setTitle", '恒昌医药集团');
        //     this.$store.commit("setHasNavbar", false)
        // }
        // this.query();
    },
    created(){
        const qrCode = this.$route.query.qrCode
        var url = window.location.href
        if (url.indexOf('productQrCodeDetail') > -1){
            window.location.href = `https://m.hnhcyy.com/qrcode.html?qrCode=${qrCode}`
        }
    },
    methods: {
        // query() {
        //     if (this.$route.query.qrCode) {
        //         Api.productDetails(this.$route.query.qrCode).then(re => {
        //             this.showDetails = true;
        //             const data = re.data.data;
        //             data.imgList.forEach(img => {
        //                 if (img.imgUrl.indexOf('.mp4') === -1){
        //                     this.goodsBannerList.push(img)
        //                 } else {
        //                     this.videoStroge = this.$store.getters.userInfo.oss + img.imgUrl
        //                 }
        //             })
        //             this.details = data;
        //         }).catch((re) => {
        //             this.showDetails = false;
        //             this.details = this.$route.query.qrCOde;
        //         })
        //     }
        // },
        /**
         * 切换轮播图
         */
        // changeSwipe(e){
        //     this.current = e;
        // }
    }
}
</script>
<style lang="scss">
.Page-product-qrCode{
    // color: #333333;
    // .no-data{
    //     padding: .4rem;
    // }
    // .product-info{
    //     padding: .16rem .4rem;
    //     .name{
    //         font-size: .36rem;
    //         line-height: .68rem;
    //         font-weight: 600;
    //     }
    //     .row{
    //         margin-bottom: .2rem;
    //         p:nth-child(2){
    //             margin-left: .74rem;
    //             font-size: .28rem;
    //         }
    //     }
    //     .row-title{
    //         img{
    //             width: .48rem;
    //             height: .48rem;
    //             margin-right: .2rem;
    //             vertical-align: middle;
    //             position: relative;
    //             top: -.04rem;
    //         }
    //         span{
    //             display: inline-block;
    //             line-height: .48rem;
    //             color: #666666;
    //             font-size: .24rem;
    //             margin-top: .14rem;
    //         }
    //     }
    //     .price{
    //         color: #ED3129;
    //         font-size: .36rem;
    //         margin-left: .68rem;
    //         .price-icon{
    //             font-size: .28rem;
    //         }
    //     }
    // }
    // .custom-indicator {
    //     position: absolute;
    //     right: .2rem;
    //     bottom: .4rem;
    //     padding: 0.04rem .08rem;
    //     font-size: .16rem;
    //     background: rgba(0, 0, 0, 0.1);
    //     color: #fff;
    // }
}
</style>
