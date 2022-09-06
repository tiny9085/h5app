<template>
    <app-template class="page-reopen-index" system="b2b" @init="fetchList">
        <div v-if="!isApp" class="personal-box" />
        <van-form :show-error-message="false" @failed="failed" @submit="save">
            <van-field
                v-for="(item, index) in reopenData"
                :key="index"
                v-model="item.results"
                :required="item.required"
                :label="(index+1)+'.'+item.title"
                :rules="item.rules"
            >
                <template #input>
                    <template v-if="item.type===2">
                        <van-checkbox-group 
                            v-model="item.results"
                            @change="changeState(item)"
                        >
                            <van-checkbox 
                                v-for="(items, values) in item.option"
                                :key="values"
                                :name="items.id"
                                square
                                label-position="left"
                                :class="item.results.indexOf(items.id)>-1 ? 'change-checkbox-color' : '' "
                            >
                                {{ items.title }}
                            </van-checkbox>
                            <van-field 
                                v-if="item.isShow"
                                :key="values"
                                v-model="item.reason"
                                placeholder="请输入内容"
                            />
                        </van-checkbox-group>
                        <div v-if="item.isError" class="van-field__error-message">请选择</div>
                    </template>
                    <template v-else-if="item.type===1">
                        <van-radio-group 
                            v-model="item.results"
                            @change="checkdedDisable"
                        >
                            <van-radio 
                                v-for="(val, key) in item.option"
                                :key="key"
                                :name="val.id"
                                label-position="left"
                                :class="item.results===val.id ? 'change-radio-color' : '' "
                            >
                                {{ val.title }}
                            </van-radio>
                        </van-radio-group>
                        <div v-if="item.isError" class="van-field__error-message">请选择</div>
                    </template>
                    <van-field
                        v-else-if="item.type===3"
                        v-model="item.results"
                        :maxlength="item.limit ? item.limit : 100000"
                        placeholder="请输入内容"
                        class="input-reason"
                        :rules="item.rules"
                        @input.native="checkdedDisable"
                    />
                    <van-field
                        v-else-if="item.type===4"
                        v-model="item.results"
                        type="textarea"
                        :maxlength="item.limit ? item.limit : 100000"
                        placeholder="请输入内容"
                        class="input-message"
                        :rules="item.rules"
                        @input.native="checkdedDisable"
                    />
                </template>
            </van-field>
            
            <div class="submit-button">
                <van-button round :loading="loading" block="true" type="info" :disabled="isDisable" loading-type="spinner">提交申请</van-button>
            </div>
        </van-form>
        <win-not-open-account ref="refNotOpenAccount" />
    </app-template>
</template>

<script>
import Api from '@/api/account/reopen'
import WinNotOpenAccount from './dialog/index'
import VMnative from '@/utils/VMnative'
import appTemplate from '@/components/appTemplate/Index'
export default {
    components: {
        WinNotOpenAccount,
        appTemplate
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            reopenData: [],
            isDisable: true,
            loading: false,
            status: this.$route.query.username
        };
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "申请重开")
            this.goback()
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    },
    activated() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "申请重开")
            this.goback()
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    },
    methods: {
        /* 
        点击事件 
        */
        changeState(item) {
            item.isError = !(item.results.length > 0)
            item.option.forEach(v => {
                if (v.title === '其他'){
                    if (item.results.filter(item => item === v.id).length > 0){
                        item.isShow = true
                    } else {
                        item.isShow = false
                        item.reason = ''
                    }
                }
            })
            this.checkdedDisable()
        },
        /* 
        判断按钮是否可以提交 
        */
        checkdedDisable() {
            this.isDisable = false
            this.reopenData.forEach(val => {
                if (val.required){
                    if (val.type === 2){
                        if (val.results && !val.results.length) this.isDisable = true
                    } else {
                        if (val.type === 1) val.isError = false
                        if (!val.results) this.isDisable = true
                    }
                }
            })
        },
        /* 
        提交表单且验证不通过后触发 
        */
        failed() {
            this.reopenData.forEach(v => {
                if (v.type === 2 && v.results.length === 0) 
                {
                    v.isError = true
                }
                else if (v.type === 1 && !v.results) 
                {
                    v.isError = true
                }
            })
        },
        /* 
        账号重开问卷数据列表
         */
        fetchList() {
            Api.fetchContent(this.status).then(({ data: { data }}) => {
                this.reopenData = JSON.parse(data.jsonContent)
                this.reopenData.forEach(v => {
                    this.$set(v, "isError", false)
                    if (v.type === 1)
                    {
                        this.$set(v, "results", '')
                        this.$set(v, "rules", [{ required: v.required, trigger: "change", message: '请选择' }])
                    }
                    else if (v.type === 2)
                    {
                        this.$set(v, "results", [])
                        this.$set(v, "isShow", false)
                        this.$set(v, "reason", '')
                        this.$set(v, "rules", [{ required: v.required, trigger: "change", message: '请选择' }])
                    }
                    else if (v.type === 3)
                    {
                        this.$set(v, "results", '')
                        this.$set(v, "rules", [{ required: v.required, trigger: "blur", message: '请输入内容' }])
                    }
                    else
                    {
                        this.$set(v, "results", '')
                        this.$set(v, "rules", [{ required: v.required, trigger: "blur", message: '请输入内容' }])
                    }
                })
                console.log(this.reopenData)
            })
        },
        /* 
        提交页面 
        */
        save(){
            this.loading = true
            Api.fetchSave({
                account: this.status,
                content: JSON.stringify(this.reopenData)
            }).then((res) => {
                this.reopenData.forEach(v => {
                    if (v.type === 2) v.results = []
                    else v.results = ''
                })
                if (this.isApp) {
                    VMnative.callHandler("getResponse", JSON.stringify(res.data))
                } else {
                    this.$refs.refNotOpenAccount.open({
                        status: 2,
                        msg: res.data.msg,
                        managerList: res.data.data
                    }, () => {
                        this.$router.push({
                            path: '/account/login'
                        })
                    })
                }
            }).catch(() => {
                this.loading = false
            })
        }
    }
}

