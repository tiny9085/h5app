<template>
    <div class="Page-account-login">
        <div class="login-title">
            <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-1.png">
            <span>欢迎来到恒昌健康</span>
        </div>
        <div class="login-form">
            <div class="row row-1 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-2.png">
                    <p>账号</p>
                </div>
                <input v-model="formData.username" placeholder="请输入ID号、手机号+区分号" placeholder-class="input-placeholder">
                <img v-show="formData.username.length > 0" style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-8.png" @click="clearUser">
            </div>
            <div class="row row-2 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-3.png">
                    <p>密码</p>
                </div>
                <input v-model="formData.password" placeholder="请输入登录密码" :type="inputType" placeholder-class="input-placeholder">
                <van-icon v-show="inputType==='text'" class-prefix="btn-eye-1" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-6.png?v=1" @click="changeInputType('password')" />
                <van-icon v-show="inputType==='password'" class-prefix="btn-eye-2" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-5.png?v=1" @click="changeInputType('text')" />
            </div>
            <div class="row row-3 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-4.png">
                    <p>验证码</p>
                </div>
                <input v-model="formData.code" placeholder="请输入验证码" placeholder-class="input-placeholder" type="number" :focus="focus.code" @keyup.enter="handleLogin">
                <img v-show="formData.code.length > 0" style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-8.png" @click="clearCode">
                <van-image class="imageCode" width="79px" height="38px" :src="codeImageUrl+'?randomStr='+formData.randomStr" @click="refreshImageCode" />
                <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-9.png" @click="refreshImageCode">
            </div>
            <div class="row-5">
                <van-checkbox v-model="checked" shape="square" use-icon-slot>阅读并同意恒昌健康的
                    <span style="color:#ED3129;" @click="$router.push({path:'/account/service',query:{source:'h5'}})">《用户协议》</span>
                    <span style="color:#ED3129;" @click="$router.push({path:'/account/privacy',query:{source:'h5'}})">《隐私政策》</span>
                    <!-- <img slot="icon" :src="checked ? activeIcon : inactiveIcon"> -->
                </van-checkbox>
            </div>
            <div class="row row-4">
                <van-button
                    v-model="loading"
                    type="danger"
                    :disabled="!checked || !formData.username || !formData.password || !formData.code"
                    size="large"
                    round
                    @click="login"
                >登 录</van-button>
            </div>
            <p class="navigator" @click="changePassword">忘记密码</p>
        </div>

        <!-- <a class="go-to" href="https://www.hnhcyy.com/#/account/login?from=mobile">
            电脑端入口
            <img src="@/assets/images/entrance.png" alt="">
        </a> -->

        <div v-show="showServe" class="footer-box">
            <!-- <a class="go-to" href="https://www.hnhcyy.com/#/account/login?from=mobile">
                电脑端入口
                <img src="@/assets/images/entrance.png" alt="">
            </a> -->
            <p class="go-to" @click="changeUrl">
                电脑端入口
                <img src="@/assets/images/entrance.png" alt="">
            </p>
            <div class="server-text">
                <p class="server">服务顾问:</p>
                <a data-phone="400-662-4000" href="tel:400-662-4000">
                    <p class="phone">400-662-4000</p>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-10.png">
                </a>
            </div>
        </div>
        <win-select-club ref="refSelectClub" :form-data="formData" />
        <win-not-open-account ref="refNotOpenAccount" />
        <!-- 提交申诉成功提示 -->
        <van-dialog v-model="show" :show-confirm-button="false">
            <div class="dialog-box">
                <i class="close-btn" @click="show = false;"><img src="@/assets/images/&times.png" alt=""></i>
                <h6 class="title">温馨提示</h6>
                <p>欢迎使用恒昌健康APP<br>为了您的账户安全，请您重置密码</p>
            </div>
            <div class="dialog-footer">
                <div class="btn cancel-btn" @click="show=false">暂不处理</div>
                <div class="btn confirm-btn" @click="changePassword">立即修改</div>
            </div>
        </van-dialog>
        <van-dialog v-model="showDownloadTips" class="download-app-dialog" :show-confirm-button="false">
            <!-- <img class="download-app" src="@/assets/images/download-app-bg.png" alt=""> -->
            <div class="dialog-footer download-app-footer">
                <div class="btn cancel-btn" @click="useH5">使用网页版</div>
                <div class="btn confirm-btn" @click="downloadApp">下载App</div>
            </div>
        </van-dialog>
    </div>
</template>

<script>
import { baseURL } from '@/utils/urls'
import { compile, uncompile } from '@/utils/util'
import { validatenull } from '@/utils/validate'
import WinSelectClub from '@/components/selectClub/Index'
import Api from '@/api/account/login'
import WinNotOpenAccount from './dialog/index';
import { Toast } from 'vant'
import { GetQueryString } from '@/utils/util'

