<template>
    <app-template v-if="pageName === 'AcitvityTheme'" @init="init">
        <div class="app-product-list">
            <div v-if="!isApp" class="top-div" />
            <van-list
                v-model="loading"
                :finished="finished"
                :finished-text="'人家是有底线的哦！'"
                :offset="50"
                :immediate-check="false"
                @load="query"
            >
                <product-list :source="isApp?'app':'h5'" :goods-list="goodsList" :back-top="true" />
            </van-list>
        </div>
    </app-template>
    <div v-else class="app-product-list">
        <van-list
            v-model="loading"
            :finished="finished"
            :finished-text="'人家是有底线的哦！'"
            :offset="50"
            @load="query"
        >
            <div class="top-div" />
            <product-list :goods-list="goodsList" />
        </van-list>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
import Api from '@/api/product/list'
import AppTemplate from '@/components/appTemplate/Index'
import productList from '@/components/productList'
export default {
    name: 'ProductList',
    components: {
        AppTemplate,
        productList
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            goodsList: [],
            page: 1,
            size: this.size,
            loading: false,
            finished: false,
            pageName: this.$route.name,
            searchParams: {
                current: 1, 
                size: 20, 
                medicalInsurance: 0, 
                sortType: 0, 
                huddleType: 1, 
                manufacturerList: '' 
            },
            scrollHeight: 0,
            searchTypeObjs: {
                getRise: 2, 
                newGoods: 1,
                preSale: 7
            }
        }
    },
    created() {
        if (['AcitvityTheme'].indexOf(this.pageName) > -1 && this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.$route.query.title || '商品列表')
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        }
    },
    destroyed() {
        document.body.style.overflow = 'auto';
        document.body.style.height = 'auto';
    },
    methods: {
        init() {
            this.query()
        },
        /**
         * 加载更多
         */
        query() {
            const params = Object.assign({}, this.searchParams, this.$route.query)
            if (['getRise', 'newGoods', 'preSale'].indexOf(this.pageName) > -1) {
                Api.fetchGoods({
                    current: this.page,
                    size: this.size,
                    searchType: this.searchTypeObjs[this.pageName],
                    huddle: 1
                }).then(({ data: { data }}) => {
                    this.goodsList = this.goodsList.concat(data.records || [])
                    this.loading = false
                    if (this.page >= data.pages) {
                        this.finished = true
                    } else {
                        this.page++
                    }
                })
            } else {
                switch (this.pageName) {
                    case 'comingSoon': // 即将到货
                        Api.fetchComingGoods({
                            current: this.page,
                            size: this.size
                        }).then(({ data: { data }}) => {
                            this.goodsList = this.goodsList.concat(data.records || [])
                            this.loading = false
                            if (this.page >= data.pages) {
                                this.finished = true
                            } else {
                                this.page++
                            }
                        })
                        break;

                    case 'promotion': // 限时促销
                        Api.fetchPromotionGoods({
                            current: this.page,
                            size: this.size,
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
                        break;

                    case 'recomGoods': // 商品详情-相关推荐
                        this.goodsList = JSON.parse(localStorage.getItem('relationList'));
                        this.page = 1;
                        this.loading = false;
                        this.finished = true;
                        break;

                    case 'materials': // 宣传物料
                        Api.searchGoods({
                            current: this.page,
                            size: this.size,
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
                        break;

                    case 'AcitvityTheme': // 品牌街
                        delete params.source
                        Api.searchGoods(params).then(({ data: { data }}) => {
                            this.goodsList = this.goodsList.concat(data.records || [])
                            this.loading = false
                            if (this.searchParams.current >= data.pages) {
                                this.finished = true
                            } else {
                                this.searchParams.current++
                            }
                        })
                        break;
                }
            }
        }
    }
}
</script>

<style lang="scss">
body{
    height: 100vh;
    overflow: hidden;
}
.app-product-list{
    height: 100vh;
    display: flex;
    flex-direction: column;
    background: #f1f1f1;
    .van-list{
        flex: 1;
        overflow-y: auto;
    }
    .goods-box{
        display: flex;
        li{
            flex: 1;
            &:nth-child(1){
                .new-product-card{
                    margin-left: .2rem;
                }
            }
            &:nth-child(2){
                .new-product-card{
                    margin-left: .1rem;
                }
            }
            
        }
    }
}

</style>
