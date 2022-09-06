<template>
    <div class="detail-box">
        <template v-if="loading">
            <van-loading size="24px">加载中...</van-loading>
        </template>
        <template v-else>
            <div class="floor-1">
                <div class="row">
                    <span class="border-line" />
                    <span>套餐秒杀</span>
                    <div class="count-down">
                        <span>倒计时</span>
                        <span class="red">{{ h < 10 ? '0'+ h : h }}</span>
                        <span>:</span>
                        <span class="red">{{ m < 10 ? '0'+ m : m }}</span>
                        <span>:</span>
                        <span class="red">{{ s < 10 ? '0'+ s : s }}</span>
                    </div>
                </div>
                <div class="pkg-box">
                    <div v-for="item in activity.promotionProduct" :key="item.sid" class="pkg-goods">
                        <div class="img-box">
                            <a :href="locationType + '://commodity/commodityDetail?proSid='+item.proSid"><img :src="'https://imga.hnhcyy.com/'+item.mainImg"></a>
                            <span>{{ item.huddle===1 ? '抱团': '尚划算' }}</span>
                        </div>
                        <div class="info-box">
                            <div class="row-1">
                                <a :href="locationType + '://commodity/commodityDetail?proSid='+item.proSid" class="title"><span>{{ item.commodityName }}</span></a>
                            </div>
                            <div class="row-2">
                                <div>{{ item.spec }}</div>
                                <div>
                                    <span>×</span>
                                    <span>{{ item.proReachNum }}</span>
                                </div>
                            </div>
                            <div class="row-3">效期优于 {{ item.expireDateStr }}</div>
                            <div class="row-4">{{ item.manufacturer }}</div>
                        </div>
                    </div>
                </div>
                <div v-if="timeEnd">
                    <div class="end-tips">活动已结束，下次再来吧！</div>
                </div>
                <div v-else class="pkg-control">
                    <div class="price">
                        <span>秒杀金额：</span>
                        <span>¥</span>
                        <span> {{ activity.totalPrice }}</span>
                    </div>
                    <div class="control">
                        <van-stepper v-model="activity.quantity" step="1" min="1" />
                        <van-icon name="shopping-cart-o" @click="addToCart(activity)" />
                    </div>
                </div>
            </div>
            <div v-if="relationList.length>0" class="floor-2">
                <div class="row">
                    <span class="border-line" />
                    <span>推荐商品</span>
                </div>
                <div class="item-hd">
                    <template v-for="item in relationList">
                        <goods-card :key="item.sid" :data="item" sid-name="targetProductSid" />
                    </template>
                </div>
            </div>
        </template>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
import Api from '@/api/nationalDay'
import goodsCard from '@/components/goodsCard/Index'
import '@/utils/pxtorem'

export default {
    name: 'Detail',
    components: {
        goodsCard
    },
    data() {
        return {
            actSid: this.$route.query.id,
            activity: {},
            relationList: [],
            d: 0,
            h: 0,
            m: 0,
            s: 0,
            endTime: this.$route.query.endTime,
            countDown: false,
            timeEnd: false,
            loading: true,
            locationType: navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) ? 'hcjkpay' : 'hcyy'
        }
    },
    mounted() {
        VMnative.callHandler("setTitle", "套餐详情")

        VMnative.registerHandler('goBack', (data, responseCallback) => {
            this.$router.push('/subject/nationalDay')
        });

        this.query()
    },
    methods: {
        /**
         * 查询活动详情
         */
        query(){
            Api.getActivityInfo({
                actSid: this.actSid
            }).then(({ data: { data }}) => {
                this.activity = data.activity
                const relationList = data.relationList ? data.relationList.records || [] : []
                if (relationList.length > 0){
                    relationList.forEach(element => {
                        element.quantity = element.minNum
                    });
                }
                this.relationList = relationList;
                this.$set(this.activity, 'quantity', 1)
                this.countTime()
                this.loading = false;
            }).catch(() => {})
        },
        /**
         * 加入购物车
         */
        addToCart(item){
            const data = {
                packageId: item.sid,
                quantity: item.quantity
            }
            VMnative.callHandler("addToCart", data)

            // eslint-disable-next-line no-undef
            gio('track', 'addCart', { 'productId': item.sid, 'quantity': item.quantity });
        },
        /**
         * 倒计时
         */
        countTime: function() {
            this.countDown = true;
            // 获取当前时间
            var date = new Date();
            var now = date.getTime();
            // 设置截止时间
            var endDate = new Date(this.endTime);
            var end = endDate.getTime();
            // 时间差
            var leftTime = end - now;
            // 定义变量 d,h,m,s保存倒计时的时间
            if (leftTime >= 0) {
                this.d = Math.floor(leftTime / 1000 / 60 / 60 / 24)
                this.h = (this.d * 24) + Math.floor(leftTime / 1000 / 60 / 60 % 24);
                this.m = Math.floor(leftTime / 1000 / 60 % 60);
                this.s = Math.floor(leftTime / 1000 % 60);
            }

            if (leftTime <= 0){
                this.timeEnd = true
            }
            
            // 递归每秒调用countTime方法，显示动态时间效果
            setTimeout(this.countTime, 1000);
        }
    }
}
</script>

