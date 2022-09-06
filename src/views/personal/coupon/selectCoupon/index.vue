<template>
    <div class="select-coupon-box">
        <div class="top-div" />
        <div v-for="(item, index) in storeList" :key="index">
            <div v-if="item.couponsModel.couponsList.length !== 0" class="store-list-box">
                <div class="store-top">
                    <h5>
                        <img class="store-icon" src="@/assets/images/store_icon_red.png">
                        <span class="store-name">{{ item.userName }}</span>
                    </h5>
                </div>
                <div class="coupon-list">
                    <div v-for="(coupon, idx) in item.couponsModel.couponsList" :key="idx" class="coupon-list-use">
                        <van-checkbox v-model="coupon.checked" class="is-checked" @change="selectCoupon($event, coupon, item)" />
                        <div class="coupon-detail">
                            <div class="left">
                                <div class="discount">
                                    <span>￥</span>
                                    <span>{{ coupon.discount }}</span>
                                </div>
                                <div v-if="coupon.buyMoney !== 0" class="sill">
                                    满{{ coupon.buyMoney }}可用
                                </div>
                                <div v-else class="sill">无门槛</div>
                            </div>
                            <div class="right">
                                <div class="row-1 row">
                                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-coupon-red.png" alt="">
                                    <span>{{ coupon.typeName }}</span>
                                </div>
                                <div class="row-2 row">
                                    <span>{{ coupon.productDesc }}</span>
                                </div>
                                <div class="row-3">
                                    使用时间：{{ coupon.useStartTime.split(" ")[0].replace(/-/g,'.') }}-{{ coupon.useEndTime.split(" ")[0].replace(/-/g,'.') }}
                                </div>      
                            </div>
                        </div>
                    </div>
                    <div class="coupon-list-useless">
                        <van-checkbox v-model="item.checked" class="is-checked" @click="selectNoCoupon($event, item)" />
                        <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-coupon-gray.png" alt="">
                        <span>不使用优惠券</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="btn-box">
            <van-button color="#ed3129" round @click="comfirmCoupon">确  定</van-button>
        </div>
    </div>
</template>

<script>
import { Toast } from 'vant'
import Api from '@/api/personal/index'
export default {
    name: 'SelectCoupon',
    data(){
        return {
            storeList: [],
            selectCouponList: []
        }
    },
    created(){
        this.storeList = JSON.parse(localStorage.getItem("discountModelList"))
        this.selectCouponList = JSON.parse(localStorage.getItem("selectCoupon")) || []
        if (this.selectCouponList.length !== 0){
            this.selectCouponList.forEach((store, i) => {
                if (store.couponsModel.couponsList.length !== 0){
                    this.storeList.forEach(store1 => {
                        if (store1.userSid === store.userSid){
                            store.couponsModel.couponsList.forEach((coupon, j) => {
                                this.$set(store1.couponsModel.couponsList[j], "checked", true)
                            })
                        }
                    })
                } else {
                    this.storeList.forEach(store1 => {
                        if (store1.userSid === store.userSid){
                            this.$set(store1, "checked", true)
                        }
                    })
                }
            })
        } else {
            this.storeList.forEach(store => {
                this.$set(store, "checked", false)
                this.$set(store, "selectNum", 1)
                store.couponsModel.couponsList.forEach(coupon => {
                    this.$set(coupon, "checked", false)
                })
                if (store.couponsModel.couponsList.length !== 0){
                    this.$set(store.couponsModel.couponsList[0], "checked", true)
                } else {
                    this.$set(store, "checked", true)
                }
            })
        }
    },
    methods: {
        /**
         * 选择优惠券
         */
        selectCoupon(e, coupon, item){
            if (item.checked){
                item.checked = false
            }
            if (coupon.checked){
                item.selectNum++
            } else {
                item.selectNum--
            }
            if (item.selectNum > item.couponsModel.maxChoice){
                Toast("每单最多选择" + item.couponsModel.maxChoice + "张优惠券")
                coupon.checked = false
            }
        },
        /**
         * 不使用优惠券
         */
        selectNoCoupon(e, item){
            item.checked = true
            item.couponsModel.couponsList.forEach(store => {
                store.checked = false
            })
        },
        /**
         * 确定选择的优惠券
         */
        comfirmCoupon(){
            const userCouponsList = []
            this.storeList.forEach(store => {
                const storeObj = {
                    userSid: store.userSid,
                    couponsList: []
                }
                if (store.checked){
                    userCouponsList.push(storeObj)
                } else {
                    store.couponsModel.couponsList.forEach(coupon => {
                        const couponItem = {}
                        if (coupon.checked){
                            couponItem.id = coupon.id
                            storeObj.couponsList.push(couponItem)
                        }
                    })
                    userCouponsList.push(storeObj)
                }
            })
            const item = {
                calcToken: JSON.parse(localStorage.getItem('cartInfo')).calcToken,
                userCouponsList: userCouponsList
            }
            localStorage.setItem("couponInfo", JSON.stringify(item.userCouponsList))
            Api.selectCoupon(item).then(({ data: { data }}) => {
                const cartInfo = JSON.parse(localStorage.getItem('cartInfo'))
                cartInfo.balanceModelMap = data.balanceModelMap
                cartInfo.calcToken = data.calcToken
                cartInfo.items.forEach(item => {
                    data.discountModelList.forEach(discount => {
                        if (discount.userSid === item.userSid){
                            item.preferentialAmount = discount.preferentialAmount
                        }
                    })
                })
                localStorage.setItem("cartInfo", JSON.stringify(cartInfo))
                localStorage.setItem('selectCoupon', JSON.stringify(data.discountModelList))
                this.$router.back(-1)
            })
        }
    }
}
</script>

