<template>
    <van-popup v-model="popup" round closeable close-icon="clear" position="right" class="head-popup" duration="0" @close="close">
        <div class="head-screen">
            <h1>筛选</h1>
        </div>
        <div class="screen">
            <h4>价格区间</h4>
            <div class="section">
                <van-field
                    v-model="minPrice"
                    placeholder="最低价"
                    type="number"
                    :rules="[{ validator: validatorMin, message: '最低价' }]"
                />
                <span>—</span>
                <van-field v-model="maxPrice" placeholder="最高价" type="number" :rules="[{ validator: validatorMan, message: '最高价' }]" />
            </div>
            <div class="screen-condition">
                <h4>筛选条件</h4>
                <ul>
                    <li v-for="item in screenLists" :key="item.id" :class="{'active':searchTypeList.indexOf(item.id)>-1}" @click="condition(item.id)">{{ item.name }}</li>
                </ul>
            </div>
            <div class="label-list">
                <h4>标签</h4>
                <ul>
                    <li v-for="item in labelListFacet" :key="item.name" :class="{'active':labelVal.indexOf(item.name)>-1}" @click="getLabel(item.name)">{{ item.name }}</li>
                </ul>
            </div>
        </div>
        <div class="submit">
            <button @click="reset">重 置</button>
            <van-button :loading="loading" loading-type="spinner" @click="save(2)">确 定</van-button>
        </div>
    </van-popup>

</template>

<script>
import regex from '@/utils/regex';
import { Toast } from 'vant'
export default {
    props: {
        popup: {
            type: Boolean,
            default: false
        },
        labelListFacet: {
            type: Array,
            default: () => {
                return []
            }
        }
    },
    data() {
        return {
            minPrice: '',
            maxPrice: '',
            searchTypeList: [],
            screenLists: [
                { name: '新品', id: 1 },
                { name: '活动', id: 2 },
                { name: '历史采购', id: 3 },
                { name: '预售', id: 4 },
                { name: '有货', id: 5 },
                { name: '医保', id: 6 }
            ],
            labelVal: [],
            regex: regex,
            action: '',
            loading: true
        };
    },
    mounted() {
        // window.addEventListener('resize', this.keyboardChange);
    },
    methods: {
        /* keyboardChange() {
            var u = navigator.userAgent;
            if (u.indexOf('Android') > -1 || u.indexOf('Linux') > -1) {// 安卓手机
                document.querySelector('.head-popup').style.position = this.$store.getters.winHeight > this.$store.getters.originHeight ? 'fixed' : 'absolute';
            }
        }, */
        /* 最低价 */
        validatorMin(val) {
            val = val.replace(/\s+/g, ''); // 去除所有空格
            return this.regex.money.number(val);
        },
        /* 最高价 */
        validatorMan(val) {
            val = val.replace(/\s+/g, ''); // 去除所有空格
            return this.regex.money.number(val);
        },
        /* 筛选条件 */
        condition(id) {
            const arrIndex = this.searchTypeList.indexOf(id);
            if (arrIndex > -1) {
                this.searchTypeList.splice(arrIndex, 1)
            } else {
                this.searchTypeList.push(id)
            }
        },
        /* 标签 */
        getLabel(name) {
            const arrIndex = this.labelVal.indexOf(name);
            if (arrIndex > -1) {
                this.labelVal.splice(arrIndex, 1)
            } else {
                this.labelVal.push(name)
            }
        },
        /* 关闭弹窗 */
        close() {
            if (this.action !== 2) this.reset();
            this.loading = false
            this.$emit("closePopup")
        },
        /* 提交数据 */
        save(val) {
            this.action = val;
            const obj = {
                minPrice: this.minPrice,
                maxPrice: this.maxPrice,
                searchTypeList: this.searchTypeList,
                labelVal: this.labelVal
            }
            if (this.maxPrice - this.minPrice < 0) {
                Toast('请输入正确的价格区间')
            }
            else {
                this.loading = true
                this.$emit("save", obj) }
        },
        /* 重置数据 */
        reset() {
            this.minPrice = '';
            this.maxPrice = '';
            this.searchTypeList = [];
            this.labelVal = [];
            this.action = ''
        }
    }
}
</script>

<style lang="scss">
.head-popup {
    height: 100%;
    width: 5.9rem;
    display: flex;
    flex-direction: column;
    .van-popup__close-icon {
        color: #ffd29e;
    }
    .van-popup__close-icon--top-right {
        right: .24rem;
    }
    .screen {
        flex: 1;
        overflow: auto;
    }
    .head-screen {
        width: 100%;
        height: 1.5rem;
        background-image: url("~@/assets/images/screen.png");
        background-size: 100% auto;
        h1 {
            font-size: 0.36rem;
            padding: 0.28rem;
        }
        h1:before {
            content: "";
            display: inline-block;
            width: 0.06rem;
            height: 0.28rem;
            background: linear-gradient(180deg, #ed3129 0%, #ffbbb5 100%);
            border-radius: 2px;
            margin-right: 0.12rem;
        }
    }
    h4 {
        padding: 0.28rem;
        font-size: 0.28rem;
    }
    .van-cell:not(:last-child)::after {
        display: none;
    }
    .section {
        display: flex;
        span {
            line-height: 1rem;
            color: #c4c4c4;
        }
        .van-cell{
            padding-left: .28rem;
            padding-right: .28rem;
        }
        .van-field__control {
            height: 0.64rem;
            text-align: center;
            background-color: #f8f8fa;
            border-radius: 0.08rem;
        }
    }
    .screen-condition ul {
        display: flex;
        flex-wrap: wrap;
        li {
            width: 1.64rem;
            height: 0.64rem;
            text-align: center;
            line-height: 0.64rem;
            font-size: 0.26rem;
            color: #666666;
            background: #f8f8fa;
            border-radius: 0.08rem;
            margin-left: .2rem;
            margin-bottom: .2rem;
        }
        li:first-child,li:nth-child(4) {
            margin-left: 0.28rem;
        }
    }
    .label-list ul {
        display: flex;
        flex-wrap: wrap;
        li {
            height: 0.64rem;
            text-align: center;
            line-height: 0.64rem;
            padding-left: 0.2rem;
            padding-right: 0.2rem;
            font-size: 0.26rem;
            color: #666666;
            background: #f8f8fa;
            border-radius: 0.08rem;
            margin-left: .28rem;
            margin-bottom: 0.2rem;
        }
    }
    .active {
        background: #ffede7 !important;
        color: #ff4646 !important;
        font-weight: 600;
    }
    .submit {
        border-top: 0.02rem solid #eeeeee;
        height: 1.36rem;
        display: flex;
        justify-content: space-around;
        button {
            width: 2.5rem;
            height: 0.7rem;
            font-weight: 600;
            font-size: 0.28rem;
            border-radius: 0.4rem;
            background: #ffffff;
            border: 0.01rem solid #e8e8e8;
            margin-top: .28rem;
        }
        .van-button {
            width: 2.52rem;
            height: 0.8rem;
            font-weight: 600;
            font-size: 0.28rem;
            border-radius: 0.4rem;
            color: #ffffff;
            background: #ff4646;
            line-height: .8rem;
        }
        .van-button__loading {
            line-height: .6rem;
        }
    }
}
</style>
