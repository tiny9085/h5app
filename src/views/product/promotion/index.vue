<template>
    <div class="page-index-promotion">
        <div class="top-div" />
        <div class="goods-box">
            <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
                <product-card v-for="(item, index) in goodsList" :key="index" :item="item.promotionProduct[0]" :card-type="'promotion'" :current-type="1" :theme="'theme-1'" />
            </van-list>
        </div>
    </div>
</template>

<script>
import Api from '@/api/product/promotion'
import productCard from '@/components/productCard/index'
export default {
    name: 'Promotion',
    components: {
        productCard
    },
    data() {
        return {
            goodsList: [],
            page: 1,
            loading: false,
            finished: false
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "promotion-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "promotion-index");
    },
    methods: {
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoods({
                current: this.page,
                size: 20,
                sourceType: 0,
                types: 1
            }).then(({ data: { data }}) => {
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
.promotion-index{
    background: #F1F1F1;  
}
.page-index-promotion{
    background: #F1F1F1;
    .get-rise-img {
        width: 100%;
        height: 2.32rem;
        img {
            width: 100%;
            height: 100%;
        }
    }
    .goods-box {
        // padding: .20rem .20rem 0;
        .goods-list-box{
            .list:nth-child(1){
                margin-top: 0.24rem;
            }
            margin: 0;
            .row-12{
                display: flex;
                font-size: 0.24rem;
                margin-top: 0.16rem;
                div{
                    height: 0.32rem;
                    width: 0.64rem;
                    border-radius: 0.16rem;
                    border: 0.02rem solid #FF4646;
                    text-align: center;
                    line-height: 0.32rem;
                    color: #ED3129;
                }
                p{ 
                    color: #666666;
                    margin-left: 0.14rem;
                    overflow: hidden;
                    text-overflow:ellipsis;
                    white-space: nowrap;
                    max-width: 3.4rem;
                }
            }
        }
    }
}
</style>
