<template>
    <van-popup
        v-model="show"
        :overlay="true"
        z-index="10000"
        :class="'theme-'+currentType"
        get-container="body"
        position="bottom"
        @click-overlay="close"
    >
        <div class="popup-select-shop"> 
            <div class="popup-title-box">
                <div class="popup-title">
                    <span class="name">请选择采购的门店</span>
                    <span class="multiple-choices">(可多选)</span>
                    <span class="close-store" @click="close">&times;</span> 
                </div>
            </div>
            <div class="scroll-box">
                <div class="selectAll">
                    <van-checkbox v-model="checkedAll" @click="toggleAll">全选</van-checkbox>
                    <span v-if="getCartAddedNum(product) > 0" style="color:#666666">
                        合计已加购：{{ getCartAddedNum(product) }}件
                    </span>
                </div>
                <van-checkbox-group ref="checkboxGroup" v-model="checked" class="checkbox-group">
                    <div v-if="isCoupon" class="choose-store-coupon">
                        <!-- 多店领取优惠券、 -->
                        <template v-for="(item, index) in stores">
                            <div :key="index" class="store-list-box">
                                <van-checkbox :key="index" v-model="item.checked" :disabled="item.status !== 1" :name="item.userId" @click="changeStore">
                                    <span>{{ item.userName }}</span>
                                </van-checkbox>
                                <template>
                                    <span v-if="item.status === 2" class="received_coupon">
                                        <img src="@/assets/images/received_coupon.png" alt="">
                                        已领取
                                    </span>
                                    <span v-if="item.status === 0" class="warning_coupon">
                                        <img src="@/assets/images/warning_coupon.png" alt="">
                                        不符合领取条件
                                    </span>
                                </template>
                            </div>
                        </template>
                    </div>
                    <div v-else>
                        <template v-for="(item, index) in stores">
                            <!-- 
                            item.status === 1        已停用
                            item.supply              组织机构名称
                            item.storeName           是否在当前俱乐部
                            item.purchaseLimited     是否限购 true 是  false 否
                            item.isGSPExpired        是否资质过期  true 否  false 是
                            item.noBussinessScope        是否有经验范围  true 没有  false 有
                        -->
                            <div
                                v-if="item.status !== 1 && !item.supply && !item.storeName"
                                :key="index"
                                :class="{ 'store-list-box':true, 'checked-store':checked.indexOf(item.userSid)>-1 }"
                            >
                                <div class="store-box-top">
                                    <span
                                        v-show="item.packageNumFlag && !(item.disabled || item.purchaseLimited || item.status === 1)"
                                        class="store-package-tips"
                                    >再加购{{ item.missMum }}{{ product.unit }}满整件将优先发货哟</span>
                                    <div class="clearFix" />

                                    <van-checkbox
                                        :key="index"
                                        :disabled="item.disabled || item.purchaseLimited || item.status === 1 ||item.noBussinessScope"
                                        :name="item.userSid"
                                        @click="changeStore"
                                    >
                                        <span>{{ item.name }}</span>
                                    </van-checkbox>
                                    <div class="store-box-bottom">
                                        <div v-if="item.addedQuantity > 0" class="added">
                                            <img
                                                v-if="item.disabled || item.purchaseLimited || item.status === 1 ||item.noBussinessScope"
                                                src="@/assets/images/gray_added.png"
                                                alt=""
                                            >
                                            <img
                                                v-else
                                                src="@/assets/images/added.png"
                                                alt=""
                                            >
                                            <span :style="(item.disabled || item.purchaseLimited || item.status === 1 ||item.noBussinessScope) ? 'color:#999999' : ''">已加购：{{ item.addedQuantity }}</span>
                                        </div>
                                        <div v-else class="added" />
                                        <template v-if="item.disabled || item.purchaseLimited || item.status === 1||item.noBussinessScope">
                                            <span v-if="item.status === 1" class="redText">已停用</span>
                                            <template v-else>
                                                <span v-if="item.supply" class="redText">({{ item.supply }})</span>
                                                <span v-if="!item.supply && item.storeName" class="redText">({{ item.storeName }})</span>
                                                <span v-if="item.purchaseLimited" class="redText">已限购</span>
                                                <span v-if="item.noBussinessScope" class="redText">{{ getBusinessName() }}</span>
                                            </template>
                                        </template>
                                        <template v-else>
                                            <span v-if="!item.isGSPExpired" class="redText">资质过期</span>
                                            <van-stepper
                                                v-if="!isCopyOrder"
                                                :key="index"
                                                v-model="item.quantity"
                                                input-width=".72rem"
                                                button-size=".48rem"
                                                :min="product.stock < 1 || product.stock > product.minNum ? product.minNum : product.stock"
                                                :max="product.stock < 1 || product.stock > product.maxNum ? product.maxNum : product.stock"
                                                :step="product.stock < 1 || product.stock > product.step ? product.step : product.stock"
                                                @change="changeQuantity($event, item)"
                                                @overlimit="overlimitFn($event, item)"
                                            />
                                        </template>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </div>
                </van-checkbox-group>
            </div>
            <div class="btn">
                <van-button :loading="loading" type="danger" size="large" round @click="onSubmit">确定</van-button>
            </div>
        </div>
    </van-popup>
