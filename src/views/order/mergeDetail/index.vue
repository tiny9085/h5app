<template>
    <div class="merge-order-box">
        <div class="many-store-title">
            <van-checkbox v-model="orderInfo.checked" icon-size="18" class="is-checked" @change="selectMainOrder($event ,orderInfo)" />
            <div>
                <font>多店订单编号:</font>
                <span>{{ orderInfo.mergeOrderId }}</span>
            </div>
        </div>
        <div v-for="(store, idx) in orderInfo.orderList" :key="idx" class="many-store-list">
            <div v-if="store.orderStatus == 1" class="order-state order-state-1">
                <div class="need-payment">
                    <span>需支付 ¥</span>
                    <span>{{ (store.paymentAmount||0).toFixed(2) }}</span>
                </div>
                <div v-if="store.remainingTime>0" class="payment-timer">
                    <span>支付倒计时</span>
                    <van-count-down :time="store.remainingTime" format="HH:mm:ss">
                        <template #default="timeData">
                            <span>{{ timeData.hours < 10 ? '0' + timeData.hours : timeData.hours }}</span>
                            <span style="margin-right:.1rem">:</span>
                            <span>{{ timeData.minutes < 10 ? '0' + timeData.minutes : timeData.minutes }}</span>
                            <span style="margin-right:.1rem">:</span>
                            <span>{{ timeData.seconds < 10 ? '0' + timeData.seconds : timeData.seconds }}</span>
                        </template>
                    </van-count-down>
                </div>
                <div v-else class="payment-timer"><span class="overtime">超时未支付</span></div>
                <div class="order-status-show">
                    <span class="label">
                        <img src="@/assets/images/icon_money.png">
                        <i>{{ store.orderStatusDesc }}</i>
                    </span>
                    <div v-if="store.btns" class="btns">
                        <span v-if="store.btns.indexOf('取消订单') > -1" class="plain-btn" @click="cancelOrder(store,6)">取消订单</span>
                        <copy-order-btn
                            v-if="store.btns.indexOf('再来一单') > -1"
                            :item="store"
                            :is-show-top="true"
                        />
                        <span v-if="store.btns.indexOf('支付订单') > -1" @click="payOrder(store)">支付订单</span>
                    </div>
                </div>
                <p class="border-line" />
            </div>
            <div v-else class="order-state order-state-2">
                <div class="order-status-show">
                    <span class="label">
                        <img v-if="store.orderStatus == 2" src="@/assets/images/icon_wait.png">
                        <img v-if="store.orderStatus == 3" src="@/assets/images/icon_wait.png">
                        <img v-if="store.orderStatus == 4" src="@/assets/images/icon_received.png">
                        <img v-if="store.orderStatus == 5" src="@/assets/images/icon_received.png">
                        <img v-if="store.orderStatus == 6" src="@/assets/images/icon_cancelled.png">
                        <img v-if="store.orderStatus == 7" src="@/assets/images/icon_money.png">
                        <img v-if="store.orderStatus == 8" src="@/assets/images/icon_delete.png">
                        <i>{{ store.orderStatusDesc }}</i>
                    </span>
                    <div v-if="store.btns" class="btns">
                        <span v-if="store.btns.indexOf('取消订单') > -1" class="plain-btn" @click="cancelOrder(store,6)">取消订单</span>
                        <span v-if="store.btns.indexOf('删除订单') > -1" class="plain-btn" @click="cancelOrder(store,8)">删除订单</span>
                        <span v-if="store.btns.indexOf('查看发票') > -1" class="plain-btn" @click="gotoInvoice(store.orderId)">查看发票</span>
                        <span v-if="store.btns.indexOf('查看物流') > -1" class="plain-btn" @click="getLogic(store)">查看物流</span>
                        <copy-order-btn
                            v-if="store.btns.indexOf('再来一单') > -1"
                            :item="store"
                            :is-show-top="true"
                        />
                        <span v-if="store.btns.indexOf('确认收货') > -1" @click="cancelOrder(store,4)">确认收货</span>
                        <span v-if="store.btns.indexOf('支付订单') > -1" @click="payOrder(store)">支付订单</span>
                        <!-- <van-button data-item="{{item}}" data-index="{{index}}" plain color="#ED3129" wx:if="{{item.orderStatus == 7}}">取消退款</van-button>
                        <van-button data-item="{{item}}" data-index="{{index}}" round wx:if="{{item.orderStatus == 4}}" bind:click="applyRefund">申请退款</van-button> -->
                    </div>
                    <van-icon
                        v-if="store.otherBtns && store.otherBtns.length"
                        name="https://imga.hnhcyy.com/fed/b2b-wechat/icon_more_pointer.png"
                        color="#cccccc"
                        size=".36rem"
                        style="line-height:.6rem"
                        @click="showMoreBtn(idx)"
                    >
                        <div v-if="store.isShowMoreBtn" :class="['more-btn-box', store.otherBtns.length>1?'more-btn-box-2':'more-btn-box-1']">
                            <div v-if="store.otherBtns.indexOf('取消订单') > -1" @click="cancelOrder(store,6)">取消订单</div>
                            <div v-if="store.otherBtns.indexOf('删除订单') > -1" @click="cancelOrder(store,8)">删除订单</div>
                            <div v-if="store.otherBtns.indexOf('查看发票') > -1" @click="gotoInvoice(store.orderId)">查看发票</div>
                            <div v-if="store.otherBtns.indexOf('查看物流') > -1" @click="getLogic(store)">查看物流</div>
                        </div>
                    </van-icon>
                </div>
                <p class="border-line" />
            </div>
            <div class="order-info-box">
                <div class="goods-list">
                    <div class="shop-title">
                        <van-checkbox v-model="store.checked" icon-size="18" class="is-checked" @change="selectOrder($event, store, orderInfo)" />
                        <span class="store-name">{{ store.userName }}</span>
                        <i v-if="store.isMainShop" class="main-store">主店</i>
                    </div>
                    <img src="@/assets/images/icon_line.png" class="dividing-line" alt="">
                    <div v-if="store.orderType === 4 && store.orderGeneralDetailList.length !== 0" class="preSaleTime">
                        <img src="@/assets/images/icon_presale.png">
                        <span v-if="store.predictShippingDate">此订单包含预售商品，预计{{ store.predictShippingDate }}前发货</span>
                        <span v-else>此订单含预售商品，发货时间待定</span>
                    </div>
                    
                    <div class="item-list">
                        <div class="img-box">
                            <div style="display:flex;">
                                <div v-for="(img,index1) in store.goodsList" :key="index1" class="img-box">
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
                        <div class="btn-all" @click="getOrderlist(store)">
                            <span>查看清单</span>
                            <span>共{{ store.speciesNum }}件</span>
                            <img class="goto-list" src="@/assets/images/arrow-icon.png" alt="">
                        </div>
                    </div>
                    <div v-if="store.showMore">
                        <div class="shop-total">
                            <span>商品总额</span>
                            <span>¥{{ (store.totalAmount||0).toFixed(2) }}</span>
                        </div>
                        <div class="shop-total">
                            <span>满减优惠</span>
                            <span>-¥{{ (store.reduceAmount||0).toFixed(2) }}</span>
                        </div>
                        <div class="shop-total">
                            <span>优惠券</span>
                            <span>-¥{{ (store.couponsAmount||0).toFixed(2) }}</span>
                        </div>
                    </div>
                    <template v-else>
                        <p class="show-more"><span @click="showMoreInfo(true, idx)">展开<van-icon name="arrow-down" /></span></p>
                        <img src="@/assets/images/bottom-bg.png" class="botton-bg-line" alt="">
                    </template>
                </div>
                <div v-if="store.showMore" class="order-goods-info border-line">
                    <div class="shop-total">
                        <span>返利抵扣</span>
                        <span>-¥{{ (store.rebateAmount||0).toFixed(2) }}</span>
                    </div>
                    <div class="shop-total">
                        <span>专项款抵扣</span>
                        <span>-¥{{ (store.specialAmount||0).toFixed(2) }}</span>
                    </div>
                    <div class="shop-total">
                        <span>余额抵扣</span>
                        <span>-¥{{ (store.receivedAmount||0).toFixed(2) }}</span>
                    </div>
                    <div class="shop-total">
                        <span>{{ [2, 3, 4, 5].indexOf(store.orderStatus) > -1 ? '实付金额' : '还需支付' }}</span>
                        <span class="total-num">¥{{ (store.paymentAmount||0).toFixed(2) }}</span>
                    </div>
                </div>
                <div v-if="store.showMore" class="order-info">
                    <img src="@/assets/images/icon_line.png" class="dividing-line" alt="">
                    <div class="title">订单信息</div>
                    <div class="info-dl">
                        <div class="dt">订单编号：</div>
                        <div class="dd">{{ store.orderId }}<span class="copy" @click="copy(store.orderId)">复制</span></div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">发票类型：</div>
                        <div class="dd">{{ store.invoiceTypeDesc }}</div>
                        <div
                            v-if="store.invoiceType === 3 && [3, 4, 5].indexOf(store.orderStatus)> -1"
                            class="sent-email"
                            @click="showPopup(store.orderId, store.email)"
                        >发送至邮箱</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">配送方式：</div>
                        <div class="dd">{{ store.shippingDesc }}</div>
                    </div>
                    <div v-if="store.orderStatus == 3 || store.orderStatus == 4 || store.orderStatus == 5" class="info-dl">
                        <div class="dt">发货时间：</div>
                        <div class="dd">{{ store.shipTime }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">留言备注：</div>
                        <div class="dd">{{ store.userMessage }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">下单时间：</div>
                        <div class="dd">{{ store.createTime }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">支付方式：</div>
                        <div class="dd">{{ store.paymentTypeDesc || '' }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">付款时间：</div>
                        <div class="dd">{{ store.paymentTime || '' }}</div>
                    </div>
                    <div class="info-dl">
                        <div class="dt">交易流水号：</div>
                        <div class="dd">{{ store.tradeNo || '' }}</div>
                    </div>
                    <p class="show-more"><span @click="showMoreInfo(false, idx)">收起<van-icon name="arrow-up" /></span></p>
                    <img src="@/assets/images/bottom-bg.png" class="botton-bg-line" alt="">
                </div>
            </div>
        </div>
        <div class="total-info">
            <div class="row">
                <span>共{{ orderInfo.totalSpeciesNum }}件</span>
            </div>
            <div class="row">
                <div v-if="orderInfo.totalPreferentialAmount" class="row-preferent">
                    <span>优惠：</span>
                    <span>￥{{ (orderInfo.totalPreferentialAmount||0).toFixed(2) }}</span>
                </div>
                <div class="row-total">
                    <span>合计：</span>
                    <span>￥{{ (orderInfo.totalAmount||0).toFixed(2) }}</span>
                </div>
            </div>
        </div>
        <div class="order-btns">
            <van-icon
                v-if="orderInfo.otherBtns && orderInfo.otherBtns.length"
                name="ellipsis"
                color="#cccccc"
                size=".36rem"
                @click="showMoreBtn('all')"
            >
                <div
                    v-if="orderInfo.isShowMoreBtn"
                    :class="orderInfo.otherBtns.length > 1 ? 'more-btn-box more-btn-box-2' : 'more-btn-box more-btn-box-1'"
                >
                    <div
                        v-if="orderInfo.otherBtns.indexOf('取消订单') > -1"
                        @click="cancelMergOrder(orderInfo, 6)"
                    >取消订单</div>
                    <div
                        v-if="orderInfo.otherBtns.indexOf('删除订单') > -1"
                        @click="cancelMergOrder(orderInfo, 8)"
                    >删除订单</div>
                    <!-- <div v-if="orderInfo.otherBtns.indexOf('查看发票') > -1">查看发票</div> -->
                    <div v-if="orderInfo.otherBtns.indexOf('查看物流') > -1">查看物流</div>
                </div>
            </van-icon>
            <div v-if="orderInfo.btns" class="btn-box">
                <van-button
                    v-if="orderInfo.btns.indexOf('取消订单') > -1"
                    round
                    @click="cancelMergOrder(orderInfo, 6)"
                >取消订单</van-button>
                
                <van-button
                    v-if="orderInfo.btns.indexOf('删除订单') > -1"
                    round
                    @click="cancelMergOrder(orderInfo, 8)"
                >删除订单</van-button>

                <!-- <van-button
                    v-if="orderInfo.btns.indexOf('查看发票') > -1"
                    round
                >查看发票</van-button> -->

                <copy-order-btn
                    v-if="orderInfo.btns.indexOf('再来一单') > -1"
                    :item="orderInfo"
                    :is-merge-order="true"
                />

                <van-button
                    v-if="orderInfo.btns.indexOf('确认收货') > -1"
                    round
                    color="#ED3129"
                    @click="cancelMergOrder(orderInfo, 4)"
                >确认收货</van-button>

                <van-button
                    v-if="orderInfo.btns.indexOf('支付订单') > -1"
                    round
                    color="#ED3129"
                    @click="payMergOrder(orderInfo)"
                >支付订单</van-button>
            </div>
        </div>
        <van-dialog
            id="sent-email"
            v-model="isShowSentBox"
            use-slot
            title="发送至邮箱"
            confirm-button-text="提交"
            :before-close="validateEmail"
            @confirm="sentEmail(orderId)"
        >
            <div class="code-info-box">
                <input v-model="email" placeholder="请输入您的邮箱地址" focus>
                <van-icon class="close-dialog" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png" @click="closeDialog" />
            </div>
        </van-dialog>
    </div>
</template>

<style lang="scss">
    %center{
        display: flex;
        justify-content: center;
        color: #ffffff;
    }
    %textOver{
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }
    .mergBtn{
        border-radius: .16rem;
        .van-dialog__message{
            font-size: .32rem;
        }
    }
    .merge-order-box{
        background: #F4F4F4;
        padding-bottom: 1.12rem;
        padding-top: 46px;
        height: 100%;
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
        .row{
            display: flex;
            align-items: center;
            line-height: 1;
        }
        .many-store-title{
            display: flex;
            align-items: center;
            margin: .32rem 0 .42rem .44rem;
            font-size: .32rem;
            color: #333333;
            .van-checkbox {
                margin-right: .2rem;
            }
            font{
                color: #666666;
            }
            span{
                font-size: .36rem;
                font-weight: 600;
            }
        }
        .many-store-list{
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
                    padding: .4rem 0 .24rem 0;
                    margin: 0 .28rem;
                    .label{
                        display: flex;
                    }
                    i{
                        font-style: normal;
                    }
                    img{
                        width: .48rem;
                        height: .48rem;
                    }
                    .van-icon {
                        position: absolute;
                        right: 0;
                        img{
                            width: .28rem;
                        }
                        .more-btn-box{
                            position: absolute;
                            left: -1.9rem;
                            width: 2.14rem;
                            div{
                                color: #ED3129;
                                font-size: .28rem;
                                text-align: center;
                                padding: .2rem 0;
                                margin: 0 .1rem;
                            }
                        }
                        .more-btn-box-1{
                            height: 1.08rem;
                            top: -1.1rem;
                            background: url('~@/assets/images/more-btn-bg-3.png') center center no-repeat;
                            background-size: contain;
                        }
                        .more-btn-box-2{
                            height: 1.68rem;
                            top: -1.7rem;
                            background: url('~@/assets/images/more-btn-bg-3.png') center center no-repeat;
                            background-size: contain;
                        }
                    }
                    .btns{
                        display: flex;
                        flex: 1;
                        justify-content: flex-end;
                        padding-right: .1rem;
                        span{
                            box-sizing: border-box;
                            height: .6rem;
                            line-height: .6rem;
                            padding: 0 .2rem;
                            background: linear-gradient(180deg, #FFFFFF 0%, #FFF2F2 100%);
                            box-shadow: 0 .04rem .08rem 0 rgba(255,227,227,0.5);
                            border-radius: .3rem;
                            color: #ED3129;
                            font-size: .28rem;
                            margin-left: .16rem;
                        }
                        .plain-btn{
                            background: transparent;
                            border: .02rem solid #FFFFFF;
                            color: #ffffff;
                        }
                    }
                }
                .border-line{
                    height: .36rem;
                    background: linear-gradient(180deg, #BF0000 0%, #A40808 100%);
                    border-radius: .18rem;
                    margin: 0 .04rem;
                }
            }
            .order-state-1 {
                height: 3.6rem;
                .need-payment{
                    @extend %center;
                    padding-top: .46rem;
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
                    margin-top: .22rem;
                    margin-bottom: -.08rem;
                    >span:nth-child(1){
                        font-size: .28rem;
                        margin-right: .2rem;
                        line-height: .56rem;
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
            .order-info-box{
                margin: -.36rem .16rem .28rem .16rem;
                border-radius: .08rem;
                background: #ffffff;
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
                .shop-title{
                    display: flex;
                    padding: .32rem .28rem .26rem .28rem;
                    .store-name{
                        max-width: 5.2rem;
                        @extend %textOver;
                        color: #333333;
                        font-size: .32rem;
                        font-weight: 600;
                        margin-left: .2rem;
                        line-height: .4rem;
                    }
                    .main-store{
                        color: #ED3129;
                        font-size: .24rem;
                        font-style: normal;
                        padding: 0 .1rem;
                        border: .02rem solid #ED3129;
                        border-radius: .08rem;
                        margin-left:.08rem;
                    }
                }
                .dividing-line{
                    width: 100%;
                    height: .16rem;
                    margin-top: .04rem;
                }
                .goods-list {
                    border-radius: .08rem;
                    .item-list {
                        margin-top: .32rem;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: .26rem;
                        padding: 0 .28rem;
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
                        margin: .28rem .2rem;
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
                .order-info {
                    border-radius: .08rem;
                    overflow: hidden;
                    .dividing-line{
                        margin: .26rem 0 .18rem 0;
                    }
                    .title {
                        line-height: .44rem;
                        font-size: .32rem;
                        padding-top: .16rem;
                        color: #333333;
                        font-weight: 600;
                        padding: 0 .28rem;
                        margin: .14rem 0 .2rem 0;
                    }

                    .info-dl {
                        font-size: .28rem;
                        line-height: .68rem;
                        display: flex;
                        position: relative;
                        padding: 0 .28rem;
                        .dt {
                            width: 2rem;
                            color: #666;
                        }
                        .dd {
                            flex: 1;
                            color: #333;
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
                            top: .1rem;
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
                    padding: 0 .28rem;
                    :nth-child(1){
                        color: #666666;
                    }
                    .total-num{
                        color: #ED3129
                    }
                }
                .show-more{
                    text-align: center;
                    color: #999999;
                    margin: .14rem 0 .28rem 0;
                    .van-icon{
                        margin-left: .08rem;
                    }
                    .van-icon-arrow-down{
                        top: .04rem;
                    }
                    .van-icon-arrow-up{
                        top: .02rem;
                    }
                }
            }
        }
        .total-info{
            padding: .2rem .2rem 0 .2rem;
            display: flex;
            justify-content: flex-end;
            align-items: flex-end;
            .row:nth-child(1){
                padding-right: .08rem;
            }
            .row{
                display: flex;
                flex-direction: column;
                line-height: 1;
                color: #333333;
                font-size: .24rem;
                padding-bottom: .2rem;
            }
            .row-preferent{
                padding-bottom: .16rem;
            }
            .row-total{
                span:nth-child(2){
                    font-size: .28rem;
                    color: #ED3129;
                }
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
        }
        .order-btns .van-icon{
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
            display: flex;
            justify-content: flex-end;
            flex: 1;
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
</style>

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
            goodsList: [],
            isShowSentBox: false,
            email: '',
            orderId: ''
        }
    },
    created(){
        this.showOrderList();
    },
    methods: {
        /**
         * 查看订单详情
         */
        showOrderList() {
            Api.getMergOrderInfo(this.$route.query.mergeOrderId).then(res => {
                const data = res.data.data
                if (res.data.code === 0) {
                    data.allBtns = [];
                    data.btns = [];
                    data.otherBtns = [];
                    this.$set(data, 'isShowMoreBtn', false);
                    data.orderList.forEach((item, idx) => {
                        item.goodsList = []
                        item.checked = false
                        item.showMore = false;
                        if (idx === 0) item.showMore = true;
                        if (item.orderGeneralDetailList){
                            item.orderGeneralDetailList.forEach(goods => {                                
                                item.goodsList.push(goods);
                            })
                        }
                        this.$set(item, 'isShowMoreBtn', false);
                        item.allBtns = [];
                        item.btns = [];
                        item.otherBtns = [];
                        
                        if (item.orderStatus === 1){
                            item.allBtns = ['支付订单', '再来一单',  '取消订单'];
                        } else if (item.orderStatus === 3){
                            item.allBtns = ['确认收货', '再来一单', '查看物流' ];
                        } else if (item.orderStatus === 6){
                            item.allBtns = ['再来一单', '删除订单'];
                        } else {
                            item.allBtns = ['再来一单'];
                        }
                        if ([3, 4, 5].indexOf(item.orderStatus) > -1 && item.invoiceType === 3) {
                            item.allBtns.push('查看发票');
                        }
                        data.allBtns = [...data.allBtns, ...item.allBtns];
                        // 平行展示和更多展示逻辑(每个店)
                        if (item.allBtns.length > 3) {
                            item.otherBtns = item.allBtns.slice(3, item.allBtns.length);
                            item.btns = item.allBtns.slice(0, 3);
                        } else {
                            item.btns = item.allBtns;
                        }
                        if (item.expireTime) {
                            item.remainingTime = new Date(item.expireTime.split('-').join('/')).getTime() - new Date().getTime();
                        } else {
                            item.remainingTime = ''
                        }
                    })
                    // 按钮合并后去重
                    data.allBtns = [...new Set(data.allBtns)];

                    // 多门店汇总按钮没有查看发票&查看物流
                    const bIndex = data.allBtns.indexOf('查看发票');
                    if (bIndex > -1)data.allBtns.splice(bIndex, 1);
                    const aIndex = data.allBtns.indexOf('查看物流');
                    if (aIndex > -1)data.allBtns.splice(aIndex, 1);

                    // 按钮排序规则生成新数组
                    data.allBtns.sort((a, b) => {
                        const order = ["支付订单", "确认收货", "再来一单", "查看物流", "查看发票", "删除订单", "取消订单"];
                        return order.indexOf(a) - order.indexOf(b);
                    })

                    // 平行展示和更多展示逻辑
                    if (data.allBtns.length > 3) {
                        data.otherBtns = data.allBtns.slice(3, data.allBtns.length);
                        data.btns = data.allBtns.slice(0, 3);
                    } else {
                        data.btns = data.allBtns;
                    }
                    data.checked = false
                    data.selectList = []
                    this.orderInfo = data || {};
                }
            })
        },
        /**
         * 订单全选
         */
        selectMainOrder(e, item){
            item.orderList.forEach(store => {
                store.checked = e
            })
        },
        /**
         * 选择子店订单
         */
        selectOrder(e, item, mainItem){
            item.checked = e
            if (e){
                mainItem.selectList.push(item.orderId)
            } else {
                for (let i = 0; i < mainItem.selectList.length; i++){
                    if (mainItem.selectList[i] === item.orderId) {
                        mainItem.selectList.splice(i, 1)
                    }
                }
            }
        },
        /**
         * 弹出更多按钮选择
         */
        showMoreBtn(index){
            if (index === 'all') {
                this.orderInfo.isShowMoreBtn = !this.orderInfo.isShowMoreBtn
            } else {
                this.orderInfo.orderList[index].isShowMoreBtn = !this.orderInfo.orderList[index].isShowMoreBtn;
            }
        },
        /**
         * 判断所选门店订单状态是否一致
         */
        isSameOrderStatus(item){
            const orderStatus = []
            item.orderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    orderStatus.push(store.orderStatus)
                }
            })
            if (orderStatus.length > 0) {
                return !orderStatus.some(function(value, index) {
                    return value !== orderStatus[0];
                });
            } else {
                return true;
            }
        },
        /**
         * 取消订单&删除订单&确认收货(非多门店)
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
         * 取消订单&删除订单&确认收货(多门店)
         */
        cancelMergOrder(item, orderStatus){
            const orderStatusList = []
            item.orderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    orderStatusList.push(store.orderStatus)
                }
            })
            let orderNum = 0
            // if (this.isSameOrderStatus(item)){
            let message, tips;
            const filterList = []
            if (orderStatus === 6){
                // message = '是否取消订单？'
                tips = '取消'
                orderStatusList.forEach((val, idx) => {
                    if (val !== 1){ 
                        orderNum++
                        // item.selectList.splice(idx, 1)
                    } else {
                        filterList.push(item.selectList[idx])
                    }
                })
                if (filterList.length === 0){
                    Toast("未勾选待付款订单")
                    return
                }
            } else if (orderStatus === 8){
                message = '确认删除'
                tips = '删除'
                orderStatusList.forEach((val, idx) => {
                    if (val !== 6){ 
                        orderNum++
                        // item.selectList.splice(idx, 1)
                    } else {
                        filterList.push(item.selectList[idx])
                    }
                })
                if (filterList.length === 0){
                    Toast("未勾选已取消订单")
                    return
                }
            } else if (orderStatus === 4){
                message = '确认收货'
                tips = '确认收货'
                orderStatusList.forEach((val, idx) => {
                    if (val !== 3){ 
                        orderNum++
                        // item.selectList.splice(idx, 1)
                    } else {
                        filterList.push(item.selectList[idx])
                    }
                })
                if (filterList.length === 0){
                    Toast("未勾选已发货订单")
                    return
                }
            }
            if (orderNum === 0){
                Dialog.confirm({
                    message: '有 ' + orderStatusList.length + ' 个订单将' + tips,
                    cancelButtonText: "我再想想",
                    cancelButtonColor: '#999999',
                    confirmButtonText: message || '确定',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn'
                }).then(() => {
                    Api.cancelMergOrder({ orderIdList: item.selectList, orderStatus: orderStatus }).then(res => {
                        Toast.success({
                            message: '操作成功',
                            duration: 800,
                            onClose: () => {
                                this.showOrderList()
                            }
                        })
                    })
                })
            } else {
                Dialog.confirm({
                    message: '因有 ' + orderNum + ' 个订单状态不一致，将不与其他订单一起' + tips,
                    cancelButtonColor: '#999999',
                    confirmButtonText: '确定',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn',
                    messageAlign: 'left'
                }).then(() => {
                    Api.cancelMergOrder({ orderIdList: filterList, orderStatus: orderStatus }).then(res => {
                        Toast.success({
                            message: '操作成功',
                            duration: 800,
                            onClose: () => {
                                this.showOrderList()
                            }
                        })
                    })
                }).catch(() => {
                    Dialog.close();
                });
            }
        },
        /**
         * 支付订单
         */
        payOrder(item){
            localStorage.setItem('orderId', item.orderId)
            this.$router.push({ path: '/order/checkout', query: { mergOrder: false }})
        },
        /**
         * 支付订单(多门店)
         */
        payMergOrder(item){
            const orderStatusList = []
            item.orderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    orderStatusList.push(store.orderStatus)
                }
            })
            let orderNum = 0
            orderStatusList.forEach((val, idx) => {
                if (val === 1){ 
                    orderNum++
                } else {
                    // item.selectList.splice(idx, 1)
                }
            })
            if (orderNum === 0){
                Toast("未勾选待付款订单")
                return
            }
            orderNum = orderStatusList.length - orderNum
            if (orderNum !== 0){
                Dialog.confirm({
                    message: '因有 ' + orderNum + ' 个订单状态不一致，将不与其他订单一起支付',
                    cancelButtonColor: '#999999',
                    confirmButtonText: '去支付',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn',
                    messageAlign: 'left'
                }).then(() => {
                    if (!this.isSameInvoiceType(item)){
                        Dialog.alert({
                            message: '增值税专用发票与增值税普通发票订单不支持一同付款，请选择同类型发票订单进行付款',
                            cancelButtonColor: '#999999',
                            confirmButtonColor: '#ED3129',
                            className: 'mergBtn'
                        }).then(() => {
                            return false
                        });
                    } else {
                        localStorage.setItem('orderId', JSON.stringify(item.selectList))
                        this.$router.push({ path: '/order/checkout', query: { mergOrder: true }})
                    }
                }).catch(() => {
                    Dialog.close();
                });
            } else {
                if (!this.isSameInvoiceType(item)){
                    Dialog.alert({
                        message: '增值税专用发票与增值税普通发票订单不支持一同付款，请选择同类型发票订单进行付款',
                        cancelButtonColor: '#999999',
                        confirmButtonColor: '#ED3129',
                        className: 'mergBtn'
                    }).then(() => {
                        return false
                    });
                } else {
                    localStorage.setItem('orderId', JSON.stringify(item.selectList))
                    this.$router.push({ path: '/order/checkout', query: { mergOrder: true }})
                }
            }
        },
        /**
         * 判断是否为同种发票(1普通纸质发票 2专用发票 3电子发票)
         */
        isSameInvoiceType(item){
            const invoiceTypeList = []
            item.orderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    invoiceTypeList.push(store.invoiceType)
                }
            })
            if (invoiceTypeList.length > 0) {
                if (invoiceTypeList.indexOf(1) > -1 && invoiceTypeList.indexOf(2) > -1){
                    return false
                } else if (invoiceTypeList.indexOf(2) > -1 && invoiceTypeList.indexOf(3) > -1){
                    return false
                } else {
                    return true
                }
                // return !invoiceTypeList.some(function(value, index) {
                //     return value !== invoiceTypeList[0];
                // });
            } else {
                return true;
            }
        },
        /**
         * 查看物流
         */
        getLogic(val){
            this.$router.push({ path: `/order/logistics?orderId=${val.orderId}` })
        },
        /**
         * 查看清单
         */
        getOrderlist(store) {
            const goodsList = []
            const item = {
                orderGeneralDetailList: store.orderGeneralDetailList || [],
                orderPackageDetailList: store.orderPackageDetailList || [],
                orderGroupDetailList: store.orderGroupDetailList || [] 
            }
            goodsList.push(item)
            localStorage.setItem('goodsLists', JSON.stringify(goodsList));
            const orderGiftList = [];
            const promotionIds = [];
            (store.orderGiftList || []).forEach(v => {
                if (promotionIds.indexOf(v.promotionId) === -1) {
                    promotionIds.push(v.promotionId);
                    const giftList = store.orderGiftList.filter(gift => gift.promotionId === v.promotionId);
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
            localStorage.setItem('goodnum', store.speciesNum);
            this.$router.push(`/order/goodlist`)
        },
        /**
         * 弹出发送邮件弹框
         */
        showPopup(orderId, email){
            this.isShowSentBox = true
            this.email = email
            this.orderId = orderId
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
            this.isShowSentBox = false
            Api.sentEmail({
                orderId: orderId,
                email: this.email
            })
        },
        showMoreInfo(isOpen, index) {
            this.$set(this.orderInfo.orderList[index], 'showMore', isOpen);
        },
        /**
         * 复制订单号
         */
        copy(copyInner, e) {
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
        }
    }
}
</script>
