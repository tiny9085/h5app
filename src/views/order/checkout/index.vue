<template>
    <div class="checkout-box">
        <div class="title">
            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-goback.png" @click="goAway" />
            <span>恒昌收银台</span>
        </div>
        <div class="top">
            <div class="order-id">
                <font>订单编号：</font>{{ payInfo.orderId }}
            </div>
            <div class="order-info">
                <p>还需支付</p>
                <p>
                    ￥<span>{{ (totals || 0 ).toFixed(2) }}</span>
                </p>
                <van-count-down v-if="time != 0" :time="time">
                    <template v-slot="timeData">
                        <span class="span-1">支付倒计时</span>
                        <span class="item">{{ timeData.days }}天</span>
                        <span class="item">{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}时 </span>
                        <span class="item">{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}分 </span>
                        <span class="item">{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}秒</span>
                    </template>
                </van-count-down>
                <span v-else class="timeOut">您的订单已超时，请重新下单</span>
            </div>
            <div class="order-tips">
                <font>提示：</font>
                <p>若订单未在规定时间内支付，所占用的库存和余额都将自动释放</p>
            </div>
            
            <!-- <div class="row-3">
                <img src="https://imga.hnhcyy.com/fed/b2b-wechat/tips.png">
            </div> -->
        </div>
        <div class="floor-1">
            <div class="discount-item">
                <span class="item-left">
                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-fl.png">
                    <font>返利</font>
                </span>
                <div><font>冻结金额：</font>¥ {{ (payInfo.rebateAmount || 0).toFixed(2) }}</div>
            </div>
            <div class="discount-item">
                <span class="item-left">
                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-zx.png">
                    <font>专项款</font>
                </span>
                <div><font>冻结金额：</font>¥ {{ (payInfo.specialAmount || 0).toFixed(2) }}</div>
            </div>
            <div class="discount-item">
                <span class="item-left">
                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-ye.png">
                    <font>余额</font>
                </span>
                <div><font>冻结金额：</font>¥ {{ (payInfo.receivedAmount || 0).toFixed(2) }}</div>
            </div>
        </div>
        <div v-if="payInfo.totalAmount != 0" class="floor-2">
            <div class="balance-box">
                <van-radio-group v-model="radioName" checked-color="#ED3129">
                    <van-cell-group>
                        <van-cell v-if="isWechat && payInfo.invoiceType !== 2 && payInfo.paymentAmount !== 0 && payInfo.availableReceivedBalance < payInfo.paymentAmount" title="微信支付" clickable @click="choosePayKind('wechatpay')">
                            <img slot="icon" class="icon-3" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-wechat-pay.png">
                            <van-radio name="wechatpay" />
                        </van-cell>
                        <van-cell v-if="payInfo.availableReceivedBalance >= payInfo.paymentAmount && payInfo.paymentAmount !== 0" class="balance-kind-box" title="余额" clickable @click="choosePayKind('balancepay')">
                            <div class="cellText">￥{{ payInfo.paymentAmount }}</div>
                            <img slot="icon" class="icon-3" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-ye.png">
                            <van-radio name="balancepay" />
                        </van-cell>
                        <van-cell v-if="!isWechat && payInfo.invoiceType !== 2 && payInfo.paymentAmount !== 0 && payInfo.availableReceivedBalance < payInfo.paymentAmount" title="支付宝支付" clickable @click="choosePayKind('alipay')">
                            <img slot="icon" class="icon-2" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-ali-pay.png">
                            <van-radio name="alipay" />
                        </van-cell>
                        <!-- <van-cell title="银行卡支付" clickable data-name="bankpay" bind:click="choosePayKind">
                            <img slot="icon" class="icon-4" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-bank-pay.png" />
                            <van-radio name="bankpay" />
                        </van-cell> -->
                    </van-cell-group>
                </van-radio-group>
            </div>
            <div v-if="payInfo.invoiceType === 2 && payInfo.availableReceivedBalance < payInfo.paymentAmount" class="pay-tips">
                <img src="https://imga.hnhcyy.com/fed/b2b-wechat/pay-tips.png">
            </div>
        </div>
        <div class="floor-3">
            <van-button v-if="payInfo.invoiceType !== 2 || payInfo.availableReceivedBalance >= payInfo.paymentAmount" type="default" :loading="isLoading" :disabled="isDisabled" @click="payment">立即支付</van-button>
        </div>
        <van-dialog
            id="van-dialog"
            v-model="isShowCodeInput"
            use-slot
            title="请输入6位数字支付验证码"
            async-close="true"
            confirm-button-text="支付"
            @confirm="payWithBalance"
        >
            <div class="code-info-box">
                <input v-model="payCode" type="number" maxlength="6" focus>
                <van-button :type="btnType" :disabled="disabled" size="small" @click="getPayCode">{{ buttonText }}</van-button>
                <van-icon class="close-dialog" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png" @click="closeDialog" />
            </div>
        </van-dialog>
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
            payInfo: {},
            // orderId: localStorage.getItem("orderId"),
            isLoading: false,
            isShowCodeInput: false, // 是否显示验证码输入框
            buttonText: "发送验证码",
            btnType: "danger",
            disabled: false,
            isDisabled: false,
            code: '', // 验证码
            payOpenid: '',
            time: 0,
            radioName: '',
            payCode: '',
            megerOrderId: '',
            totals: 0,
            timer: null,
            isWechat: localStorage.getItem("isWechat") === 'true'
        }
    },
    computed: {
        orderId: function(){
            if (this.$route.query.mergOrder){
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
        if (this.$route.query.mergOrder){
            this.getMergOrderInfo(this.orderId)
        } else {
            this.getOrderInfo(this.orderId)
        }
        if (window.history && window.history.pushState) {
            history.pushState(null, null, document.URL);
            window.addEventListener('popstate', this.goAway, false);    // false阻止默认事件    this.fun是指返回按建实际要执行的方法
        }
        // if (localStorage.getItem("isWechat") === 'true'){
        //     this.payCode = this.getUrlParam('code')
        //     this.getOpenid(this.payCode)
        // }
    },
    destroyed(){
        window.removeEventListener('popstate', this.goAway, false);// false阻止默认事件
        clearInterval(this.timer);
    },
    methods: {
        /**
         * 获取收银台信息
         */
        getOrderInfo(orderId){
            Api.fetchOrderInfo(orderId).then((re) => {
                const data = re.data.data;
                if (re.data.code === 102017) {
                    Dialog.alert({
                        message: '订单超时已取消，请前往订单页面选择"再来一单"，并及时支付。',
                        confirmButtonColor: '#ED3129',
                        messageAlign: 'left',
                        className: 'mergBtn'
                    }).then(() => {
                        this.$router.push('/personal/orderlist')
                    });
                } else if (data.orderStatus === 1 || !data.orderStatus) {
                    this.time = new Date(data.expireTime.replace(/-/g, "/")).getTime() - new Date()
                    this.payInfo = data
                    this.totals = data.paymentAmount;
                    this.radioName = this.radioName || this.payInfo.availableReceivedBalance >= this.payInfo.paymentAmount ? 'balancepay' : this.isWechat ? 'wechatpay' : 'alipay'
                    if (this.payInfo.paymentAmount === 0 || (this.payInfo.availableReceivedBalance >= this.payInfo.paymentAmount)){
                        this.isShowCodeInput = true
                    }
                    if (!this.timer) this.init();
                } else {
                    clearInterval(this.timer);
                    this.$router.push('/order/paySuccess');
                }
            })
        },
        /**
         * 获取收银台信息(多门店)
         */
        getMergOrderInfo(orderId){
            Api.fetchMergOrderInfo(orderId).then(re => {
                const data = re.data.data;
                if (re.data.code === 102017) {
                    Dialog.alert({
                        message: '订单超时已取消，请前往订单页面选择"再来一单"，并及时支付。',
                        confirmButtonColor: '#ED3129',
                        messageAlign: 'left',
                        className: 'mergBtn'
                    }).then(() => {
                        // window.location.href = '/#/personal/orderlist'
                        this.$router.push('/personal/orderlist')
                    });
                } else if (data.orderStatus === 1 || !data.orderStatus) {
                    this.time = new Date(data.expireTime.replace(/-/g, "/")).getTime() - new Date()
                    this.megerOrderId = data.orderId;
                    localStorage.setItem('orderId', this.megerOrderId);
                    this.payInfo = data
                    this.totals = data.paymentAmount;
                    this.radioName = this.radioName || this.payInfo.availableReceivedBalance >= this.payInfo.paymentAmount ? 'balancepay' : this.isWechat ? 'wechatpay' : 'alipay'
                    if (this.payInfo.paymentAmount === 0 || (this.payInfo.availableReceivedBalance >= this.payInfo.paymentAmount)){
                        this.isShowCodeInput = true
                    }
                    if (!this.timer) this.init();
                } else {
                    clearInterval(this.timer);
                    this.$router.push('/order/paySuccess');
                }
            })
        },
        /**
         * 选择支付方式
         */
        choosePayKind(name){
            this.radioName = name
        },
        /**
         * 微信支付
         */
        wechatPay(data){
            // if (localStorage.getItem("isWechat") === 'true') {
            // Api.payOrder(data).then(({ data: { data }}) => {
            //     // eslint-disable-next-line no-undef
            //     WeixinJSBridge.invoke(
            //         'getBrandWCPayRequest', {
            //             "appId": data.payParams.appId,     // 公众号名称，由商户传入     
            //             "timeStamp": data.payParams.timeStamp,         // 时间戳，自1970年以来的秒数     
            //             "nonceStr": data.payParams.nonceStr, // 随机串     
            //             "package": data.payParams.package,     
            //             "signType": data.payParams.signType,         // 微信签名方式：     
            //             "paySign": data.payParams.paySign // 微信签名 
            //         },
            //         function(res){
            //             if (res.err_msg === "get_brand_wcpay_request:ok") {
            //                 // 使用以上方式判断前端返回,微信团队郑重提示：
            //                 // res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
            //             } 
            //         }
            //     ); 
            // })
            // } else {
            Api.pay(data).then(({ data: { data }}) => {
                if (localStorage.getItem("mergOrder")){
                    if (this.$route.query.mergOrder){
                        localStorage.setItem("mergOrder", 1)
                    } else {
                        localStorage.removeItem("mergOrder")
                    }
                }
                window.location.href = data
                // if (this.isWechat){
                //     setTimeout(() => {
                //         Dialog.confirm({
                //             message: '支付是否遇到问题？',
                //             confirmButtonText: '支付已完成',
                //             cancelButtonText: '支付未完成',
                //             cancelButtonColor: '#ED3129',
                //             confirmButtonColor: '#999999'
                //         }).then(() => {
                //             Api.fetchOrderInfo(this.orderId).then(({ data: { data }}) => {
                //                 if (data.orderStatus === 1 || !data.orderStatus){
                //                     Toast('您的订单支付失败，请重试！')
                //                 } else {
                //                     this.$router.push('/order/paySuccess')
                //                 }
                //             })
                //         }).catch(() => {
                                
                //         })
                //     }, 1500);
                // }
            })
            // }
        },
        /**
         * 点击支付按钮
         */
        payment(){
            if (this.payInfo.paymentAmount === 0 || (this.payInfo.availableReceivedBalance >= this.payInfo.paymentAmount)){
                this.isShowCodeInput = true
            } else {
                // if (localStorage.getItem("isWechat") === 'true'){
                this.wechatPay({
                    orderId: this.$route.query.mergOrder ? this.megerOrderId  : this.orderId,
                    paymentType: this.radioName === 'wechatpay' ? 1 : 2
                    // openid: this.payOpenid
                })
                // } else {
                //     this.wechatPay({
                //         orderId: this.$route.query.mergOrder ? this.megerOrderId  : this.orderId
                //     })
                // }
            }
        },
        /**
         * 根据参数名 获取 URL 路径中的参数
         * @param {String} name 要读取的参数名称
         */
        getUrlParam(name) {
            var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)')
            const url = window.location.href.split('#')[0]
            const search = url.split('?')[1]
            if (search) {
                var r = search.substr(0).match(reg)
                if (r !== null) return unescape(r[2])
                return null
            } else {
                return null
            }
        },
        /**
         * 获取openid
         */
        getOpenid(code){
            const APPID = 'wx4696e4b4b8ae570d'
            // const APPID = 'wxfe1b7757e914aeef'
            Api.getOpenid({
                appId: APPID,
                code: code
            }).then((res) => {
                this.payOpenid = res.data.data
            })
        },
        /**
         * 关闭弹窗
         */
        closeDialog(){
            this.isShowCodeInput = false
        },
        /**
         * 获取支付验证码
         */
        getPayCode(){
            Api.getCode(this.$route.query.mergOrder ? this.megerOrderId  : this.orderId).then(({ data: { data }}) => {
                Toast.success('发送成功！')
                let time = 60;
                this.buttonText = '60秒后重发'
                this.disabled = true
                this.btnType = "default"
                const Interval = setInterval(() => {
                    time--;
                    if (time > 0) {
                        this.buttonText = time + '秒后重发'
                    } else {
                        clearInterval(Interval);
                        this.buttonText = '发送验证码'
                        this.disabled = false
                        this.btnType = "danger"
                    }
                }, 1000)
            })
        },
        /**
         * 验证码支付
         */
        payWithBalance(){
            Api.payWithCode({
                orderId: this.$route.query.mergOrder ? this.megerOrderId  : this.orderId,
                payCode: this.payCode
            }).then(res => {
                this.$router.replace('/order/paySuccess')
            })
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
        },
        init() {
            this.timer = setInterval(() => {
                if (this.$route.query.mergOrder){
                    this.getMergOrderInfo(this.orderId)
                } else {
                    this.getOrderInfo(this.orderId)
                }
            }, 10000)
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
