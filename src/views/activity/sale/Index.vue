<template>
    <app-template @init="init">
        <div class="Page-subject celarfix" :style="[{'padding-top':isApp ? '0' :'0.92rem'}]">
            <div class="goods-list">
                <product-card v-for="(item, index) in productData" :key="index" :item="item" :card-type="'search'" :current-type="1" theme="theme-1" :source="isApp ? 'app' : 'h5'" />
            </div>
            <a v-show="scrollHeight >= 50" class="back-top" href="#TOP">
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
            productData: [],
            loading: false,
            scrollHeight: 0
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.$route.query.title)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        } else {
            this.$route.meta.title = this.$route.query.title
        }

        window.addEventListener('scroll', this.scroll);
    },
    methods: {
        init() {
            this.fecthProduct(this.$route.query.sidList)
        },
        fecthProduct(ids) {
            Api.fetchGoods({
                productSidList: ids.split(' ').join(""),
                size: 999
            }).then(({ data }) => {
                this.productData = data.data.records || []
            })
        },
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
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