</template>

<script>
import { Toast } from 'vant'
export default {
    name: 'SelectStore',
    data(){
        return {
            checked: [],
            checkedAll: false,
            storeNum: 0,
            loading: false
        }
    },
    computed: {
        show: function(){
            return this.$store.getters.selectStore.show || false
        },
        stores: function(){
            if (this.$store.getters.userInfo){
                return this.$store.getters.userInfo.stores || []
            } else {
                return []
            }
        },
        isCopyOrder: function(){
            return this.$store.getters.selectStore.isCopy || false
        },
        product: function(){
            return this.$store.getters.selectStore.product || {}
        },
        isCoupon() {// 多店领取优惠券、
            return this.$store.getters.selectStore.isCoupon || false
        },
        currentType: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : ''
        },
        cartAdded() {
            return this.$store.state.cartAdded || {};
        },
        allScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.allScope : [];
        }
    },
    watch: {
        show: function(val){
            this.storeNum = 0
            this.checked = localStorage.getItem("checkedStore") ? JSON.parse(localStorage.getItem("checkedStore")) : [];
            if (this.isCoupon) {
                this.stores.forEach((item, idx) => {
                    if ([0, 2].indexOf(item.status) > -1) {// 删掉已领取和不可领取的默认勾选状态
                        this.checked.forEach((checkItem, i) => {
                            if (checkItem === item.userId){
                                this.checked.splice(i, 1)
                            }
                        })
                    } else {
                        this.storeNum++;
                    }
                })
            } else {
                this.stores.forEach((item, idx) => {
                    const subPackNum = (item.addedQuantity + this.product.quantity) % this.product.packageNum;// 已加购+当前加购数量，除整件(含多件)外单个发货剩余的数量
                    const missMum = this.product.packageNum - subPackNum;// 满足整件还要加多少数量
                    // 当前数量是否大于等于整件的95% && 库存是否大于整件购买后的数量
                    const packageNumFlag = (subPackNum / this.product.packageNum) >= 0.95 && this.product.stock >= this.product.quantity + missMum + item.addedQuantity;
                    this.$set(item, 'packageNumFlag', packageNumFlag)
                    this.$set(item, 'missMum', missMum);
                    if (item.disabled || item.purchaseLimited || item.noBussinessScope){
                        this.checked.forEach((checkItem, i) => {
                            if (checkItem === item.userSid){
                                this.checked.splice(i, 1)
                            }
                        })
                    }
                    if (!item.disabled && !item.purchaseLimited && !item.supply && item.status !== 1 && !item.storeName){
                        this.storeNum++
                    }
                })
                if (this.checked.length === 0){
                    this.checkedAll = false
                }
            }
            if (!val) this.loading = false;
        }
    },
    methods: {
        close() {
            this.$store.commit("setSelectStore", {
                show: false,
                isCopy: this.isCopyOrder
            })
        },
        /**
         * 全选
         */
        toggleAll() {
            if (this.checkedAll){
                if (this.isCoupon) {// 多店领取优惠券、
                    this.stores.forEach(item => {
                        if (item.status === 1){
                            if (this.checked.indexOf(item.userId) === -1) this.checked.push(item.userId)
                        }
                    })
                } else {
                    this.stores.forEach(item => {
                        if (!item.disabled && !item.purchaseLimited && !item.supply && item.status !== 1 && !item.storeName && !item.noBussinessScope){
                            if (this.checked.indexOf(item.userSid) === -1) this.checked.push(item.userSid)
                        }
                    })
                }
            } else {
                this.checked = []
            }
        },
        changeStore(){
            this.$nextTick(() => {
                this.checkedAll = (this.checked.length === this.storeNum) && this.checked.length > 0;
            })
        },
        /**
         * 确定提交
         */
        onSubmit() {
            const userQuantityList = []
            if (this.isCopyOrder){
                this.stores.forEach(item => {
                    this.checked.forEach(user => {
                        if (item.userSid === user){
                            userQuantityList.push(item.userSid)
                        }
                    })
                })
                this.$store.getters.selectStore.callback(userQuantityList);
            } else {
                if (this.isCoupon) {// 多店领取优惠券、
                    this.$store.getters.selectStore.callback(this.checked.join(','))
                } else {
                    this.stores.forEach(item => {
                        this.checked.forEach(user => {
                            if (item.userSid === user){
                                const obj = {
                                    quantity: item.quantity,
                                    userSid: user
                                }
                                userQuantityList.push(obj)
                            }
                        })
                    })
                }
                this.$store.getters.selectStore.callback(userQuantityList) 
            }
            localStorage.setItem("checkedStore", JSON.stringify(this.checked));
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
         * 获取经营范围名称
         */
        getBusinessName() {
            const data = this.allScope.filter(v => v.sid === this.product.businessScope)[0] || {};
            return data.name + '：无经营范围';
        },
        // 改变数量
        changeQuantity(val, item) {
            item.quantity = val;
            if (item.timer) clearTimeout(item.timer);
            item.timer = setTimeout(() => {
                const subPackNum = (item.addedQuantity + val) % this.product.packageNum;// 已加购+当前加购数量，除整件(含多件)外单个发货剩余的数量
                const missMum = this.product.packageNum - subPackNum;// 满足整件还要加多少数量
                // 当前数量是否大于等于整件的95% && 库存是否大于整件购买后的数量
                const packageNumFlag = (subPackNum / this.product.packageNum) >= 0.95 && this.product.stock >= val + missMum + item.addedQuantity;
                item.packageNumFlag = packageNumFlag;
                item.missMum = missMum;
                
                this.overlimitFn(val, item);
                if (val > this.product.stock && this.product.stock > 0) {// 大于品种当前库存数量
                    item.quantity = this.product.stock;
                } else if (val <= this.product.minNum && this.product.stock > 0) {// 小于最小起订量
                    item.quantity = this.product.minNum;
                } else if (val > this.product.maxNum && this.product.stock > 0) {// 大于等于最大起订量
                    item.quantity = this.product.maxNum;
                } else {
                    if (!val % this.product.step === 0){
                        item.quantity = Math.ceil(val / this.product.step) * this.product.step;
                    } else {
                        item.quantity = val;
                    }
                }
                this.$forceUpdate();
            }, 600)
        },
        // 超出最大最小起订量提示
        overlimitFn(value, item) {
            Toast.clear();
            if ((value === 'plus' && item.quantity >= this.product.maxNum) || (value > this.product.maxNum && this.product.stock > 0)) {
                Toast("高于最大订购数量：" + this.product.maxNum);
            } else if ((value === 'plus' && item.quantity >= this.product.stock) || (value > this.product.stock && this.product.stock > 0)) {
                Toast("高于最大订购数量：" + this.product.stock);
            } else if ((value === 'minus' && item.quantity <= this.product.minNum) || (value < this.product.minNum && this.product.stock > 0)) {
                Toast('低于最小起订量：' + this.product.minNum);
            }
        }
    }
}
</script>

