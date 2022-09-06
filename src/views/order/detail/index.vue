<template>
    <div class="order-detail">
        <div :class="currentType == 1 ? 'theme-lsx' : currentType == 2 ? 'theme-zat' : 'theme-chx'">
            <div v-if="orderInfo.orderStatus == 1" class="order-state order-state-1">
                <div class="order-status-show"><img src="@/assets/images/icon_money.png"><span>待付款</span></div>
                <div class="need-payment">
                    <span>需支付 ¥</span>
                    <span>{{ (orderInfo.paymentAmount||0).toFixed(2) }}</span>
                </div>
                <div v-if="orderInfo.remainingTime>0" class="payment-timer">
                    <div style="flex:1;display:flex;justify-content:flex-end;">
                        <span style="line-height:.78rem">支付倒计时</span>
                        <van-count-down :time="orderInfo.remainingTime" format="HH:mm:ss">
                            <template #default="timeData">
                                <span v-if="timeData.days">{{ timeData.days }}天</span>
                                <span>{{ timeData.hours < 10 ? '0' + timeData.hours : timeData.hours }}时</span>
                                <!-- <span style="margin-right:.1rem"></span> -->
                                <span>{{ timeData.minutes < 10 ? '0' + timeData.minutes : timeData.minutes }}分</span>
                                <!-- <span style="margin-right:.1rem"></span> -->
                                <span>{{ timeData.seconds < 10 ? '0' + timeData.seconds : timeData.seconds }}秒</span>
                            </template>
                        </van-count-down>
                    </div>
                    <span class="pay-btn" @click="payOrder">支付订单</span>
                </div>
                <div v-else class="payment-timer"><span class="overtime">超时未支付</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 2" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_wait.png"><span>待发货</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 3" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_delivered.png"><span>已发货</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 4" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_received.png"><span>已收货</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 5" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_received.png"><span>已完成</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 6" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_cancelled.png"><span>已取消</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 7" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_money.png"><span>退款中</span></div>
                <p class="border-line" />
            </div>
            <div v-else-if="orderInfo.orderStatus == 8" class="order-state order-state-2">
                <div class="order-status-show"><img src="@/assets/images/icon_delete.png"><span>{{ orderInfo.orderStatusDesc }}</span></div>
                <p class="border-line" />
            </div>
            <div v-else class="order-state order-state-2">
                <div class="order-status-show"><span>{{ orderInfo.orderStatusDesc }}</span></div>
                <p class="border-line" />
            </div>
            <div class="order-content">
                <div class="goods-list">
                    <div class="shop-title">
                        <!-- <van-icon class-prefix="iconfont icon-shangdian" /> -->
                        <span>{{ orderInfo.userName }}</span>
                    </div>
                    <img src="@/assets/images/icon_line.png" class="dividing-line" alt="">
                    <div
                        v-if="(orderInfo.orderStatus == 3 || orderInfo.orderStatus == 4 || orderInfo.orderStatus == 5)&&orderInfo.orderTrack"
                        class="order-logistics clearfix"
                        @click="showLogiDetail(orderInfo)"
                    >
                        <img src="@/assets/images/img_logistics.png" class="icon-kd1">
                        <div class="logistics-text">
                            <p>{{ orderInfo.orderTrack.shippingStateDesc }}</p>
                            <p>{{ orderInfo.orderTrack.detail }}</p>
                        </div>
                    </div>
                    <div v-if="orderInfo.orderType === 4 && orderInfo.orderGeneralDetailList.length !== 0" class="preSaleTime">
                        <img src="@/assets/images/icon_presale.png">
                        <span v-if="orderInfo.predictShippingDate">此订单包含预售商品，预计{{ orderInfo.predictShippingDate }}前发货</span>
                        <span v-else>此订单包含预售商品，发货时间待定</span>
                    </div>
                    <div class="order-goods-info">
                        <div class="item-list">
                            <div class="img-box">
                                <div style="display:flex;">
                                    <div v-for="(img,index1) in goodsList" :key="index1" class="img-box">
                                        <div v-if="index1<4" class="item-li">
                                            <img v-if="img.saleType === 2" class="preSaleImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" alt="">
                                            <van-image :src="$store.getters.userInfo.oss+img.productImg+'?x-oss-process=image/resize,m_fill,h_300,w_300/watermark,image_ZmVkL2IyYi1jb21tb24vc3lfMjAweDIwMC5wbmc=,t_100'">
                                                <template v-slot:error>
                                                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" alt="">
                                                </template>
                                            </van-image>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="btn-all" @click="getOrderlist">
                                <span>查看清单</span>
                                <span>共 {{ orderInfo.speciesNum }} 件商品</span>
                                <img class="goto-list" src="@/assets/images/arrow-icon.png" alt="">
                            </div>
                        </div>
                        <div class="shop-total">
                            <span>商品总额</span>
                            <span>¥{{ (orderInfo.totalAmount||0).toFixed(2) }}</span>
                        </div>
                        <div class="shop-total">
                            <span>满减优惠</span>
                            <span>-¥{{ (orderInfo.reduceAmount||0).toFixed(2) }}</span>
                        </div>
                        <div class="shop-total">
                            <span>优惠券</span>
                            <span>-¥{{ (orderInfo.couponsAmount||0).toFixed(2) }}</span>
                        </div>
                    </div>
                </div>
                <div class="order-goods-info border-line">
                    <div class="shop-total">
                        <span>返利抵扣</span>
                        <span>-¥{{ (orderInfo.rebateAmount||0).toFixed(2) }}</span>
                    </div>
                    <div class="shop-total">
                        <span>专项款抵扣</span>
                        <span>-¥{{ (orderInfo.specialAmount||0).toFixed(2) }}</span>
                    </div>
                    <div class="shop-total">
                        <span>余额抵扣</span>
                        <span>-¥{{ (orderInfo.receivedAmount||0).toFixed(2) }}</span>
                    </div>
                    <div class="shop-total">
                        <span>{{ [2, 3, 4, 5].indexOf(orderInfo.orderStatus) > -1 ? '实付金额' : '还需支付' }}</span>
                        <span class="total-num">¥{{ (orderInfo.paymentAmount||0).toFixed(2) }}</span>
                    </div>
                </div>
                <img src="@/assets/images/icon_line.png" class="dividing-line" style="margin-top:.24rem" alt="">
                <div class="order-info">
                    <div class="title">订单信息</div>
                    <div class="info-dl">
                        <div class="dt">订单编号：</div>
                        <div class="dd">{{ orderInfo.orderId }}<span class="copy" @click="copy(orderInfo.orderId)">复制</span></div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">发票类型：</div>
                        <div class="dd">{{ orderInfo.invoiceTypeDesc }}</div>
                        <div
                            v-if="orderInfo.invoiceType === 3 && [3, 4, 5].indexOf(orderInfo.orderStatus)> -1"
                            class="sent-email"
                            @click="showPopup(orderInfo.orderId, orderInfo.email)"
                        >发送至邮箱</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">配送方式：</div>
                        <div class="dd">{{ orderInfo.shippingDesc }}</div>
                    </div>
                    <div v-if="orderInfo.orderStatus == 3 || orderInfo.orderStatus == 4" class="info-dl">
                        <div class="dt">发货时间：</div>
                        <div class="dd">{{ orderInfo.shipTime }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">留言备注：</div>
                        <div class="dd">{{ orderInfo.userMessage }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">下单时间：</div>
                        <div class="dd">{{ orderInfo.createTime }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">支付方式：</div>
                        <div class="dd">{{ orderInfo.paymentTypeDesc || '' }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">付款时间：</div>
                        <div class="dd">{{ orderInfo.paymentTime || '' }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">交易流水号：</div>
                        <div class="dd">{{ orderInfo.tradeNo || '' }}</div>
                    </div>
                </div>
                <img src="@/assets/images/bottom-bg.png" class="botton-bg-line" alt="">
                <div class="order-btns">
                    <van-icon
                        v-if="orderInfo.otherBtns && orderInfo.otherBtns.length"
                        name="ellipsis"
                        color="#cccccc"
                        size=".36rem"
                        @click="showMoreBtn"
                    >
                        <div v-if="orderInfo.isShowMoreBtn" class="more-btn-box more-btn-box-1">
                            <div
                                v-if="orderInfo.otherBtns.indexOf('取消订单') > -1"
                                class="border-bottom"
                                @click="cancelOrder(orderInfo,6)"
                            >取消订单</div>
                            <div
                                v-if="orderInfo.otherBtns.indexOf('删除订单') > -1"
                                @click="cancelOrder(orderInfo, 8)"
                            >删除订单</div>
                            <div
                                v-if="orderInfo.otherBtns.indexOf('查看发票') > -1"
                                @click="gotoInvoice(orderInfo.orderId)"
                            >查看发票</div>
                        </div>
                    </van-icon>
                    <div v-if="orderInfo.btns" class="btn-box">
                        <van-button
                            v-if="orderInfo.btns.indexOf('取消订单') > -1"
                            round
                            @click="cancelOrder(orderInfo,6)"
                        >取消订单</van-button>

                        <van-button
                            v-if="orderInfo.btns.indexOf('删除订单') > -1"
                            round
                            @click="cancelOrder(orderInfo,8)"
                        >删除订单</van-button>

                        <van-button
                            v-if="orderInfo.btns.indexOf('查看发票') > -1"
                            round
                            @click="gotoInvoice(orderInfo.orderId)"
                        >查看发票</van-button>

                        <van-button
                            v-if="orderInfo.btns.indexOf('查看物流') > -1"
                            round
                            @click="showLogistics(orderInfo.expressNum)"
                        >查看物流</van-button>
                        
                        <copy-order-btn
                            v-if="orderInfo.btns.indexOf('再来一单') > -1"
                            :item="orderInfo"
                        />

                        <van-button
                            v-if="orderInfo.btns.indexOf('确认收货') > -1"
                            color="#ED3129"
                            round
                            @click="cancelOrder(orderInfo,4)"
                        >确认收货</van-button>
                        
                        <van-button
                            v-if="orderInfo.btns.indexOf('支付订单') > -1"
                            color="#ED3129"
                            round
                            @click="payOrder"
                        >支付订单</van-button>
                    </div>
                </div>
            </div>
        </div>
        <van-dialog
            id="sent-email"
            v-model="isShowSentBox"
            use-slot
            title="发送至邮箱"
            confirm-button-text="提交"
            :before-close="validateEmail"
            @confirm="sentEmail(orderInfo.orderId)"
        >
            <div class="code-info-box">
                <input v-model="email" placeholder="请输入您的邮箱地址" focus>
                <van-icon class="close-dialog" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png" @click="closeDialog" />
            </div>
        </van-dialog>
    </div>
</template>
<script>
import {  Dialog, Toast } from 'vant';
import Api from '@/api/order/index'
import { isEmail } from '@/utils/validate'
import copyOrderBtn from '@/components/copyOrderBtn/index';
export default {
    components: {
        copyOrderBtn
    },
    data(){
        return {
            orderInfo: {},
            currentType: 0,
            goodsList: [],
            isShowSentBox: false,
            email: '',
            imgLists: []
        }
    },
    computed: {
        gobackMergOrder: function(){
            return this.$route.query.gobackMergOrder || 'false'
        },
        stores() {
            return this.$store.getters.userInfo.stores || []
        }
    },
    created(){
        if (this.gobackMergOrder === 'true'){
            localStorage.setItem("gobackMergOrder", true)
        } else {
            localStorage.setItem("gobackMergOrder", '')
        }
        this.showOrderList();
    },
    methods: {
        /**
         * 查看订单详情
         */
        showOrderList() {
            this.goodsList = []
            Api.getOrderInfo(this.$route.query.orderId).then(res => {
                if (res.data.code === 0) {
                    const responseData = res.data.data;
                    if (responseData.orderGeneralDetailList){
                        responseData.orderGeneralDetailList && responseData.orderGeneralDetailList.forEach(item => {                                
                            this.goodsList.push(item)
                        })
                    }
                    if (responseData.orderGroupDetailList){
                        responseData.orderGroupDetailList && responseData.orderGroupDetailList.forEach(good => {
                            good.orderGeneralDetailList.forEach(item => {
                                this.goodsList.push(item)
                            })
                        })
                    }
                    if (responseData.orderPackageDetailList){
                        responseData.orderPackageDetailList && responseData.orderPackageDetailList.forEach(packages => {
                            packages.productList.forEach(item => {
                                this.goodsList.push(item)
                            })
                        })
                    }
                    this.$set(responseData, 'isShowMoreBtn', false);
                    responseData.allBtns = [];
                    responseData.btns = [];
                    responseData.otherBtns = [];
                    if (responseData.orderStatus === 1){
                        responseData.allBtns = ['支付订单', '再来一单', '取消订单'];
                    } else if (responseData.orderStatus === 3){
                        responseData.allBtns = ['确认收货', '再来一单', '查看物流' ];
                    } else if (responseData.orderStatus === 6){
                        responseData.allBtns = ['再来一单', '删除订单'];
                    } else {
                        responseData.allBtns = ['再来一单'];
                    }
                    if ([3, 4, 5].indexOf(responseData.orderStatus) > -1 && responseData.invoiceType === 3) responseData.allBtns.push('查看发票');
                    // 平行展示和更多展示逻辑
                    if (responseData.allBtns.length > 3) {
                        responseData.otherBtns = responseData.allBtns.slice(3, responseData.allBtns.length);
                        responseData.btns = responseData.allBtns.slice(0, 3);
                    } else {
                        responseData.btns = responseData.allBtns;
                    }
                    if (responseData.expireTime) {
                        responseData.remainingTime = new Date(responseData.expireTime.split('-').join('/')).getTime() - new Date().getTime();
                    } else {
                        responseData.remainingTime = ''
                    }
                    this.orderInfo = responseData || {};
                }
            })
        },
        /**
         * 查看物流详情
         */
        showLogiDetail(item){
            this.$router.push({ path: `/order/logistics?orderId=${this.$route.query.orderId}&expressNum=${item.expressNum}` })
        },
        /**
         * 取消订单&删除订单&确认收货
         */
        cancelOrder(item, orderStatus) {
            let message;
            if (orderStatus === 6){
                message = '您确认取消此订单吗'
            } else if (orderStatus === 8){
                message = '您确认删除此订单吗'
            } else if (orderStatus === 4){
                message = '您确认收货此订单吗'
            }
            Dialog.confirm({
                message: message,
                asyncClose: true,
                cancelButtonText: "我再想想",
                cancelButtonColor: '#999999',
                confirmButtonColor: '#ED3129',
                className: 'mergBtn'
            }).then(() => {
                Api.cancelOrder(item.orderId, orderStatus).then(res => {
                    if (res.data.code === 0){
                        this.showOrderList()
                    }
                })
            }).catch(() => {
                Dialog.close();
            });
        },
        /**
         * 支付订单
         */
        payOrder(){
            this.$router.push({
                path: '/order/checkout',
                query: {
                    id: this.orderInfo.orderId
                }
            })
        },
        /**
         * 复制订单号
         */
        copy(copyInner) {
            var oInput = document.createElement('input');
            oInput.value = copyInner;
            document.body.appendChild(oInput);
            oInput.select();
            document.execCommand("Copy");
            oInput.className = 'oInput';
            oInput.style.display = 'none';
            Toast("复制成功")
        },
        /**
         * 查看清单
         */
        getOrderlist() {
            const goodsList = []
            const item = {
                orderGeneralDetailList: this.orderInfo.orderGeneralDetailList,
                orderPackageDetailList: this.orderInfo.orderPackageDetailList,
                orderGroupDetailList: this.orderInfo.orderGroupDetailList 
            }
            goodsList.push(item)
            localStorage.setItem('goodsLists', JSON.stringify(goodsList));
            // if (this.$route.query.isPreSale === 'true'){
            //     localStorage.setItem('giftList', JSON.stringify([]))
            // } else {
            const orderGiftList = [];
            const promotionIds = [];
            (this.orderInfo.orderGiftList || []).forEach(v => {
                if (promotionIds.indexOf(v.promotionId) === -1) {
                    promotionIds.push(v.promotionId);
                    const giftList = this.orderInfo.orderGiftList.filter(gift => gift.promotionId === v.promotionId);
                    const obj = {
                        giftList: giftList,
                        activityTypeDesc: v.activityTypeDesc,
                        promotionTips: v.promotionTips
                    }
                    orderGiftList.push({
                        currentLadder: obj
                    });
                }
            })
            localStorage.setItem('giftList', JSON.stringify(orderGiftList || []));
            // }
            localStorage.setItem('goodnum', this.orderInfo.speciesNum);
            this.$router.push(`/order/goodlist`)
        },
        /**
         * 查看物流
         */
        showLogistics(val){
            this.$router.push({ path: `/order/logistics?orderId=${this.$route.query.orderId}&expressNum=${val}` })
        },
        /**
         * 弹出发送邮件弹框
         */
        showPopup(orderId, email){
            this.isShowSentBox = true
            this.email = email
        },
        /**
         * 关闭弹窗
         */
        closeDialog(){
            this.isShowSentBox = false
        },
        /**
         * 验证邮箱是否正确
         */
        validateEmail(action, done){
            if (isEmail(this.email)){
                Toast({
                    type: 'success',
                    duration: 1500,
                    message: '已发送至邮箱，请注意查收！',
                    onClose: () => {
                        done()
                    }
                })
            } else {
                Toast('请输入正确的邮箱地址')
                done(false)
            }
        },
        /**
         * 发送发票到邮箱
         */
        sentEmail(orderId){
            Api.sentEmail({
                orderId: orderId,
                email: this.email
            })
        },
        /**
         * 查看电子发票
         */
        gotoInvoice(orderId) {
            Api.getInvoiceList(orderId).then(({ data: { data }}) => {
                if (data.length === 1){
                    window.location.href = data[0].previewUrl;
                } else if (data.length > 1){
                    this.$router.push({
                        path: '/order/invoice',
                        query: {
                            orderId: orderId
                        }
                    })
                }    
            })
        },
        /**
         * 弹出更多按钮选择
         */
        showMoreBtn(){
            this.orderInfo.isShowMoreBtn = !this.orderInfo.isShowMoreBtn
        }
    }
}
</script>
<style lang="scss" >
%center{
    display: flex;
    justify-content: center;
    color: #ffffff;
}
.mergBtn{
    border-radius: .16rem;
    .van-dialog__message{
        font-size: .32rem;
    }
}
.order-detail {
    background: #F1F1F1;
    padding-top: 46px;
    padding-bottom: 54px;
    min-height: 12.8rem;
    #sent-email {
        width: 6.86rem;
        font-size: .32rem;
        .van-dialog__header {
            color: #666666;
            font-size: .28rem;
        }

        .code-info-box {
            display: flex;
            align-items: center;
            padding: .32rem .40rem .40rem;
            position: relative;

            input {
                width: 5.9rem;
                border-radius: .12rem;
                border: .02rem solid #E4E4E4;
                padding: .16rem .40rem;
                font-size: .28rem;
                color: #666666;
                &::-webkit-input-placeholder {
                    color: #999999;
                }
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

            &::after{
                border: none;
            }

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
    .order-state {
        width: 100%;
        color: #FFF;
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        background-image: url(https://imga.hnhcyy.com/fed/b2b-wechat/order-info-bg.png);
        .order-status-show{
            @extend %center;
            font-size: .36rem;
            padding: .42rem 0 .32rem 0;
        }
        img{
            width: .48rem;
            height: .48rem;
            margin-right: .2rem;
        }
        .border-line{
            height: .36rem;
            background: linear-gradient(180deg, #BF0000 0%, #A40808 100%);
            border-radius: .18rem;
            margin: 0 .04rem;
        }
    }

    /** 1 待支付 2 待发货 3 已发货 4 已收货 5 已完成 6 已取消 7 退款中 **/
    .order-state-1 {
        height: 3.6rem;
        .order-status-show{
            padding-bottom: .16rem;
        }
        .need-payment{
            @extend %center;
            line-height: .66rem;
            :nth-child(1){
                font-size: .28rem;
            }
            :nth-child(2){
                font-size: .48rem;
                margin-left: .1rem;
            }
        }
        .payment-timer{
            @extend %center;
            margin: .22rem .2rem .34rem 0;
            >span:nth-child(1){
                font-size: .28rem;
                margin-right: .2rem;
                line-height: .78rem;
            }
            .pay-btn{
                display: inline-block;
                margin-left: .2rem;
                width: 2.26rem;
                height: .78rem;
                text-align: center;
                line-height: .78rem;
                background: linear-gradient(180deg, #FFFFFF 0%, #FFF2F2 100%);
                box-shadow: 0 .04rem .08rem 0 rgba(255,227,227,0.5);
                border-radius: .4rem;
                color: #ED3129;
                font-size: .36rem;
                font-weight: 600;
            }
            .van-count-down{
                color: #FFFFFF;
                font-size: .36rem;
                margin-left: .2rem;
                line-height: .78rem;
            }
            .overtime{
                font-size: .36rem!important;
                font-weight: 600;
            }
        }
    }
    .order-state-2 {
        height: 1.76rem;
    }
    .order-logistics {
        display: flex;
        margin: -.08rem .1rem .32rem .28rem;
        background: #F8F8F8;
        border-radius: .08rem;
        .icon-kd1 {
            width: 1.16rem;
            height: 1.16rem;
        }
        .logistics-text {
            flex: 1;
            overflow: hidden;
            padding: .24rem .34rem .24rem 0;
            margin-left: .16rem;
            font-size: .24rem;
            line-height: .34rem;
            color: #666666;
            :nth-child(1){
                font-size: .28rem;
                font-weight: 600;
                margin-bottom: .08rem;
            }
            :nth-child(2){
                width: 100%;
                overflow: hidden;
                text-overflow:ellipsis;
                white-space: nowrap;
                font-size: .24rem;
            }
        }
    }
    .dividing-line{
        width: 100%;
        height: .16rem;
        margin: .32rem 0;
    }
    .order-content{
        background: #ffffff;
        margin: -.36rem .16rem .08rem .16rem;
        border-radius: .08rem;
        &::before{
            display: block;
            content: '';
            height: .16rem;
            border-top-left-radius: .08rem;
            border-top-right-radius: .08rem;
            background: linear-gradient(180deg, #E55F5F 0%, rgba(252, 240, 240, 0.31) 99%, rgba(253, 212, 212, 0.3) 100%);
        }
        .botton-bg-line{
            display: block;
            height: .08rem;
            margin: 0 .12rem;
        }
        .border-line::before{
            content: '';
            display: block;
            border-top: .02rem dotted #DDDDDD;
            margin: .24rem 0 .26rem 0;
        }
    }
    .goods-list {
        margin-top: .24rem;
        .shop-title {
            height: .44rem;
            line-height: .44rem;
            font-size: .32rem;
            color: #333333;
            display: flex;
            align-items: center;
            font-weight: 600;
            padding-left: .2rem;
            span{
                width: 6.68rem;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }
        }
        .item-list {
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: .26rem;
            padding: 0 .29rem;
            .img-box {
                .item-li {
                    float: left;
                    width: 1rem;
                    height: 1rem;
                    overflow: hidden;
                    text-align: center;
                    position: relative;
                    box-sizing: border-box;
                    margin-right: .2rem;
                    .preSaleImg{
                        position: absolute;
                        width: .6rem;
                        top: .2rem;
                        left: .08rem;
                        top: 0;
                        z-index: 9;
                    }
                    .van-image{
                        width: 1rem;
                        height: 1rem;
                        img {
                            width: 100%;
                            height: 100%;
                            border-radius: 5px;
                        }
                    }
                }
            }

            .btn-all {
                padding-right: .48rem;
                position: relative;
                .goto-list{
                    position: absolute;
                    right: -.16rem;
                    top: 50%;
                    width: .48rem;
                }
                span {
                    display: block;
                    &:first-child {
                        margin-top: .24rem;
                        color: #666666;
                        font-size: .28rem;
                        line-height: .36rem;
                        letter-spacing: .04rem;
                    }

                    &:nth-child(2) {
                        margin-top: .04rem;
                        font-size: .24rem;
                        color: #999999;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                        line-height: .3rem;
                    }
                }
            }
        }
        
        .preSaleTime{
            display: flex;
            height: .56rem;
            line-height: .56rem;
            margin: -.04rem .2rem .28rem .2rem;
            color: #FF6E00;
            font-size: .24rem;
            background: #FFF6EE;
            border-radius: .08rem;
            img{
                width: .28rem;
                margin: .14rem;
            }
            span{
                flex: 1;
            }
        }
    }
    .order-goods-info{
        background: #FFF;
        border-radius: .08rem;
    }
    
    .order-info {
        background: #FFF;
        padding: 0 .29rem .28rem .29rem;
        border-radius: .08rem;
        .title {
            line-height: .44rem;
            padding-bottom: .06rem;
            font-size: .32rem;
            color: #333333;
            font-weight: 600;
        }

        .info-dl {
            font-size: .28rem;
            line-height: .4rem;
            display: flex;
            position: relative;
            margin-top: .28rem;
            .dt {
                width: 2rem;
                color: #666666;
            }

            .dd {
                flex: 1;
                color: #333333;
            }
            .copy{
                display: inline-block;
                background: #FFE9E8;
                color: #ED3129;
                font-size: .24rem;
                width: .68rem;
                height:.36rem;
                text-align: center;
                line-height: .36rem;
                border-radius: .08rem;
                margin-left: .2rem;
            }

            .sent-email{
                padding: 0 .12rem;
                border-radius: .08rem;
                line-height: .4rem;
                background: #FFEAE9;
                position: absolute;
                right: .2rem;
                top: 0;
                color: #ED3129;
                font-size: .24rem;
            }
        }
    }
    .shop-total{
        display: flex;
        justify-content: space-between;
        font-size: .28rem;
        line-height: .68rem;
        padding: 0 .29rem;
        :nth-child(1){
            color: #666666;
        }
        .total-num{
            color: #ED3129
        }
    }
    .order-btns {
        position: fixed;
        width: 100%;
        bottom: 0;
        left: 0;
        background: #FFF;
        box-shadow: 0px 1px 6px 0px rgba(0, 0, 0, 0.16);
        padding: .14rem 0;
        transform: translateZ(0);
        display: flex;
        line-height: 1;
        justify-content: space-between;
        align-items: center;
        .van-icon{
            position: relative;
            left: .4rem;
            .more-btn-box{
                position: absolute;
                left: -.3rem;
                width: 2.14rem;
                div{
                    color: #333;
                    font-size: .28rem;
                    text-align: center;
                    padding: .2rem 0;
                    margin: 0 .1rem;
                }
            }
            .more-btn-box-1{
                height: 1.08rem;
                top: -1.1rem;
                background: url('~@/assets/images/more-btn-bg-1.png') center center no-repeat;
                background-size: contain;
            }
            .more-btn-box-2{
                height: 1.68rem;
                top: -1.7rem;
                background: url('~@/assets/images/more-btn-bg-2.png') center center no-repeat;
                background-size: contain;
            }
        }
        .btn-box{
            flex: 1;
            display: flex;
            justify-content: flex-end;
            padding: 0;
            margin-right: .32rem;
            .van-button{
                font-size: .28rem;
                line-height: .6rem;
                height: .6rem;
                padding: 0 .2rem;
                margin-left: .20rem;
            }
        }
    }
}
</style>
