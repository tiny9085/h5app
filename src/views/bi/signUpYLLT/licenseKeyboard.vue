<template>
    <div class="app-license-keyboard" :class="[customClass]">
        <span @click="show">
            <slot>
                <van-icon v-if="isMobile" name="browsing-history" />
                <i v-else class="el-icon-s-grid icon" />
            </slot>
        </span>
        <div v-if="isShow" class="license-mark" />
        <div v-if="isShow" class="license-container" :class="[customLicenseClass]" :style="{background:keyboardBg,opacity,fontSize}">
            <div class="license-bar">
                <span class="close" :style="{fontSize}" @click="close">取消</span>
                <span class="res-view" :style="{fontSize}">预览: {{ licenseNumber }}</span>
                <span class="confirm" :style="{fontSize}" @click="confirm">确认</span>
            </div>
            
            <template v-if="type">
                <template v-for="(items,k) in licenseNumberModels">
                    <div :key="k" class="license-buttons">
                        <span v-if="k== 3" :disabled="!licenseNumber" class="model" :class="{'disabled-btn':!licenseNumber}" :style="keyStyle" @click="toggle()">
                            切换
                        </span>
                        <template v-for="(item,j) in items">
                            <span :key="j" :style="keyStyle" @click="handleChinese(item)">{{ item }}</span>
                        </template>
                        <span v-if="k== 3" class="delete" :disabled="!licenseNumber" :class="{'disabled-btn':!licenseNumber}" :style="keyStyle">删除</span>
                    </div>
                </template>
            </template>
            <template v-else>
                <template v-for="(items,k) in abcAndNums">
                    <div :key="k" class="license-buttons">
                        <span v-if="k== 3" :disabled="!licenseNumber" class="model" :class="{'disabled-btn':!licenseNumber}" :style="keyStyle" @click="toggle()">
                            切换
                        </span>
                        <template v-for="(item,j) in items">
                            <span :key="j" :style="keyStyle" @click="handleAbcNum(item)">{{ item }}</span>
                        </template>
                        <span v-if="k== 3" class="delete" :disabled="!licenseNumber" :class="{'disabled-btn':!licenseNumber}" :style="keyStyle" @click="deleteLicense()">删除</span>
                    </div>
                </template>
            </template>
        </div>
    </div>
