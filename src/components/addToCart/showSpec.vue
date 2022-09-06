<template>
    <!-- 调整原有加入购物车组件预售和商品信息展示卡片的弹出优先级 -->
    <van-action-sheet
        v-model="show"
        close-on-click-action
        :class="['add-cart-spec-sheet', 'theme-'+currentType]"
        get-container="body"
    >
        <div class="spec-box">
            <div class="top">
                <imageLoad
                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                    :is-product-img="true"
                    :original-image="item.mainImg"
                    :sid="item.sid"
                    :item="item"
                />
                <div class="top-right">
                    <h6>{{ item.commodityName }}</h6>
                    <div>抱团价<span>¥ {{ item.price }}</span></div>
                    <i class="close-btn" @click="close"><img src="@/assets/images/&times.png" alt=""></i>
                </div>
            </div>
            <div class="info">
                <div class="row-title">
                    <div class="line" />
                    <h6>规格、厂家、效期</h6>
                </div>
                <div class="row">
                    <img class="icon" src="@/assets/images/spec-icon.png" alt="">
                    <span class="content">{{ item.spec }}</span>
                </div>
                <div class="row">
                    <img class="icon" src="@/assets/images/manufacturer-icon.png" alt="">
                    <span class="content">{{ item.manufacturer }}</span>
                </div>
                <div class="row">
                    <img class="icon" src="@/assets/images/expireDate-icon.png" alt="">
                    <span class="content">
                        优于{{ item.expireDate }}
                        <i
                            v-if="item.expireStatus === 1"
                            class="jxq-tips"
                        >近效期</i>
                    </span>
                    
                </div>
            </div>
            <div class="info">
                <div class="row-title">
                    <div class="line" />
                    <h6>包装</h6>
                </div>
                <ul class="pack-list">
                    <template v-if="item.step === item.packageNum">
                        <li class="active">件装/{{ item.packageNum }}</li>
                        <img class="pack-tips" src="@/assets/images/pack.gif" alt="">
                    </template>
                    <template v-else-if="item.packageNum < item.step || !item.packageNum">
                        <li class="active">中包装/{{ item.step }}</li>
                    </template>
                    <template v-else>
                        <li :class="packType === 0 ? 'active':''" @click="changePackType(0)">中包装/{{ item.step }}</li>
                        <li :class="packType === 1 ? 'active':''" @click="changePackType(1)">件装/{{ item.packageNum }}</li>
                        <img class="pack-tips" src="@/assets/images/pack.gif" alt="">
                    </template>
                </ul>
            </div>
            <div class="info">
                <div class="row-title">
                    <div class="line" />
                    <h6>数量
                        <span
                            v-if="item.stock > 0"
                            class="stock-tips"
                        >{{ item.minNum }}盒起购，库存：{{ item.stock > 1000 ? '>1000' : item.stock }}</span>
                        <span
                            v-else
                            class="stock-tips"
                        >无库存，预计到货时间：
                            <font color="#FFB931">{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</font>
                        </span>
                    </h6>
                </div>
                <stepper-number
                    v-if="packType === 0"
                    :source="source"
                    :item="item"
                    :activity-type="activityType"
                    theme="addToCartSpec"
                />
                <stepper-number
                    v-if="packType === 1"
                    :source="source"
                    :item="item"
                    :activity-type="activityType"
                    :is-package="true"
                    theme="addToCartSpec"
                />
            </div>
            <div class="footer">
                <p v-if="item.preSale" @click="confirmPreSale">加入购物车<font v-if="getCartAddedNum(item)">({{ getCartAddedNum(item) }})</font></p>
                <p v-else @click="addToCart(1)">加入购物车<font v-if="getCartAddedNum(item)">({{ getCartAddedNum(item) }})</font></p>
            </div>
        </div>
        <!-- 整件购买提示 -->
        <van-dialog
            v-model="showPackageNumFlag"
            get-container="body"
            show-cancel-button
            cancel-button-text="正常加购"
            confirm-button-text="整件购买"
            confirm-button-color="#fff"
            class="package-dialog"
            @confirm="packageAdd(1)"
            @cancel="packageAdd(0)"
        >
            <div slot="title">
                <span>温馨提示</span>
                <van-icon name="cross" @click="showPackageNumFlag = false" />
            </div>
            <div class="content">
                <img src="@/assets/images/hi.png" alt="">
                <span>当前商品再加购{{ item.packageNum - subPackNum }}{{ item.unit }}满整件将优先发货哟</span>
            </div>
        </van-dialog>
    </van-action-sheet>
</template>
<script>
import { Toast, Dialog } from 'vant'
import imageLoad from '@/components/imageLoad/index'
import StepperNumber from '@/components/stepperNumber/index';
import Api from '@/api/product/cart'

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    components: {
        imageLoad,
        StepperNumber
    },
    props: {
        item: {
            type: Object,
            default: () => {
                return {

                }
            }
        },
        activityType: {
            type: Number,
            default: null
        },
        source: {
            type: String,
            default: 'h5'
        }
    },
    data() {
        return {
            show: false,
            packType: 0,
            subPackNum: 0,
            missMum: 0,
            packageNumFlag: false,
            showPackageNumFlag: false,
            supplyNameArr: ['', '长沙', '天津', '上海优福思乐', '重庆']
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
    methods: {
        open(item) {
            this.show = true;
            this.$set(this.item, 'packageCount', item.step === item.packageNum ? item.minNum : item.packageNum);
            this.$set(this.item, 'packageMinNum', item.step === item.packageNum ? item.minNum : item.packageNum);
            if (item.step === item.packageNum) this.packType = 1;
        },
        changePackType(type) {
            const packageStock = Math.floor(this.item.stock / this.item.packageNum);
            const packageMaxNum = Math.floor(this.item.maxNum / this.item.packageNum);
            if (type === 1) {
                _czc.push([
                    "_trackEvent",
                    "点击切换件装类型",
                    "add_cart_switch",
                    "club:" + this.$store.getters.userInfo.currentType
                ])
                if (packageStock < 1 || packageMaxNum < 1) {
                    Toast('超过最大订购数量，无法切换');
                    return;
                }
            }
            type === 0 ? this.item.quantity = this.item.minNum : this.item.packageCount = this.item.packageNum;
            this.packType = type;
        },
        close() {
            this.show = false;
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
        // 更新已加购数量
        refreshAdded(params) {
            // 更新已加购数量
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
        // 加入购物车接口
        cartApiFn(params) {
            Api.addTocart(params).then(({ data }) => {
                if (data.code === 101005) {
                    const userInfo = this.$store.getters.userInfo
                    userInfo.stores = data.data
                    const currentType = userInfo.currentType
                    const supplySid = userInfo.supplySid
                    userInfo.stores.forEach(store => {
                        store.clubList = store.clubList || []
                        store.quantity = params.userQuantityList[0].quantity
                        if (store.clubList.indexOf(currentType) === -1){
                            store.disabled = true
                            if (currentType === 1){
                                store.storeName = '无乐赛仙俱乐部'
                            } else if (currentType === 2){
                                store.storeName = '无佐安堂俱乐部'
                            } else if (currentType === 3){
                                store.storeName = '无初心俱乐部'
                            } else if (currentType === 4){
                                store.storeName = '无六谷俱乐部'
                            } else if (currentType === 5){
                                store.storeName = '无国通俱乐部'
                            }
                        }
                        if (store.supplySid !== supplySid){
                            store.disabled = true
                            store.supply = this.supplyNameArr[supplySid - 0];
                        }
                    })
                    this.$store.commit("setUserInfo", userInfo)
                    this.$store.commit("setSelectStore", {
                        isPackage: false,
                        show: true,
                        product: this.item,
                        callback: (userQuantityList) => {
                            this.addToCart(2, userQuantityList)
                        }
                    })
                } else if (data.code === 0) {
                    this.refreshAdded(params);
                    Toast.success({
                        message: "加入成功",
                        duration: 1000
                    })
                    this.show = false;
                    this.$store.commit('setCartNum')
                    this.$store.commit('setSelectStore', { show: false })
                }
            })
        },
        /**
         * 商品加入购物车(动作)
         */
        addCartAct(params) {
            if (this.$store.getters.userInfo.stores && this.$store.getters.userInfo.stores.length === 1 && this.packageNumFlag) {
                this.showPackageNumFlag = true;
                this.params = params;
            } else {
                this.cartApiFn(params);
            }
        },
        /**
         * 商品加入购物车
         */
        addToCart(theSecond, checkedStore) {
            const addedNum = this.getCartAddedNum(this.item);
            this.subPackNum = (this.item.quantity + addedNum) % this.item.packageNum; // 已加购+当前加购数量，除整件(含多件)外单个发货剩余的数量
            this.missMum = this.item.packageNum - this.subPackNum; // 满足整件还要加多少数量
            // 当前数量是否大于等于整件的95% && 库存是否大于整件购买后的数量
            this.packageNumFlag = (this.subPackNum / this.item.packageNum) >= 0.95 && this.item.stock >= this.item.quantity + addedNum + this.missMum;
                
            // 单店无经营范围提示
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
            // if (item.stock <= 0) return
            let params = {}
            const packageProp = ['quantity', 'packageCount'];
            if (this.activityType === null) {
                params = {
                    productSid: this.item.sid,
                    userQuantityList: [{ quantity: this.item[packageProp[this.packType]] }]
                }
            } else if (this.activityType === 1) {
                params = {
                    productSid: this.item.proSid,
                    userQuantityList: [{ quantity: this.item.promotionProduct ? this.item[packageProp[this.packType]] * this.item.promotionProduct[0].proReachNum : this.item[packageProp[this.packType]] }]
                }
            } else if (this.activityType === 2 || this.activityType === 4) {// 套餐
                params = {
                    packageId: this.item.sid,
                    userQuantityList: [{ quantity: this.item.packageQuantity || 1 }]
                }
            } else if (this.activityType === 3 || this.activityType === 5) {
                params = {
                    productSid: this.item.targetProductSid,
                    userQuantityList: [{ quantity: this.item[packageProp[this.packType]] }]
                }
            }
            if (checkedStore) {
                params.userQuantityList = checkedStore
            }
            if (theSecond === 2 && checkedStore.length === 0){
                Toast.clear()
                Toast("您没有选择店铺")
                return
            }
            this.addCartAct(params);
            _czc.push([
                "_trackEvent",
                "点击加入购物车",
                "shoppingcart_button_click",
                'goodsName:' + this.item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType
            ])
        },
        // 整件添加
        packageAdd(type) {
            if (type === 1) {
                this.params.userQuantityList[0].quantity += this.missMum;
                this.cartApiFn(this.params);
            } else {
                this.cartApiFn(this.params);
            }
        },
        /**
         * 继续购买
         */
        confirmPreSale(){
            const storeList = this.$store.getters.userInfo.stores
            const preTime = (new Date(this.item.preSaleDeliveryTimeStr)).getTime();
            const packageProp = ['quantity', 'packageCount'];
            const params = {
                productSid: this.item.sid || this.item.proSid,
                userQuantityList: [{ quantity: this.item[packageProp[this.packType]] }]
            }
            if (this.item.userQuantityList) {
                params.userQuantityList = this.item.userQuantityList
            }
            if (storeList.length === 1){
                this.addCartAct(params);
            } else {
                if (params.userQuantityList){
                    const selectStoreList = []
                    storeList.forEach(item => {
                        if (params.userQuantityList.indexOf(item.userSid) !== -1){
                            selectStoreList.push(item)
                        }
                    })
                    if (this.isPreSaleTime(selectStoreList, preTime)){
                        Dialog.confirm({
                            title: '温馨提示',
                            message: '预计发货时间可能存在资质过期情况，请核实后下单。',
                            cancelButtonColor: '#999999',
                            confirmButtonText: '继续购买',
                            confirmButtonColor: '#ffffff',
                            className: 'jxq preSalejxq'
                        }).then(() => {
                            this.addCartAct(params);
                        }).catch(() => {

                        })
                    } else {
                        this.addCartAct(params);
                    }
                } else {
                    this.addCartAct(params);
                }
            }
        },
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
@mixin overflowText{
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.add-cart-spec-sheet{
    background: transparent;
    font-size: .28rem;
    box-sizing: border-box;
    .van-action-sheet__content{
        background: #FFFFFF;
        border-top-left-radius: .32rem;
        border-top-right-radius: .32rem;
    }
    .spec-box{
        width: 100%;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/spec-bg.png') no-repeat;
        background-size: 100% auto;
        padding: 0 .28rem;
        margin-top: .4rem;
        .image-box{
            position: relative;
            top: -.4rem;
            width: 1.92rem;
            height: 1.92rem;
        }
        .top{
            display: flex;
            height: 1.54rem;
            .top-right{
                flex: 1;
                overflow: hidden;
                padding: .4rem 0 .06rem .28rem;
                position: relative;
                h6{
                    font-size: .32rem;
                    line-height: .44rem;
                    padding-right: .36rem;
                    @include overflowText;
                }
                >div{
                    margin-top: .12rem;
                    span{
                        color: #FF4646;
                        font-size: .36rem;
                        font-weight: 600;
                        line-height: .34rem;
                        margin-left: .2rem;
                    }
                }
                .close-btn{
                    position: absolute;
                    right: 0;
                    top: .44rem;
                    width: .36rem;
                    height: .36rem;
                    border-radius: 50%;
                    background: #FFD29E;
                    color: #FFFFFF;
                    img{
                        display: block;
                        width: .16rem;
                        height: .16rem;
                        margin: .1rem auto;
                    }
                }
            }
        }
        .info{
            padding-top: .42rem;
            .row-title{
                height: .48rem;
                display: flex;
                align-items: center;
                margin-bottom: .28rem;
                .line{
                    width: .06rem;
                    height: .28rem;
                    background: linear-gradient(180deg, #ED3129 0%, #FFBBB5 100%);
                    border-radius: .04rem;
                    margin-right: 0.12rem;
                }
                h6{
                    flex: 1;
                    margin-left: .16rem;
                    font-size: .28rem;
                    .stock-tips{
                        margin-left: .16rem;
                        font-weight: normal;
                    }
                }
            }
            .row{
                display: flex;
                align-items: center;
                .icon{
                    width: .28rem;
                    height: .28rem;
                    border-radius: .04rem;
                    margin-right: .12rem;
                }
                .content{
                    flex: 1;
                    height: .52rem;
                    line-height: .52rem;
                    @include overflowText;
                    .jxq-tips{
                        width: .72rem;
                        height: .34rem;
                        font-style: normal;
                        font-size: .24rem;
                        font-weight: 400;
                        text-align: center;
                        line-height: .34rem;
                        color: #FFB931;
                        background: #FFF4E3;
                        border-radius: .04rem;
                        margin-left: .12rem;
                    }
                }
            }
        }
        .pack-list{
            display: flex;
            margin-top: .06rem;
            align-items: center;
            li{
                height: .52rem;
                padding: 0 .2rem;
                margin-right: .2rem;
                line-height: .52rem;
                background: linear-gradient(0deg, #FFFFFF, #FFFFFF);
                border: .02rem solid #E3E3E3;
                border-radius: .04rem;
            }
            :nth-child(2){
                margin-right: 0;
            }
            .active{
                background: linear-gradient(0deg, #FFF0F0, #FFF0F0);
                border: .02rem solid #FF4646;
                color: #FF4646;
            }
            .pack-tips{
                width: 2.6rem;
                height: .8rem;
            }
        }
        .footer{
            padding: .28rem 0;
            p{
                height: .8rem;
                text-align: center;
                line-height: .8rem;
                background: #FF4646;
                color: #FFFFFF;
                border-radius: .4rem;
            }
        }
    }
}
</style>
