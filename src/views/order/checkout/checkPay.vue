<template>
    <div class="checkout-box">
        <div class="title">
            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-goback.png" @click="goAway" />
            <span>恒昌收银台</span>
        </div>
    </div>
</template>

<script>
import Api from '@/api/order/index'
import { Toast, Dialog } from 'vant'
export default {
    name: 'Checkout',
    components: {
        
    },
    data() {
        return {
            isWechat: localStorage.getItem("isWechat") === 'true',
            mergOrder: localStorage.getItem("mergOrder")
        }
    },
    computed: {
        orderId: function(){
            if (this.mergOrder){
                return JSON.parse(localStorage.getItem("orderId"))
            } else {
                return localStorage.getItem("orderId")
            }
        }
    },
    activated(){
        window.removeEventListener('popstate', this.goAway, false);// false阻止默认事件
    },
    mounted(){
        this.showToast()
        if (window.history && window.history.pushState) {
            history.pushState(null, null, document.URL);
            window.addEventListener('popstate', this.goAway, false);    // false阻止默认事件    this.fun是指返回按建实际要执行的方法
        }
    },
    destroyed(){
        window.removeEventListener('popstate', this.goAway, false);// false阻止默认事件
    },
    methods: {
        /**
         * 微信支付
         */
        showToast(){
            if (this.isWechat){
                Dialog.confirm({
                    message: '支付是否遇到问题？',
                    confirmButtonText: '支付已完成',
                    cancelButtonText: '支付未完成',
                    cancelButtonColor: '#ED3129',
                    confirmButtonColor: '#999999'
                }).then(() => {
                    Api.fetchOrderInfo(this.orderId).then(({ data: { data }}) => {
                        if (data.orderStatus === 1 || !data.orderStatus){
                            Toast({
                                message: '您的订单支付失败，请重试！',
                                onOpened: () => {
                                    setTimeout(() => {
                                        this.$router.push({ path: '/personal/orderlist', query: { type: 1 }})
                                    }, 2000)
                                }
                            })
                        } else {
                            this.$router.push('/order/paySuccess')
                        }
                    })
                }).catch(() => {
                    this.$router.push({ path: '/personal/orderlist', query: { type: 1 }})        
                })
            }
        },
        /**
         * 关闭弹窗
         */
        closeDialog(){
            this.isShowCodeInput = false
        },
        /**
         * 离开当前页
         */
        goAway(){
            if (this.time > 0){
                const timeData = new Date(this.payInfo.expireTime.replace(/-/g, "/")).getTime() - new Date()
                const hours = parseInt(timeData / (1000 * 60 * 60))
                const mintues = parseInt(timeData / (1000 * 60)) - hours * 60 > 9 ? parseInt(timeData / (1000 * 60)) - hours * 60 : '0' + (parseInt(timeData / (1000 * 60)) - hours * 60)
                Dialog.confirm({
                    title: '确认要离开收银台？',
                    message: '您的订单在' + hours + "小时" + mintues + '分内未支付将被取消，请尽快完成支付',
                    cancelButtonText: '确认离开',
                    confirmButtonText: '继续支付',
                    cancelButtonColor: '#ED3129',
                    confirmButtonColor: '#999999'
                }).then(() => {
                    
                }).catch(() => {
                    window.location.href = '/#/personal/orderlist'
                    setTimeout(() => {
                        Dialog.close()
                    }, 10)
                })
            } else {
                this.$router.go(-1)
            }
        }
    }
}
</script>

