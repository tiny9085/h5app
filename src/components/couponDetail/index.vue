<template>
    <div>
        <div :class="(type === 1 || type === 4) ? 'couponDetail-box' : 'couponDetail-box couponDetail-box-1'">
            <div class="left">
                <div class="discount">
                    <span>￥</span>
                    <span>{{ isDetail ? coupon.promotionCouponsRule.discount : coupon.discount }}</span>
                </div>
                <template v-if="isDetail">
                    <div v-if="coupon.promotionCouponsRule.buyMoney !== 0" class="sill">
                        满{{ coupon.promotionCouponsRule.buyMoney }}可用
                    </div>
                    <div v-else class="sill">无门槛</div>
                </template>
                <template v-else>
                    <div v-if="coupon.buyMoney !== 0" class="sill">
                        满{{ coupon.buyMoney }}可用
                    </div>
                    <div v-else class="sill">无门槛</div>
                </template>
                <!-- <img v-if="[2, 3].indexOf(type) > -1" class="coupon-bg" src="@/assets/images/invalid_bg.png">
                <img v-else class="coupon-bg" src="@/assets/images/coupon_bg.png"> -->
            </div>
            <div class="right">
                <div class="row-1 row">
                    <!-- <img :src="(type === 1 || type === 4) ? 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-coupon-red.png' : 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-coupon-gray.png'" alt=""> -->
                    <span>{{ coupon.typeName }}</span>
                </div>
                <div class="row-2 row">
                    <span>{{ coupon.productDesc }}</span>
                    <button v-if="type === 4 && coupon.gainStatus === 0" class="receiveBtn" :style="btnCoupon.btn? 'margin-left: 1.16rem;':'margin-left: 1.62rem;'" @click="receiveCoupon(coupon)">立即领取</button>
                    <!-- <button @click="receiveCoupon(coupon)">立即领取</button> -->
                    <button v-if="(type === 1 || (type === 4 && coupon.gainStatus !== 0)) && notUse" class="useBtn" :style="btnCoupon.btn? 'margin-left: 1.16rem;':'margin-left: 1.62rem;'" @click="goUse(coupon.couponsId || coupon.sid)">立即使用</button>
                    <img v-if="type === 2" class="statusImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-shiyong.png" alt="">
                    <img v-if="type === 3" class="statusImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-shixiao.png" alt="">
                    <img v-if="!isMyCoupon && coupon.gainStatus !== 0 && coupon.gainStatus" class="statusImg-1" src="@/assets/images/coupon-received.png" alt="">
                    <img v-if="coupon.isExpiringSoon && type === 1" class="statusImg-2" src="@/assets/images/coupon-expiring.png" alt="">
                </div>
                <div class="row-3">
                    {{ coupon.useStartTime.split(" ")[0] }}-{{ coupon.useEndTime.split(" ")[0] }}
                </div>      
            </div>
        </div>
        <win-coupon ref="myCouponDialog" :source="source" />
    </div>
</template>

<script>
import Api from '@/api/personal/index'
import VMnative from '@/utils/VMnative'
import winCoupon from '@/components/receivedCoupon/index'
import { Toast } from 'vant'
export default {
    name: "CouponDetail",
    components: {
        winCoupon
    },
    props: {
        isMyCoupon: {
            type: Boolean,
            default: false
        },
        isDetail: {
            type: Boolean,
            default: false
        },
        coupon: {
            type: Object,
            default: function(){
                return {}
            }
        },
        btnCoupon: {
            type: Object,
            default: function(){
                return {}
            }
        },
        isExpired: {
            type: Boolean,
            default: false
        },
        source: {
            type: String,
            default: 'h5'
        },
        notUse: {
            type: Boolean,
            default: true
        }
    },
    computed: {
        type: function(){
            if (!this.coupon.statusCode){
                return 4
            } else {
                return this.coupon.statusCode
            }
        }
    },
    watch: {
        coupon: function(val){
            this.$set(this.coupon, 'isExpiringSoon', (new Date(this.coupon.useEndTime.split("-").join("/")).getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24) < 3)
        }
    },
    mounted(){
        this.$set(this.coupon, 'isExpiringSoon', (new Date(this.coupon.useEndTime.split("-").join("/")).getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24) < 3)
    },
    methods: {
        setCouponName(coupon) {
            if (coupon.buyMoney === 0) {
                return '无门槛减' + coupon.discount + '元'
            } else {
                return '满' + coupon.buyMoney + '减' + coupon.discount + '元'
            }
        },
        // 领取优惠券
        receiveCoupon(coupon){
            if (this.source === 'h5'){
                Api.receiveCoupon(coupon.couponsId || coupon.sid).then(({ data: { data }}) => {
                    this.$emit('fetchList')
                    coupon.gainStatus = 1
                    this.$toast({ message: '优惠券领取成功', className: 'toast-box' })
                    // Toast("优惠券领取成功")
                    // Toast.success("优惠券领取成功")
                    // if (this.$store.getters.userInfo.stores.length > 1) {
                    //     this.$refs['myCouponDialog'].open(coupon);
                    // } else {
                    //     this.$emit('fetchList')
                    //     Toast.success("领取成功")
                    //     coupon.gainStatus = 1
                    // }
                }).catch(() => {
                    Toast.fail("请重试")
                })
                // if (this.$store.getters.userInfo.stores.length > 1) {// 多店领取优惠券
                //     Api.manyStoresCouponsInfo(coupon.couponsId || coupon.sid).then(({ data: { data }}) => {
                //         // 获取店铺领取的优惠券信息
                //         let userInfo = Object.assign({}, this.$store.getters.userInfo, { stores: data });
                //         this.$store.commit("setUserInfo", userInfo)
                //         this.$store.commit("setSelectStore", {
                //             isCoupon: true,
                //             show: true,
                //             callback: (userIds) => {// 领取优惠券
                //                 Api.gainManyStoresCoupons({
                //                     couponsId: coupon.couponsId || coupon.sid,
                //                     userIds: userIds
                //                 }).then((re) => {
                //                     if(re.data.code === 0) {
                //                         this.$emit('fetchList')
                //                         Toast.success("领取成功")
                //                         coupon.gainStatus = 1
                //                         this.$store.commit("setSelectStore", { show: false })
                //                     }
                //                 })
                //             }
                //         })
                //     }).catch(() => {
                //         Toast.fail("请重试")
                //     })
                // } else {// 单店领取优惠券
                //     Api.receiveCoupon(coupon.couponsId || coupon.sid).then(({ data: { data }}) => {                   
                //         this.$emit('fetchList')
                //         Toast.success("领取成功")
                //         coupon.gainStatus = 1
                    
                //     }).catch(() => {
                //         Toast.fail("请重试")
                //     })
                // }
            } else {
                Api.receiveCoupon(coupon.couponsId || coupon.sid).then(({ data: { data }}) => {
                    const obj = {
                        couponId: coupon.couponsId || coupon.sid,
                        value: this.setCouponName(coupon),
                        useTime: `${coupon.useStartTimeStr}-${coupon.useEndTimeStr}`
                    }
                    VMnative.callHandler('gainMultiStoresCouponSuccess', obj, () => {
                        this.$emit('fetchList')
                        coupon.gainStatus = 1
                    }) 
                }).catch(() => {
                    Toast.fail("请重试")
                })
            }
        },
        // 去使用
        goUse(sid){
            if (this.source === 'h5'){
                this.$router.push({ path: "/product/collectOrders", query: { type: 2, sid }})
            } else {
                VMnative.callHandler('useCoupon', sid)
            }
        }
    }
}
</script>

