<template>
    <div>
        <van-dialog
            v-model="receivedDialog"
            className="show-received-coupon"
            show-cancel-button
            overlay-class="overlay-q"
            confirmButtonText="去使用"
            cancelButtonText="查看优惠券"
            cancelButtonColor="#999999"
            confirmButtonColor="#fff"
            @confirm="goUse"
            @cancel="goCouponList"
        >
            <div slot="title">
                <img src="@/assets/images/received_coupon_icon.png" class="received-coupon-icon" alt="">
                <span class="success-title">恭喜您,领券成功</span>
                <span class="close-dialog" @click="close">&times;</span>
            </div>
            <div class="coupon-tips">所有门店已成功领取<span class="coupon-info">{{ setCouponName(couponInfo) }}</span>优惠券</div>
            <div class="use-time">使用时间：{{ couponInfo.useStartTimeStr }}-{{ couponInfo.useEndTimeStr }}</div>
        </van-dialog>
    </div>
</template>
<script>
import VMnative from '@/utils/VMnative'
export default {
    props: {
        source: {
            type: String,
            default: 'h5'
        }
    },
    data() {
        return {
            receivedDialog: false,
            couponInfo: {}
        }
    },
    methods: {
        setCouponName(coupon) {
            if (coupon.buyMoney === 0) {
                return '无门槛减' + coupon.discount + '元'
            } else {
                return '满' + coupon.buyMoney + '减' + coupon.discount + '元'
            }
        },
        open (couponInfo) {
            this.couponInfo = couponInfo;
            this.receivedDialog = true;
        },
        // 去使用
        goUse(){
            const sid = this.couponInfo.couponsId || this.couponInfo.sid;
            if (this.source === 'h5'){
                localStorage.setItem("actSid", sid)
                this.$router.push({ path: "/product/getTogether", query: { type: 2 }})
            } else {
                VMnative.callHandler('useCoupon', sid)
            }
        },
        // 查看优惠券
        goCouponList() {
            this.$router.push('/personal/coupon');
        },
        close() {
            this.receivedDialog = false;
        }
    }
}
</script>
<style lang="scss">
    .overlay-q{
        background:rgba(0,0,0,0.6)!important;
    }
    .show-received-coupon{
        border-radius: 12px;
        .received-coupon-icon{
            width: .4rem;
            display: inline-block;
            vertical-align: sub;
            margin-right: .08rem;
        }
        .success-title{
            color: #333333;
            font-size: .32rem;
            display: inline-block;
        }
        .close-dialog{
            font-size: .48rem;
            color: #979797;
            position: absolute;
            right: .2rem;
            top: .2rem;
        }
        .van-dialog__confirm{
            background: #ED3129;
        }
        .van-dialog__header{
            padding: .4rem .2rem .32rem .4rem;
            position: relative;
        }
        .coupon-tips{
            margin-left: .4rem;
            margin-bottom: .2rem;
            font-size: .28rem;
            color: #333333;
            .coupon-info{
                color: #ED3129;
            }
        }
        .use-time{
            margin-left: .4rem;
            color: #666666;
            font-size: .24rem;
            margin-bottom: .32rem;
        }
    }
</style>
