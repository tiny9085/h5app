<template>
    <div class="Page-personal-coupon theme-lsx personal-box">
        <img src="@/assets/images/icon-coupon-tips.png" alt="" class="tips" @click="showTips">
        <div class="tab-box clearfix">
            <van-tabs line-width="0" sticky :active="active" @click="changeTabs">
                <van-tab :title="conponList.length === 1 ?'未使用(' + (totalA ? totalA : 0) +')': '未使用'">
                    <template v-if="!conponList.length && !loading">
                        <div v-if="!refreshFlag" class="no-data">
                            <img src="@/assets/images/emptyCart.png">
                            <span>暂无可用优惠券，快去领取吧</span>
                        </div>
                        <div v-else-if="refreshFlag" class="no-data">
                            <img src="@/assets/images/refresh.png">
                            <span>数据获取失败，请尝试刷新!</span>
                            <van-button @click="resh"><p>重新刷新</p></van-button>
                        </div>
                    </template>
                    <template v-else>
                        <div v-for="(coupon, i) in conponList" :key="i" class="store-bg" :style="conponList.length === 1 ? 'margin:0':'margin: 0.24rem 0.16rem 0 0.16rem;'">
                            <div v-if="conponList.length >1" class="box">
                                <div class="coupon-store">
                                    <img src="@/assets/images/store_icon.png" alt="">
                                    <span class="store-name">{{ coupon.userName }}</span>
                                    <span class="show-more-coupon" :style="coupon.showMore?'':'margin-bottom:.24rem'">
                                        {{ coupon.showMore ? '收起' : '展开' }}
                                        <img
                                            v-if="coupon.showMore"
                                            src="@/assets/images/close_icon.png"
                                            @click="showMoreCoupon(false, i)"
                                        >
                                        <img
                                            v-else
                                            src="@/assets/images/open_icon.png"
                                            @click="showMoreCoupon(true, i)"
                                        >
                                    </span>
                                </div>
                                <p class="coupon-title">
                                    当前有 <span>{{ coupon.promotionCouponsHistoryVos.length }}</span> 张优惠券
                                </p>
                            </div>
                            <div v-if="coupon.showMore" class="ticket">
                                <coupon-box v-for="(item, index) in coupon.promotionCouponsHistoryVos" :key="index" :coupon="item" :is-my-coupon="true" :btn-coupon="coupon" />
                            </div>
                        </div>
                    </template>
                </van-tab>
                <van-tab title="已使用">
                    <template v-if="!conponList.length && !loading">
                        <div v-if="!refreshFlag" class="no-data">
                            <img src="@/assets/images/emptyCart.png">
                            <span>暂无数据</span>
                        </div>
                        <div v-else-if="refreshFlag" class="no-data">
                            <img src="@/assets/images/refresh.png">
                            <span>数据获取失败，请尝试刷新!</span>
                            <van-button @click="resh"><p>重新刷新</p></van-button>
                        </div>
                    </template>
                    <template v-else>
                        <div v-for="(coupon, i) in conponList" :key="i" class="store-bg" :style="conponList.length === 1 ? 'margin:0':'margin: 0.24rem 0.16rem 0 0.16rem;'">
                            <div v-if="conponList.length >1" class="box">
                                <div class="coupon-store">
                                    <img src="@/assets/images/store_icon.png" alt="">
                                    <span class="store-name">{{ coupon.userName }}</span>
                                    <span class="show-more-coupon" :style="coupon.showMore?'':'margin-bottom:.2rem'">
                                        {{ coupon.showMore ? '收起' : '展开' }}
                                        <img
                                            v-if="coupon.showMore"
                                            src="@/assets/images/close_icon.png"
                                            @click="showMoreCoupon(false, i)"
                                        >
                                        <img
                                            v-else
                                            src="@/assets/images/open_icon.png" 
                                            @click="showMoreCoupon(true, i)"
                                        >
                                    </span>
                                </div>
                                <p class="coupon-title">
                                    当前有 <span>{{ coupon.promotionCouponsHistoryVos.length }}</span> 张优惠券
                                </p>
                            </div>
                            <div v-if="coupon.showMore" class="ticket">
                                <coupon-box v-for="(item, index) in coupon.promotionCouponsHistoryVos" :key="index" :coupon="item" :is-my-coupon="true" />
                            </div>
                        </div>
                    </template>
                </van-tab>
                <van-tab title="已失效">
                    <template v-if="!conponList.length && !loading">
                        <div v-if="!refreshFlag" class="no-data">
                            <img src="@/assets/images/emptyCart.png">
                            <span>暂无数据</span>
                        </div>
                        <div v-else-if="refreshFlag" class="no-data">
                            <img src="@/assets/images/refresh.png">
                            <span>数据获取失败，请尝试刷新!</span>
                            <van-button @click="resh"><p>重新刷新</p></van-button>
                        </div>
                    </template>
                    <template v-else>
                        <div v-for="(coupon, i) in conponList" :key="i" class="store-bg" :style="conponList.length === 1 ? 'margin:0':'margin: 0.24rem 0.16rem 0 0.16rem;'">
                            <div v-if="conponList.length >1" class="box">
                                <div class="coupon-store">
                                    <img src="@/assets/images/store_icon.png" alt="">
                                    <span class="store-name">{{ coupon.userName }}</span>
                                    <span class="show-more-coupon" :style="coupon.showMore?'':'margin-bottom:.2rem'">
                                        {{ coupon.showMore ? '收起' : '展开' }}
                                        <img
                                            v-if="coupon.showMore"
                                            src="@/assets/images/close_icon.png"
                                            @click="showMoreCoupon(false, i)"
                                        >
                                        <img
                                            v-else
                                            src="@/assets/images/open_icon.png" 
                                            @click="showMoreCoupon(true, i)"
                                        >
                                    </span>
                                </div>
                                <p class="coupon-title">
                                    当前有 <span>{{ coupon.promotionCouponsHistoryVos.length }}</span> 张优惠券
                                </p>
                            </div>
                            <div v-if="coupon.showMore" class="ticket">
                                <coupon-box v-for="(item, index) in coupon.promotionCouponsHistoryVos" :key="index" :coupon="item" :is-my-coupon="true" />
                            </div>
                        </div>
                    </template>
                </van-tab>
            </van-tabs>
        </div>
        <div v-if="!refreshFlag" class="update-bar">
            <van-button class="get-more-coupon" @click="$router.push('/couponList')">领取更多的券</van-button>
        </div>
        <view class="clearfix" />
        <van-dialog id="van-dialog" />
    </div>