<style lang="scss">
    @mixin flex($p: row) {
        display: flex;
        flex-direction: $p;
    }

    %textOver {
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }
    .select-coupon-box{
        .store-list-box{
            border-bottom: .2rem solid #F4F4F4;
            &:nth-last-child(1){
                border: none;
            }
        }
        .store-top {
            position: relative;
            padding: .4rem .2rem .32rem;
            box-shadow: 0px .08rem .08rem 0px rgba(246, 246, 246, 1);
            line-height: 1;

            h5 {
                margin-bottom: 0.1rem;
                @include flex;
                align-items: center;
            }

            .store-icon {
                width: .32rem;
                height: .32rem;
                margin-right: 0.16rem;
            }

            .store-name {
                color: #333333;
                font-size: 0.28rem;
                flex: 1;
                @extend %textOver;
            }
        }
        .coupon-list{
            padding: .2rem .2rem .44rem;
            .coupon-list-use{
                @include flex;
                align-items: center;
                .coupon-detail{
                    width: 6.58rem;
                    @include flex;
                    margin-left: .12rem;
                    align-items: center;
                    background: url('https://imga.hnhcyy.com/fed/b2b-wechat/coupon-bg-3.png') 50% 50% no-repeat;
                    background-size: cover;
                    margin-bottom: .2rem;
                    .left{
                        margin: .28rem 0;
                        border-right: .02rem dotted #FBC4C2;
                        width: 1.65rem;
                        justify-content: center;
                        align-items: center;
                        display: flex;
                        flex-direction: column;
                        .discount{
                            color: #ED3129;
                            padding-bottom: .2rem;
                            span:nth-child(1){
                                font-size: .32rem;
                            }
                            span:nth-child(2){
                                font-size: .52rem;
                            }
                        }
                        .sill{
                            color: #666666;
                        }
                    }
                    .right{
                        margin: .32rem .2rem;
                        width: 4.54rem;
                        .row{
                            display: flex;
                            align-items: center;
                        }
                        .row-1{
                            padding-bottom: .12rem;
                            img{
                                width: .56rem;
                                height: .28rem;
                                margin-right: .08rem;
                            }
                            span{
                                color: #ED3129;
                                font-size: .28rem;
                            }
                        }
                        .row-2{
                            justify-content: space-between;
                            padding-bottom: .2rem;
                            span{
                                font-size: .28rem;
                                color: #999999;
                            }
                        }
                        .row-3{
                            color: #666666;
                            font-size: .24rem;
                        }
                    }
                }
            }
            .coupon-list-useless{
                @include flex;
                align-items: center;
                padding-top: .22rem;
                img{
                    width: .56rem;
                    height: .28rem;
                    margin: 0 .08rem 0 .16rem;
                }
                span{
                    color: #333333;
                    font-size: .28rem;
                    font-weight: 500;
                }
            }
        }
        .btn-box{
            width: 7.1rem;
            position: fixed;
            bottom: .2rem;
            padding: 0 .2rem;
            background: #fff;
            .van-button{
                width: 100%;
                font-size: .32rem;
            }
        }
    }
</style>
