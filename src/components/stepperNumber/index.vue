<template>
    <!-- 将原有加入购物车组件和计步器分离成独立组件并支持整件加入购物车 -->
    <div :class="theme === 'addToCartSpec' ? 'step-controller':'controller'">
        <div class="content">
            <van-stepper
                v-if="isPackage"
                v-model.number="item.packageCount"
                :min="item.packageMinNum"
                :max="item.maxNum"
                :step="item.packageNum"
                @change="changeStep($event,item)"
                @overlimit="overlimitPackageFn"
            />
            <van-stepper
                v-else
                v-model.number="item[prop]"
                :min="item.stock < 1 || item.stock > item.minNum ? item.minNum : item.stock"
                :max="item.stock < 1 || item.stock > item.maxNum ? item.maxNum : item.stock"
                :step="item.stock < 1 || item.stock > item.step ? item.step : item.stock"
                @change="changeStep($event,item)"
                @overlimit="overlimitFn"
            />
        </div>
    </div>
</template>
<script>
import { Toast } from 'vant'

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'StepperNumber',
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
        isPackage: {
            type: Boolean,
            default: false
        },
        theme: {
            type: String,
            default: ''
        }
    },
    data() {
        return {
            packageNumFlag: false,
            subPackNum: 0,
            missMum: 0,
            showPackageNumFlag: false,
            prop: 'quantity',
            minusStep: false
        }
    },
    mounted() {
        this.prop = [2, 4].indexOf(this.activityType - 0) > -1 ? 'packageQuantity' : 'quantity';
        this.$set(this.item, this.prop, this.item.packageQuantity || this.item.quantity || this.item.minNum || 1);
        this.$set(this.item, 'price', this.item.discountPrice || this.item.price);
        this.$set(this.item, 'step', this.item.step || 1);
        if (this.isCart) this.$set(this.item, 'packageNum', this.item.packageNum || this.item.maxNum || 1000000000);
    },
    methods: {
        // 超出最大最小起订量提示
        overlimitFn(value) {
            Toast.clear();
            if ((value > this.item.maxNum && this.item.stock > 0) || (value === 'plus' && this.item[this.prop] >= this.item.maxNum)) {
                Toast("高于最大订购数量：" + this.item.maxNum);
            } else if ((value > this.item.stock && this.item.stock > 0) || (value === 'plus' && this.item[this.prop] >= this.item.stock)) {
                Toast("高于最大订购数量：" + this.item.stock);
            } else if ((value < this.item.minNum && this.item.stock > 0) || (value === 'minus' && this.item[this.prop] <= this.item.minNum)) {
                Toast('低于最小起订量：' + this.item.minNum);
            }
            // step大于件装时，减到最后一个步频未到最小起订量，再减时不会触发min限制，change方法不返回负数需要提前记录操作
            if (this.item[this.prop] < this.item.step && this.item.minNum < this.item[this.prop]) {
                this.minusStep = true;
            }
        },
        overlimitPackageFn(value) {
            Toast.clear();
            if (value > this.item.maxNum || (value === 'plus' && this.item.packageCount >= this.item.maxNum)) {
                Toast("高于最大订购件装量：" + (this.item.maxNum || this.item.maxNum));
            } else if (value > this.item.stock || (value === 'plus' && this.item.packageCount >= this.item.stock)) {
                Toast("高于最大订购件装量：" + this.item.stock);
            } else if (value < this.item.packageMinNum || (value === 'minus' && this.item.packageCount <= this.item.packageMinNum)) {
                Toast('低于最小起订件装量：' + this.item.packageMinNum);
            }
        },
        changeStep(value) {
            this.item[this.prop] = value;
            if (this.item.timer) clearTimeout(this.item.timer);
            this.item.timer = setTimeout(() => {
                if (this.minusStep && value < this.item.step){
                    value = -value;
                    this.minusStep = false;
                }
                if (this.isCart) {
                    this.cartStepRule(value);
                    if (this.activityType === 9) {
                        const groupProductList = JSON.parse(localStorage.getItem("groupList")) || []
                        groupProductList.forEach(e => {
                            if (this.item.productSid === e.productSid){
                                e.quantity = this.item.quantity
                            }
                        })
                        localStorage.setItem("groupList", JSON.stringify(groupProductList))
                        const cartItem = {
                            userSid: this.$store.getters.userInfo.stores[this.index].sid,
                            club: this.$store.getters.userInfo.currentType,
                            cart: {
                                productSid: this.item.productSid,
                                quantity: this.item.quantity
                            },
                            groupProductList: groupProductList
                        }
                        this.$parent.updateGroupNum(cartItem, this.group)
                    } else {
                        this.$parent.updateNum(this.item, this.index)
                    }
                } else {
                    this.stepRule(value);
                }
                _czc.push([
                    "_trackEvent",
                    "点击步进器",
                    "InputNumber_button_click",
                    'goodsName:' + this.item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType
                ])
            }, 600)
        },
        // 获取件装和倍数组合
        getPSGroup(quantity) {
            const len = Math.floor(quantity / this.item.packageNum);
            let flag = false;
            for (let i = len; i >= 1; i--) {
                const packageCount = this.item.packageNum * i;
                if (((quantity - packageCount) % this.item.step) === 0) {
                    flag = true;
                    break;
                }
            }
            return flag;
        },
        // 购物车步进器和上调规则
        cartStepRule(e) {
            const num = e - 0;
            if (num > this.item.stock && this.item.stock > 0) {// 大于品种当前库存数量
                this.item[this.prop] = this.item.stock;
            } else if (num <= this.item.minNum && this.item.stock > 0) {// 小于最小起订量
                this.item[this.prop] = this.item.minNum;
            } else if (num > this.item.maxNum && this.item.stock > 0) {// 大于等于最大起订量
                this.item[this.prop] = this.item.maxNum;
            } else {
                const step = this.item.step ? this.item.step : 1
                const stepSurplus = num % this.item.step;
                const packageSurplus = num % this.item.packageNum;
                const flag = this.getPSGroup(num);
                // 不为【中包装】倍数、不为【件装】倍数、不为【m倍件装】倍数+【n倍中包装】倍数、
                if (!(stepSurplus === 0 || packageSurplus === 0 || flag)) {
                    if ((this.item.packageNum - packageSurplus) <=  (step - stepSurplus)) {
                    // (N倍件装数-当前数据 <= (N倍中包数-当前数据)
                    // 系统自动上调数值为【N+1】倍件装数
                        this.item[this.prop] = Math.ceil(num / this.item.packageNum) * this.item.packageNum;
                    } else { // 系统自动上调数值为【N+1】倍中包装数
                        this.item[this.prop] = Math.ceil(num / this.item.step) * this.item.step;
                    }
                } else {
                    this.item[this.prop] = num;
                }
            }
            this.overlimitFn(this.item[this.prop]);
        },
        // 步进器上调规则
        stepRule(value) {
            const num = value - 0;
            if (this.isPackage) {
                this.overlimitPackageFn(num);
                if (num > this.item.stock) {// 大于品种当前库存数量
                    this.item.packageCount = this.item.stock;
                } else if (num <= this.item.packageMinNum) {// 小于最小起订量
                    this.item.packageCount = this.item.packageMinNum;
                } else if (num > this.item.maxNum) {// 大于等于最大起订量
                    this.item.packageCount = this.item.maxNum;
                } else {
                    if (!num % this.item.packageNum === 0){
                        this.item.packageCount = Math.ceil(num / this.item.packageNum) * this.item.packageNum;
                    } else {
                        this.item.packageCount = num;
                    }
                }
            } else {
                this.overlimitFn(num);
                if (num > this.item.stock && this.item.stock > 0) {// 大于品种当前库存数量
                    this.item[this.prop] = this.item.stock;
                } else if (num <= this.item.minNum && this.item.stock > 0) {// 小于最小起订量
                    this.item[this.prop] = this.item.minNum;
                } else if (num > this.item.maxNum && this.item.stock > 0) {// 大于等于最大起订量
                    this.item[this.prop] = this.item.maxNum;
                } else {
                    if (!num % this.item.step === 0){
                        this.item[this.prop] = Math.ceil(num / this.item.step) * this.item.step;
                    } else {
                        this.item[this.prop] = num;
                    }
                }
            }
        }
    }
}
</script>

