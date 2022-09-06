<template>
    <div class="order-box-submit">
        <div class="top-div" />
        <div v-for="(item, index) in userOrderCofirmList" :key="index">
            <div class="shop-name">
                <img class="store-icon" src="@/assets/images/store_icon_red.png">
                <span>{{ item.shopName }}</span>
            </div>
            <div class="order-list-box">
                <div class="order-list">
                    <div class="info">
                        <img src="@/assets/images/location-icon.png">
                        <div>
                            <div class="username">{{ item.contactorInfo.contactor }}<font>{{ item.contactorInfo.contactorPhone }}</font></div>
                            <div>地址：{{ item.contactorInfo.address }}</div>
                        </div>
                    </div>
                    <img class="order-line" src="@/assets/images/order-line.png" alt="">
                    <div class="item-list">
                        <div class="item-li-box">
                            <template v-for="(images, bindex) in item.imageList">
                                <div v-if="bindex < 4" :key="bindex" class="item-li">
                                    <img v-if="images.presell === true" class="preSaleImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" alt="">
                                    <image-load :is-product-img="true" mode="aspectFit" default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="images.imgUrl" />
                                </div>
                            </template>
                        </div>
                        <div class="item-li btn-all" @click="showOrderList(item, item.goodsList, item.imageList.length)">
                            <div>
                                <p>查看清单</p>
                                <p>共 {{ item.imageList.length }} 件商品</p>
                            </div>
                            <i class="van-icon van-icon-arrow van-cell__right-icon goto-list" />
                        </div>
                    </div>
                    <div v-if="item.presellNum > 0" class="preSaleTime">
                        <img src="@/assets/images/icon_presale.png">
                        <span v-if="item.predictShippingDate">此订单包含预售商品，预计{{ item.predictShippingDate }}前发货</span>
                        <span v-else>此订单包含预售商品，发货时间待定</span>
                    </div>
                    <div class="invoice-box border-bottom">
                        <van-radio-group v-model="item.invoiceType" class="invoice-list" @change="changeInvoiceShape(index)">
                            <span>发票类型</span>
                            <div>
                                <div
                                    v-for="(invoice, a) in item.invoiceInfo.invoiceTypeList"
                                    :key="a"
                                    class="invoice"
                                    :style="a>0 &&item.invoiceInfo.invoiceTypeList.length>1 ? 'margin-top: .24rem':''"
                                    @click="item.invoiceType = invoice.invoiceId"
                                >
                                    <!-- <img
                                        slot="icon"
                                        :src="invoice.invoiceId === 1 ? 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-pupiao-1.png' : invoice.invoiceId === 2 ? 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-zhuanpiao.png' : 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-pupiao-2.png'"
                                        style="margin-right:.06rem"
                                    > -->
                                    {{ invoice.invoiceName }}
                                    <van-radio slot="right-icon" :name="invoice.invoiceId" />
                                </div>
                            </div>
                        </van-radio-group>
                        <div v-if="item.invoiceType === 3" class="email-box">
                            <van-field v-model="item.invoiceInfo.email" label="邮箱地址：" placeholder="请输入邮箱地址" />
                            <van-checkbox v-model="item.invoiceInfo.syncEmail">设为默认</van-checkbox>
                            <!-- <van-radio :name="item.syncEmail">将电子邮箱同步至帐号信息</van-radio> -->
                        </div>
                        <div class="logistics-box">
                            <van-cell
                                :class="item.logistics === '请选择' ? 'logistics-red' : ''"
                                title="配送方式"
                                is-link
                                :value="item.logistics"
                                @click="chooseLogistics(index)"
                            />
                            <van-action-sheet
                                v-model="item.shipInfo.value"
                                z-index="9999999"
                                :round="false"
                                :actions="item.shipInfo.shipList"
                                cancel-text="取消"
                                close-on-click-action="true"
                                @select="selectLogistics($event,item, index)"
                            />
                        </div>
                        <div class="note-box">
                            <span>订单备注</span>
                            <input v-model="item.userMessage" type="text" placeholder="请输入留言内容">
                        </div>
                    </div>
                </div>
                <!-- 店铺小计 -->
                <div class="pay-info">
                    
                    <div class="pay-info-title">
                        <span>抱团小计</span>
                        <span>¥{{ (item.huddleAmount || 0).toFixed(2) }}</span>
                    </div>
                    <div class="pay-info-title">
                        <span>中药小计</span>
                        <span>¥{{ (item.herbAmount || 0).toFixed(2) }}</span>
                    </div>
                    <div class="pay-info-title">
                        <span>非药小计</span>
                        <span>¥{{ (item.notMedicineAmount || 0).toFixed(2) }}</span>
                    </div>
                    <div class="pay-info-title">
                        <span>商品总额</span>
                        <span>¥{{ (item.settlementInfo.totalAmount || 0).toFixed(2) }}</span>
                    </div>
                    <div
                        v-if="item.settlementInfo.discountInfo.combDiscountModel.reduceAmount"
                        class="pay-info-title"
                    >
                        <span>满减优惠</span>
                        <span>-¥{{ (item.settlementInfo.discountInfo.combDiscountModel.reduceAmount || 0).toFixed(2) }}</span>
                    </div>
                    <div
                        v-if="item.settlementInfo.discountInfo.couponsModel.couponsList.length"
                        class="pay-info-title"
                        @click="showCouponFn(item, index)"
                    >
                        <span>优惠券<i class="coupon-info">{{ item.settlementInfo.discountInfo.couponsModel.cuoponName }}</i></span>
                        <span>-¥{{ (item.settlementInfo.discountInfo.couponsModel.couponsAmount || 0 ).toFixed(2) }}
                            <van-icon name="arrow" />
                        </span>
                    </div>

                    <div class="pay-info-title">
                        <span>小计：</span>
                        <span>¥{{ (item.subTotal || 0).toFixed(2) }}</span>
                    </div>
                </div>
                <!-- <div :class="couponsList.length > 0 ? 'pay-kind' : 'pay-kind pay-kind-1'"> -->
                <div class="pay-kind">
                    <div class="pay-info-title">
                        <span>
                            <font>返利</font><img class="rebate-tips" src="https://imga.hnhcyy.com/fed/b2b-wechat/rebate-tips.png" @click="showTips">
                        </span>
                        <span style="flex:1;display:flex;justify-content:flex-end;">
                            可用返利：¥{{ (item.settlementInfo.balanceInfoMap.useRebate.rebateAmount).toFixed(2) }}
                            <van-checkbox
                                v-model="item.useRebate"
                                :disabled="!item.isRebate"
                                :name="item.useRebate"
                                class="balance-pay"
                                @change="changeBalancePay(item, index)"
                            />
                        </span>
                    </div>
                    <div class="pay-info-title">
                        <span>专项款抵扣</span>
                        <span>-¥{{ (item.useRebate ? item.settlementInfo.balanceInfoMap.useRebate.specialAmount : item.settlementInfo.balanceInfoMap.notUseRebate.specialAmount).toFixed(2) }}</span>
                    </div>
                    <div v-if="item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList&&item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0]&&item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].restrict">
                        <template v-if="item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].isDividend-0=== -1">
                            <div
                                v-if="item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].startTime && new Date(item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].startTime).getTime() > new Date().getTime()"
                                class="special-disabled-box"
                            >专项款已冻结，解冻日期：{{ item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].startTime }}</div>
                            <div v-else>专项款已冻结，请联系地总或管理员</div>
                        </template>
                        <template v-else>
                            <div
                                v-if="item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].ableQuantity<item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].minProductQuantity"
                                class="special-box"
                            >还需采购 {{ item.settlementInfo.balanceInfoMap.notUseRebate.accountUsage.specialAccountUsageList[0].diffQuantity || 0 }} 个专项品种可使用专项款</div>
                        </template>
                    </div>
                    <div class="pay-info-title">
                        <span>余额</span>
                        <span>-¥{{ (item.useRebate ? item.settlementInfo.balanceInfoMap.useRebate.receivedAmount : item.settlementInfo.balanceInfoMap.notUseRebate.receivedAmount).toFixed(2) }}</span>
                    </div>
                </div>
                <div class="pay-kind-bottom">
                    <span>还需支付：</span>
                    <span class="red">¥{{ (item.useRebate ? item.settlementInfo.balanceInfoMap.useRebate.needPayAmount : item.settlementInfo.balanceInfoMap.notUseRebate.needPayAmount).toFixed(2) }}</span>
                </div>
            </div>
            
        </div>
        <!-- 多店总计 -->
        <div v-if="userOrderCofirmList.length > 1">
            <h6 class="order-sub-title">订单合计</h6>
            <div class="order-total-info">
                <div class="pay-info-title">
                    <span>抱团合计</span>
                    <span>¥{{ (totalInfo.huddleAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>中药合计</span>
                    <span>¥{{ (totalInfo.herbAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>非药合计</span>
                    <span>¥{{ (totalInfo.notMedicineAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>商品总额</span>
                    <span>¥{{ ( totalInfo.totalAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>满减优惠</span>
                    <span>-¥{{ (totalInfo.reduceAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>优惠券</span>
                    <span>-¥{{ (totalInfo.couponsAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>优惠后总额</span>
                    <span>¥{{ (totalInfo.orderTotalAmount || 0).toFixed(2) }}</span>
                </div>
            </div>
            <h6 class="order-sub-title">抵扣合计</h6>
            <div class="order-total-info">
                <div class="pay-info-title">
                    <span>返利抵扣</span>
                    <span>-¥{{ (totalInfo.rebateAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>专项款抵扣</span>
                    <span>-¥{{ (totalInfo.specialAmount || 0).toFixed(2) }}</span>
                </div>
                <div class="pay-info-title">
                    <span>余额抵扣</span>
                    <span>-¥{{ (totalInfo.receivedAmount || 0).toFixed(2) }}</span>
                </div>
            </div>
        </div>

        <div class="bottom" />
        <div class="submit-order">
            <div class="multi-subtotal">
                <p>共 {{ userOrderCofirmList.length }} 个订单  共 {{ totalInfo.count }} 件</p>
                <div class="subtotal">
                    <span>还需支付：</span>
                    <span>¥{{ (totalInfo.needPayAmount || 0).toFixed(2) }}</span>
                </div>
            </div>
            <!-- <div v-else class="subtotal">
                <span>还需支付</span>
                <span>¥{{ (totalInfo.needPayAmount || 0).toFixed(2) }}</span>
            </div> -->
            <van-button class="submit-btn" :loading="isloading" round loading-text="加载中" @click="submitOrder(0)">提交订单</van-button>
        </div>

        <!-- 优惠券弹窗 -->
        <van-action-sheet v-model="showCoupon" :round="false" title="请选择优惠券" class="detail-coupon-sheet">
            <div
                v-for="(couponItem, index) in couponsList"
                :key="index"
                class="dv"
            >
                <coupon-detail :coupon="couponItem" :not-use="false" />
                <van-radio v-model="selectedCoupon" :name="couponItem.id" @click="changeCoupon" />
            </div>
            <div class="no-dv">
                <van-radio v-model="selectedCoupon" name="" @click="changeCoupon">不使用优惠券</van-radio>
            </div>
        </van-action-sheet>

        <van-action-sheet
            v-model="confirmAddress"
            :round="false"
            title="确认收货人信息"
            class="confirm-address-sheet"
            @close="cancelSubmit"
        >
            <p class="confirm-tips">如您的收货地址与实际收货地址不符,请在对应订单上留言说明或联系您的专属地区经营顾问～</p>
            <div class="confirm-address-stores">
                <template v-for="(item, i) in userOrderCofirmList">
                    <div v-if="item.contactorInfo && !item.contactorInfo.userConfirmed" :key="i" class="store-default-address">
                        <div class="shop-name">
                            <img class="store-icon" src="@/assets/images/store_icon_red.png">
                            <span>{{ item.shopName }}</span>
                        </div>
                        <div class="info">
                            <img src="@/assets/images/location-icon.png">
                            <div>
                                <div class="username">{{ item.contactorInfo.contactor }}
                                    <font>{{ item.contactorInfo.contactorPhone }}</font>
                                </div>
                                <div>{{ item.contactorInfo.address }}</div>
                            </div>
                        </div>
                        <img class="order-line" src="@/assets/images/order-line.png" alt="">
                    </div>
                </template>
            </div>
            <van-button :loading="isloading" class="confirm-address-btn" @click="submitOrder(1)">确 定</van-button>
        </van-action-sheet>
    </div>
</template>

<script>
import imageLoad from '@/components/imageLoad/index'
import couponDetail from '@/components/couponDetail/index'
import Api from '@/api/order/index'
import { Dialog, Toast } from 'vant'
import { isEmail } from '@/utils/validate'
export default {
    name: 'ComfirmOrder',
    components: {
        imageLoad,
        couponDetail
    },
    inject: ['reload'],
    data() {
        return {
            orderInfo: {
                orderList: [],
                calcToken: JSON.parse(localStorage.getItem('cartInfo')).calcToken
            },
            couponsList: [],
            itemObj: {},
            showCoupon: false,
            selectedCoupon: '',
            isloading: false,
            couponName: '',
            userOrderCofirmList: [],
            totalInfo: {
                huddleAmount: 0, // 抱团合计
                herbAmount: 0, // 中药合计
                notMedicineAmount: 0, // 非药合计
                totalAmount: 0, // 商品总额合计
                reduceAmount: 0, // 满减合计
                couponsAmount: 0, // 优惠券合计
                orderTotalAmount: 0, // 优惠后总额
                rebateAmount: 0, // 返利
                specialAmount: 0, // 专项款
                receivedAmount: 0, // 余额
                needPayAmount: 0, // 还需支付
                count: 0 // 商品件数
            },
            firstSelectRebateFlag: true, // 第一次选择返利
            firstSelectShipFlag: true, // 第一次选择物流
            changeCouponFlag: false, // 改变优惠券选择
            confirmAddress: false,
            userConfirmedLen: 0 // 未确认收货地址的店铺数
        }
    },
    computed: {},
    mounted() {
        this.initData();
    },
    beforeDestroy(){
        localStorage.setItem('selectCoupon', null)
    },
    methods: {
        setCouponName(coupon) {
            if (coupon.buyMoney === 0) {
                return '无门槛减' + coupon.discount + '元'
            } else {
                return '满' + coupon.buyMoney + '减' + coupon.discount + '元'
            }
        },
        // 初始化页面展示数据
        initData() {
            const extraGift = JSON.parse(localStorage.getItem('extraGift')) || []
            const userOrderCofirmList = JSON.parse(localStorage.getItem('cartInfo')).userOrderCofirmList || [];
            const goodsList = JSON.parse(localStorage.getItem('goodsList')) || []
            const totalInfo = {
                huddleAmount: 0, // 抱团合计
                herbAmount: 0, // 中药合计
                notMedicineAmount: 0, // 非药合计
                totalAmount: 0, // 商品总额合计
                reduceAmount: 0, // 满减合计
                couponsAmount: 0, // 优惠券合计
                orderTotalAmount: 0, // 优惠后总额
                rebateAmount: 0, // 返利
                specialAmount: 0, // 专项款
                receivedAmount: 0, // 余额
                needPayAmount: 0, // 还需支付
                count: 0 // 商品件数
            }
            userOrderCofirmList.forEach(storeOrder => {
                if (storeOrder.contactorInfo && !storeOrder.contactorInfo.userConfirmed) this.userConfirmedLen++;
                storeOrder.presellNum = 0;
                // 设置每个店铺额外的赠品
                storeOrder.extraGift = [];
                extraGift.forEach(user => {
                    if (user.userSid === storeOrder.userSid){
                        storeOrder.extraGift = user.promotionInfoGroupList;
                    }
                })
                storeOrder.predictShippingDate = '';
                // 组装订单店信息
                goodsList.forEach(storeGoods => {
                    if (storeOrder.userSid === storeGoods.userSid) {
                        storeOrder.huddleAmount = storeGoods.huddleAmount;
                        storeOrder.herbAmount = storeGoods.herbAmount;
                        storeOrder.notMedicineAmount = storeGoods.notMedicineAmount;
                        
                        // 组装商品图片
                        const imageList = [];
                        storeGoods.generalProductList.forEach(v => {
                            if (v.presell === true) {
                                storeOrder.presellNum++;
                                if (storeOrder.predictShippingDate) {
                                    const old = new Date(storeOrder.predictShippingDate.split('-').join('/')).getTime();
                                    const curr = new Date(v.predictShippingDate.split('-').join('/')).getTime();
                                    if (curr - old > 0) storeOrder.predictShippingDate = v.predictShippingDate;
                                } else {
                                    storeOrder.predictShippingDate = v.predictShippingDate;
                                }
                            }
                            v.imgUrl = v.imgUrl || v.mainImg;
                            imageList.push(v);
                        })
                        storeGoods.packageProductList.forEach(v => {
                            v.orderGiftList = v.giftList;
                            delete v.giftList;
                            v.productList.forEach(vl => {
                                if (vl.presell === true) storeOrder.presellNum++;
                                vl.imgUrl = vl.imgUrl || v.mainImg;
                                imageList.push(vl.imgUrl);
                            })
                        })
                        storeOrder.goodsList = storeGoods;
                        storeGoods.groupProductList.forEach(v => {
                            v.productList.forEach(vl => {
                                if (vl.presell === true) storeOrder.presellNum++;
                                vl.imgUrl = vl.imgUrl || v.mainImg;
                                imageList.push(v);
                            })
                        })
                        storeOrder.imageList = imageList;
                    }
                })
                
                // 组装其他数据
                storeOrder.showCoupon = false;
                // 设置优惠券信息
                if (storeOrder.settlementInfo.discountInfo.couponsModel.couponsList.length) {
                    if (storeOrder.selectedCoupon) {// 改变了优惠券
                        // 选择了优惠券
                        storeOrder.settlementInfo.discountInfo.couponsModel.cuoponName = 
                            this.setCouponName(storeOrder.selectedCouponObj);
                    } else {
                        // 不使用优惠券
                        if (storeOrder.selectedCouponObj && storeOrder.selectedCouponObj.name === '不使用优惠券') {
                            storeOrder.settlementInfo.discountInfo.couponsModel.cuoponName = '不使用优惠券';
                        } else {// 未改变过优惠券
                            storeOrder.settlementInfo.discountInfo.couponsModel.cuoponName = 
                                this.setCouponName(storeOrder.settlementInfo.discountInfo.couponsModel.couponsList[0]);
                            storeOrder.selectedCoupon = storeOrder.settlementInfo.discountInfo.couponsModel.couponsList[0].id;
                            storeOrder.selectedCouponObj = storeOrder.settlementInfo.discountInfo.couponsModel.couponsList[0];
                        }
                    }
                } else {
                    storeOrder.selectedCoupon = '';
                    storeOrder.selectedCouponObj = {};
                }
                // 单店小计
                storeOrder.subTotal = storeOrder.settlementInfo.totalAmount - storeOrder.settlementInfo.discountInfo.preferentialAmount;
                // 初始化其他数据
                if (!storeOrder.hasOwnProperty('invoiceType'))storeOrder.invoiceType = storeOrder.invoiceInfo.invoiceTypeList[0].invoiceId;
                if (!storeOrder.hasOwnProperty('userMessage'))storeOrder.userMessage = "";
                if (!storeOrder.invoiceInfo.hasOwnProperty('syncEmail'))storeOrder.invoiceInfo.syncEmail = "";
                if (!storeOrder.invoiceInfo.hasOwnProperty('emailVal'))storeOrder.invoiceInfo.emailVal = storeOrder.invoiceInfo.email;
                if (!storeOrder.hasOwnProperty('logistics'))storeOrder.logistics = '';
                if (!storeOrder.shipInfo.hasOwnProperty('value'))storeOrder.shipInfo.value = false;
                if (!storeOrder.hasOwnProperty('shippingSid'))storeOrder.shippingSid = '';
                // 默认不使用返利
                // if (!storeOrder.hasOwnProperty('useRebate'))storeOrder.useRebate = false;
                storeOrder.useRebate = false;
                
                storeOrder.shipInfo.shipList.forEach(ship => {
                    ship.name = ship.shippingName;
                })
                // 是否可选返利
                // if (!storeOrder.hasOwnProperty('isRebate')){
                if (storeOrder.settlementInfo.balanceInfoMap.useRebate.rebateAmount === 0) {
                    storeOrder.isRebate = false;
                } else {
                    storeOrder.isRebate = true;
                }
                // }
                // ------------统计信息---------
                
                // 合计信息统计
                totalInfo.huddleAmount += storeOrder.huddleAmount;
                totalInfo.herbAmount += storeOrder.herbAmount;
                totalInfo.notMedicineAmount += storeOrder.notMedicineAmount;
                totalInfo.totalAmount += storeOrder.settlementInfo.totalAmount;
                totalInfo.reduceAmount += storeOrder.settlementInfo.discountInfo.combDiscountModel.reduceAmount;
                totalInfo.couponsAmount += storeOrder.settlementInfo.discountInfo.couponsModel.couponsAmount;
                totalInfo.orderTotalAmount += storeOrder.subTotal;
                totalInfo.count += storeOrder.imageList.length;
                if (storeOrder.useRebate) {
                    totalInfo.rebateAmount += storeOrder.settlementInfo.balanceInfoMap.useRebate.rebateAmount;
                    totalInfo.specialAmount += storeOrder.settlementInfo.balanceInfoMap.useRebate.specialAmount;
                    totalInfo.receivedAmount += storeOrder.settlementInfo.balanceInfoMap.useRebate.receivedAmount;
                    totalInfo.needPayAmount += storeOrder.settlementInfo.balanceInfoMap.useRebate.needPayAmount;
                } else {
                    totalInfo.rebateAmount += storeOrder.settlementInfo.balanceInfoMap.notUseRebate.rebateAmount;
                    totalInfo.specialAmount += storeOrder.settlementInfo.balanceInfoMap.notUseRebate.specialAmount;
                    totalInfo.receivedAmount += storeOrder.settlementInfo.balanceInfoMap.notUseRebate.receivedAmount;
                    totalInfo.needPayAmount += storeOrder.settlementInfo.balanceInfoMap.notUseRebate.needPayAmount;
                }
            })
            this.userOrderCofirmList = userOrderCofirmList;
            this.totalInfo = totalInfo;
        },
        /**
         * 切换是否使用返利
         */
        changeBalancePay(item, index) {
            this.totalInfo.rebateAmount = 0;
            this.totalInfo.specialAmount = 0;
            this.totalInfo.receivedAmount = 0;
            this.totalInfo.needPayAmount = 0;
            
            // 第一个店铺第一次选返利时默认给其他可选返利的店铺选上返利
            this.userOrderCofirmList.forEach(v => {
                const useRebateObj = v.settlementInfo.balanceInfoMap.useRebate
                const notUseRebateObj = v.settlementInfo.balanceInfoMap.notUseRebate
                // 当前修改为选中返利 & 当前改的是第一个 & 店铺可以使用返利 & 所有店第一次选择返利 满足所有条件代选其他有返利的店铺
                if (item.useRebate && index === 0 && useRebateObj.rebateAmount &&  this.firstSelectRebateFlag) {
                    v.isRebate = true;
                    v.useRebate = true;
                }
                // 计算总返利
                if (v.useRebate) {
                    this.totalInfo.rebateAmount += useRebateObj.rebateAmount;
                    this.totalInfo.specialAmount += useRebateObj.specialAmount;
                    this.totalInfo.receivedAmount += useRebateObj.receivedAmount;
                    this.totalInfo.needPayAmount += useRebateObj.needPayAmount;
                } else {
                    this.totalInfo.rebateAmount += notUseRebateObj.rebateAmount;
                    this.totalInfo.specialAmount += notUseRebateObj.specialAmount;
                    this.totalInfo.receivedAmount += notUseRebateObj.receivedAmount;
                    this.totalInfo.needPayAmount += notUseRebateObj.needPayAmount;
                }
            })
            this.firstSelectRebateFlag = false;
        },
        /**
         * 点击显示返利说明 
         */
        showTips() {
            Dialog.alert({
                title: '返利使用规则',
                confirmButtonText: '知道了',
                message: '抵扣条件：除促销活动和限价外的所有商品\n抵扣额度：最多抵扣订单总金额的30%',
                messageAlign: 'left',
                className: 'rebateTips'
            })
        },
        /**
         * 切换发票类型
         */
        changeInvoiceShape(i){
            // this.userOrderCofirmList[i].invoiceType = this.userList[i].invoiceShape
        },
        /**
         * 显示商品清单
         */
        showOrderList(user, item, num) {
            const goodsLists = []
            item.generalProductList.forEach(product => {
                product.orderGiftList = product.giftList
            })
            const goods = {
                orderGeneralDetailList: item.generalProductList || [],
                orderPackageDetailList: item.packageProductList || [],
                orderGroupDetailList: item.groupProductList || []
            }
            goodsLists.push(goods)
            localStorage.setItem('goodsLists', JSON.stringify(goodsLists))
            // if (this.$route.query.type !== 'preSale'){
            //     localStorage.setItem('giftList', JSON.stringify(user.extraGift))
            // } else {
            localStorage.setItem('giftList', JSON.stringify(user.extraGift))
            // }
            localStorage.setItem('goodnum', num)
            this.$router.push('/order/goodlist')
        },
        /**
         * 弹出选择物流方式窗口
         */
        chooseLogistics(i) {
            this.userOrderCofirmList[i].shipInfo.value = true;
        },
        /**
         * 选择物流方式
         */
        selectLogistics(e, item, index){
            // 当前为第一个店 & 所有店都未选择过物流时 代选其他有该物流的店铺
            let flag = false;
            if (index === 0 && this.firstSelectShipFlag) {
                this.userOrderCofirmList.forEach(v => {
                    if (item.userSid !== v.userSid) {
                        v.shipInfo.shipList.forEach(ship => {
                            if (ship.sid === e.sid) {
                                flag = true;
                                v.shippingSid = ship.sid;
                                v.logistics = ship.name;
                            }
                        })
                    }
                })
            }
            item.logistics = e.name
            item.shippingSid = e.sid
            this.firstSelectShipFlag = false;
            if (flag && this.userOrderCofirmList.length > 1)Toast("其它门店已选相同物流");
        },
        /**
         * 查看优惠券
         */
        showCouponFn(item){
            this.showCoupon = true;
            this.couponsList = item.settlementInfo.discountInfo.couponsModel.couponsList;
            this.itemObj = item;
            this.selectedCoupon = item.selectedCoupon ? item.selectedCoupon : '';
        },
        /**
         * 判断是否为同种发票
         */
        isSameInvoiceType(item){
            const invoiceTypeList = []
            item.orderList.forEach(store => {
                invoiceTypeList.push(store.invoiceType)
            })
            if (invoiceTypeList.length > 0) {
                if (invoiceTypeList.indexOf(1) > -1 && invoiceTypeList.indexOf(2) > -1){
                    return false
                } else if (invoiceTypeList.indexOf(2) > -1 && invoiceTypeList.indexOf(3) > -1){
                    return false
                } else {
                    return true
                }
            } else {
                return true;
            }
        },
        // 取消设置默认地址
        cancelSubmit() {
            this.isloading = false;
        },
        /**
         * 提交
         */
        submitOrder(action){
            this.orderInfo.orderList = []
            let shipFlag = true;
            let flagIndex = ''; // 控制定位的店铺，先物流后邮箱选最开始的一个
            let emailFlag = true;
            const eMailList = []
            this.userOrderCofirmList.forEach((user, i) => {
                if (!user.shippingSid) {
                    if (shipFlag) flagIndex = i;
                    shipFlag = false;
                    user.logistics = '请选择';
                } else {
                    if (user.invoiceType === 3 && user.invoiceInfo.email) { // 邮箱存在时验证格式
                        if (!isEmail(user.invoiceInfo.email)){
                            if (emailFlag) flagIndex = i;
                            emailFlag = false;
                        }
                    }
                }
                // 额外赠品组装
                let giftList = [];
                user.extraGift.forEach(promotion => {
                    giftList = giftList.concat(promotion.currentLadder.giftList || []);
                })
                const item = {
                    generalProductList: [],
                    packageProductList: [],
                    groupProductList: [],
                    userMessage: user.userMessage, // 备注
                    userSid: user.userSid,
                    source: 5,
                    shippingSid: user.shippingSid,
                    useRebate: user.useRebate,
                    giftList: giftList,
                    couponsList: user.selectedCoupon ? [{ id: user.selectedCoupon }] : [],
                    email: user.invoiceType === 3 ? user.invoiceInfo.email : user.invoiceInfo.emailVal, // 邮箱
                    invoiceType: user.invoiceType,
                    syncEmail: user.invoiceInfo.syncEmail // 默认邮箱
                    // Logistics: user.logistics
                }
                user.goodsList.generalProductList.forEach(general => {
                    item.generalProductList.push({
                        id: general.productSid,
                        quantity: general.quantity,
                        giftList: general.giftList
                    })
                })
                user.goodsList.packageProductList.forEach(items => {
                    item.packageProductList.push({
                        id: items.packageId,
                        quantity: items.packageQuantity,
                        giftList: items.orderGiftList
                    })
                })
                user.goodsList.groupProductList.forEach(group => {
                    group.productList.forEach(items => {
                        item.generalProductList.push({
                            id: items.productSid,
                            quantity: items.quantity,
                            giftList: items.giftList
                        })
                    })
                })
                if (item.syncEmail){
                    const eMailItem = {
                        sid: user.userSid,
                        email: item.email
                    }
                    eMailList.push(eMailItem)
                }
                this.orderInfo.orderList.push(item)
            })

            if (!shipFlag){
                this.gotoTop(flagIndex);
                this.isloading = false
                Toast("请选择配送方式")
            } else if (!emailFlag){
                this.gotoTop(flagIndex);
                this.isloading = false
                Toast("邮箱格式不正确")
            }
            else {
                // 确认默认收获地址
                if (action === 0 && this.userConfirmedLen > 0) {
                    this.confirmAddress = true;
                    return;
                }
                this.isloading = true
                // 同步邮箱
                if (eMailList.length !== 0){
                    Api.bindEmail(eMailList).then((res) => {
                        
                    })
                }
                if (this.$route.query.type === 'preSale'){
                    Api.submitPreSaleOrder(this.orderInfo).then(({ data }) => {
                        localStorage.setItem("couponInfo", null)
                        localStorage.setItem('selectCoupon', null)
                        localStorage.setItem('selectLogisticsArr', null)
                        this.goToPay(data.data)
                    }).catch(() => {
                        this.isloading = false
                    })
                } else {
                    Api.submitOrder(this.orderInfo).then(({ data: { data }}) => {
                        localStorage.setItem("couponInfo", null)
                        localStorage.setItem('selectCoupon', null)
                        localStorage.setItem('selectLogisticsArr', null)
                        this.goToPay(data)
                    }).catch(() => {
                        this.isloading = false
                    })
                }
            }
        },
        /**
         * 去支付
         */
        goToPay(data){
            this.confirmAddress = false;
            this.userConfirmedLen = 0;
            // 修改本地缓存的状态
            // const userOrderCofirmList = JSON.parse(localStorage.getItem('cartInfo')).userOrderCofirmList || [];
            // userOrderCofirmList.forEach(storeOrder => {
            //     if (storeOrder.contactorInfo && !storeOrder.contactorInfo.userConfirmed) storeOrder.contactorInfo.userConfirmed = true;
            // })
            // const cartInfo = JSON.parse(localStorage.getItem('cartInfo'));
            // cartInfo.userOrderCofirmList = userOrderCofirmList;
            // localStorage.setItem('cartInfo', JSON.stringify(cartInfo));

            if (this.isSameInvoiceType(this.orderInfo)){
                this.isloading = false
                localStorage.setItem("orderId", data)
                this.$store.commit('setCartNum')
                this.$router.push('/order/checkout')
                // if (localStorage.getItem("isWechat") === 'true'){
                //     // 微信内支付
                //     const appid = 'wx4696e4b4b8ae570d'
                //     // const appid = 'wxfe1b7757e914aeef'
                //     const redirect_uri = encodeURIComponent('http://m.hnhcyy.com/#/order/checkout')
                //     const url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + redirect_uri + '&response_type=code&scope=snsapi_base#wechat_redirect'
                //     window.location.href = url
                // } else {
                //     this.$router.push('/order/checkout')
                // }
            } else {
                Dialog.alert({
                    message: '您本次提交的订单含有增值税专用发票和增值税普通发票，需前往多门店订单列表分开支付！',
                    messageAlign: 'left'
                }).then(() => {
                    localStorage.setItem("gobackMergOrder", 'true')
                    this.$router.push('/personal/orderlist')
                });
            }
        },
        // 选择优惠券后替换本地数据并刷新页面
        changeCoupon() {
            Toast.loading({
                message: '加载中...',
                forbidClick: true,
                duration: 0,
                mask: true
            })
            this.showCoupon = false;
            const selectedCouponObj = this.couponsList.filter(v => v.id === this.selectedCoupon)[0];
            Api.couponsChoose({
                calcToken: this.orderInfo.calcToken,
                userSid: this.itemObj.userSid,
                couponsList: [{ id: this.selectedCoupon }]
            }).then(re => {
                if (re.data.code === 0) {
                    const cartInfo = JSON.parse(localStorage.getItem('cartInfo'))
                    const data = re.data.data;
                    this.orderInfo.calcToken = data.calcToken;
                    cartInfo.calcToken = data.calcToken;
                    data.userSettlement.settlementInfo.discountInfo.couponsModel.couponsList = this.couponsList;
                    cartInfo.userOrderCofirmList.forEach(user => {
                        if (user.userSid === data.userSettlement.userSid) {
                            user.settlementInfo = data.userSettlement.settlementInfo;
                            user.selectedCoupon = this.selectedCoupon;
                            user.selectedCouponObj = selectedCouponObj || { id: '', name: '不使用优惠券' };
                        }
                        this.userOrderCofirmList.forEach(v => {// 设置选中的数据
                            if (user.userSid === v.userSid) {
                                user.isRebate = v.isRebate;
                                user.shippingSid = v.shippingSid;
                                user.logistics = v.logistics;
                                user.invoiceType = v.invoiceType;
                                user.userMessage = v.userMessage;
                                user.invoiceInfo.syncEmail = v.invoiceInfo.syncEmail;
                                user.invoiceInfo.emailVal = v.invoiceInfo.emailVal;
                            }
                        })
                    })
                    localStorage.setItem('cartInfo', JSON.stringify(cartInfo));
                    this.initData();
                    Toast.clear();
                }
            }).catch(() => {
                Toast.clear();
            })
        },
        // 定位
        gotoTop(i) {
            const doms = document.querySelectorAll('.order-list-box');
            const h = doms[i].offsetTop - 63
            window.scrollTo(0, h)
        }
    }
}
</script>

<style lang="scss">
%textOver {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.van-dialog.rebateTips{
    .van-dialog__header{
        color: #333333;
        font-weight: 700;
    }
    .van-dialog__content{
        .van-dialog__message {
            font-size: 0.28rem;
            color: #333333;
        }
    }
    .van-button__text{
        color: #ed3129;
    }
}
.app-wrapper [class*="van-hairline"]::after {
    border: none!important;
}
.order-box-submit {
    background: #F1F1F1;
    word-break: break-all;
    input::-webkit-input-placeholder { 
        color: #BBBBBB!important; 
    }
    .shop-name{
        display: flex;
        padding: .24rem 0 .24rem .24rem;
        background:#F4F4F4;
        font-size: .32rem;
        line-height: .4rem;
        align-items: center;
        span{
            flex: 1;
            @extend %textOver;
            color: #666666;
            font-weight: bold;
        }
        .store-icon {
            width: .32rem;
            height: .32rem;
            margin-right: .12rem;
        }
    }
    .detail-coupon-sheet{
        background: rgba(255, 255, 255, 0.95);
        .van-action-sheet__header{
            padding: .4rem .28rem .3rem .28rem;
            line-height: .5rem;
            text-align: left;
            font-size: .36rem;
            font-weight: 600;
            color: #666666;
        }
        .van-action-sheet__content{
            margin: 0 .2rem;
            height: 5.88rem;
            overflow: auto;
            .van-radio{
                display: flex;
            }
            .van-radio__label{
                margin-left: 0;
                flex: 1;
            }
        }
        .couponDetail-box{
            margin: 0;
        }
        .van-action-sheet__close{
            top: .4rem;
        }
        .not-use-coupon{
            width: .56rem;
            margin-left: .16rem;
            margin-right: .08rem;
            position: relative;
            top: .04rem;
        }
        .dv{
            position: relative;
            margin-bottom: .24rem;
            .van-radio{
                position: absolute;
                right: .28rem;
                top: 50%;
                margin-top: -10px;
            }
        }
        .no-dv{
            margin-left: .08rem;
            .van-radio__label{
                margin-left: .16rem;
                color: #666666;
            }
        }
    }
    .van-cell {
        // padding: 0 .2rem;
        font-size: 0.28rem;
        align-items: center;
        background: transparent!important;
        ::after{
            border: none!important;
        }
    }
    // .van-cell-group{
    //     background: transparent!important;
    // }

    .van-placeholder {
        color: #bcbcbc;
        font-size: 0.24rem;
    }

    .money {
        font-size: 0.24rem;
        color: #ed3129;
        position: absolute;
        top: 0.2rem;
        left: 2.78rem;
    }

    &.order-box-submit {
        font-size: 0.28rem;

        .icon-1 {
            margin-right: 0.2rem;
            width: 0.06rem;
            height: 0.32rem;
            background: #ed3129;
        }
        // .van-checkbox__icon-wrap,
        // .van-checkbox__icon {
        //     width: 0.32rem;
        //     height: 0.32rem;
        //     float: right;
        //     font-size: 0.32rem;
        // }
        // .van-cell-group{
        //     width: 100%;
        //     img {
        //         margin-right: .2rem;
        //     }
        //     .van-radio{
        //         .van-radio__icon {
        //             width: 0.32rem;
        //             height: 0.32rem;
        //             line-height: .32rem;
        //         }
        //     }
        // }

        .van-cell:not(:last-child)::after{
            border: none;
        }

        .van-radio {
            align-items: center;

            .van-radio__input {
                .van-radio__icon {
                    width: 0.36rem;
                    height: 0.36rem;
                }
            }
        }

        .pay-kind {
            padding: .4rem .28rem 0 .28rem;
            border-bottom: .02rem solid #F4F4F4;
            overflow: hidden;
        }
        .special-box{
            width: 4.2rem;
            margin-top: -.2rem;
            margin-bottom: .28rem;
            line-height: .4rem;
            background: #FFEDED;
            color: #FF4646;
            padding: 0 .1rem;
            font-size: .24rem;
            border-radius: .08rem;
        }
        .special-disabled-box{
            width: 5.2rem;
            margin-top: -.2rem;
            margin-bottom: .28rem;
            line-height: .4rem;
            background: #F4F4F4;
            color: #BBBBBB;
            padding: 0 .1rem;
            font-size: .24rem;
            border-radius: .08rem;
        }
        .pay-kind-bottom{
            display: flex;
            padding: 0 .28rem;
            height: .8rem;
            line-height: .8rem;
            justify-content: flex-end;
            font-weight: 600;
            :nth-child(1){
                color: #666666;
            }
            :nth-child(2){
                color: #ED3129;
            }
        }

        .bottom{
            height: 1.14rem;
        }
        .couponList{
            .van-cell__value{
                text-overflow: ellipsis;
                width: 4rem;
                white-space: nowrap;
                color: #ED3129;
            }
        }

        .balance-box {
            margin-top: 0.1rem;
            background: #ffffff;

            .balance-kind-box {
                display: flex;
                align-items: center;
                justify-content: space-between;
                border-bottom: 0.01rem solid #f4f4f4;
                position: relative;
            }

            img {
                width: 0.39rem;
                height: 0.36rem;
                padding-right: 0.2rem;
                padding-top: 0.06rem;
            }
        }

        .order-list-box {
            border-radius: .16rem;
            background: #ffffff;
            margin: 0 .16rem .28rem .16rem;
            .order-list{
                .van-cell{
                    span{
                        text-overflow: -o-ellipsis-lastline;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        line-clamp: 2;
                        -webkit-box-orient: vertical;
                        color: #666666;
                    }
                }
            }

            .info {
                display: flex;
                align-items: center;
                padding: .28rem .28rem .36rem .16rem;
                font-size: 0.28rem;
                color: #303030;
                img {
                    width: .48rem;
                    height: .56rem;
                    margin-right: .16rem;
                }
                .username {
                    font-size: .32rem;
                    font-weight: 600;
                    margin-bottom: .24rem;
                    font{
                        color: #999999;
                        margin-left: .16rem;
                    }
                }
                :nth-child(2){
                    line-height: .4rem;
                    font-size: .28rem;
                    color: #666666;
                }
            }
            .order-line{
                display: block;
                width: 100%;
                height: .04rem;
            }

            .item-list {
                overflow: hidden;
                display: flex;
                justify-content: space-between;
                margin: .4rem .28rem;
                .item-li-box {
                    display: flex;

                    .item-li {
                        margin-right: .2rem;
                        position: relative;
                        .preSaleImg{
                            position: absolute;
                            width: .76rem;
                            height: .44rem;
                            top: 0;
                            left: 0;
                            border-radius: 0;
                            z-index: 999;
                        }
                    }
                }

                .item-li {
                    overflow: hidden;
                    text-align: center;

                    img {
                        width: 1rem;
                        height: 1rem;
                        margin: 0 auto;
                        border-radius: 5px;
                    }

                    &.btn-all {
                        display: flex;
                        align-items: center;
                        .goto-list{
                            margin-right: -.08rem;
                            color: #999999;
                        }
                        p{
                            flex: 1;
                            &:first-child {
                                color: #666666;
                                font-size: .28rem;
                                line-height: .36rem;
                                letter-spacing: .02rem;
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
            }

            .preSaleTime{
                display: flex;
                height: .56rem;
                line-height: .56rem;
                margin: -.16rem .24rem .24rem .24rem;
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

            .store-amount-box{
                padding: 0.2rem .66rem .2rem 1.46rem;
                font-size: .24rem;
                &.other-amount {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    color: #333333;
                    .huddle,
                    .herb {
                        display: flex;
                        align-items: center;

                        text:nth-child(1) {
                            margin-right: 0.2rem;
                        }
                    }
                }
                &.store-promotion, &.store-total{
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    color: #999999;
                    padding-top: 0;
                }
                &.store-payment{
                    display: flex;
                    justify-content: flex-end;
                    align-items: baseline;
                    font-weight: 600;
                    padding-top: 0;
                    span:nth-child(1){
                        color: #666;
                        font-size: .24rem;
                    }
                    span:nth-child(2){
                        color: #ED3129;
                        font-size: .26rem;
                    }
                }
                &.store-preferentialAmount{
                    display: flex;
                    justify-content: flex-end;
                    align-items: baseline;
                    font-weight: 500;
                    padding-top: 0;
                    font-size: .24rem;
                    color: #333333;
                }
            }
        }

        .note-box {
            display: flex;
            font-size: 0.28rem;
            span{
                flex: 1;
                color: #666666;
                line-height: .64rem;
            }
            input{
                width: 3.84rem;
                height: .64rem;
                line-height: .64rem;
                border-radius: .08rem;
                border: none;
                outline: none;
                background: #F6F6F6;
                padding-left: .24rem;
            }
        }

        .invoice-box {
            overflow: hidden;
            padding: 0 .28rem;
            font-size: 0.3rem;
            color: #333333;
            >div{
                margin-bottom: .4rem;
            }
            .van-radio,.van-radio__icon,.van-icon {
                width: .36rem;
                height: .36rem;
                font-size: .28rem;
                line-height: .36rem;
            }
            .invoice-list{
                display: flex;
                >span{
                    width: 1.38rem;
                    color: #666666;
                    font-size: .28rem;
                }
                >div{
                    flex: 1;
                }
                .invoice{
                    display: flex;
                    justify-content: flex-end;
                    color: #999999;
                    .van-radio{
                        margin-left: .2rem;
                    }
                }
            }
            .logistics-box {
                margin-bottom: .28rem;
                .van-cell__value,
                .van-cell__right-icon-wrap {
                    color: #333333;
                    font-size: 0.28rem;
                }
                .van-cell__title span{
                    color: #666666;
                    font-size: 0.28rem;
                    font-weight: normal!important;
                }
                .logistics-red .van-cell__value span{
                    color: #ED3129;
                }
            }
            // .van-radio-group {
            //     display: flex;
            //     color: #333333;
            //     font-size: 0.28rem;
            //     .van-radio__icon{
            //         font-size: .28rem;
            //         span {
            //             width: 1.9rem;
            //         }
            //     }

            //     .van-radio {
            //         &.firstRadio{
            //             margin-left: 1.4rem;
            //             margin-right: .4rem;
            //         }
            //         .van-radio__label {
            //             font-weight: 500;
            //             font-size: 0.24rem;
            //         }
            //     }
            // }

            // .van-cell-group {
            //     color: #333333;
            //     font-size: 0.28rem;
            // }
            .email-box{
                display: flex;
                .van-field{
                    flex: 1;
                    .van-field__control{
                        color: #666666;
                    }
                }
                .van-checkbox{
                    margin-left: .22rem;
                    // padding: .2rem 0;
                    font-size: .24rem;
                    background: #fff;
                    .van-checkbox__label{
                        margin-left: .08rem;
                        font-size: .28rem;
                        color: #666666;
                    }
                    .van-checkbox__icon{
                        width: .36rem;
                        height: .36rem;
                        line-height: .36rem;
                        .van-icon{
                            width: 100%;
                            height: 100%;
                            font-size: .28rem;
                        }
                    }
                }
            }
        }
        .van-cell{
            padding: 0;
            .van-cell__right-icon{
                margin-right: -.08rem;
            }
        }
        
        .pay-info-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            line-height: .4rem;
            margin-bottom: .28rem;
            color: #666666;
            .rebate-tips {
                width: .32rem;
                height: .32rem;
                margin-left: .16rem;
                position: relative;
                top: .06rem;
            }
            .balance-pay{
                margin-left: .16rem;
            }
            text:nth-child(2) {
                color: #ed3129;
            }
            .coupon-info{
                color: #ED3129;
                font-style: normal;
                margin-left: .2rem;
            }
        }
        .pay-info, .order-total-info{
            padding: .4rem .28rem .12rem .28rem;
            border-bottom: .02rem solid #F4F4F4;
        }
        .order-sub-title{
            margin: .4rem .4rem .2rem;
            font-size: .32rem;
            color: #666666;
        }
        .order-total-info{
            background: #ffffff;
            border-radius: .08rem;
            margin: .2rem;
        }

        .submit-order {
            box-sizing: border-box;
            position: fixed;
            bottom: 0;
            z-index: 9;
            display: flex;
            justify-content: space-between;
            width: 100%;
            background: #ffffff;
            box-shadow: 0 0 0.02rem 0.02rem #eaeaea;
            transform: translateZ(0);
            padding: .2rem .28rem;

            div:not(.van-loading) {
                line-height: 1;
                font-size: .28rem;

                &.subtotal {
                    display: flex;
                    align-items: center;
                    span:nth-child(2) {
                        color: #ed3129;
                        font-size: 0.32rem;
                    }

                    span:nth-child(3) {
                        color: #ed3129;
                    }
                }
            }
            .multi-subtotal{
                p{
                    line-height: .34rem;
                    font-size: .24rem;
                    color: #999999;
                }
                .subtotal{
                    line-height: .4rem;
                }
            }

            .van-button__loading-text,
            .van-loading__spinner {
                padding: 0;
            }

            .submit-btn{
                border: 0;
                height: .72rem;
                color: #FFF;
                font-size: .36rem;
                background: #FF4646;
                overflow: hidden;
                display: flex;
                align-items: center;
                padding: 0 .26rem;
                box-shadow: 0px 0px 12px 0px rgba(255,70,70,0.25);
                .van-loading{
                    width: auto;
                }
            }
        }

        .van-radio {
            .van-radio__icon-wrap {
                .van-radio__icon {
                    width: 0.36rem;
                    height: 0.36rem;
                }
            }
        }
    }
}
.confirm-address-sheet{
    .confirm-tips{
        background: #FFF5E4;
        padding: .12rem .28rem;
        font-weight: 600;
        font-size: .24rem;
        line-height: .34rem;
        color: #FF6E00;
    }
    .van-action-sheet__header{
        text-align: left;
        padding: 0 .28rem;
        line-height: 1.16rem;
    }
    .confirm-address-stores{
        max-height: 292px;
        overflow-y: auto;
        .store-default-address{
            margin: 0 .2rem;
            border-radius: .12rem .12rem 0px 0px;
            .shop-name{
                background: #fff;
                padding: .4rem 0 .28rem 0;
            }
            .info {
                display: flex;
                align-items: center;
                padding: .28rem .22rem .28rem .28rem;
                font-size: 0.28rem;
                color: #303030;
                background: #F4F4F4;
                border-radius: .12rem .12rem 0px 0px;
                img {
                    width: .48rem;
                    height: .56rem;
                    margin-right: .16rem;
                }
                .username {
                    font-size: .32rem;
                    font-weight: 600;
                    margin-bottom: .24rem;
                    font{
                        color: #999999;
                        margin-left: .16rem;
                    }
                }
                :nth-child(2){
                    line-height: .4rem;
                    font-size: .28rem;
                    color: #666666;
                }
            }
            .order-line{
                display: block;
                width: 100%;
                height: .04rem;
            }
        }
    }
    .confirm-address-btn{
        width: 6.94rem;
        height: .8rem;
        text-align: center;
        line-height: .8rem;
        background: #FF4646;
        border-radius: .4rem;
        color: #fff;
        margin: .28rem;
    }
}
</style>