export default {
    components: {
        WinSelectClub,
        WinNotOpenAccount
    },
    data() {
        return {
            codeImageUrl: baseURL + "/code",
            formData: {
                randomStr: new Date().getTime(),
                username: localStorage.getItem("loginInfo") ? JSON.parse(localStorage.getItem("loginInfo")).username : '',
                password: localStorage.getItem("loginInfo") ? uncompile(JSON.parse(localStorage.getItem("loginInfo")).password) : '',
                code: ''
            },
            clubs: [],
            inputType: 'password',
            focus: {},
            code: {
                len: 4
            },
            checked: false,
            activeIcon: 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-6.png',
            inactiveIcon: 'https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-5.png',
            flag: false,
            isShowAccountLogin: true,
            loading: false,
            showServe: true,
            show: false,
            showDownloadTips: GetQueryString("isFromJYGW") !== 'wx'
        }
    },
    computed: {
        height: function() {
            return this.$store.getters.winHeight
        }
    },
    mounted(){
        if (this.$store.getters.token && this.$route.query.linkUrl){
            const queryParams = Object.assign({}, this.$route.query) 
            delete queryParams.linkUrl
            this.$router.push({
                path: this.$route.query.linkUrl,
                query: queryParams
            })
        }
        document.getElementsByTagName("body")[0].className = "login-index";
        if (localStorage.getItem("loginInfo") && (JSON.parse(localStorage.getItem("loginInfo"))).password === ''){
            this.formData.password = ''
        }
        this.showServeFn();
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "login-index");
    },
    methods: {
        showServeFn(){
            const ua = window.navigator.userAgent.toLocaleLowerCase();
            const isAndroid = /android/.test(ua);
            if (isAndroid) {
                window.addEventListener('resize', () => {
                    this.showServe = !this.showServe;
                })
            } else {
                document.body.addEventListener('focusin', () => {
                    this.showServe = false;
                })
                document.body.addEventListener('focusout', () => {
                    this.showServe = true;
                })
            }
        },
        changePassword(){
            this.$router.push({
                path: '/account/register',
                query: {
                    username: this.formData.username
                }
            })
        },
        // 回车登录
        handleLogin(){
            this.login()
        },
        /**
         * 清空账号
         */
        clearUser(){
            this.formData.username = ''
        },
        /**
         * 清空验证码
         */
        clearCode(){
            this.formData.code = ''
        },
        /**
         * 刷新验证码
         */
        refreshImageCode() {
            this.formData.code = ''
            this.formData.randomStr = new Date().getTime()
        },
        /**
         * 密码是否明文显示
         */
        changeInputType(type) {
            this.inputType = type
        },
        /**
         * 表单验证
         */
        formValidate(callback) {
            if (validatenull(this.formData.username)) {
                this.$toast("用户名不能为空");
                this.focus.username = true;
                return false;
            }
            if (validatenull(this.formData.password)) {
                this.$toast("密码不能为空");
                this.focus.password = true;
                return false;
            }
            if (validatenull(this.formData.code)) {
                this.$toast("验证码不能为空");
                this.focus.code = true;
                return false;
            }
            callback();
        },
        /**
         * 登录
         */
        login() {
            this.formValidate(() => {
                this.$store.commit("setUserAccount", encodeURIComponent(JSON.stringify(this.formData)))
                if (!this.checked){
                    Toast("请同意《商城用户服务协议》")
                    return;
                }
                this.loginAction(this.formData)
            })
        },
        loginAction(formData) {
            Toast.loading({
                message: '正在登录...',
                duration: 0
            })
            Api.login(formData).then((res) => {
                // 账号关闭重开提醒
                if (res.data.code === 181013) {
                    this.$refs.refNotOpenAccount.open({
                        status: 1,
                        msg: res.data.msg
                    }, () => { // 申请重开
                        this.$refs.refNotOpenAccount.loading = true;
                        Api.accountOpenStauts({
                            type: 1,
                            account: this.formData.username
                        }).then(({ data: { msg, code, data }}) => {
                            this.$refs.refNotOpenAccount.loading = false;
                            if (code === 2) { // 审核中
                                this.$refs.refNotOpenAccount.refreshStatus({
                                    status: 3,
                                    msg: msg,
                                    managerList: data || []
                                });
                            } else { // 申请重开填写问答卷
                                this.$router.push({
                                    path: '/account/reopenAccount',
                                    query: { 
                                        username: this.formData.username,
                                        source: 'h5' 
                                    }
                                });
                            }
                        })
                    });
                    Toast.clear();
                    return;
                } else if (res.data.code === 181014) {
                    Toast.clear();
                    this.show = true;
                    return;
                }
                // 登陆流程
                Toast.clear();
                this.clubs = res.data.data.clubs || []
                // localStorage.removeItem('isShowClassGuide')
                // localStorage.removeItem('isShowGuide')
                localStorage.removeItem('popFlag')
                localStorage.removeItem('popFlagCfy')
                localStorage.removeItem('qftFlag')
                if (res.data.code === 111000) {
                    this.$refs['refSelectClub'].open(res.data.data.clubs || [], club => {
                        this.loginAction(Object.assign({}, this.formData, { currentId: club }))
                    })
                } else {
                    this.$store.commit("setToken", 'Bearer ' + res.data.data.access_token)
                    this.$store.commit("setCartAdded");
                    const store = res.data.data.stores ? res.data.data.stores.filter(store => store.sid - 0 === res.data.data.sid - 0)[0] : {};
                    const userInfo = {
                        currentType: res.data.data.currentType,
                        isFree: res.data.data.isFree,
                        oss: res.data.data.ossServerAddress,
                        stores: res.data.data.stores,
                        clubs: this.clubs,
                        sid: res.data.data.sid,
                        account: store.account,
                        name: store.name,
                        supplySid: res.data.data.supplySid
                    }
                    if (res.data.data.isFree !== 0){
                        localStorage.setItem('qftFlag', true)
                    }
                    localStorage.setItem("isShowNeedKnow", true)
                    const loginInfo = {
                        username: this.formData.username,
                        password: compile(this.formData.password)
                    }
                    localStorage.setItem("loginInfo", JSON.stringify(loginInfo))
                    this.$store.commit('setUserInfo', userInfo)
                    this.$store.commit('setCartNum')
                    this.$store.commit('setBusinessScope')
                    if (this.$route.query.linkUrl && this.$route.query.linkUrl !== '' && this.$route.name !== 'AccountLogin'){
                        const queryParams = Object.assign({}, this.$route.query) 
                        delete queryParams.linkUrl
                        this.$router.push({
                            path: this.$route.query.linkUrl,
                            query: queryParams
                        })
                    } else {
                        var isFromJYGW = GetQueryString("isFromJYGW");
                        if (isFromJYGW === 'wx'){
                            this.$router.push('/bi/signUpYLLT?source=h5&&isFromJYGW=wx');
                        } else {
                            this.$router.push("/")
                        }     
                    }
                }
            }).catch(() => {
                Toast.clear();
                // this.refreshImageCode()
            })
        },
        /**
         * 微信登录
         */
        wxLogin() {

        },
        changeUrl(){
            const setWebsite = GetQueryString('setWebsite')
            if (setWebsite === 'www.hcyycq.com'){
                window.location.href = "https://www.hcyycq.com/#/account/login?from=mobile"
            } else if (setWebsite === 'www.tjhzhcyy.com'){
                window.location.href = "https://www.tjhzhcyy.com/#/account/login?from=mobile"
            } else if (setWebsite === 'www.hnhcyy.com'){
                window.location.href = "https://www.hnhcyy.com/#/account/login?from=mobile"
            } else {
                window.location.href = "https://www.hcjk.com/#/account/login?from=mobile"
            }
        },
        downloadApp() {
            location.href = 'https://www.hcjk.com/mobile/appDownload.html';
        },
        useH5() {
            this.showDownloadTips = false;
        }
    }
}
</script>

