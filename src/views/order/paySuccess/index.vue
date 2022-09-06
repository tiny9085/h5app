<template>
    <div class="pay-success">
        <div class="top-div" />
        <img src="https://imga.hnhcyy.com/fed/b2b-wechat/success-pay.png?v=1" alt="">
        <div class="pay-success-div-text">支付成功！</div>
        <div class="pay-success-tips">将在3秒后跳转至我的订单页面！</div>
        <div class="pay-success-div">
            <router-link to="/menu/index">继续购物</router-link>
            <router-link :to="'/personal/orderlist'">查看订单</router-link>
        </div>
        <!-- 优惠券弹窗 -->
        <van-popup v-model="showCoupon" overlay-class="couponPop">
            <div class="coupon-box">
                <!-- <div class="couponInfoList">
                    <div v-for="(item, index) in couponList" :key="index" class="couponInfo">
                        <div class="left">
                            <div class="discount">
                                <span>￥</span>
                                <span>{{ item.discount }}</span>
                            </div>
                            <div v-if="item.buyMone !== 0" class="sill">
                                满{{ item.buyMoney }}可用
                            </div>
                            <div v-else class="sill">无门槛</div>
                        </div>
                        <div class="right">
                            <div class="row-1"><span>{{ item.typeName }}</span></div>
                            <div class="row-2">{{ item.productDesc }}</div>
                            <div class="row-3">使用时间：</div>
                            <div class="row-4">{{ item.useStartTimeStr }}-{{ item.useEndTimeStr }}</div>
                        </div>
                    </div>
                </div> -->
                <div class="success-pay-button" @click="closeCoupon">
                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/success-pay-button.png" alt="">
                </div>
            </div>
        </van-popup>
    </div>
</template>

<script>
import Api from '@/api/order/index'
export default {
    name: 'PaySuccess',
    data(){
        return {
            showCoupon: false
        }
    },
    computed: {
        orderId: function(){
            return localStorage.getItem('orderId')
        }
    },
    mounted(){
        this.getCouponList()
    },
    methods: {
        // 查询是否有优惠券
        getCouponList(){
            Api.fetchCouponList(this.orderId).then(({ data: { data }}) => {
                this.couponList = data || []
                if (data.length > 0){
                    this.showCoupon = true
                }
            })
        },
        // 关闭优惠券弹窗
        closeCoupon(){
            this.showCoupon = false
            this.$router.push('/personal/coupon');
        }
    }
}
</script>

<style lang="scss" scoped>
%textOver {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
    .pay-success{
        padding-top: 3.5rem;
        img {
            width: 4.96rem;
        }
        .van-popup{
            background-color: transparent;
            height: 6.4rem;
            overflow: hidden;
        }
        .coupon-box{
            width: 5.93rem;
            height: 6.3rem;
            background: url('https://imga.hnhcyy.com/fed/b2b-wechat/coupon-bg.png?v=1') 50% 50% no-repeat;
            background-size: contain;
            position: relative;
            .couponInfoList{
                position: absolute;
                top: 3.18rem;
                left: .1rem;
                // .couponInfo{
                //     &:last-child{
                //         margin: 0;
                //     }
                //     background: url('https://imga.hnhcyy.com/fed/b2b-wechat/coupon-bg-4.png') 50% 50% no-repeat;
                //     background-size: contain;
                //     width: 100%;
                //     height: 1.92rem;
                //     margin-bottom: .1rem; 
                //     display: flex;
                //     line-height: 1;
                //     .left{
                //         width: 2rem;
                //         margin: .1rem 0;
                //         border-right: .02rem dotted #FBC4C2;
                //         display: flex;
                //         flex-direction: column;
                //         justify-content: center;
                //         align-items: center;
                //         .discount{
                //             color: #ED3129;
                //             padding-bottom: .36rem;
                //             span:nth-child(1){
                //                 font-size: .32rem;
                //             }
                //             span:nth-child(2){
                //                 font-size: .52rem;
                //             }
                //         }
                //         .sill{
                //             font-size: .28rem;
                //             color: #666666;
                //         }
                //     }
                //     .right{
                //         width: 3.06rem;
                //         margin: .2rem .16rem;
                //         .row-1{
                //             span{
                //                 display: inline-block;
                //                 max-width: 2.82rem;
                //                 @extend %textOver;
                //                 padding: .06rem .12rem;
                //                 line-height: .4rem;
                //                 border-radius: .22rem;
                //                 text-align: center;
                //                 background: rgba(237,49,41,0.09);
                //                 color: #ED3129;
                //                 font-size: .28rem;
                //                 margin-bottom: .12rem;

                //             }
                //         }
                //         .row-2{
                //             color: #999999;
                //             font-size: .24rem;
                //             margin-bottom: .12rem;
                //             @extend %textOver;
                //         }
                //         .row-3{
                //             margin-bottom: .02rem;
                //         }
                //         .row-3, .row-4{
                //             font-size: .24rem;
                //             color: #666666;
                //             @extend %textOver;
                //         }
                //     }
                // }
            }
            .success-pay-button{
                position: absolute;
                bottom: -.1rem;
                left: 1.58rem;
                img{
                    width: 3.06rem;
                    height: .76rem;
                }
            }
        }
        display: flex;
        flex-direction: column;
        align-items: center;
        height: 100%;
        image{
            width: 2.60rem;
            height: 2.60rem;
            margin: .80rem 0 .40rem;
        }
        .pay-success-div-text{
            width: 2.02rem;
            height: .36rem;
            font-size: .4rem;
            font-weight: 600;
            color: #ED3129;
            line-height: .36rem;
            padding: .78rem 0 0;
        }
        .pay-success-tips{
            font-size: .28rem;
            font-weight: 400;
            color: #BBBBBB;
            padding: .2rem 0 .6rem;
        }
        .pay-success-div{
            font-size: .32rem;
            font-weight: 700;
            display: flex;
            margin-bottom: .80rem;
            line-height: 1;
            a {
                display: flex;
                justify-content: center;
                align-items: center;
                width: 2.20rem;
                height: .68rem;
                box-shadow: 0px 0px .12rem 0px rgba(255, 70, 70, 0.2);
                border-radius: .47rem;
                box-sizing: border-box;
            }
            a:nth-child(1){
                color: #FF4646;
                border: .02rem solid #FF4646;
                background: #FFFFFF;
                margin-right: .4rem;
            }
            a:nth-child(2){
                color: #ffffff;
                background: #FF4646;
            }
        }
    }
</style>
