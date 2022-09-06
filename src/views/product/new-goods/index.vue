<template>
    <div class="goods-box">
        <div class="top-div" />
        <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
            <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :card-type="'newGoods'" :current-type="1" :theme="'theme-1'" />
        </van-list>
    </div>
</template>

<script>
import Api from '@/api/product/getRise'
import productCard from '@/components/productCard/index'
export default {
    name: 'NewGoods',
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
        document.getElementsByTagName("body")[0].className = "new-goods-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "new-goods-index");
    },
    methods: {
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoods({ current: this.page, size: 12, searchType: 1, huddle: 1 }).then(({ data: { data }}) => {
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
.new-goods-index{
    background: #f1f1f1;
    .goods-box{
        background: #f1f1f1;
    .goods-list-box{
        margin: 0.24rem 0;
        }
    }
}

</style>