</template>

<script>
import couponBox from '@/components/couponDetail/index'
import Api from '@/api/personal/index'
import { Toast } from 'vant'
export default {
    name: "Coupon",
    components: {
        couponBox
    },
    data(){
        return {
            conponList: {},
            active: 0,
            status: 1,
            refreshFlag: false,
            loading: false,
            totalA: null
            // loading: {
            //     unuseLoading: false,
            //     useLoading: false,
            //     invalidLoading: false
            // },
            // finished: {
            //     unuseFinished: false,
            //     useFinished: false,
            //     invalidFinished: false
            // }
        }
    },
    watch: {
        totalA: function(val){
            // this.totalA = val
            // console.log(val)
        }
    },
    mounted(){
        Api.fetchCoupon({ status: this.status }).then(({ data: { data }}) => {
            this.totalA =  data[0].promotionCouponsHistoryVos.length
        })
        this.loading = true
        // this.refreshFlag = false
        Toast.loading({
            message: '加载中...',
            duration: 0,
            forbidClick: true
        })
        this.getCoupon(1)
        document.getElementsByTagName("body")[0].className = "product-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "product-index");
    },
    methods: {
        resh(){
            this.getCoupon(this.status)
        },
        // 切换tab
        changeTabs(e){
            Toast.loading({
                message: '加载中...',
                forbidClick: true,
                duration: 0
            })
            this.active = e
            switch (e) {
                case 0:
                    // this.page.unusePage = 1
                    this.status = 1
                    this.getCoupon(1)
                    break;
                case 1:
                    // this.page.usePage = 1
                    this.status = 2
                    this.getCoupon(2)
                    break;
                case 2:
                    // this.page.invalid = 1
                    this.status = 3
                    this.getCoupon(3)
                    break;
            }
        },
        // 获取优惠券
        getCoupon(status){
            Api.fetchCoupon({ status: status }).then(({ data: { data }}) => {
                data.forEach((v, i) => {
                    if (data.length === 1){
                        v.btn = false
                    } else {
                        v.btn = true
                    }
                    v.showMore = false;
                    if (i === 0) v.showMore = true;
                })
                this.conponList = data || []
                this.loading = false
                this.refreshFlag = false
                Toast.clear()
            }).catch(() => {
                this.loading = false
                this.refreshFlag = true
                Toast.clear()
            })
        },
        /**
         * 加载更多
         */
        // onLoad() {
        //     if (this.status === 1){
        //         Api.fetchCoupon({ status: this.status, current: this.page.unusePage + 1, size: 10 }).then(({ data: { data }}) => {
        //             this.conponList.unuseList = this.conponList.unuseList.concat(data.records || [])
        //             this.loading.unuseLoading = false
        //             if (this.page.unusePage >= data.pages) {
        //                 this.finished.unuseFinished = true
        //             } else {
        //                 this.page.unusePage++
        //             }
        //         })
        //     } else if (this.status === 2){
        //         Api.fetchCoupon({ status: this.status, current: this.page.usePage + 1, size: 10 }).then(({ data: { data }}) => {
        //             this.conponList.useList = this.conponList.useList.concat(data.records || [])
        //             this.loading.useLoading = false
        //             if (this.page.usePage >= data.pages) {
        //                 this.finished.useFinished = true
        //             } else {
        //                 this.page.usePage++
        //             }
        //         })
        //     } else if (this.status === 3){
        //         Api.fetchCoupon({ status: this.status, current: this.page.invalid + 1, size: 10 }).then(({ data: { data }}) => {
        //             this.conponList.invalidList = this.conponList.invalidList.concat(data.records || [])
        //             this.loading.invalidLoading = false
        //             if (this.page.invalid >= data.pages) {
        //                 this.finished.invalidFinished = true
        //             } else {
        //                 this.page.invalid++
        //             }
        //         })
        //     }
        // },
        // /**
        //  * 查询优惠券
        //  */
        // fetchCoupon(list, total, page, loading, finished){
        //     Api.fetchCoupon({ status: status, current: page + 1, size: 10 }).then(({ data: { data }}) => {
        //         list = list.concat(data.records || [])
        //         total = data.total
        //         loading = false
        //         if (page > data.pages) {
        //             finished = true
        //         } else {
        //             page++
        //         }
        //     })
        // },
        /**
         * 优惠券规则说明
         */
        showTips(){
            this.$router.push('/personal/tips?source=h5')
        },
        showMoreCoupon(showMore, index) {
            this.$set(this.conponList[index], 'showMore', showMore);
        }
    }
}
</script>