<style lang="scss">
.detail-box {
    .row {
        display: flex;
        align-items: center;
        padding: 0.2rem;
        font-size: 0.32rem;
        color: #333333;
        position: relative;
        .border-line {
            width: 0.08rem;
            height: 0.32rem;
            background: #ed3129;
            border-radius: 0.04rem;
            margin-right: 0.12rem;
        }
        .count-down {
            padding: 0.24rem 0;
            font-size: .28rem;
            position: absolute;
            right: .2rem;
            span {
                color: #666;
                margin: 0 0.06rem;
                &.red {
                    width:.40rem;
                    height:40rem;
                    color: #FFF;
                    padding: 0 .03rem;
                    background:rgba(237,49,41,1);
                    border-radius:4px;
                    font-size: .28rem;
                }
            }
        }
        &::after {
            position: absolute;
            content: " ";
            left: 0;
            bottom: 0;
            width: 200%;
            z-index: 1;
            border-top: 1px solid #e4e4e4;
            -webkit-transform-origin: 0 0;
            transform-origin: 0 0;
            -webkit-transform: scale(0.5, 0.5);
            transform: scale(0.5, 0.5);
        }
    }
    .floor-1 {
        .pkg-box {
            padding: 0 0.2rem;
            .pkg-goods {
                display: flex;
                align-items: center;
                padding: 0.2rem 0;
                position: relative;
                &:last-child::after {
                    display: none;
                }
                &::after {
                    position: absolute;
                    content: " ";
                    left: 0;
                    bottom: 0;
                    width: 200%;
                    z-index: 1;
                    border-top: 1px solid #e4e4e4;
                    -webkit-transform-origin: 0 0;
                    transform-origin: 0 0;
                    -webkit-transform: scale(0.5, 0.5);
                    transform: scale(0.5, 0.5);
                }
                .img-box {
                    margin-right: 0.2rem;
                    position: relative;
                    img {
                        width: 1.48rem;
                        height: 1.48rem;
                    }
                    span {
                        position: absolute;
                        left: 0;
                        top: 0;
                        background: #f69894;
                        width: 0.68rem;
                        height: 0.28rem;
                        text-align: center;
                        line-height: 0.28rem;
                        color: #ffffff;
                        font-size: 0.24rem;
                        border-top-right-radius: 0.3rem;
                        border-bottom-right-radius: 0.3rem;
                    }
                }
                .info-box {
                    line-height: 1;
                    width: 5.6rem;
                    position: relative;
                    .row-1 {
                        display: flex;
                        align-items: center;
                        padding-bottom: 0.08rem;
                        .title {
                            float: left;
                            display: block;
                            max-width: 2.3rem;
                            overflow: hidden;
                            white-space: nowrap;
                            text-overflow: ellipsis;
                            color: #333333;
                            font-size: 0.32rem;
                        }
                        .brand {
                            position: relative;
                        }
                    }
                    .row-2 {
                        position: relative;
                        padding-bottom: 0.08rem;
                        div:nth-child(1) {
                            color: #999999;
                            font-size: 0.24rem;
                        }
                        div:nth-child(2) {
                            position:absolute;
                            right: .2rem;
                            top: -0.3rem;
                            span:nth-child(1) {
                                color: #ccc;
                                font-size: 0.38rem;
                                padding-right: 0.08rem;
                            }
                            span:nth-child(2) {
                                color: #333333;
                                font-size: 0.28rem;
                            }
                        }
                    }
                    .row-3,
                    .row-4 {
                        color: #666666;
                        font-size: 0.28rem;
                        padding-bottom: 0.08rem;
                    }
                }
            }
        }
        .pkg-control {
            padding-left: 1.85rem;
            padding-bottom: 0.18rem;
            border-bottom: 0.2rem solid #f4f4f4;
            .price {
                display: flex;
                align-items: baseline;
                padding-bottom: 0.22rem;
                span:nth-child(1) {
                    color: #333333;
                    font-size: 0.28rem;
                }
                span:nth-child(2) {
                    color: #ed3129;
                    font-size: 0.28rem;
                }
                span:nth-child(3) {
                    color: #ed3129;
                    font-size: 0.36rem;
                }
            }
            .control {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-right: 0.2rem;
                .van-icon {
                    font-size: 0.42rem;
                    color: #ed3129;
                }
            }
        }
        .end-tips {
            font-size: 0.28rem;
            color: #ed3129;
            padding-left: 2rem;
            padding-bottom: 0.18rem;
            border-bottom: 0.2rem solid #f4f4f4;
        }
    }
    .floor-2 {
        .item-hd {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
        }
    }
    .van-loading {
        width: 100%;
        padding: .2rem;
        text-align: center;
    }
}
</style>