<style lang="scss">
.mergBtn .van-dialog__message{
    font-size: .32rem;
    color: #666666;
    line-height: .48rem;
}
.checkout-box{
    background: #F1F1F1;
    .title {
        display: flex;
        align-items: center;
        padding: .20rem;
        background: #ffffff;

        span {
            font-size: .36rem;
            color: #333333;
            font-weight: 700;
        }

        .van-icon {
            font-size: .50rem;
            margin-right: 2.30rem;
        }
    }

    .top {
        overflow: hidden;
        margin-top: .24rem;
        background: #ffffff;
        padding: 0 .28rem;
        .order-id {
            margin-top: .24rem;
            font-size: .28rem;
            color: #333333;
            line-height: .4rem;
            text-align: center;
            font{
                color: #BBBBBB;
            }
        }
        .order-info{
            box-sizing: border-box;
            margin-top: .24rem;
            width: 100%;
            height: 2.4rem;
            background: url('https://imga.hnhcyy.com/fed/b2b-wechat/cashier_bg.png') no-repeat;
            background-size: 100%;
            text-align: center;
            padding: .28rem;
            >:nth-child(1) {
                line-height: .44rem;
                color: #666666;
                font-size: .32rem;
                font-weight: 600;
            }
            >:nth-child(2) {
                margin-top: .2rem;
                height: .66rem;
                line-height: .66rem;
                font-size: .48rem;
                font-family: PingFangSC-Semibold, PingFang SC;
                color: #ED3129;
                span{
                    font-weight: 600;
                }
            }
            .span-1{
                color: #666666;
                font-weight: 400;
                line-height: .4rem;
                margin-right: .16rem;
            }
            .van-count-down{
                margin-top: .2rem;
            }
            .item{
                color: #ED3129;
            }
        }
        .order-tips{
            display: flex;
            margin: .4rem 0;
            color: #888888;
            font{
                width: .72rem;
                color: #BBBBBB;
                font-size: .24rem;
                line-height: .34rem;
            }
            p{
                flex: 1;
            }
        }
    }

    .floor-1 {
        background: #ffffff;
        margin-top: .24rem;
        padding: .08rem .28rem .12rem .28rem;
        .discount-item{
            display: flex;
            justify-content: space-between;
            padding: .32rem 0;
            .item-left{
                display: flex;
                flex: 1;
                font-size: .32rem;
                img{
                    width: .48rem;
                    height: .48rem;
                    margin-right: .2rem;
                }
                font{
                    color: #666666;
                }
            }
            >div{
                font-size: .28rem;
                font{
                   color: #BBBBBB;
                }
            }
        }
    }

    .floor-2 {
        margin-top: .24rem;
        .balance-box {
            background: #ffffff;

            .balance-kind-box {
                display: flex;
                align-items: center;
                justify-content: space-between;
                border-bottom: .01rem solid #F4F4F4;
                position: relative;
                .cellText{
                    position: absolute;
                    top: -.08rem;
                    right: .6rem;
                    font-size: .28rem;
                    color: #333333;
                }
            }

            img {
                width: .39rem;
                height: .36rem;
                margin-right: .20rem;
                margin-top: .06rem;
            }
        }
        .pay-tips{
            width: 100%;
            height: 7.74rem;
            img{
                width: 100%;
                height: 100%;
            }
        }
    }

    .floor-3 {
        position: fixed;
        bottom: .40rem;
        width: 100%;
        background: #ffffff;
        text-align: center;
        transform: translateZ(0);

        .van-button {
            width: 7.10rem;
            background: #ED3129;
            color: #ffffff;
            border-radius: .44rem;
            font-size: .36rem;
        }
    }

    #van-dialog {
        width: 6.4rem;
        font-size: .32rem;
        .van-dialog__header {
            color: #666666;
            font-size: .24rem;
            text-align: left;
            padding-left: .40rem;
        }

        .code-info-box {
            display: flex;
            align-items: center;
            padding: .32rem .40rem .40rem;
            position: relative;

            input {
                width: 2.48rem;
                border-radius: .12rem;
                border: .02rem solid #E4E4E4;
                padding: .16rem .40rem;
                margin-right: .40rem;
            }

            .van-button {
                font-size: .24rem;
                line-height: .62rem;
                height: .68rem;
                padding: 0 .30rem;
                border-radius: .34rem;
                background: #ffffff;
                color: #ED3129 !important;
                border: .01rem solid #ED3129;
            }

            .close-dialog {
                position: absolute;
                top: -.60rem;
                right: .20rem;
                font-size: .48rem;
            }
        }

        .van-dialog__footer {
            text-align: center;
            padding-bottom: .40rem;

            .van-dialog__confirm {
                width: 2.40rem;
                height: .68rem;
                line-height: .68rem;
                background: #ED3129;
                color: #ffffff !important;
                border-radius: .44rem;
                font-size: .36rem;
                span.van-button__text{
                    text-align: center;
                    width: 2.40rem;
                    height: .68rem;
                    display: inline-block;
                    color: #ffffff;
                    background: #ED3129;
                    border-radius: .44rem;
                    font-size: .36rem;
                }
            }
        }

    }

    .van-cell {
        padding: .3rem .28rem;

        .van-cell__title {
            font-size: .32rem;
            color: #666666;
        }

        .van-clee__value {
            color: #BBBBBB;
            font-size: .24rem;
        }
    }

    .van-radio .van-radio__icon-wrap .van-radio__icon {
        width: .44rem;
        height: .44rem;
    }

    .van-radio {
        justify-content: flex-end;
    }

    .van-hairline--bottom:after,
    .van-hairline--left:after,
    .van-hairline--right:after,
    .van-hairline--surround:after,
    .van-hairline--top-bottom:after,
    .van-hairline--top:after,
    .van-hairline:after {
        border: none;
    }
}
</style>