<style lang="scss">
html,.login-index{ width: 100%; height: 100%; overflow: scroll}
.Page-account-login {
    // .van-popup {
    //     width: 90%;
    // }
    input:-webkit-autofill {
        box-shadow: 0 0 0px 1000px white inset;
    }
    .login-title {
        display: flex;
        padding: 0.64rem 0.4rem 0 0.4rem;
        font-weight: 600;
        img:nth-child(1){
            margin-top: 0.06rem;
        }
        img:nth-child(3){
            margin-left: 1.4rem;
            margin-top: 0.06rem;
        }
        span {
            font-size: 0.36rem;
            line-height: 0.6rem;
            padding-left: 0.2rem;
            padding-right: 1.22rem;
            color: #ED3129;
        }
    }
    .login-form {
        margin: 0.8rem 0.4rem 0 0.4rem;
        .row {
            margin-bottom: 0.4rem;
            div{
                display: flex;
                height: 0.48rem;
                width: 1.7rem;
                margin-bottom: 0.22rem;
                img{
                    margin-right: 0.16rem;
                }
                p{
                    color: #666;
                    font-size: 0.32rem;
                    font-weight: 600;
                    line-height: 0.52rem;
                    letter-spacing: 1px;
                }
            }
            input {
                font-size: 0.32rem;
                caret-color: #ed3129;
                border: 0;
                position: relative;
                width: 80%;
                color: #333333;
                padding-bottom: 0.14rem;  
            }
            img:nth-child(3){
                position: absolute;
                top: 0.64rem;
                right: 0;
            }
            ::placeholder {
                color: #cccccc;
                font-size: 0.32rem;
            }
        }

        .row-2 {
            position: relative;
            input {
                float: left;
                width: 4.6rem;
                border: 0;
                letter-spacing: 1px;
            }
            .btn-eye-1,
            .btn-eye-2 {
                position: absolute;
                right: 0;
                font-size: 0.48rem;
                top: 0.64rem;
            }
            &.text {
                .btn-eye-2 {
                    display: none;
                }
            }
            &.password {
                .btn-eye-1 {
                    display: none;
                }
            }
        }

        .row-3 {
            input {
                width: 4rem;
                letter-spacing: 1px;
            }
            .imageCode {
                position: absolute;
                right: 0.8rem;
                bottom: -0.2rem;
                .van-image__img{
                    margin-left: 0.16rem;
                }
                .van-image__error, .van-image__img, .van-image__loading {
                    height: 100%;
                }
            }
            img:nth-child(3){
                position: absolute;
                left: 3.36rem;
            }
            img:nth-child(5){
                position: absolute;
                top: 0.62rem;
                right: 0;
            }
            &::before {
                width: 120%;
            }
        }

        .row-4 {
            padding-top: 0.34rem;
            margin-bottom: 0;
            .van-button {
                height: 0.88rem;
                line-height: 0.88rem;
                font-size: 0.36rem;
                color: #fff;
                border: none;
                font-weight: 500;
            }
            :disabled{  
                opacity: 0.2;
            }
            .van-button__content{
                width: 100%;
                margin-bottom: 0;
            }
        }
        .row-5{
            display: flex;
            justify-content: space-between;
            .van-checkbox__label{
                display: flex;
                font-size: 0.28rem;
                color: #999;
                margin-left: 0.14rem;
                img{
                    height: 0.32rem;
                    width: 0.32rem;
                }
            }
            .van-checkbox__icon{
                line-height: 0.3rem;
                font-size: 16px;
            }
            .van-checkbox__icon{
                height: 0.32rem;
                width: 0.32rem;
                img{
                    height: 100%;
                    width: 100%;
                }
            }
            .van-checkbox__icon .van-icon{
                height: 100%;
                width: 100%;
                border-radius: 0.08rem;
            }
            .van-checkbox__icon--checked i.van-icon {
                background-color: #fff;
                border-color: #ed3129;
                color: #ed3129;
            }
        }
        .navigator {
            margin-top: .48rem;
            text-align: center;
            color: #666;
            font-size:0.29rem ;
        }
    }
    .footer-box {
        position: fixed;
        text-align: center;
        bottom: 0;
        width: 100%;
        transform: translateZ(0);
        .go-to{
            display: flex;
            align-items: center;
            font-size: .28rem;
            color: #14A9FF;
            cursor: pointer;
            justify-content: center;
            margin-bottom: .24rem;
        img{
            height: .32rem;
            width: .32rem;
            margin-left: .08rem;
            }
        }
        .server-text{
            height: 0.62rem;
            // width: 4.54rem;
            margin: 0 1.48rem 0.4rem 1.48rem;
            // padding-bottom: 20px;
            display: flex;
            .server{
                font-size: 0.29rem;
                color: #bbb;
                margin-top: 0.12rem;
            }
            a{
                line-height: 0.62rem;
                height: 0.62rem;
                border-radius:0.32rem ;
                background: #f6f6f6;
                margin-left: 0.16rem;
                display: flex;
                .phone{
                    color: #666;
                    font-size: 0.29rem;
                    letter-spacing: 0.02rem;
                    margin: 0.01rem 0.14rem 0;
                }
                img{
                    margin-top: 0.06rem;
                }
            }
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
    .download-app-dialog{
        width: 6.54rem;
        height: 7.32rem;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/download-app-bg.png') no-repeat;
        background-size: 100% auto;
        .download-app{
            width: 100%;
            height: 100%;
        }
        .download-app-footer {
            position: absolute;
            left: 0;
            bottom: 0;
            .btn{
                margin: 0 0 .4rem .4rem;
            }
        }
    }
    
}
.van-toast--html, .van-toast--text{
    padding: 0.22rem;
}
.van-toast{
    top: 41%;
}
</style>
