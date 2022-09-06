<template>
    <div class="page-coupon-tips">
        <div v-if="!isApp" class="top-div" />
        <p>1.恒昌医药集团发放的商品优惠券仅能在恒昌B2B平台提交订单时抵扣应支付商品金额，不能迸行兑现或其他用途；</p>
        <p>2.使用优惠券提交的订单，若订单未出库取消将返回账户；</p>
        <p>3.使用优惠券提交的订单，若订单发生售后退货时，已使用优惠券不予返还，请您慎重考虑；</p>
        <p>4.发放所有优惠券严禁出售，如经发现并证实的，该券将予以作废处理；</p>
        <p>5.本规则由恒昌依据国家相关法律法规及规章制度予以解释。</p>
        <p class="tip">注意：优惠券使用后，将无法再使用。你可以在【我的】-【优惠券】中找到失效的优惠券。</p>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
export default {
    data() {
        return {
            isApp: this.$route.query.source !== 'h5'
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "优惠券规则说明")
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        }
    }
}
</script>

<style lang="scss">
    .page-coupon-tips{
        padding: .4rem .2rem;
        font-size: .28rem;
        color: #333333;
        line-height: .44rem;
        p{
            padding-bottom: .2rem;
            &.tip{
                padding-top: .2rem;
                font-size: .24rem;
            }
        }
    }
</style>
