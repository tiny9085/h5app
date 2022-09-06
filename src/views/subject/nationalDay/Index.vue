<template>
    <div class="national-day-box clearfix">
        <router-link to="/subject/nationalDay/Tips">
            <div class="top-banner">
                <van-image
                    width="100%"
                    fit="contain"
                    src="https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/top-banner.png"
                />
                <img class="entrance" src="https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/tips-icon.png" alt="">
            </div>
        </router-link>
        <div class="tab-list clearfix">
            <div class="tab-hd clearfix">
                <ul>
                    <li :class="[{'active':activeTab===1}]" @click="activeTab=1">限时秒杀</li>
                    <li v-if="hasNext" :class="[{'active':activeTab===2}]" @click="activeTab=2">下期预告</li>
                </ul>
                <div class="count-down">
                    <span>倒计时</span>
                    // eslint-disable-next-line vue/no-parsing-error
                    <span class="red">{{ h < 10 ? '0'+ h : h }}</span>
                    <span>:</span>
                    <span class="red">{{ m < 10 ? '0'+ m : m }}</span>
                    <span>:</span>
                    <span class="red">{{ s < 10 ? '0'+ s : s }}</span>
                </div>
            </div>
            <div class="banner-list clearfix">
                <ul>
                    <template v-for="(item,index) in packData">
                        <!-- <li :key="index"> -->
                        <li v-if="isNow(item)" :key="index">
                            <van-image
                                width="100%"
                                fit="contain"
                                :src="item.imageUrl + '?time=' + time"
                            />
                            <div class="tc-poper">
                                <router-link v-if="activeTab===1" class="link" :to="{path:'/subject/nationalDay/detail/',query:{id:item.id,endTime:item.endTime}}" />
                                <div v-if="activeTab===1" class="buy">
                                    <van-stepper v-model="item.quantity" min="1" step="1" />
                                    <van-icon name="shopping-cart-o" @click="addToCart(item)" />
                                </div>
                            </div>
                        </li>
                    </template>
                </ul>
            </div>
            <div class="banner-ad clearfix">
                <van-image
                    width="100%"
                    fit="contain"
                    src="https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/banner-mid.png"
                />
            </div>

            <div class="product-list goods-hd">
                <van-list
                    v-model="loading"
                    :finished="finished"
                    finished-text="人家是有底线的哦!"
                    @load="query"
                >
                    <template v-for="item in productData">
                        <goods-card :key="item.sid" :data="item" />
                    </template>
                </van-list>
            </div>
        </div>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
import moment from 'moment'
import goodsCard from '@/components/goodsCard/Index'
import Api from '@/api/nationalDay'

