<template>
    <div class="goods-box">
        <div class="top-div" />
        <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
            <!-- <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :card-type="'comingSoon'" :current-type="1" :theme="'theme-1'" /> -->
            <div v-for="(item, index) in goodsList" :key="index" class="list">
                <div class="goods-img">
                    <!-- <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.mainImg" /> -->
                    <div>
                        <!-- <img :src="'http://hcyy-test.oss-cn-shenzhen.aliyuncs.com/' + item.mainImg" :onerror="defaultImg" alt=""> -->
                        <image-load
                            default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                            :is-product-img="true"
                            :original-image="item.mainImg"
                            :sid="item.targetProductSid?item.targetProductSid:(item.proSid?item.proSid:item.sid)"
                            :item="item"
                            :source="source"
                        />
                    </div>
                </div>
                <div class="goods-info">
                    <div class="arrivalTimeStr">
                        <img src="@/assets/images/arrival_time.png" alt="">
                        <p>{{ item.publishTime ? item.publishTime.slice(0,11) : "待定" }}</p>
                    </div>
                    <div class="row-1">{{ item.commodityName }}</div>
                    <div class="row-2">{{ item.spec }}</div>
                    <div class="row-3">{{ item.manufacturer }}</div>
                </div>
            </div>
        </van-list>
    </div>
</template>

<script>
import Api from '@/api/product/comingSoon'
import imageLoad from '@/components/imageLoad/index'
// import productCard from '@/components/productCard/index'

var _czc = _czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'ComingSoon',
    components: {
        // productCard
        imageLoad
    },
    data() {
        return {
            goodsList: [],
            page: 1,
            loading: false,
            finished: false,
            defaultImg: 'https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png'
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "coming-soon-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "coming-soon-index");
    },
    methods: {
        // goDetail(item){
        //     if (item.targetProductSid){
        //         if (this.source !== 'app'){
        //             this.$router.push(`/product/detail/${item.targetProductSid}`)
        //         } else {
        //             window.location.href = 'hcyy://commodity/commodityDetail?proSid=' + item.targetProductSid
        //         }
        //     } else if (item.proSid){
        //         if (this.source !== 'app'){
        //             this.$router.push(`/product/detail/${item.proSid}`)
        //         } else {
        //             window.location.href = 'hcyy://commodity/commodityDetail?proSid=' + item.proSid
        //         }
        //     } else {
        //         if (this.source !== 'app'){
        //             this.$router.push(`/product/detail/${item.sid}`)
        //         } else {
        //             window.location.href = 'hcyy://commodity/commodityDetail?proSid=' + item.sid
        //         }
        //     }
        //     _czc.push(["_trackEvent", "点击商品", "goods_click", 'goodsName:' + item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType])
        // },
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoods({ current: this.page, size: 12 }).then(({ data: { data }}) => {
                this.goodsList = this.goodsList.concat(data.records || [])
                this.loading = false
                if (this.page >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
            })
        }
    }
}
</script>

<style lang="scss">
.coming-soon-index{
    background: #F1F1F1;
    .goods-box{
    background: #F1F1F1;
    .top-div{
        margin-bottom: 0.2rem;
    }
    .list{
        margin-bottom: 0.28rem;
        display: flex;
        background: #ffffff;
        .goods-img{
            height: 2rem;
            width: 2rem;
            padding: 0.38rem 0 0.4rem 0.4rem;
            div{
                height: 2rem;
                width: 2rem;
                img{
                    height: 100%;
                    width: 100%;
                }
            }
        }
        .goods-info{
            width: 4.92rem;
            padding: 0.18rem 0 0.38rem 0.18rem;
            .arrivalTimeStr{
                display: flex;
                margin-left: 2.2rem;
                background: #F8F8F8;
                height: 0.42rem;
                line-height: 0.42rem;
                img{
                    height: 0.6rem;
                    width: 1.48rem;
                    margin-top: -0.1rem;
                    margin-left: -0.22rem;
                }
                p{
                    color: #FC9128;
                    font-size: 0.22rem;
                    font-weight: 500;
                    margin-left: 0.08rem;
                    margin-top: 0.01rem;
                }
            }
            .row-1{
                margin-top: 0.24rem;
                color: #333333;
                font-size: 0.32rem;
                font-weight: 600;
                overflow: hidden;
                text-overflow:ellipsis;
                white-space: nowrap;
                max-width: 3.4rem;
            }
            .row-2{
                margin: 0.08rem 0 0.22rem 0;
                color: #999999;
                font-weight: 500;
                font-size: 0.24rem;
            }
            .row-3{
                font-weight: 500;
                font-size: 0.28rem;
                color: #666666;
            }
        }
    }
}
}
</style>
