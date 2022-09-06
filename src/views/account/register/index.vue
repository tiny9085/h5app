<template>
    <div class="app-retrieve-pwd">
        <div class="top-div" />
        <div class="tips">
            <span>!</span>
            <p>密码长度为8~16位，需含大些字母、小写字母、数字、特殊符号中的两种或以上，不允许有空格。</p>
        </div>
        <ul class="user-info">
            <li class="input-item">
                <div class="title">
                    <img src="@/assets/images/icon-login-phone.png" class="icon">
                    <span>手机号码</span>
                </div>
                <p class="content">
                    <input v-model.trim="phone" class="flex-none" type="number" placeholder="请输入手机号码">
                </p>
            </li>
            <li class="input-item">
                <div class="title">
                    <img src="@/assets/images/icon-login-4.png" class="icon">
                    <span>验证码</span>
                </div>
                <p class="content">
                    <input v-model.trim="code" class="flex-none-code" type="text" placeholder="请输入验证码" @input="codeError=''">
                    <i class="line" />
                    <countDownTimer :timestamp="timestamp" #default="scope">
                        <span v-if="scope.time <= 0" class="line-text code" @click="getCode(scope.init)">获取验证码</span>
                        <span v-else class="resend">{{ scope.time }}s重新发送</span>
                    </countDownTimer>
                </p>
                <div v-show="codeError" class="error-tips">{{ codeError }}</div>
            </li>
            <li class="input-item">
                <div class="title">
                    <img src="@/assets/images/icon-login-3.png" class="icon">
                    <span>密码</span>
                </div>
                <p class="content">
                    <template v-if="seeType===1">
                        <input
                            id="pwd"
                            v-model.trim="pwd"
                            type="password"
                            autocomplete="new-password"
                            placeholder="请输入密码"
                            onpaste="return false"
                            @input="checkNpwd"
                            @blur="checkPwd"
                        >
                        <label for="pwd">
                            <img
                                src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-6.png"
                                class="icon-pwd"
                                @click="seeType=2"
                            >
                        </label>
                    </template>
                    <template v-if="seeType===2">
                        <input
                            id="pwd"
                            v-model.trim="pwd"
                            type="text"
                            autocomplete="new-password"
                            placeholder="请输入新密码"
                            onpaste="return false"
                            @input="checkNpwd"
                            @blur="checkPwd"
                        >
                        <label for="pwd">
                            <img
                                src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-5.png"
                                class="icon-pwd"
                                @click="seeType=1"
                            >
                        </label>
                    </template>
                </p>
                <div v-show="pwdError" class="error-tips">{{ pwdError }}</div>
            </li>
            <li class="input-item">
                <div class="title">
                    <img src="@/assets/images/icon-login-13.png" class="icon">
                    <span>确认密码</span>
                </div>
                <p class="content">
                    <template v-if="seeNPwdType===1">
                        <input
                            id="nPwd"
                            v-model.trim="nPwd"
                            type="password"
                            autocomplete="new-password"
                            placeholder="请再次确认新密码"
                            onpaste="return false"
                            @blur="checkNpwd"
                        >
                        <label for="nPwd">
                            <img
                                src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-6.png"
                                class="icon-pwd"
                                @click="seeNPwdType=2"
                            >
                        </label>
                    </template>
                    <template v-if="seeNPwdType===2">
                        <input
                            id="nPwd"
                            v-model.trim="nPwd"
                            type="text"
                            autocomplete="new-password"
                            placeholder="请再次确认新密码"
                            onpaste="return false"
                            @blur="checkNpwd"
                        >
                        <label for="nPwd">
                            <img
                                src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-5.png"
                                class="icon-pwd"
                                @click="seeNPwdType=1"
                            >
                        </label>
                    </template>
                </p>
                <div v-show="nPwdError" class="error-tips">{{ nPwdError }}</div>
            </li>
        </ul>
        <van-dialog
            id="preSaleTips"
            v-model="show"
            get-container="body"
            title="恒昌商城会员注册协议和隐私政策"
            show-cancel-button
            cancel-button-text="不同意"
            confirm-button-text="同意"
            @confirm="openSpecDialog"
        >
            <div>
                <span>亲爱的用户，感谢您使用恒昌健康!我们非常重视您的个人信息和隐私安全。为了更好地保障您的个人权益，请您在使用恒昌健康前仔细阅读《用户协议》和《隐私政策》，并在您充分理解并同意全部内容后开始使用我们的产品和服务。我们将严格按照法律法规及协议政策约定收集、使用和保护您的个人信息，感谢您的信任!
                </span>
                <p><span>*需要申请您的电话/存储权限，便于您更快捷地登录。</span></p>
            </div>
        </van-dialog>
        <div class="footer">
            <p :class="isOk ? '':'is-ok'" @click="updatePwd">确 定</p>
        </div>
    </div>
