<template>
    <div class="controller">
        <div class="add-to-cart-content">
            <!-- <van-stepper
                :value="item.quantity || item.packageQuantity"
                :min="item.stock > item.minNum ? item.minNum : 1"
                :max="item.stock > item.maxNum ? item.maxNum : item.stock"
                :step="item.step"
                @minus="minusNum(item, activityType, isCart, index, group)"
                @blur="blurChange($event,item, isCart, index, activityType, group)"
                @plus="plusNum(item, activityType, isCart, index, group)"
                @overlimit="overlimitFn(item)"
            /> -->
            <template v-if="theme==='productDetail'">
                <template v-if="getCartAddedNum(item) > 0">
                    <div
                        v-if="item.preSale"
                        class="add-cart"
                        style="padding:0;justify-content:center"
                        @click="presale(item)"
                    >
                        {{ isUnScope() ? '无经营范围' : '加入购物车' }}({{ getCartAddedNum(item) }})
                    </div>
                    <div
                        v-else
                        class="add-cart"
                        style="padding:0;justify-content:center"
                        @click="openSpecDialog"
                    >
                        {{ isUnScope() ? '无经营范围' : '加入购物车' }}({{ getCartAddedNum(item) }})
                    </div>
                </template>
                <template v-else>
                    <template v-if="item.preSale">
                        <div class="add-cart" @click="presale(item)">
                            <img src="@/assets/images/add_cart_btn.png" style="width:0.48rem;">
                            <span>{{ isUnScope() ? '无经营范围' : '加入购物车' }}</span>
                        </div>
                    </template>
                    <template v-else>
                        <div class="add-cart" @click="openSpecDialog">
                            <img src="@/assets/images/add_cart_btn.png" style="width:0.48rem;">
                            <span>{{ isUnScope() ? '无经营范围' : '加入购物车' }}</span>
                        </div>
                    </template> 
                </template>
            </template>
            <template v-else>
                <img
                    v-if="item.preSale"
                    class="add-to-cart-icon"
                    :src="isUnScope() ? 'https://imga.hnhcyy.com/fed/b2b-wechat/un_scope.png?v=3':`https://imga.hnhcyy.com/fed/b2b-wechat/gouwuche${currentType > 1 ? currentType: ''}.png`"
                    @click="presale(item)"
                >
                <img
                    v-else
                    class="add-to-cart-icon"
                    :src="isUnScope() ? 'https://imga.hnhcyy.com/fed/b2b-wechat/un_scope.png?v=3':`https://imga.hnhcyy.com/fed/b2b-wechat/gouwuche${currentType > 1 ? currentType: ''}.png`"
                    @click="openSpecDialog"
                >
                <!-- 已加购数量展示 -->
                <div
                    v-if="getCartAddedNum(item)>0"
                    class="added-tips"
                >
                    <span><van-icon name="cross" size=".24rem" color="#9F5C1D" />{{ getCartAddedNum(item) }}</span>
                </div>
            </template>
        </div>
        <!-- 预售提示框 -->
        <van-dialog
            id="preSaleTips"
            v-model="show"
            get-container="body"
            title="温馨提示"
            show-cancel-button
            cancel-button-text="我再想想"
            confirm-button-text="继续购买"
            @confirm="openSpecDialog"
        >
            <div>预售商品不支持立即发货，以实际发货时间为准！</div>
            <div>
                <span>点击继续购买代表已阅读并同意</span>
                <span class="needToKnow" @click="goNeedToKnow">《购买需知》</span>
                <span>内容</span>
            </div>
        </van-dialog>
        <!-- 商品信息和加减商品数量卡片 -->
        <win-show-spec
            ref="refShowSpec"
            :item="item"
            :activity-type="activityType"
            :source="source"
        />
    </div>
</template>

<script>
// import Api from '@/api/product/cart'
import { Dialog } from 'vant'
import VMnative from '@/utils/VMnative'
import winShowSpec from './showSpec';

