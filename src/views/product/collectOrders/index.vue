<template>
    <div class="page-collect-orders">
        <div class="top-div" />
        <div class="collect-orders-content">
            <div class="timer">
                <van-count-down v-if="cond.activityTimeDisplay === 'true'" :time="cond.endTime">
                    <template v-slot="timeData">
                        活动倒计时<span>{{ timeData.days > 9 ? timeData.days : '0'+timeData.days }}</span>天
                        <span>{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}</span>时
                        <span>{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}</span>分
                        <span>{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}</span>秒
                    </template>
                </van-count-down>
            </div>
            <div class="activity-title">{{ cond.activityName }}</div>
            <van-list
                v-model="loading"
                :finished="finished"
                :finished-text="'人家是有底线的哦！'"
                :offset="50"
                @load="query"
            >
                <product-list :goods-list="goodsList" />
            </van-list>
        </div>
    </div>
</template>

<script>
import Api from '@/api/product/getTogether'
import productList from '@/components/productList'
export default ({
    components: {
        productList
    },
    data() {
        return {
            goodsList: [],
            page: 1,
            loading: false,
            finished: false,
            pageName: this.$route.name,
            cond: {
                activityName: '',
                activityTimeDisplay: '',
                endTime: 0
            },
            sid: this.$route.query.sid,
            type: this.$route.query.type
        }
    },
    computed: {
        keyword() {
            return this.$store.getters.navBarKeyword;
        }
    },
    watch: {
        keyword() {
            this.goodsList = [];
            this.page = 1;
            this.query();
        }
    },
    methods: {
        query() {
            this.loading = true;
            Api.fetchGoods({
                current: this.page,
                size: 12,
                type: this.type,
                sid: this.sid,
                keyword: this.keyword
            }).then(({ data: { data }}) => {
                this.loading = false
                this.goodsList = this.goodsList.concat(data.records || []);
                if (this.page === 1) {
                    if (this.type - 0 === 2) {// 优惠券凑单
                        this.cond = {
                            activityName: data.aggrResult.name,
                            activityTimeDisplay: 'true',
                            endTime: data.aggrResult.useEndTime ? new Date(data.aggrResult.useEndTime.split('-').join('/')).getTime() - new Date().getTime() : 0
                        };
                    } else { // 活动凑单
                        this.cond = data.cond;
                        if (data.cond.activityTimeDisplay) {
                            this.cond.endTime = data.cond.endTime ? new Date(data.cond.endTime.split('-').join('/')).getTime() - new Date().getTime() : 0;
                        }
                    }
                }
                if (this.page >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
            }).catch(() => {
                this.loading = false;
                this.finished = true;
            })
        }
    }
})
</script>
<style lang="scss">
.page-collect-orders{
    background: #FFDFCD;
    .collect-orders-content{
        box-sizing: border-box;
        display: flex;
        flex-direction: column;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/collect-order-bg.png') no-repeat;
        background-size: 100% auto;
        .timer{
            margin-top: 4.08rem;
            display: flex;
            justify-content: center;
            .van-count-down{
                display: inline-block;
                height: .52rem;
                line-height: .52rem;
                padding: 0 .22rem;
                background: #FFCDBF;
                color: #CC0B06;
                border-radius: .44rem;
                >span{
                    height: .36rem;
                    padding: 0 .04rem;
                    margin: 0 .08rem;
                    background: #ED3129;
                    color: #fff;
                    border-radius: .08rem;
                    &:nth-child(1){
                        margin-left: .2rem;
                    }
                }
            }
        }
        .activity-title{
            height: .78rem;
            width: 95%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            margin: .2rem;
            line-height: .78rem;
            background: url('https://imga.hnhcyy.com/fed/b2b-wechat/collect-order-title-bg.png') no-repeat;
            background-size: 100% auto;
            padding-left: 1.56rem;
            font-weight: 600;
            font-size: .24rem;
        }
        .goods-box{
            display: flex;
            li{
                flex: 1;
                &:nth-child(1){
                    .new-product-card{
                        margin-left: .2rem;
                        &:nth-child(1){
                            margin-top: 0;
                        }
                    }
                }
                &:nth-child(2){
                    .new-product-card{
                        margin-left: .1rem;
                        &:nth-child(1){
                            margin-top: 0;
                        }
                    }
                }
                
            }
        }
    }
}
.collectOrders{
    .van-nav-bar{
        display: flex;
        .van-nav-bar__title{
            flex: 1;
            max-width: 100%;
            margin-right: .28rem;
            .search-collect-orders-goods{
                width: 100%;
            }
        }
        .van-nav-bar__left{
            position: unset;
        }
    }
}
</style>
