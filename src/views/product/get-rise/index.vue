<template>
    <div class="page-index-getRise">
        <div class="top-div" />
        <div class="goods-box">
            <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
                <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :card-type="'getRise'" :current-type="1" :theme="'theme-1'" />
            </van-list>
        </div>
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
        document.getElementsByTagName("body")[0].className = "get-rise-index";
    },
    beforeDestroy(){
        // document.body.removeAttribute("class", "get-rise-index");
    },
    methods: {
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoods({ current: this.page, size: 12, searchType: 2, huddle: 1 }).then(({ data: { data }}) => {
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
.get-rise-index{
    background: #F1F1F1;
    .page-index-getRise{
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
}
}
</style>
