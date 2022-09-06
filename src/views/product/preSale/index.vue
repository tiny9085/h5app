<template>
    <div class="page-index-preSale">
        <div class="top-div" />
        <div class="goods-box">
            <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
                <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :current-type="1" :theme="'theme-1'" />
            </van-list>
        </div>
        <!-- <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-qiang-gray.png?v=presell" class="go-to-cart"  @click="gotoCart"> -->
    </div>
</template>

<script>
import Api from '@/api/product/getRise'
import productCard from '@/components/productCard/index'
export default {
    name: 'GetRise',
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
        document.getElementsByTagName("body")[0].className = "product-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "product-index");
    },
    methods: {
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoods({ current: this.page, size: 12, searchType: 7 }).then(({ data: { data }}) => {
                this.goodsList = this.goodsList.concat(data.records || [])
                this.loading = false
                if (this.page >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
            })
        },
        gotoCart() {
            this.$router.push("/cart/index");
        }
    }
}
</script>

<style lang="scss">
.product-index{
    background: #F1F1F1;  
}
.page-index-preSale{
    background: #F1F1F1; 
    .goods-box {
        // padding: .20rem .20rem 0;
        .goods-list-box:nth-child(1){
            margin-top: 0.24rem;
        }
        .goods-list-box{
            .list{
                margin-bottom: 0.24rem;
            }
            margin: 0;
        }
    }
    .go-to-cart{
        width: .88rem;
        position: fixed;
        bottom: .4rem;
        right: .32rem;
    }
}
</style>
