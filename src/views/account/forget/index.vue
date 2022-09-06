<template>
    <div class="page-index-forget">
        <div class="top-div" />
        <div class="center-div">
            <div class="row row-1 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-2.png">
                    <p>账号</p>
                </div>
                <input v-model="username" placeholder="请输入ID号、手机号+区分号" placeholder-class="input-placeholder">
                <img v-show="username.length > 0" class="del" style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-8.png" @click="clearUser">
            </div>
            <div class="row row-2 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-4.png">
                    <p>验证码</p>
                </div>
                <div>
                    <input v-model="sms" label="验证码" placeholder="请输入验证码" placeholder-class="input-placeholder" type="number">
                    <button ref="abc" class="btn" @click="getCode">{{ code }}</button>
                </div>
            </div>
            <div class="row row-3 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-3.png">
                    <p>新密码</p>
                </div>
                <input v-model="password" :type="inputType" placeholder="6-16位数字或字母" placeholder-class="input-placeholder">
                <van-icon v-show="inputType==='text'" class-prefix="btn-eye-1" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-6.png?v=1" @click="changeInputType('password')" />
                <van-icon v-show="inputType==='password'" class-prefix="btn-eye-2" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-5.png?v=1" @click="changeInputType('text')" />
            </div>
            <div class="row row-3 border-bottom clearfix">
                <div>
                    <img style="height:0.48rem;width:0.48rem" src="@/assets/images/icon-login-13.png">
                    <p>确认密码</p>
                </div>
                <input v-model="comfirmPassword" :type="inputTypes" placeholder="请再次输入新密码" placeholder-class="input-placeholder">
                <van-icon v-show="inputTypes==='text'" class-prefix="btn-eye-1" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-6.png?v=1" @click="nextInputType('password')" />
                <van-icon v-show="inputTypes==='password'" class-prefix="btn-eye-2" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-login-5.png?v=1" @click="nextInputType('text')" />
            </div>
        </div>
        <div class="row row-btn">
            <van-button :disabled="!username || !sms || !password || !comfirmPassword" type="danger" size="large" round @click="resetPwd">确认修改</van-button>
        </div>
    </div>
</template>

<script>
import Api from '@/api/account/forget'
import { Toast } from 'vant'
export default {
    name: 'Forget',
    components: {
        
    },
    data(){
        return {
            username: this.$route.query.username,
            sms: '',
            password: '',
            comfirmPassword: '',
            disabled: false,
            code: "获取验证码",
            inputType: 'password',
            inputTypes: 'password'
        }
    },
    methods: {
        /**
         * 清空账号
         */
        clearUser(){
            this.username = ''
        },
        /**
         * 密码是否明文显示
         */
        changeInputType(type) {
            this.inputType = type
        },
        nextInputType(type){
            this.inputTypes = type
        },
        getCode(){
            if (this.username === ''){
                Toast('请输入账号')
                return
            }
            Api.getCode(this.username).then((res) => {
                this.$refs.abc.style.color = '#bbbbbb'
                this.$refs.abc.style.background = '#eeeeee'
                this.$refs.abc.style.border = '2px solid #eeeeee'
                Toast.success('验证码发送成功')
                let time = 90;
                this.code = '90s重新发送'
                this.disabled = true
                const Interval = setInterval(() => {
                    time--;
                    if (time > 0) {
                        this.code = time + 's重新发送'
                    } else {
                        clearInterval(Interval);
                        this.code = '重新发送'
                        this.disabled = false
                        this.$refs.abc.style.color = '#ED3129'
                        this.$refs.abc.style.background = '#ffffff'
                        this.$refs.abc.style.border = '2px solid #ED3129'
                    }
                }, 1000)
            })
        },
        resetPwd(){
            if (this.sms === ''){
                Toast('验证码不能为空')
            } else if (this.password === '') {
                Toast('密码不能为空！')
            } else if (this.password.length < 6 || this.password.length > 16){
                Toast('密码长度不符合规则，请重新输入！')
            } else if (this.password !== this.comfirmPassword){
                Toast('两次输入密码不一致，请核实！')
            } else {
                const formData = {
                    userName: this.username,
                    code: this.sms,
                    pwd: this.password
                }
                Api.changePwd(formData).then((res) => {
                    const item = JSON.parse(localStorage.getItem("loginInfo"))
                    item.password = ''
                    localStorage.setItem("loginInfo", JSON.stringify(item))
                    Toast.success(res.data.msg)
                    this.$router.push(`/account/login`)
                })
            }
        }
    }
}
</script>

<style lang="scss">
    .page-index-forget{
        .van-hairline--top-bottom::after, .van-hairline-unset--top-bottom::after{
            border: none;
        }
        .center-div{
            margin: 0 0.4rem;
            .row{
                div:nth-child(1){
                    display: flex;
                    height: 0.48rem;
                    width: 3rem;
                    margin: 0.61rem 0 0.22rem 0;
                }
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
                input {
                    font-size: 0.32rem;
                    caret-color: #ed3129;
                    border: 0;
                    position: relative;
                    width: 100%;
                    color:#333333;
                    padding-bottom: 0.14rem;
                }
                .input .textarea{
                    border: none;
                }
                ::placeholder {
                    color: #cccccc;
                    font-size: 0.32rem;
                }
            }
            .row-1{
                position: relative;
                .del{
                    position: absolute;
                    right: -0.22rem;
                    bottom: 0.06rem;
                }
            }
            .row-2{
                input{
                    width: 40%;
                    margin-bottom: -0.28rem;
                    letter-spacing: 1px;
                }
                .btn{
                    width: 2.4rem;
                    height: 0.6rem;
                    font-size: 0.32rem;
                    line-height: 0.6rem;
                    border: 2px solid #ED3129;
                    margin-bottom: 0.18rem;
                    border-radius: 0.3rem;
                    text-align: center;
                    color: #ED3129;
                    background: #fff;
                }
                div:nth-child(1){
                    margin: 0.4rem 0 0 0 ;
                }
                div:nth-child(2){
                    display: flex;
                    justify-content:space-between;
                }
            }
            .row-3{
                position: relative;
                div:nth-child(1){
                    margin: 0.4rem 0 0.2rem 0;
                }
                input {
                    padding-bottom: 0.16rem;
                    letter-spacing: 1px;
                }
                .van-icon__image{
                    position: absolute;
                    height: 0.48rem;
                    width: 0.48rem;
                    right: -0.2rem;
                    bottom: 0.08rem;
                }
            }
        }
        .row-btn {
            padding: .4rem .4rem 0 .4rem;
            .van-button {
                border: none;
                height: .88rem;
                line-height: .88rem;
                font-size: .36rem;
                font-weight: 500;
                color: #ffffff;
                &.van-button--danger {
                    background-color: #ED3129;
                }
            }
            :disabled{  
                opacity: 0.2;
            }
        }
    }
</style>