</template>
<script>
const theme = '#3d51aa';
export default {
    name: 'LicenseKeyboard',
    model: {
        value: 'license',
        event: 'confirm'
    },
    props: {
        title: {
            required: false,
            type: [String],
            default: '软键盘'
        },
        license: {
            required: false,
            type: [String],
            default: null
        },

        // 顶级节点自定义的class
        customClass: {
            required: false,
            type: [String],
            default: null
        },

        // 键盘容器节点自定义的class
        customLicenseClass: {
            required: false,
            type: [String],
            default: null
        },

        // 键盘背景
        keyboardBg: {
            required: false,
            type: [String],
            default: null
        },

        // 键盘字体颜色
        fontColor: {
            required: false,
            type: [String],
            default: null
        },

        // 键盘按钮的边框颜色
        keyBorderColor: {
            required: false,
            type: [String],
            default: theme
        },

        // 键盘背景
        keyBg: { 
            required: false,
            type: [String],
            default: null
        },

        // 键盘的透明度
        opacity: {
            required: false,
            type: [Number],
            default: 1
        },

        // 默认的字体大小 16px => 1rem
        fontSize: {
            required: false,
            type: [String],
            default: '1rem'
        },

        // 键盘的默认圆角
        borderRadius: {  
            required: false,
            type: [String],
            default: null
        },

        // 是否只在移动端使用 默认false,在pc端使用的时候,建议全部使用手动配置字体大小的方法,区别在于是否会开启字体响应,其中使用了autosize的方法,会改变跟元素的font-size
        isMobile: {
            required: false,
            type: [Boolean],
            default: false
        }
    },
    data() {
        return {
            isShow: false,
            licenseNumberModels: [
                ['川', '京', '苏', '津', '浙', '渝', '冀', '皖', '琼', '鲁'],
                ['闽', '贵', '新', '晋', '赣', '云', '宁', '蒙', '豫', '藏'],
                ['港', '辽', '桂', '陕', '澳', '吉', '湘', '甘', '台', '粤'],
                ['青', '沪', '鄂', '黑', '军', '警', '学']
            ],
            abcAndNums: [
                [1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
                [`Q`, `W`, `E`, `R`, `T`, `Y`, `U`, `I`, `O`, `P`],
                [`A`, `S`, `D`, `F`, `G`, `H`, `J`, `K`, `L`],
                [`Z`, `X`, `C`, `V`, `B`, `N`, `M`]
            ],
            type: true,
            licenseNumber: null // 车牌输入的值
        };
    },
    computed: {
        keyStyle(){
            return {
                color: this.fontColor,
                background: this.keyBg,
                borderColor: this.keyBorderColor,
                fontSize: this.fontSize,
                borderRadius: this.borderRadius
            }
        }
    },
    watch: {
        licenseNumber(val) {
            // 删除完的时候返回到初始界面
            if (!val) {
                this.type = true;
            }
        }
    },
    methods: {
        /**
         * 弹出键盘
         */
        show() {
            this.isShow = true;
            this.licenseNumber = null;
            this.type = true;
        },

        /**
         * 切换
         */
        toggle() {
            if (this.licenseNumber) {
                this.type = !this.type;
            }
        },

        /**
         * 汉字输入
         */
        handleChinese(key) {
            this.licenseNumber = key;
            // 输入1个汉字切换到英文输入
            this.type = false;
        },

        /**
         * 数字和字母输入
         */
        handleAbcNum(key) {
            if (this.licenseNumber.length < 7) { // 最多允许输入8位
                this.licenseNumber += key;
            }
        },

        /**
         * 删除车牌
         */
        deleteLicense() {
            if (this.licenseNumber) {
                this.licenseNumber = this.licenseNumber.substring(0, this.licenseNumber.length - 1);
            }
        },

        /**
         * 完成
         */
        confirm() {
            if (this.licenseNumber) {
                this.$emit('confirm', this.licenseNumber);
                this.isShow = false;
            }
        },

        /**
         * 关闭
         */
        close() {
            this.licenseNumber = '';
            this.isShow = false;
        }
    }
};
</script>
<style lang="scss" scoped>
.app-license-keyboard{
    .icon{
        font-size: .36rem;
        cursor: pointer;
    }
    font{
        cursor: pointer;
    }
    .license-mark{
        position: fixed;
        top: 0;
        left: 0;
        z-index: 2003;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,.7);
    }
    .license-content{
        position: fixed;
        z-index: 2004;
    }
    .license-container{
        box-sizing: border-box;
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        height: auto;
        z-index: 99999999;
        background: rgba(255, 255, 255, 1);
        box-shadow: 0 .25rem .375rem 0 #3d51aa;
        .license-bar{
            display: flex;
            justify-content: space-between;
            padding: .08rem .32rem;
            color: #f00;
            font-weight: bold;
            font-size: .24rem;
            span{
                align-self: center;
            }
            .confirm,
            .close{
                cursor: pointer;
            }
            .res-view{
                color: #333;
            }
        }
        .license-buttons{
            padding: 0 .2rem;
            margin: 0 auto;
            display: flex;
            flex-wrap:wrap;
            justify-content: center;
            span{
                flex: 1;
                margin: .08rem .04rem;
                padding: .08rem 0;
                text-align: center;
                white-space: nowrap;
                color: #3d51aa;
                border: .02rem solid #3d51aa;
                border-radius: .08rem;
                cursor: pointer;
                transition: color,background .2s ease-in;
                font-size: .28rem;
                &:not(.disabled-btn):hover{
                    background: #3d51aa;
                    color: #fff;
                }
            }
            .model,
            .delete{
                flex: 1;
                color: #f00;
            }
            .disabled-btn{
                color: #ccc;
                cursor:not-allowed;
            }
        }
    }
}
</style>