var _czc = _czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'AddToCart',
    components: {
        winShowSpec
    },
    props: {
        source: {
            type: String,
            default: 'h5'
        },
        item: {
            type: Object,
            default: () => {
                return {

                }
            }
        },
        showIcon: {
            type: Boolean,
            default: true
        },
        activityType: {
            type: Number,
            default: null
        },
        isCart: {
            type: Boolean,
            default: false
        },
        index: {
            type: Number,
            default: 0
        },
        group: {
            type: Object,
            default: () => {
                return {

                }
            }
        },
        theme: {
            type: String,
            default: ''
        }
    },
    data() {
        return {
            show: false
            // packageNumFlag: false,
            // subPackNum: 0,
            // missMum: 0,
            // showPackageNumFlag: false,
            // params: {}
        }
    },
    computed: {
        cartAdded() {
            return this.$store.state.cartAdded || {};
        },
        userInfoScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.userInfoScope : [];
        },
        allScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.allScope : [];
        },
        currentType: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : ''
        }
    },
    created() {
        VMnative.registerHandler('refreshAdded', (data, responseCallback) => {
            data = data ? JSON.parse(data) : {};
            this.refreshAdded(data);
        });
    },
    mounted() {
        this.$set(this.item, 'quantity', this.item.packageQuantity || this.item.quantity || this.item.minNum || 1)
        this.$set(this.item, 'price', this.item.discountPrice || this.item.price)
    },
    methods: {
        // 弹出商品信息和计步器
        openSpecDialog() {
            if (this.source === 'h5') {
                const stores = this.$store.getters.userInfo.stores;
                if (stores && stores.length > 1 || [2, 4].indexOf(this.activityType - 0) > -1){
                // 多门店和套餐加入购物车不展示商品信息卡片
                    this.$refs.refShowSpec.addToCart(1);
                } else {
                    const preTime = (new Date(this.item.preSaleDeliveryTimeStr)).getTime();
                    if (this.isPreSaleTime(stores, preTime)){
                    // 单门店预售商品，预售发货时间大于资质过期时间提示
                        Dialog.confirm({
                            title: '温馨提示',
                            message: '预计发货时间可能存在资质过期情况，请核实后下单。',
                            cancelButtonColor: '#999999',
                            confirmButtonText: '继续购买',
                            confirmButtonColor: '#ffffff',
                            className: 'jxq preSalejxq'
                        }).then(() => {
                            this.$refs.refShowSpec.open(this.item);
                        }).catch(() => {

                        })
                    } else if (this.item.expireStatus === 1) {
                        Dialog.confirm({
                            message: '<div style="color: #666666">该商品有效期至：<span style="color: #ED3129">' + this.item.expireDateStr + '</span>\n确定加入购物车吗？</div>',
                            cancelButtonText: '不要了',
                            cancelButtonColor: '#999999',
                            confirmButtonText: '继续加入',
                            confirmButtonColor: '#fff',
                            className: 'jxq'
                        }).then(() => {
                            this.$refs.refShowSpec.open(this.item);
                        }).catch(() => {

                        })
                    } else {
                        this.$refs.refShowSpec.open(this.item);
                    }
                }
            } else {
                // APP加入购物车
                this.appAddToCart(this.item, this.activityType);
            }
        },
        // 更新已加购数量
        refreshAdded(params) {
            const cartAdded = this.$store.state.cartAdded || {};
            const obj = Object.assign({}, params);
            obj.quantity = 0;
            obj.userQuantityList.forEach(v => {
                obj.quantity += Number(v.quantity);
            })
            if (obj.packageId && obj.packageId !== '0') {
                let count = Number(cartAdded.pkgQtyMap[obj.packageId]) || 0;
                count += Number(obj.quantity);
                cartAdded.pkgQtyMap[obj.packageId] = count;
            } else {
                let count = Number(cartAdded.prodQtyMap[obj.productSid]) || 0;
                count += Number(obj.quantity);
                cartAdded.prodQtyMap[obj.productSid] = count;
            }
            this.$store.commit("setCartAdded", cartAdded);
        },
        /**
         * 预售抢购
         */
        presale(item){
            if (this.source === 'h5'){
                if (this.$store.getters.userInfo && this.$store.getters.userInfo.stores.length === 1) {
                    const flag = this.isUnScope();
                    if (flag) {
                        Dialog.confirm({
                            title: '温馨提示',
                            message: `该商品属于${this.getBusinessName()}，暂未登记此经营范围`,
                            cancelButtonColor: '#999999',
                            confirmButtonText: '确定',
                            confirmButtonColor: '#ffffff',
                            className: 'jxq preSalejxq'
                        }).then(() => {

                        }).catch(() => {

                        })
                        return;
                    }
                }
                // if (this.$store.getters.userInfo.isFree === 2 && this.$store.getters.userInfo.stores.length === 1){
                //     Toast("当前门店有资质已过期，暂无法操作!")
                // } else {
                // 打开预售确认框,调用继续购买函数，或取消
                this.show = true
                // }
            } else {
                const obj = {
                    productId: item.proSid || item.sid,
                    quantity: item.quantity,
                    productModel: item
                }
                VMnative.callHandler("presellAction", JSON.stringify(obj), (params) => {
                    params = params ? JSON.parse(params) : {};
                    this.refreshAdded(params);
                })
            }
        },
        /**
         * 跳转购买需知
         */
        goNeedToKnow(){
            this.$router.push("/product/needToKnow?source=h5&type=cart")
        },
        // 获取已加购的数量
        getCartAddedNum(item) {
            let count = 0;
            if (this.cartAdded.prodQtyMap && this.cartAdded.prodQtyMap[item.sid]) {
                count = this.cartAdded.prodQtyMap[item.sid];
            } else if (this.cartAdded.pkgQtyMap && this.cartAdded.pkgQtyMap[item.sid]) {
                count = this.cartAdded.pkgQtyMap[item.sid];
            }
            if (count > item.stock) count = item.stock;
            return count;
        },
        /**
         * 判断是主店否有经营范围
         */
        isUnScope() {
            if (this.item.businessScope || this.item.businessScope === 0) {
                const data = this.userInfoScope.filter(v => v.isMain === 1)[0];
                return (data.scopeSidSet || []).indexOf(this.item.businessScope) === -1;
            } else {
                return false;
            }
        },
        /**
         * 获取经营范围名称
         */
        getBusinessName() {
            const data = this.allScope.filter(v => v.sid === this.item.businessScope)[0] || {};
            return data.name;
        },
        // overlimitFn(item) {
        //     if (item.quantity >= item.stock || item.quantity >= item.maxNum) {
        //         Toast.clear();
        //         Toast("已达最大订购数量");
        //     }
        //     if (item.stock > item.minNum && item.quantity <= item.minNum) {
        //         Toast.clear();
        //         Toast('不可小于最小起订量：' + item.minNum)
        //     } else if (item.stock < item.minNum && item.quantity <= 1) {
        //         Toast.clear();
        //         Toast('不可小于最小起订量：1')
        //     }
        // },
        // /**
        //  * 商品数量加
        // */
        // plusNum(item, activityType, isCart, index, group) {
        //     let num
        //     if (activityType === null) {
        //         num = item.quantity ? item.quantity : item.minNum < item.stock ? item.minNum : item.stock
        //         item.quantity = num + item.step
        //     } else {
        //         num = item.quantity
        //         if (item.step) {
        //             item.quantity = num + item.step
        //         } else {
        //             num++
        //             item.quantity = num
        //         }
        //     }
        //     if (item.quantity > item.maxNum) {
        //         item.quantity = item.maxNum
        //     }
        //     if (item.quantity >= item.stock || item.quantity >= item.maxNum) {
        //         Toast.clear();
        //         Toast("已达最大订购数量");
        //     }
        //     if (isCart) {
        //         if (activityType === 9) {
        //             const groupProductList = JSON.parse(localStorage.getItem("groupList")) || []
        //             groupProductList.forEach(e => {
        //                 if (item.productSid === e.productSid){
        //                     e.quantity = item.quantity
        //                 }
        //             })
        //             localStorage.setItem("groupList", JSON.stringify(groupProductList))
        //             const cartItem = {
        //                 userSid: this.$store.getters.userInfo.stores[index].sid,
        //                 club: this.$store.getters.userInfo.currentType,
        //                 cart: {
        //                     productSid: item.productSid,
        //                     quantity: item.quantity
        //                 },
        //                 groupProductList: groupProductList
        //             }
        //             this.$parent.updateGroupNum(cartItem, group)
        //         } else {
        //             this.$parent.updateNum(item, index)
        //         }
        //     }
        //     _czc.push(["_trackEvent", "点击步进器", "InputNumber_button_click", 'goodsName:' + item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType])
        // },
        // /**
        //  * 商品数量减
        //  */
        // minusNum(item, activityType, isCart, index, group) {
        //     let num
        //     if (activityType === null) {
        //         num = item.quantity ? item.quantity : item.minNum < item.stock ? item.minNum : item.stock
        //         item.quantity = num - item.step
        //     } else {
        //         num = item.quantity
        //         if (item.step) {
        //             item.quantity = num - item.step
        //         } else {
        //             num--
        //             item.quantity = num
        //         }
        //     }
        //     if (isCart) {
        //         if (activityType === 9) {
        //             const groupProductList = JSON.parse(localStorage.getItem("groupList")) || []
        //             groupProductList.forEach(e => {
        //                 if (item.productSid === e.productSid){
        //                     e.quantity = item.quantity
        //                 }
        //             })
        //             localStorage.setItem("groupList", JSON.stringify(groupProductList))
        //             const cartItem = {
        //                 userSid: this.$store.getters.userInfo.stores[index].sid,
        //                 club: this.$store.getters.userInfo.currentType,
        //                 cart: {
        //                     productSid: item.productSid,
        //                     quantity: item.quantity
        //                 },
        //                 groupProductList: groupProductList
        //             }
        //             this.$parent.updateGroupNum(cartItem, group)
        //         } else {
        //             this.$parent.updateNum(item, index)
        //         }
        //     }
        //     _czc.push(["_trackEvent", "点击步进器", "InputNumber_button_click", 'goodsName:' + item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType])
        // },
        // /**
        //  * 失去焦点（加减数量）
        //  */
        // blurChange(e, item, isCart, index, activityType, group) {
        //     const num = e.target.value
        //     const step = item.step ? item.step : 1
        //     const minNum = item.minNum ? item.minNum < item.stock ? item.minNum : item.stock : 1
        //     item.quantity = Math.ceil(num / step) * step
        //     if (item.quantity < minNum) {
        //         item.quantity = minNum
        //     }
        //     if (item.quantity >= item.stock || item.quantity >= item.maxNum) {
        //         Toast.clear();
        //         Toast("已达最大订购数量");
        //     }
        //     if (item.stock > item.minNum && item.quantity <= item.minNum) {
        //         Toast.clear();
        //         Toast('不可小于最小起订量：' + item.minNum)
        //     } else if (item.stock < item.minNum && item.quantity <= 1) {
        //         Toast.clear();
        //         Toast('不可小于最小起订量：1')
        //     }
        //     if (isCart) {
        //         if (activityType === 9) {
        //             const groupProductList = JSON.parse(localStorage.getItem("groupList")) || []
        //             groupProductList.forEach(e => {
        //                 if (item.productSid === e.productSid){
        //                     e.quantity = item.quantity
        //                 }
        //             })
        //             localStorage.setItem("groupList", JSON.stringify(groupProductList))
        //             const cartItem = {
        //                 userSid: this.$store.getters.userInfo.stores[index].sid,
        //                 club: this.$store.getters.userInfo.currentType,
        //                 cart: {
        //                     productSid: item.productSid,
        //                     quantity: item.quantity
        //                 },
        //                 groupProductList: groupProductList
        //             }
        //             this.$parent.updateGroupNum(cartItem, group)
        //         } else {
        //             this.$parent.updateNum(item, index)
        //         }
        //     }
        // },
        // /**
        //  * 商品加入购物车
        //  */
        // addToCart(item, theSecond, activityType) {
        //     if (this.source === 'h5'){
        //         const addedNum = this.getCartAddedNum(item);
        //         this.subPackNum = (item.quantity + addedNum) % item.packageNum; // 已加购+当前加购数量，除整件(含多件)外单个发货剩余的数量
        //         this.missMum = item.packageNum - this.subPackNum; // 满足整件还要加多少数量
        //         // 当前数量是否大于等于整件的95% && 库存是否大于整件购买后的数量
        //         this.packageNumFlag = (this.subPackNum / item.packageNum) >= 0.95 && item.stock >= item.quantity + addedNum + this.missMum;
                
        //         // 单店无经营范围提示
        //         if (this.$store.getters.userInfo && this.$store.getters.userInfo.stores.length === 1) {
        //             const flag = this.isUnScope();
        //             if (flag) {
        //                 Dialog.confirm({
        //                     title: '温馨提示',
        //                     message: `该商品属于${this.getBusinessName()}，暂未登记此经营范围`,
        //                     cancelButtonColor: '#999999',
        //                     confirmButtonText: '确定',
        //                     confirmButtonColor: '#ffffff',
        //                     className: 'jxq preSalejxq'
        //                 }).then(() => {

        //                 }).catch(() => {

        //                 })
        //                 return;
        //             }
        //         }
        //         // if (item.stock <= 0) return
        //         let params = {}
        //         if (activityType === null) {
        //             params = {
        //                 productSid: item.sid,
        //                 userQuantityList: [{ quantity: item.quantity }]
        //             }
        //         } else if (activityType === 1) {
        //             params = {
        //                 productSid: item.proSid,
        //                 userQuantityList: [{ quantity: item.promotionProduct ? item.quantity * item.promotionProduct[0].proReachNum : item.quantity }]
        //             }
        //         } else if (activityType === 2 || activityType === 4) {
        //             params = {
        //                 packageId: item.sid,
        //                 userQuantityList: [{ quantity: item.quantity }]
        //             }
        //         } else if (activityType === 3 || activityType === 5) {
        //             params = {
        //                 productSid: item.targetProductSid,
        //                 userQuantityList: [{ quantity: item.quantity }]
        //             }
        //         }
        //         if (item.userQuantityList) {
        //             params.userQuantityList = item.userQuantityList
        //         }
        //         if (theSecond === 2 && item.userQuantityList.length === 0){
        //             Toast.clear()
        //             Toast("您没有选择店铺")
        //             return
        //         }
        //         if (item.expireStatus === 1 && theSecond === 1) {
        //             Dialog.confirm({
        //                 message: '<div style="color: #666666">该商品有效期至：<span style="color: #ED3129">' + item.expireDateStr + '</span>\n确定加入购物车吗？</div>',
        //                 cancelButtonText: '不要了',
        //                 cancelButtonColor: '#999999',
        //                 confirmButtonText: '继续加入',
        //                 confirmButtonColor: '#fff',
        //                 className: 'jxq'
        //             }).then(() => {
        //                 this.addCartAct(params)
        //             }).catch(() => {

        //             })
        //         } else {
        //             this.addCartAct(params)
        //         }
        //         _czc.push(["_trackEvent", "点击加入购物车", "shoppingcart_button_click", 'goodsName:' + item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType])
        //     } else {
        //         // APP加入购物车
        //         this.appAddToCart(item, activityType)
        //     }
        // },
        // // 加入购物车接口
        // cartApiFn(params) {
        //     Api.addTocart(params).then(({ data }) => {
        //         if (data.code === 101005) {
        //             const userInfo = this.$store.getters.userInfo
        //             userInfo.stores = data.data
        //             const currentType = userInfo.currentType
        //             const supplySid = userInfo.supplySid
        //             userInfo.stores.forEach(store => {
        //                 store.clubList = store.clubList || []
        //                 store.quantity = params.userQuantityList[0].quantity
        //                 if (store.clubList.indexOf(currentType) === -1){
        //                     store.disabled = true
        //                     if (currentType === 1){
        //                         store.storeName = '无乐赛仙俱乐部'
        //                     } else if (currentType === 2){
        //                         store.storeName = '无佐安堂俱乐部'
        //                     } else if (currentType === 3){
        //                         store.storeName = '无初心俱乐部'
        //                     } else if (currentType === 4){
        //                         store.storeName = '无六谷俱乐部'
        //                     } else if (currentType === 5){
        //                         store.storeName = '无国通俱乐部'
        //                     }
        //                 }
        //                 if (store.supplySid !== supplySid){
        //                     store.disabled = true
        //                     if (supplySid === 2){
        //                         store.supply = '长沙'
        //                     } else if (supplySid === 1){
        //                         store.supply = '天津'
        //                     }
        //                 }
        //             })
        //             this.$store.commit("setUserInfo", userInfo)
        //             this.$store.commit("setSelectStore", {
        //                 isPackage: false,
        //                 show: true,
        //                 product: this.item,
        //                 callback: (userQuantityList) => {
        //                     this.addToCart(Object.assign({}, this.item, { userQuantityList: userQuantityList }), 2, this.activityType)
        //                 }
        //             })
        //         } else if (data.code === 0) {
        //             this.refreshAdded(params);
        //             Toast.success({
        //                 message: "加入成功",
        //                 duration: 1000
        //             })
        //             this.$store.commit('setCartNum')
        //             this.$store.commit('setSelectStore', { show: false })
        //         }
        //     })
        // },
        // /**
        //  * 商品加入购物车(动作)
        //  */
        // addCartAct(params) {
        //     if (this.$store.getters.userInfo.stores && this.$store.getters.userInfo.stores.length === 1 && this.packageNumFlag) {
        //         this.showPackageNumFlag = true;
        //         this.params = params;
        //     } else {
        //         this.cartApiFn(params);
        //     }
        // },
        // // 整件添加
        // packageAdd(type) {
        //     if (type === 1) {
        //         this.params.userQuantityList[0].quantity += this.missMum;
        //         this.cartApiFn(this.params);
        //     } else {
        //         this.cartApiFn(this.params);
        //     }
        // },
        /**
         * 加入购物车(app)
         */
        appAddToCart(item, activityType){
            const data = {
                quantity: item.quantity,
                expiredStatus: item.expireStatus,
                expiredDate: item.expireDate,
                productModel: item
            }
            if (activityType === null) {
                data.productId = item.sid
            } else if (activityType === 1) {
                data.productId = item.proSid
            } else if (activityType === 2 || activityType === 4) {
                data.packageId = item.sid
            } else if (activityType === 3 || activityType === 5) {
                data.productId = item.targetProductSid
            }
            VMnative.callHandler("addToCart", data, (params) => {
                params = params ? JSON.parse(params) : {};
                this.refreshAdded(params);
            })
        },
        // /**
        //  * 继续购买
        //  */
        // confirmPreSale(item){
        //     const storeList = this.$store.getters.userInfo.stores
        //     const preTime = (new Date(item.preSaleDeliveryTimeStr)).getTime()
        //     const params = {
        //         productSid: item.sid || item.proSid,
        //         userQuantityList: [{ quantity: item.quantity }]
        //     }
        //     if (item.userQuantityList) {
        //         params.userQuantityList = item.userQuantityList
        //     }
        //     if (storeList.length === 1){
        //         if (this.isPreSaleTime(storeList, preTime)){
        //             Dialog.confirm({
        //                 title: '温馨提示',
        //                 message: '预计发货时间可能存在资质过期情况，请核实后下单。',
        //                 cancelButtonColor: '#999999',
        //                 confirmButtonText: '继续购买',
        //                 confirmButtonColor: '#ffffff',
        //                 className: 'jxq preSalejxq'
        //             }).then(() => {
        //                 this.confirmPreSaleAct(params, item)
        //             }).catch(() => {

        //             })
        //         } else {
        //             this.confirmPreSaleAct(params, item)
        //         }
        //     } else {
        //         if (params.userQuantityList){
        //             const selectStoreList = []
        //             storeList.forEach(item => {
        //                 if (params.userQuantityList.indexOf(item.userSid) !== -1){
        //                     selectStoreList.push(item)
        //                 }
        //             })
        //             if (this.isPreSaleTime(selectStoreList, preTime)){
        //                 Dialog.confirm({
        //                     title: '温馨提示',
        //                     message: '预计发货时间可能存在资质过期情况，请核实后下单。',
        //                     cancelButtonColor: '#999999',
        //                     confirmButtonText: '继续购买',
        //                     confirmButtonColor: '#ffffff',
        //                     className: 'jxq preSalejxq'
        //                 }).then(() => {
        //                     this.confirmPreSaleAct(params, item)
        //                 }).catch(() => {

        //                 })
        //             } else {
        //                 this.confirmPreSaleAct(params, item)
        //             }
        //         } else {
        //             this.confirmPreSaleAct(params, item)
        //         }
        //     }
        // },
        // /**
        //  * 继续购买(动作)
        //  */
        // confirmPreSaleAct(params, item){
        //     // Api.comfirmPreSale(params).then(({ data: data }) => {
        //     //     if (data.code === 101005) { // 多门店，选择门店
        //     //         const userInfo = this.$store.getters.userInfo
        //     //         userInfo.stores = data.data
        //     //         const currentType = this.$store.getters.userInfo.currentType
        //     //         const supplySid = this.$store.getters.userInfo.supplySid
        //     //         userInfo.stores.forEach(store => {
        //     //             store.clubList = store.clubList || []
        //     //             store.quantity = params.userQuantityList[0].quantity
        //     //             if (!store.isGSPExpired){
        //     //                 store.disabled = true
        //     //             }
        //     //             if (store.clubList.indexOf(currentType) === -1){
        //     //                 store.disabled = true
        //     //                 if (currentType === 1){
        //     //                     store.storeName = '无乐赛仙俱乐部'
        //     //                 } else if (currentType === 2){
        //     //                     store.storeName = '无佐安堂俱乐部'
        //     //                 } else if (currentType === 3){
        //     //                     store.storeName = '无初心俱乐部'
        //     //                 } else if (currentType === 4){
        //     //                     store.storeName = '无六谷俱乐部'
        //     //                 } else if (currentType === 5){
        //     //                     store.storeName = '无国通俱乐部'
        //     //                 }
        //     //             }
        //     //             if (store.supplySid !== supplySid){
        //     //                 store.disabled = true
        //     //                 // this.$set(store, 'disabled', false)
        //     //                 if (supplySid === 2){
        //     //                     store.supply = '长沙'
        //     //                 } else if (supplySid === 1){
        //     //                     store.supply = '天津'
        //     //                 }
        //     //             }
        //     //         })
        //     //         this.$store.commit("setUserInfo", userInfo)
        //     //         this.$store.commit("setSelectStore", {
        //     //             isPackage: false,
        //     //             show: true,
        //     //             product: this.item,
        //     //             callback: (userQuantityList) => {
        //     //                 this.confirmPreSale(Object.assign({}, this.item, { userQuantityList: userQuantityList }))
        //     //             }
        //     //         })
        //     //     } else if (data.code === 101008) { // 额外赠品
        //     //         const array = []
        //     //         const arr = []
        //     //         params.userQuantityList.forEach((user, i) => {
        //     //             // 订单确认接口参数组装
        //     //             array.push({
        //     //                 userSid: user.userSid || this.$store.getters.userInfo.stores[0].sid,
        //     //                 generalProductList: [{
        //     //                     id: params.productSid,
        //     //                     quantity: user.quantity,
        //     //                     price: item.price,
        //     //                     giftList: []
        //     //                 }]
        //     //             })
        //     //             item.giftList = []
        //     //             item.productSid = item.sid || item.proSid;
        //     //             arr.push({
        //     //                 userSid: user.userSid || this.$store.getters.userInfo.stores[0].sid,
        //     //                 generalProductList: [item],
        //     //                 groupProductList: [],
        //     //                 packageProductList: [],
        //     //                 herbAmount: item.isCmedicine ? item.price * user.quantity : 0,
        //     //                 huddleAmount: item.huddle ? item.price * user.quantity : 0
        //     //             })
        //     //         })
        //     //         localStorage.setItem('extraGift', JSON.stringify(data.data))// 额外的赠品数据
        //     //         localStorage.setItem('goodsList', JSON.stringify(arr))// 订单确认商品数据
        //     //         localStorage.setItem('cartList', JSON.stringify(array))// 额外的赠品结算时的参数
        //     //         this.$router.push('/extraGift/index?type=preSale')
        //     //         this.$store.commit('setSelectStore', { show: false })
        //     //     } else {
        //     //         const array = []
        //     //         const arr = []
        //     //         params.userQuantityList.forEach(user => {
        //     //             // 订单确认接口参数组装
        //     //             array.push({
        //     //                 userSid: user.userSid || this.$store.getters.userInfo.stores[0].sid,
        //     //                 generalProductList: [{
        //     //                     id: params.productSid,
        //     //                     quantity: user.quantity,
        //     //                     price: item.price,
        //     //                     giftList: []
        //     //                 }]
        //     //             })
        //     //             item.giftList = []
        //     //             item.productSid = item.sid || item.proSid;
        //     //             arr.push({
        //     //                 userSid: user.userSid || this.$store.getters.userInfo.stores[0].sid,
        //     //                 generalProductList: [item],
        //     //                 groupProductList: [],
        //     //                 packageProductList: [],
        //     //                 herbAmount: item.isCmedicine ? item.price * user.quantity : 0,
        //     //                 huddleAmount: item.huddle ? item.price * user.quantity : 0
        //     //             })
        //     //         })
        //     //         localStorage.setItem('goodsList', JSON.stringify(arr))// 订单确认商品数据
        //     //         this.confirmBuy(array)
        //     //     }
        //     // })
        //     this.addCartAct(params)
        // },
        // /**
        //  * 确认抢购
        //  */
        // confirmBuy(arr){
        //     setTimeout(() => {
        //         Api.confirmBuy(arr).then(({ data }) => {
        //             this.$store.commit('setSelectStore', { show: false })
        //             localStorage.setItem('cartInfo', JSON.stringify(data.data))
        //             this.$router.push('/order/comfirmOrder?type=preSale')
        //             this.isloading = false
        //         }).catch(() => {
        //             this.isloading = false
        //         })
        //     }, 500)
        // },
        /**
         * 判断是否有门店资质到期时间小于预计到货时间
         */
        isPreSaleTime(storeList, preTime){
            let flag = false
            storeList.forEach(store => {
                const nearestGspDate = store.nearestGspDate || store.nearDate
                if ((new Date(nearestGspDate)).getTime() < preTime){
                    flag = true
                }
            })
            return flag
        }
    }
}
</script>