import '@/utils/pxtorem'
export default {
    name: 'Detail',
    components: {
        goodsCard
    },
    data(){
        return {
            loading: false,
            finished: false,
            activeTab: 1,
            time: new Date().getTime(),
            d: 0,
            h: 0,
            m: 0,
            s: 0,
            packData: [
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.16-17-299.png',
                    id: 203,
                    startTime: '2019/9/17 00:00:00',
                    endTime: '2019/9/18 23:59:59',
                    quantity: 1,
                    totalPrice: 299
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.16-17-399.png',
                    id: 194,
                    startTime: '2019/9/17 00:00:00',
                    endTime: '2019/9/18 23:59:59',
                    quantity: 1,
                    totalPrice: 399
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.16-17-499.png',
                    id: 216,
                    startTime: '2019/9/17 00:00:00',
                    endTime: '2019/9/18 23:59:59',
                    quantity: 1,
                    totalPrice: 499
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.18-19-299.png',
                    id: 193,
                    startTime: '2019/9/19 00:00:00',
                    endTime: '2019/9/20 23:59:59',
                    quantity: 1,
                    totalPrice: 299
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.18-19-399.png',
                    id: 215,
                    startTime: '2019/9/19 00:00:00',
                    endTime: '2019/9/20 23:59:59',
                    quantity: 1,
                    totalPrice: 399
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.18-19-499.png',
                    id: 204,
                    startTime: '2019/9/19 00:00:00',
                    endTime: '2019/9/20 23:59:59',
                    quantity: 1,
                    totalPrice: 499
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.20-21-299.png',
                    id: 199,
                    startTime: '2019/9/21 00:00:00',
                    endTime: '2019/9/22 23:59:59',
                    quantity: 1,
                    totalPrice: 299
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.20-21-399.png',
                    id: 205,
                    startTime: '2019/9/21 00:00:00',
                    endTime: '2019/9/22 23:59:59',
                    quantity: 1,
                    totalPrice: 399
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.20-21-499.png',
                    id: 196,
                    startTime: '2019/9/21 00:00:00',
                    endTime: '2019/9/22 23:59:59',
                    quantity: 1,
                    totalPrice: 499
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.22-23-299.png',
                    id: 198,
                    startTime: '2019/9/23 00:00:00',
                    endTime: '2019/9/24 23:59:59',
                    quantity: 1,
                    totalPrice: 299
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.22-23-399.png',
                    id: 206,
                    startTime: '2019/9/23 00:00:00',
                    endTime: '2019/9/24 23:59:59',
                    quantity: 1,
                    totalPrice: 399
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.22-23-499.png',
                    id: 197,
                    startTime: '2019/9/23 00:00:00',
                    endTime: '2019/9/24 23:59:59',
                    quantity: 1,
                    totalPrice: 499
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.24-25-299.png',
                    id: 189,
                    startTime: '2019/9/25 00:00:00',
                    endTime: '2019/9/26 23:59:59',
                    quantity: 1,
                    totalPrice: 299
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.24-25-399.png',
                    id: 201,
                    startTime: '2019/9/25 00:00:00',
                    endTime: '2019/9/26 23:59:59',
                    quantity: 1,
                    totalPrice: 399
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.24-25-499.png',
                    id: 207,
                    startTime: '2019/9/25 00:00:00',
                    endTime: '2019/9/26 23:59:59',
                    quantity: 1,
                    totalPrice: 499
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.26-27-299.png',
                    id: 208,
                    startTime: '2019/9/27 00:00:00',
                    endTime: '2019/9/28 23:59:59',
                    quantity: 1,
                    totalPrice: 299
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.26-27-399.png',
                    id: 195,
                    startTime: '2019/9/27 00:00:00',
                    endTime: '2019/9/28 23:59:59',
                    quantity: 1,
                    totalPrice: 399
                },
                {
                    imageUrl: 'https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/9.26-27-499.png',
                    id: 202,
                    startTime: '2019/9/27 00:00:00',
                    endTime: '2019/9/28 23:59:59',
                    quantity: 1,
                    totalPrice: 499
                }
            ],
            countDown: false,
            productData: [],
            searchParams: {
                actSid: 213,
                current: 1,
                size: 20
            }
        }
    },
    computed: {
        hasNext(){
            return moment().format('DD') * 1 < 26
        }
    },
    mounted(){
        VMnative.callHandler("setTitle", "十一国庆 超值惠 疯狂购")

        VMnative.registerHandler('goBack', (data, responseCallback) => {
            VMnative.callHandler("close", {})
        });
    },
    methods: {
        /**
         * 要显示的banner
         */
        isNow(item) {
            var startTime = new Date(item.startTime).getTime();
            var endTime = new Date(item.endTime).getTime();
            var nowTime = new Date().getTime();
            if (this.activeTab === 2){
                nowTime = new Date(moment().add(2, 'days')).getTime();
            }
            if (startTime < nowTime && nowTime < endTime){
                if (this.countDown === false && this.activeTab === 1){
                    this.endTime = item.endTime
                    this.countTime()
                }
                return true
            } else {
                return false
            }
        },
        /**
         * 倒计时
         */
        countTime: function(endTime) {
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
                window.location.reload()
            }
            
            // 递归每秒调用countTime方法，显示动态时间效果
            setTimeout(this.countTime, 1000);
        },
        /**
         * 加入购物车
         */
        addToCart(item){
            const data = {
                packageId: item.id,
                quantity: item.quantity
            }

            VMnative.callHandler("addToCart", data)
            
            // eslint-disable-next-line no-undef
            gio('track', 'addCart', { 'productId': item.sid, 'quantity': item.quantity });
        },
        /**
         * 跳转到套餐详情页
         */
        toDetail(item){
            if (this.activeTab === 1){
                this.$router.push({
                    path: '/subject/nationalDay/detail',
                    query: {
                        id: item.id,
                        endTime: item.endTime
                    }
                })
            } else {
                this.$toast('活动暂未开始，敬请期待！');
            }
        },
        /**
         * 查询活动详情
         */
        query(){
            Api.getActivityProduct(this.searchParams).then(({ data: { data }}) => {
                this.productData = this.productData.concat(data.records || [])
                this.loading = false;
                if (data.pages <= this.searchParams.current) {
                    this.finished = true;
                }
                this.searchParams.current++
            }).catch((res) => {
                
            })
        }
    }
}
</script>

<style lang="scss">
    .national-day-box {
        .top-banner{
            position: relative;
            .entrance{
                position: absolute;
                bottom: .2rem;
                left: 3rem;
            }
        }
        .tab-list {
            position: relative;
            top: -0.4rem;
            .tab-hd {
                padding: 0 .2rem .2rem .2rem;
                height: .4rem;
                position: relative;
                margin-bottom: .3rem;
                ul {
                    display: flex;
                    margin-top: .2rem;
                    li {
                        display: inline-block;
                        font-size:0.32rem;
                        margin-right: .4rem;
                        padding: 0.2rem 0;
                        border-bottom: 2px solid #FFF;
                        cursor: pointer;
                        &.active {
                            color: #ED3129;
                            font-weight: bold;
                            border-bottom: 2px solid #ED3129;
                        }
                    }
                }
                .count-down {
                    padding: 0.24rem 0;
                    font-size: .28rem;
                    position: absolute;
                    right: .10rem;
                    top: 0;
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
            }
            
            .banner-list {
                padding: .2rem;
                margin-top: .1rem;
                ul {
                    li {
                        position: relative;
                        .van-image {
                            position: relative;
                            z-index: 1;
                        }
                        .tc-poper {
                            z-index: 2;
                            position: absolute;
                            width: 100%;
                            height: 100%;
                            top: 0;
                            left: 0;
                            .link {
                                display: block;
                                width: 100%;
                                height: calc(100% - 40px);
                            }
                            .buy {
                                position: absolute;
                                bottom: .6rem;
                                left: .2rem;
                                z-index: 99;
                                .van-icon {
                                    top: 3px;
                                    position: absolute;
                                    font-size: .52rem;
                                    color: #ed3129;
                                    margin-left: .4rem;
                                }
                            }
                        }
                    }
                }
            }
        }
        .banner-ad {
            position: relative;
            top: -0.2rem;
        }
        .product-list {
            .van-list {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                top: -0.3rem;
                position: relative;
                .van-list__loading {
                    width: 100%;
                    padding: .2rem 0 0 .2rem;
                    .van-loading {
                        width: 100%;
                    }
                }
            }
            .van-list__finished-text {
                width: 100%;
                text-align: center;
            }
        }
        /** 步进器 **/
        .van-stepper {
            float: left;
        }
    }
</style>
