<template>
    <app-template @init="init">
        <div class="Page-subject celarfix" :style="[{'padding-top':isApp ? '0' :'0.92rem'}]">
            <div class="goods-list">
                <van-list v-model="loading" :finished="finished" :finished-text="'我是有底线的哦！'" :offset="50" :immediate-check="false" @load="onLoad">
                    <product-card v-for="(item, index) in productData" :key="index" :item="item" :current-type="1" theme="theme-1" :source="isApp ? 'app' : 'h5'" />
                </van-list>
            </div>
            <a v-show="scrollHeight >= 50" class="back-top" @click="goBackTop">
                <van-icon name="down" />
                <p>回到顶部</p>
            </a>
        </div>
    </app-template>
</template>

<script>
import AppTemplate from '@/components/appTemplate/Index'
import productCard from '@/components/productCard/index'
import VMnative from '@/utils/VMnative'
import Api from '@/api/activity/sale'

export default {
    components: {
        AppTemplate,
        productCard
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            searchParams: { 
                current: 1, 
                size: 20, 
                medicalInsurance: 0, 
                sortType: 0, 
                huddleType: 1, 
                manufacturerList: '' 
            },
            productData: [],
            scrollHeight: 0,
            loading: false,
            finished: false
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.$route.query.title || '商品列表')
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        }
        window.addEventListener('scroll', this.scroll);
    },
    methods: {
        init() {
            this.onLoad()
        },
        /**
         * 加载更多
         */
        onLoad() {
            const params = Object.assign({}, this.searchParams, this.$route.query)
            delete params.source
            Api.searchGoods(params).then(({ data: { data }}) => {
                this.productData = this.productData.concat(data.records || [])
                this.loading = false
                if (this.searchParams.current >= data.pages) {
                    this.finished = true
                } else {
                    this.searchParams.current++
                }
            })
        },
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        goBackTop(){
            window.pageYOffset = 0
            document.documentElement.scrollTop = 0
            document.body.scrollTop = 0
        }
    }
}
</script>

<style lang="scss">
.Page-subject {
    .back-top {
        z-index: 99;
        position: fixed;
        text-align: center;
        bottom: 100px;
        width:1rem;
        height:1rem;
        background:rgba(255,255,255,.8);
        box-shadow:0px 4px 13px 3px rgba(153,153,153,0.3);
        border-radius:50%;
        right: 0.2rem;
        color: #666;
        font-size: .16rem;
        transform: translateZ(0);
        .van-icon {
            margin-top: .2rem;
            transform: rotateX(180deg);
            font-size: .38rem;
            color: #999;
            font-weight: bold;
            opacity: .8;
        }
        p {
            margin-top: -2px;
        }
    }
}
</style>
