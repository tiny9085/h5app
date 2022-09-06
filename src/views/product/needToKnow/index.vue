<template>
    <app-template>
        <div :class="isApp ? 'app-need-to-know' : 'need-to-know'">
            <div style="margin-bottom:.64rem">
                <h1>尊敬的会员朋友：</h1>
                <p>您好！</p>
                <p>请在选购前，花几分钟时间认真阅读以下内容以避免我们的交易发生一些不必要的误会，请同意本文所告知的内容后再购买。</p>
                <p>1、本页面商品或标识有“<span>预售</span>”字样的商品可以进行预售；</p>
                <p>2、当预售商品达到最低配送金额时，我们将依照订购时间的先后顺序依次发货，预售商品的发货时间以平台显示的发货时间为准；</p>
                <p>3、预售商品一旦付款，即视为有效订单，如因我方原因在约定时间内未能发货，您的款项我们将在约定发货时间后的<span>5</span>个工作日内转入您的账户余额中，如您需退款，我方将依照退款流程处理，请注意查收；</p>
                <p>4、如果本须知中任何一条被视为废止、无效或因不可抗力不可执行，该条应视为可分的且并不影响任何其余条款的有效性和可执行性；</p>
                <p>5、如您对发货时间或其他条款有任何异议，由双方协商解决。</p>
                <p>您点击“同意”按钮即视为您完全接受本须知，在点击之前请您再次确认已知悉并完全理解本须知的所有内容。</p>
                <p>谢谢理解！</p>
            </div>
            <p v-if="!isApp" class="last-p">
                <van-button :color="disabled ? '#CCCCCC' : '#ED3129'" round :disabled="disabled" @click="goPreSale">{{ btnText }}</van-button>
            </p>
        </div>
    </app-template>
</template>

<script>
import VMnative from '@/utils/VMnative'
import AppTemplate from '@/components/appTemplate/Index'
export default {
    name: 'NeedToKnow',
    components: {
        AppTemplate
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            disabled: true,
            time: 5
        }
    },
    computed: {
        btnText: function(val){
            if (this.time > 0){
                return '同意(' + this.time + 's)'
            } else {
                return '同意'
            }
        }
    },
    created(){
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "购买须知")
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    },
    mounted(){
        if (this.$route.query.type === 'cart'){
            this.disabled = false
            this.time = 0
        } else {
            const timer = setInterval(() => {
                if (this.time > 1){
                    this.time--
                } else {
                    this.time = 0
                    this.disabled = false
                    clearInterval(timer)
                }
            }, 1000)
        }
    },
    methods: {
        goPreSale(){
            if (this.$route.query.type === 'cart'){
                this.$router.go(-1)
            } else {
                localStorage.setItem("isShowNeedKnow", false)
                this.$router.push("/product/preSale")
            }
        }
    }
}
</script>

<style lang="scss">
    .need-to-know, .app-need-to-know{
        padding: .92rem .2rem .4rem;
        &.app-need-to-know{
            padding: .4rem .2rem;
        }
        h1{
            color: #333333;
            font-size: .32rem;
            padding: .4rem 0 .2rem;
        }
        p{
            padding-bottom: .2rem;
            line-height: .44rem;
            font-size: .28rem;
            color: #333333;
            text-indent: .7rem;
            span{
                color: #ed3129;
            }
        }
        .van-button{
            width: 6.7rem;
            font-size: .4rem;
            .van-button__text{
                color: #fff;
            }
        }
        .last-p{
            position: fixed;
            bottom: 0rem;
            height: 1.2rem;
            text-align: center;
            padding-bottom: 0;
            text-indent: -0.3rem;
            width: 100%;
            z-index: 8888 !important;
            background: white;
            line-height: 1.2rem;
        }
    }
</style>
