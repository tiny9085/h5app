<template>
    <div class="recom-box">
        <div class="top-div" />
        <!-- <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :current-type="1" card-type="ralation" :theme="'theme-1'" /> -->
        
        <div class="goods-box">
            <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50">
                <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :current-type="1" card-type="ralation" :theme="'theme-1'" />
            </van-list>
        </div>
    </div>
</template>

<script>
import productCard from '@/components/productCard/index'
export default {
    name: 'NewGoods',
    components: {
        productCard
    },
    data() {
        return {
            goodsList: JSON.parse(localStorage.getItem('relationList')),
            page: 1,
            loading: false,
            finished: true
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "recom-goods-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "recom-goods-index");
    }
}
</script>

<style lang="scss">
.recom-goods-index{
    background: #f1f1f1;
    height: auto;
}
.recom-box{
    .goods-list-box{
        margin: 0;
        .list:nth-child(1){
            margin-top: 0.24rem;
        }
    }
}
</style>