<style lang="scss">
.toast-box{
    z-index: 2020 !important;
}
.couponDetail-box{
        height: 1.8rem;
        display: flex;
        margin: .2rem .2rem  .24rem .2rem;
        background: url('../../assets/images/background_bg.png') no-repeat;
        background-size:100%;
        background-position-x: -0.05rem;
        position: relative;
        &.couponDetail-box-1{
            background: url('../../assets/images/background_bg.png') no-repeat;
            background-size:100%;
            background-position-x: -0.05rem;
            .left{
                .discount{
                    color: #666666;
                }
            }
            .right{
                .row-1{
                    span{
                        color: #666666;
                    }
                }
            }
        }
        .left{
            position: relative;
            width: 2rem;
            justify-content: center;
            align-items: center;
            display: flex;
            flex-direction: column;
            .discount{
                color: #ED3129;
                padding-bottom: .1rem;
                font-weight: 600;
                span:nth-child(1){
                    font-size: .32rem;
                }
                span:nth-child(2){
                    font-size: .52rem;
                    display: block;
                    float: right;
                    margin-top: -0.1rem;
                }
            }
            .sill{
                color: #666666;
                font-size: 0.26rem;
                padding-left: .26rem;
            }
            .coupon-bg{
                width: .36rem;
                position: absolute;
                right: -.18rem;
                top: 0;
            }
        }
        .right{
            padding: 0.28rem 0 0 0.28rem;
            position: relative;
            flex: 1;
            .row{
                display: flex;
                align-items: center;
            }
            .row-1{
                line-height: .28rem;
                padding-bottom: .16rem;
                img{
                    width: .56rem;
                    height: .28rem;
                    margin-right: .08rem;
                }
                span{
                    color: #ED3129;
                    font-size: .32rem;
                    font-weight: 500;
                }
            }
            .row-2{
                padding-bottom: .24rem;
                height: 0.28rem;
                span{
                    font-size: .24rem;
                    line-height: .28rem;
                    color: #999999;
                }
                .receiveBtn{
                    height: .52rem;
                    width: 1.4rem;
                    line-height: .52rem;
                    font-size: .24rem;
                    color: #ffffff;
                    border-radius: 0.32rem;
                    background: #ED3129;
                    outline: none;
                    border: none;
                }
                .useBtn{
                    height: .52rem;
                    width: 1.4rem;
                    line-height: .52rem;
                    font-size: .24rem;
                    color: #ffffff;
                    border-radius: 0.32rem;
                    background:#FFAE00;
                    outline: none;
                    border: none;
                }
                .statusImg{
                    width: .92rem;
                    height: .92rem;
                    position: absolute;
                    top: .08rem;
                    right: .08rem;
                }
                .statusImg-1{
                    width: .84rem;
                    height: .84rem;
                    position: absolute;
                    top: -0.02rem;
                    right: 0;
                    z-index: 0;
                }
                .statusImg-2{
                    width: .94rem;
                    height: .94rem;
                    position: absolute;
                    top: -0.02rem;
                    right: 0;
                    z-index: 0;
                }
            }
            .row-3{
                color: #666666;
                font-size: .24rem;
            }
        }
    }
.ticket{
    .couponDetail-box:last-child{
        padding-top: 0.3rem;
    }
    .couponDetail-box{
        background: url('../../assets/images/background_bg.png') no-repeat;
        background-size:100%;
        height: 1.8rem;
        .left{
            .discount{
                margin-right: 0.2rem;
                margin-top: -0.1rem;
            }
            .sill{
                margin-right: 0.38rem;
                margin-top: -0.1rem;
            }
        }
        .right{
            padding: 0.28rem 0 0 0.24rem;
            .row-1{
                padding-bottom: .26rem;
            }
            .row-2{
                padding-bottom: .28rem;
                // .useBtn{
                //     margin-left: 1.2rem;
                // }
            }
        }
    }
}
</style>