<style lang="scss">
.step-controller{
    .van-stepper{
        display: flex;
        input{
            flex: 1;
            height: .6rem;
            background: #FAFAFA;
            border-radius: 4px;
            border: none;
            margin: 0 .2rem;
        }
        button{
            width: .6rem;
            height: .6rem;
            background: #FFFFFF;
            border: 1px solid #E4E4E4;
            border-radius: .08rem;
            color: #C4C4C4;
        }
    }
}
.controller {
    .content{
        display: flex;
        align-items: center;
        justify-content: space-between;
        .van-stepper{
            display: flex;
            align-items: center;
            .van-stepper__minus:before, .van-stepper__plus:before,.van-stepper__minus::after, .van-stepper__plus::after{
                display: none;
            }
            .van-stepper__minus{
                background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-min.png?v=1') 50% 50% no-repeat;
                background-size: contain;
                width: .6rem;
                height: .6rem;
            }
            .van-stepper__plus{
                background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-plus.png?v=1') 50% 50% no-repeat;
                background-size: contain;
                width: .6rem;
                height: .6rem;
            }
            .van-stepper__input{
                width: .94rem;
                height: .6rem;
            }
        }
        i {
            font-size: 0.92rem;
            color: #ed3129;
            &.preSale-btn{
                font-size: .64rem;
            }
        }

        .sold-out-icon {
            color: #666666 !important;
        }
    }
    .added{
        display: flex;
        align-items: center;
        // margin-bottom: .14rem;
        margin-top: .16rem;
        img{
            width: .32rem;
            height: .32rem;
            margin-right: .08rem;
        }
        span{
            color: #FBB15B;
        }
    }
}
</style>
