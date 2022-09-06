<template>
    <div class="page-index-together">
        <div class="search-input">
            <img src="@/assets/images/icon-goback-b.png" alt="" @click="goback">
            <van-field v-model="keywords" :clearable="true" left-icon="search" placeholder="商品名/首字母/商品ID/厂家/标签/商标" :border="false" @input="onChange" />
        </div>
        <div class="activity">
            <div class="activity-name">
                <!-- <i v-if="actInfo.type == 1 || actInfo.type == 5 || actInfo.type == 6 || actInfo.type == 8" class="activity-name">满赠</i> -->
                <p class="select-activity">{{ type === 2 ? '优惠' : '促销' }}</p>
            </div>
            <div class="coupon-info">
                {{ actInfo.name }}
            </div>
        </div>
        <!-- <div class="countDown">
            <div>还剩：</div>
            <van-count-down :time="actInfo.newGoodsTime">
                <template v-slot="timeData">
                    <span class="item">{{ timeData.days > 9 ? timeData.days : '0'+timeData.days }}</span>天
                    <span class="item">{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}</span>小时
                    <span class="item">{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}</span>分
                    <span class="item">{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}</span>秒
                </template>
            </van-count-down>
        </div> -->
        <van-list v-model="loading" :finished="finished" :finished-text="'我是有底线的哦！'" :offset="50" @load="onLoad">
            <product-card v-for="(item, index) in goodsList" :key="index" :item="item" :current-type="1" :theme="'theme-1'" />
        </van-list>
    </div>
</template>

<script>
import Api from '@/api/product/getTogether'
import productCard from '@/components/productCard/index'
export default {
    name: 'Menu',
    components: {
        productCard
    },
    data(){
        return {
            goodsList: [],
            page: 1,
            loading: false,
            finished: false,
            actInfo: {},
            keywords: '',
            sid: this.$route.query.sid
        }
    },
    computed: {
        type: function(){
            return this.$route.query.type
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "together-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "together-index");
    },
    methods: {
        /**
         * 加载更多
         */
        onLoad() {
            Api.fetchGoods({ current: this.page, size: 12, type: this.type, sid: this.sid, keyword: this.keywords }).then(({ data: { data }}) => {
                this.goodsList = this.goodsList.concat(data.records || [])
                this.actInfo = data.aggrResult || {}
                // const currentTime = Date.parse(new Date())
                // const newEndTime = Date.parse(this.actInfo.endTime.replace(/-/g, "/"))
                // const newGoodsTime = newEndTime - currentTime
                // this.$set(this.actInfo, 'newGoodsTime', newGoodsTime)
                this.loading = false
                if (this.page >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
            })
        },
        /**
         * 监听搜索框变化
         */
        onChange(){
            if (this.keywords === '') {
                this.searchGoods()
            } else {
                this.timer && clearTimeout(this.timer)
                this.timer = setTimeout(() => {
                    this.searchGoods(this.keywords)
                }, 500);
            }
        },
        /**
         * 搜索商品
         */
        searchGoods(keyword){
            Api.fetchGoods({ type: this.type, sid: localStorage.getItem("actSid"), keyword: keyword }).then(({ data: { data }}) => {
                this.goodsList = data.records
                if (this.page >= data.pages){
                    this.finished = true
                }
            })
        },
        /**
         * 返回
         */
        goback(){
            this.$router.back(-1)
        }
    }
}
</script>

<style lang="scss">
    @mixin flex($p: row) {
        display: flex;
        flex-direction: $p;
    }
    .together-index{
        background: #F1F1F1;
    }
    .page-index-together{
        background: #F1F1F1;
        .page-index-productCard .goods-list-box{
            margin: 0;
        }
        .search-input {
            padding: .1rem .2rem;
            background: #ffffff;
            height: 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            img{
                margin-right: .16rem;
                width: .48rem;
                height: .48rem;
            }

            .van-cell {
                background: #f4f4f4;
                border-radius: 1rem;
                color: #999999;
                padding: 0.14rem 0.2rem;

                .van-icon {
                    font-size: 0.4rem;
                    margin-left: 0;
                }

                .van-field__input {
                    font-size: 0.28rem;
                }
                .van-field__body{
                    input{
                        font-size: .26rem;
                    }
                }
            }
        }
        .activity {
            background: #FFF3F3;
            display: flex;
            align-items: center;
            padding: 0.16rem 0.28rem 0.18rem 0.28rem;

            .activity-name {
                width: 0.74rem;
                margin-right: 0.12rem;
                .select-activity{
                    height: 0.4rem;
                    width: 0.74rem;
                    border: 2px solid #FF4646;
                    border-radius: 0.2rem;
                    text-align: center;
                    line-height: 0.4rem;
                    color: #ED3129;
                    font-size: 0.24rem;
                }
            }

            .activity-tips {
                min-width: 1.2rem;
                color: #666666;
                font-size: 0.28rem;
                padding: 0.2rem 0;
                font-weight: 500;
            }

            .coupon-info{
                padding: .1rem .2rem 0.1rem 0rem;
                margin-left: 0.12rem;
                color: #ED3129;
                font-size: 0.28rem;
            }
        }
        .countDown{
            @include flex;
            align-items: center;
            justify-content: center;
            margin-bottom: .64rem;
            .van-count-down{
                font-size: .24rem;
            }

            .item {
                padding: 0.02rem;
                background: #ed3129;
                border-radius: 0.04rem;
                margin: 0 0.08rem;
                color: #ffffff;
            }
        }
    }
</style>
