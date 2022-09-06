<template>
    <div class="page-index-materials">
        <div class="top-div" />
        <div class="goods-box">
            <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
                <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :card-type="'materials'" :current-type="1" :theme="'theme-1'" />
            </van-list>
        </div>
    </div>
</template>

<script>
import Api from '@/api/menu/menu'
import productCard from '@/components/productCard/index'
export default {
    name: 'Materials',
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
        document.getElementsByTagName("body")[0].className = "materials-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "materials-index");
    },
    methods: {
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoodsList({
                current: this.page,
                size: 20,
                firstClassSid: 3
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
.materials-index{
    background: #f1f1f1;
    .page-index-materials{
        background: #f1f1f1;
    .goods-box{
        .goods-list-box{
            margin: 0;
            .list:nth-child(1){
                margin-top: 0.24rem;
            }
        }
    }  
    }
}

</style>