</template>

<script>
import Api from '@/api/account/retrievePassword'
import countDownTimer from '@/components/countDwonTimer';
import regx from '@/utils/regex';
export default {
    components: {
        countDownTimer
    },
    data() {
        return {
            userName: '',
            userNameError: '',
            phone: '',
            code: '',
            codeError: '',
            pwd: '',
            pwdError: '',
            nPwd: '',
            nPwdError: '',
            seeType: 1,
            seeNPwdType: 1,
            show: false,
            auditStatus: '',
            timer: null,
            timestamp: localStorage.retrievePwdTimestamp || 0,
            reason: '',
            ossUrl: '',
            account: '',
            from: this.$route.query.title === '会员注册' ? 1 : 0
        };
    },
    computed: {
        title() {
            if (this.auditStatus === 0){
                return '审核中';
            } else if (this.auditStatus === 1) {
                return '审核通过';
            } else if ([3, 4].indexOf(this.auditStatus) > -1) {
                return '温馨提示';
            } else {
                return '审核未通过';
            }
        },
        cancelStr() {
            if (this.auditStatus === 1){
                return '关 闭';
            } else if (this.auditStatus === 2) {
                return '联系客服';
            } else if (this.auditStatus === 3) {
                return '仍然使用';
            } else {
                return '';
            }
        },
        confirmStr() {
            if (this.auditStatus === 0){
                return '好 的';     
            } else if (this.auditStatus === 1) {
                return '去登录';
            } else if (this.auditStatus === 3) {
                return '更改密码';
            } else if (this.auditStatus === 4) {
                return '知道了';
            } else {
                return '去申诉';
            }
        },
        isOk() {
            if (this.userName && !this.userNameError && this.code && !this.codeError && this.pwd && !this.pwdError && this.nPwd && !this.nPwdError){
                return false;
            } else {
                return true;
            }
        },
        comefrom() {
            return this.$route.query.title ? 1 : ''
        }
    },
    created() {
        if (this.$route.query.title) {
            this.userName = this.$store.getters.userInfo.account || '';
        } else {
            this.userName = this.$route.query.username || '';
        }
    },
    methods: {
        // 校验密码是否合法
        checkPwd() {
            if (this.pwd) {
                if (this.pwd.length < 8) {
                    this.pwdError = '密码不能少于8位';
                } else if (this.pwd.length > 16) {
                    this.pwdError = '密码不能大于16位';
                } else if (!regx.pwd.test(this.pwd)) {
                    this.pwdError = '密码格式有误';
                } else {
                    this.pwdError = '';
                }
            } else {
                this.pwdError = '密码不能为空或空字符';
            }
        },
        // 校验两次密码是否一致
        checkNpwd() {
            if (this.pwd && this.nPwd !== this.pwd) {
                this.nPwdError = '两次输入密码不一致!';
            } else {
                this.nPwdError = '';
            }
        },
        cancelFn() {
            if (this.auditStatus === 1) {// 审核通过
                this.show = false;
            } else if (this.auditStatus === 2) {// 联系客服
                window.location.href = 'tel:400-662-4000';
            } else if (this.auditStatus === 3) {// 仍然使用
                this.updatePwd(1);
            }
        },
        confirmFn() {
            if (this.auditStatus === 0) {// 审核中
                this.show = false;
            } else if (this.auditStatus === 1) {// 审核通过
                this.$router.push('/account/login');
            } else if (this.auditStatus === 3) {// 弱密码提示
                this.show = false;
            } else {// 申诉
                this.$router.push(`/account/appeal?url=${this.ossUrl}&account=${this.account}&from=${this.from}`);
            }
        },
        // 获取验证码
        getCode(callback) {
            if (this.phone) {
                this.codeError = '';
                this.code = '';
                Api.forgetPwdCode(this.phone).then(({ data: { timestamp }}) => {
                    callback && callback(timestamp);
                })
            }
        },
        // 修改密码
        updatePwd(sign) {
            // if (this.isOk) return;
            // this.show = true;
            this.$router.push({
                path: "/account/stepone"
            })
        }
    }
};
</script>