<style lang="scss">
.product-index{
    background: #F1F1F1;
}
.Page-personal-coupon{
    height: calc(100vh - calc(45px));
    background: #F1F1F1;
    position: relative;
    .tips{
        position: absolute;
        top: .3rem;
        right: .3rem;
        z-index: 9999;
        width: .36rem;
        height: .36rem;
    }
    .tab-box {
        .store-bg{
            // background:#fff;
            overflow: hidden;
            border-radius: 0.12rem;
            margin: 0.24rem 0.16rem 0 0.16rem;
        }
        .box{
            padding: 0.28rem 0.28rem 0.01rem 0.24rem;
            background: #fff;
        }
        .no-data {
            display: flex;
            flex-direction: column;
            align-items: center;

            img {
                width: 4.96rem;
                height: 4.96rem;
                margin-top: 1.44rem;
            }

            span {
                color: #bbbbbb;
                font-size: .36rem;
                padding-top: .54rem;
            }
            .van-button{
                width: 2.2rem;
                height: 0.68rem;
                background: #FF4646;
                border-radius: 0.47rem;
                margin-top: 0.4rem;
            p{
                color: #ffffff;
                font-size: 0.32rem;
                text-align: center;
                line-height: 0.68rem;
            }
        }
    }
        .van-tabs {
            padding-top: 0px;
            .van-sticky{
                background:#F1F1F1;
                height: 44px;
            }
            .van-tabs__wrap {
                height: 0.88rem;
                margin-bottom: 15px;
                &[class*="van-hairline"]::after{
                    border: none;
                }
                .van-tabs__nav--line{
                    padding-bottom: 0;
                }
            }
            .van-tabs__content{
                background: #F1F1F1;
                max-height: 10rem;
                overflow: auto;
            }
            .van-tab {
                font-size: .28rem;
                color: #666;
                line-height: 40px;
                margin-top: 0.05rem;

                &.van-tab--active {
                    font-size: 0.32rem;
                    font-weight: 600;
                    color: #ED3129;
                    &.van-tab--active::after {
                        position: absolute;
                        box-sizing: border-box;
                        content: ' ';
                        pointer-events: none;
                        right: 0.9rem;
                        bottom: -0.04rem;
                        left: 0.8rem;
                        border-bottom: 0.16rem solid #ED3129;
                        -webkit-transform: scaleY(0.5);
                        transform: scaleY(0.5);
                        border-radius: 0.12rem;
                    }
                }
            }
        }
    }
    .update-bar{
        height: 1.21rem;
        width: 100%;
        background: #f1f1f1;
        position: fixed;
        bottom: 0rem;
         .get-more-coupon{
            height: .8rem;
            width: 7.1rem;
            line-height: .8rem;
            border-radius:0.88rem;
            font-size: .32rem;
            font-weight: 500;
            color: #fff;
            position: fixed;
            bottom: .28rem;
            transform: translateZ(0);
            background: #FF4646;
            margin: 0 0.2rem;
        }
    }
    .coupon-store{
        height: 0.4rem;
        line-height: 0.4rem;
        margin-bottom: 0.2rem;
        img{
            height:0.32rem;
            width: 0.32rem;
            margin-bottom: -0.05rem;
        }
        .store-name{
            font-size: .28rem;
            color: #333;
            font-weight:600;
            line-height: .4rem;
        }
        .show-more-coupon{
            font-size: .24rem;
            flex: 1;
            text-align: right;
            float: right;
            color: #bbbbbb;
            img{
                width: .32rem;
                height: .32rem;
                margin-bottom: -0.06rem;
            }
        }
    }
    .coupon-title{
        height: 0.6rem;
        width: 6.62rem;
        line-height: .44rem;
        border-radius: 0.12rem;
        padding: 0.1rem 0.28rem;
        background: #F4F4F4;
        color: #666;
        font-size: 0.24rem;
        letter-spacing: 1px;
        margin-bottom: 0.24rem;
        span{
            color: #FFAE00;
            font-weight: 600;
        }
    }
    .coupon_icon{
        width: .56rem;
        height: .28rem;
        vertical-align: bottom;
        margin-right: .08rem;
    }
    .ticket{
        background:#F6F6F6;
        border-radius: 0px 0px 0.12rem 0.12rem;
        padding-top: 0.08rem;
        padding-bottom: 0.01rem;
    }
}
</style>