</script>
<style lang="scss">
$font-family: PingFang SC;
$font-style: normal;
.page-reopen-index {
    width: 100%;
    padding-top: .05rem;
    background: #F3F4F6;
    overflow: hidden;
     /* 星号样式 */
    .van-cell--required::before {
        font-weight: 500;
        font-size: .4rem;
        left: .36rem;
        padding-top: .08rem;
        color: #FF4646;
    }
    .van-cell:not(:last-child)::after {
        display: none;
    }
    .van-form > .van-cell {
        margin-top: .2rem;
        background: #FFFFFF;
    }
    .van-cell  {
        flex-direction:column;
    }
    /* 正方形选择框样式 */
    .van-field__label {
            width: 100%;
            max-width: 100%;
            margin-left: .34rem;
            font-weight: 600;
            font-size: 16px;
            color: #333333;
        }
        .van-checkbox-group {
            width: 100%;
            max-width: 100%;
            .van-checkbox {
                justify-content: space-between;
                height: 1rem;
                .van-checkbox__label {
                    font-weight: 600;
                    font-size: .28rem;
                    color: #999999;
                }
                .van-checkbox, .van-icon-success{
                    border-radius: .1rem;
                }
            }
            .van-checkbox:last-child {
                border-bottom: 0;
            }
            .change-checkbox-color .van-checkbox__label {
                color: #333333;
            }
            
        }
     
    /* 圆形选择框样式 */
    .van-radio-group {
            width: 100%;
            max-width: 100%;
            .van-radio {
                justify-content: space-between;
                height: 1rem;
                .van-radio__label {
                    font-weight: 600;
                    font-size: 14px;
                    color: #999999;
                }
                .van-icon-success::before {
                    content: "";
                    height: 0.2rem;
                    width: 0.2rem;
                    border-radius: 50%;
                    margin-bottom: 0.07rem;
                    background: #FFFFFF;
                }
            }
            .change-radio-color .van-radio__label {
                color: #333333;
            }
        }
    /* 校验样式 */
        .van-field__control--custom {
            flex-direction: column;
           .van-field__error-message {
               width: 100%;
           }
        }
    /* 输入框样式 */
    .input-reason, .input-message {
        background: linear-gradient(0deg, #FAFAFA, #FAFAFA);
        border-radius: .1rem;
        margin-top: .30rem;
    }
    .van-checkbox-group .van-cell {
        background: linear-gradient(0deg, #FAFAFA, #FAFAFA);
        border-radius: .1rem;
        margin-top: .30rem;
    }
    /* 提交按钮 */
    .submit-button {
         background: #FFFFFF;
         margin-top: .2rem;
         padding: .28rem;
    }
    .van-button--disabled {
        background: #DDDDDD !important;
        border: none;
    }
    .van-button--info {
        background: #FF4646;
        border: none;
    }
    .van-button--block {
        width: 6.94rem;
    }
    .van-button--loading .van-loading, .van-button--mini {
        line-height: .7rem;
    }
}
</style>