<style scoped lang="scss">
.app-retrieve-pwd{
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100vh;
    overflow: hidden;
    .tips{
        display: flex;
        align-items: center;
        padding: .1rem .28rem;
        background: #FFF5E4;
        color: #FF6E00;
        span{
            width: .28rem;
            height: .28rem;
            text-align: center;
            line-height: .28rem;
            border-radius: 50%;
            border: .02rem solid #FF6E00;
        }
        p{
            flex: 1;
            margin-left: .2rem;
            line-height: .44rem;
        }
    }
    .user-info{
        flex: 1;
        overflow: auto;
        padding: 0 .68rem;
        .input-item{
            margin-top: .4rem;
            h6{
                font-size: .32rem;
                line-height: .44rem;
            }
            .title{
                display: flex;
                height: .46rem;
                align-items: center;
                .icon{
                    width: .36rem;
                    height: .4rem;
                }
                span{
                    flex: 1;
                    font-weight: 600;
                    font-size: .32rem;
                    margin-left: .22rem;
                }
            }
            .content{
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: .8rem;
                border-bottom: .02rem solid #EEEEEE;
                input{
                    flex: 1;
                    height: 100%;
                    border: none;
                    outline: none;
                    font-size: .32rem;
                }
                input::-webkit-input-placeholder{
                    color: #BBBBBB;
                }
                input:disabled {
                    background: transparent;
                }
                .flex-none{
                    flex: none;
                    width: 3.5rem;
                }
                .flex-none-code{
                    flex: none;
                    width: 3.65rem;
                }
                img{
                    width: .36rem;
                    height: .36rem;
                }
                .line{
                    width: .02rem;
                    height: .32rem;
                    background: #EEEEEE;
                    margin: 0 .2rem;
                }
                .line-text{
                    color: #4690FF;
                    font-weight: 500;
                    font-size: 16px;
                    line-height: 22px;
                    white-space: nowrap;
                    &.code{
                        color: #FF4646;
                    }
                }
                .resend{
                    color: #BBBBBB;
                    font-weight: 500;
                    font-size: .32rem;
                }
                .icon-pwd{
                    width: .36rem;
                    height: .28rem;
                }
            }
            .is-error{
                border-bottom: 0.02rem solid #FF8C87;
            }
            .error-tips{
                color: #ED3129;
                font-size: .24rem;
                line-height: .34rem;
                margin-top: .08rem;
            }
        }
    }
    .footer{
        padding: .28rem;
        border-top: .02rem solid #EEEEEE;
        background: #FFFFFF;
        p{
            height: .8rem;
            text-align: center;
            line-height: .8rem;
            color: #FFFFFF;
            font-weight: 600;
            background: #DDDDDD;
            border-radius: 20px;
            font-size: .28rem;
        }
        .is-ok{
            background: #FF4646;
        }
    }
    // 审核提示
    .van-dialog{
        width: 6.54rem;
        border-radius: .16rem;
        background: #FFFFFF;
        .dialog-box{
            text-align: center;
            padding: 0 .72rem;
            background: url('~@/assets/images/dialog_bg.png') no-repeat;
            background-size: 100%;
            position: relative;
            .title{
                padding: .4rem 0 .56rem 0;
                font-size: 16px;
            }
            p{
                font-weight: 500;
                font-size: .28rem;
                line-height: .48rem;
            }
            .close-btn{
                position: absolute;
                right: .28rem;
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
        .dialog-footer{
            display: flex;
            .btn{
                width: 2.68rem;
                height: .8rem;
                margin: .8rem auto .4rem auto;
                text-align: center;
                line-height: .8rem;
                border-radius: .4rem;
                font-weight: 600;
                font-size: .28rem;
            }
            .confirm-btn{
                color: #FFFFFF;
                background: #FF4646;
            }
            .cancel-btn{
                color: #666666;
                background: #FFFFFF;
                border: 1px solid #E8E8E8;
            }
        }
    }
}

</style>