<style lang="scss">
.controller{
    flex: 1;
    text-align: right;
}
.add-to-cart-content{
    position: relative;
    .add-to-cart-icon{
        width: .48rem;
        height: .48rem;
        margin-top: .06rem;
    }
    .added-tips{
        position: absolute;
        top: -.38rem;
        right: 0;
        span{
            display: flex;
            align-items: center;
            padding: 0 .08rem;
            height: .32rem;
            line-height: .32rem;
            background: linear-gradient(194.45deg, #FED38C 7.09%, #FEDCA5 86.6%);
            border-radius: 2px;
            font-size: .24rem;
            color: #9F5C1D;
        }
        &::after{
            position: absolute;
            bottom: -.12rem;
            right: .2rem;
            content: '';
            border: .06rem solid #FFDCA5;
            border-color: #FFDCA5 transparent transparent transparent;
        }
    }
}

.jxq .van-dialog__message{
    color: #666666!important;
}
.package-dialog{
    .van-dialog__header{
        padding: .4rem 0 .3rem 0!important;
        span{
            font-size: .32rem;
            font-weight: 600;
        }
    }
    .van-icon-cross{
        position: absolute;
        top: 10px;
        right: 10px;
    }
    .van-dialog__content{
        margin:0 .2rem .8rem .2rem;
    }
    .van-dialog__confirm{
        background-color: #ed3129;
    }
    .content{
        display: flex;
        align-items: center;
        img{
            width: .32rem;
            height: .34rem;
            margin-right: .14rem;
        }
    }
}
#preSaleTips{
    &.van-dialog{
        .van-dialog__header{
            color: #666666;
            font-size: .36rem;
            padding-top: .4rem;
            margin-bottom: .4rem;
            font-weight: 600;
        }
        .van-dialog__content{
            padding: 0 .3rem .32rem .34rem;
            div:nth-child(1){
                color: #666666;
                font-size: .32rem;
                padding-bottom: .32rem;
            }
            div:nth-child(2){
                font-size: .28rem;
                color: #888888;
                background: #FBFBFB;
                padding: 0.12rem 0.26rem;
                .needToKnow{
                    color: #13A9FF;
                }
            }
        }
        .van-dialog__footer--buttons{
            .van-dialog__cancel{
                color: #999999;
                font-size: .36rem;
            }
            .van-dialog__confirm{
                background: #ed3129;
                color: #ffffff;
                font-size: .36rem;
            }
        }
    }
}
// .controller {
//     width: 100%;
//     .content{
//         height: .68rem;
//         display: flex;
//         align-items: center;
//         justify-content: space-between;
//         .van-stepper{
//             display: flex;
//             align-items: center;
//             .van-stepper__minus:before, .van-stepper__plus:before,.van-stepper__minus::after, .van-stepper__plus::after{
//                 display: none;
//             }
//             .van-stepper__minus{
//                 background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-min.png?v=1') 50% 50% no-repeat;
//                 background-size: contain;
//                 width: .6rem;
//                 height: .6rem;
//             }
//             .van-stepper__plus{
//                 background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-plus.png?v=1') 50% 50% no-repeat;
//                 background-size: contain;
//                 width: .6rem;
//                 height: .6rem;
//             }
//             .van-stepper__input{
//                 width: .94rem;
//                 height: .6rem;
//             }
//         }
//         i {
//             font-size: 0.92rem;
//             color: #ed3129;
//             &.preSale-btn{
//                 font-size: .64rem;
//             }
//         }

//         .sold-out-icon {
//             color: #666666 !important;
//         }
//     }
//     .added{
//         display: flex;
//         align-items: center;
//         // margin-bottom: .14rem;
//         margin-top: .16rem;
//         img{
//             width: .32rem;
//             height: .32rem;
//             margin-right: .08rem;
//         }
//         span{
//             color: #FBB15B;
//         }
//     }
// }
</style>