<style lang="scss" scope>
.popup-select-shop {
    box-sizing: border-box;
    padding: 0 .28rem;
    max-height: 8rem;
    overflow: auto;
    .multiple-choices{
        margin-left: .12rem;
        font-size: .28rem;
        color: #999999;
    }
    .popup-title-box{
        background: #fff;
        height: 1.12rem;
        position: fixed;
        z-index: 9;
    }
    .popup-title {
        color: #666666;
        padding: 0 .28rem;
        height: 1.18rem;
        line-height: 1.18rem;
        width: 100%;
        position: fixed;
        top: 0;
        left: 0;
        border-bottom: .02rem solid #EEEEEE;
        background: #fff;
        z-index: 2;
        transform: translateZ(0);
        .name{
            font-size: .32rem;
            font-weight: 600;
        }
    }
    .scroll-box{
        .selectAll{
            display:flex;
            justify-content: space-between;
            margin-top: 1.6rem;
            margin-bottom: .28rem;
        }
        .checkbox-group{
            margin: 0 0 1.62rem;
            .choose-store-coupon{
                .received_coupon, .warning_coupon{
                    color: #999999;
                    img{
                        width: .24rem;
                        height: .24rem;
                        margin-right: .08rem;
                        vertical-align: text-top;
                    }
                }
                .warning_coupon img{
                    margin-right: 0;
                }
            }
            .store-list-box{
                width: 100%;
                margin-bottom: .16rem;
                background: #F6F6F6;
                border-radius: .12rem;
                box-shadow: 0px 0px .12rem 0px rgba(255,255,255,255);
                border: .02rem solid transparent;
                .store-box-top{
                    line-height: .4rem;
                }
                .store-package-tips{
                    float: right;
                    padding: 0 .12rem;
                    height: .44rem;
                    line-height: .44rem;
                    font-size: .28rem;
                    background: #FFDBA2;
                    color: #9F5C1D;
                    border-radius: 0px 6px;
                }
                .clearFix{
                    height: 1px;
                    clear: both;
                }
                .store-box-bottom{
                    display: flex;
                    justify-content: space-between;
                    height: .96rem;
                    padding: 0 .24rem;
                    align-items: center;
                    border-top: .02rem solid #ffffff;
                    .van-stepper{
                        margin-left: .2rem;
                    }
                }
                .van-checkbox__label{
                    line-height: .4rem;
                    color: #666666;
                }
                &.checked-store{
                    .van-checkbox__label{
                        color: #ED3129;
                    }
                }
            }
            .van-checkbox {
                margin: .24rem 0;
                padding: 0 .24rem;
                .van-checkbox__label {
                    flex: 1;
                    font-size: .24rem;
                    // max-width: 4rem;
                    // line-height: .52rem;
                    // display: flex;
                    // align-items: center;
                    // span:nth-child(1){
                    //     max-width: 4.7rem;
                    //     overflow: hidden;
                    //     white-space: nowrap;
                    //     text-overflow: ellipsis;
                    // }
                }
            }
            .van-stepper{
                display: flex;
                align-items: center;
                .van-stepper__minus:before, .van-stepper__plus:before,.van-stepper__minus::after, .van-stepper__plus::after{
                    display: none;
                }
                .van-stepper__minus{
                    background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-min.png?v=1') 50% 50% no-repeat;
                    background-size: contain;
                }
                .van-stepper__plus{
                    background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-plus.png?v=1') 50% 50% no-repeat;
                    background-size: contain;
                }
            }
            .redText{
                color: #ED3129;
                height: .4rem;
                line-height: .4rem;
                padding: 0 .12rem;
                border: .02rem solid #ED3129;
                border-radius: .04rem;
                background: #FFF7F5;
                // padding-left: .2rem;
            }
        }
        .added{
            flex: 1;
            display: flex;
            align-items: center;
            img{
                width: .24rem;
                height: .24rem;
                margin-right: .14rem;
            }
            span{
                color: #FFAE00;
            }
        }
    }
    .btn{
        position: fixed;
        bottom: 0;
        left: 0;
        z-index: 2;
        background: #fff;
        width: 100%;
        transform: translateZ(0);
        text-align: center;
        .van-button {
            height: .88rem;
            line-height: .88rem;
            font-size: .40rem;
            margin: .36rem 0;
            width: 95%;
            &.van-button--danger {
                background-color: #FF4646;
            }
        }
    }
    .close-store{
        font-size: .48rem;
        color: #CCCCCC;
        position: absolute;
        right: .1rem;
    }
    .van-checkbox__icon--disabled .van-icon{
        border: none;
    }
}
</style>
