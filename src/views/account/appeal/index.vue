<template>
    <div class="app-account-appeal personal-box">
        <div class="container">
            <!-- 步骤导航 -->
            <ul class="nav-steps">
                <li :class="['step first-step', active >= 1 ? 'active-step' : '']">
                    <div>1</div>
                    <p>填写单位名称、原手机号、姓名</p>
                </li>
                <li :class="['step', active >= 2 ? 'active-step' : '']">
                    <div>2</div>
                    <p>填写新手机号验证码</p>
                </li>
                <li :class="['step', active >= 3 ? 'active-step' : '']">
                    <div>3</div>
                    <p>上传手持身份证照</p>
                </li>
            </ul>
            <ul v-show="active === 1" class="user-info">
                <li class="input-item">
                    <div class="title">
                        <img src="@/assets/images/login-store.png" class="icon-20">
                        <span>单位名称</span>
                    </div>
                    <p :class="['content', userNameError ? 'is-error' : '']">
                        <input v-model.trim="userName" type="text" placeholder="请输入单位名称" @blur="checkAccount">
                        <img v-show="userName" src="@/assets/images/empty-word.png" @click="empty">
                    </p>
                    <div v-show="userNameError" class="error-tips">{{ userNameError }}</div>
                </li>
                <li class="input-item">
                    <div class="title">
                        <img src="@/assets/images/icon-login-phone.png" class="icon">
                        <span>原手机号码</span>
                    </div>
                    <p class="content">
                        <input v-model.number="phone" type="number" placeholder="请输入原手机号码" @keyup="checkOldPhone" @blur="checkOldPhone">
                    </p>
                    <div v-show="phoneError" class="error-tips">{{ phoneError }}</div>
                </li>
                <li class="input-item">
                    <div class="title">
                        <img src="@/assets/images/login-legal-person.png" class="icon-20">
                        <span>法人姓名</span>
                    </div>
                    <p class="content">
                        <input v-model.trim="legalPerson" type="text" placeholder="请输入法人姓名" @blur="checkLP">
                    </p>
                    <div v-show="lpError" class="error-tips">{{ lpError }}</div>
                </li>
            </ul>
            <ul v-show="active === 2" class="user-info">
                <li class="input-item">
                    <div class="title">
                        <img src="@/assets/images/icon-login-phone.png" class="icon">
                        <span>新手机号码</span>
                    </div>
                    <p :class="['content', newPhoneError ? 'is-error':'']">
                        <input v-model.number="newPhone" type="number" placeholder="请输入新手机号码" @keyup="checkPhone" @blur="checkPhone">
                        <img v-show="newPhone" src="@/assets/images/empty-word.png" @click="newPhone = ''">
                    </p>
                    <div v-show="newPhoneError" class="error-tips">{{ newPhoneError }}</div>
                </li>
                <li class="input-item">
                    <div class="title">
                        <img src="@/assets/images/icon-login-4.png" class="icon">
                        <span>验证码</span>
                    </div>
                    <p class="content">
                        <input v-model.trim="code" class="flex-none-code" type="text" placeholder="请输入验证码" @input="codeError=''">
                        <i class="line" />
                        <countDownTimer :timestamp="timestamp" from="appealPhoneTimestamp" #default="scope">
                            <span v-if="scope.time <= 0" class="line-text code" @click="getCode(scope.init)">获取验证码</span>
                            <span v-else class="resend">{{ scope.time }}s重新发送</span>
                        </countDownTimer>
                    </p>
                    <div v-show="codeError" class="error-tips">{{ codeError }}</div>
                </li>
            </ul>
            <ul v-show="active === 3" class="user-info">
                <li class="input-upload">
                    <template v-if="imgUrl">
                        <img class="main-img" :src="ossUrl+imgUrl" alt="">
                        <img class="delete-btn" src="@/assets/images/empty-word.png" alt="" @click="deleteFile">
                    </template>
                    <template v-else>
                        <div class="upload-box">
                            +
                            <input ref="myfile" accept=".jpg,.png,.jpeg" name="myfile" type="file" @change="uploadFile">
                        </div>
                        <p>点击上传</p>
                    </template>
                    <input v-show="false" id="base64Image" type="file">
                </li>
                <li class="file-tips">注意：为了保证您的账户安全，核实您的账号信息，请上传手持身份证照
                    <span class="show-example" @click="showExample">查看上传示例</span>
                </li>
            </ul>
        </div>
        <div :class="['footer', active=== 1 ? '':'btns']">
            <p v-if="active > 1" class="prev" @click="active--;">上一步</p>
            <p :class="isOk ? '':'is-ok'" @click="nextStep">{{ active === 3 ? '上 传' : '下一步' }}</p>
        </div>
        <!-- 提交申诉成功提示 -->
        <van-dialog v-model="show" :show-confirm-button="false">
            <div class="dialog-box">
                <i class="close-btn" @click="show = false;"><img src="@/assets/images/&times.png" alt=""></i>
                <h6 class="title">提交成功</h6>
                <p>您的资料已上传，我们将在48小时内反馈结果，请耐心等待~</p>
            </div>
            <div class="confirm-btn" @click="backFn">好 的</div>
        </van-dialog>
        <!-- 上传示例 -->
        <van-action-sheet
            v-model="showSheet"
            close-on-click-action
            :class="['add-cart-spec-sheet', 'theme-'+currentType]"
            get-container="body"
        >
            <div class="spec-box">
                <i class="close-btn" @click="showSheet = false;"><img src="@/assets/images/&times.png" alt=""></i>
                <h6 class="sheet-title">上传照片示例</h6>
                <div class="flex">
                    <div class="success-img">
                        <img src="@/assets/images/success_example.png" alt="">
                    </div>
                    <div class="error-imgs">
                        <img src="@/assets/images/error_example.png" alt="">
                        <img src="@/assets/images/error_example2.png" alt="">
                    </div>
                </div>
            </div>
            <div class="footer">
                <p :class="isOk ? '':'is-ok'">知道了</p>
            </div>
        </van-action-sheet>
    </div>
</template>

<script>
import Api from '@/api/account/retrievePassword'
import regx from '@/utils/regex';
import countDownTimer from '@/components/countDwonTimer';
import lrz from 'lrz'
export default {
    components: {
        countDownTimer
    },
    data() {
        return {
            active: 1,
            userName: '',
            userNameError: '',
            account: this.$route.query.account || '',
            userCode: '',
            phone: '',
            phoneError: '',
            legalPerson: '',
            lpError: '',
            newPhone: '',
            newPhoneError: '',
            timestamp: localStorage.appealPhoneTimestamp || 0,
            code: '',
            codeError: '',
            file: '',
            show: false,
            showSheet: false,
            ossUrl: this.$route.query.url || 'https://imga.hnhcyy.com/',
            imgUrl: ''
        };
    },
    computed: {
        isOk() {
            if (this.active === 1) {
                if (this.userName && !this.userNameError && this.phone && this.legalPerson){
                    return false;
                } else {
                    return true;
                }
            } else if (this.active === 2){
                if (this.newPhone && !this.newPhoneError && this.code && !this.codeError){
                    return false;
                } else {
                    return true;
                }
            } else if (this.active === 3){
                if (!this.imgUrl) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        }
    },
    created() {

    },
    mounted() {

    },
    methods: {
        nextStep() {
            if (this.isOk) return;
            if (this.active === 1) {
                this.active++;
            } else if (this.active === 2){
                Api.checkUserInfo(this.code, this.newPhone).then(({ data: { code, msg }}) => {
                    if (code === 800004) {
                        this.codeError = msg;
                        this.code = '';
                    } else {
                        this.active++;
                    }
                })
            } else {
                this.submitFn();
            }
        },
        showExample() {
            this.showSheet = true;
        },
        // 获取手机号码
        checkAccount() {
            if (this.phone && this.legalPerson) return;
            if (this.userName) {
                this.userNameError = '';
                // Api.verification(this.userName).then(({ data: { data, code, msg }}) => {
                //     if (code === 800008) {
                //         this.userNameError = msg;
                //     } else if (data) {
                //         this.phone = data.phone;
                //         this.account = data.account;
                //         // this.legalPerson = data.legalPerson;
                //         this.ossUrl = data.imgUrl;
                //         this.userCode = data.userCode;
                //     } else {
                //         this.userNameError = msg;
                //     }
                // }).catch(msg => {
                //     this.userNameError = msg;
                // })
            } else {
                this.userNameError = '单位名称不能为空或空字符';
            }
        },
        // 清空登录账号
        empty() {
            this.userName = '';
            this.phone = '';
            // this.account = '';
            this.legalPerson = '';
        },
        // 原号码校验
        checkOldPhone() {
            if (this.phone) {
                if (regx.mobile.test(this.phone)) {
                    this.phoneError = '';
                } else {
                    this.phoneError = '请输入正确的手机号码';
                }
            } else {
                this.phoneError = '请输入正确的手机号码';
            }
        },
        // 新号码校验
        checkPhone() {
            if (this.newPhone) {
                if (regx.mobile.test(this.newPhone)) {
                    this.newPhoneError = '';
                } else {
                    this.newPhoneError = '请输入正确的手机号码';
                }
            } else {
                this.newPhoneError = '请输入正确的手机号码';
            }
        },
        // 法人校验
        checkLP() {
            if (this.legalPerson === '') {
                this.lpError = '法人姓名不能为空或空字符';
            } else {
                this.lpError = '';
            }
        },
        // 获取验证码
        getCode(callback) {
            if (this.newPhone && !this.newPhoneError) {
                this.codeError = '';
                this.code = '';
                Api.getNphoneCode(this.newPhone).then(({ data: { timestamp }}) => {
                    callback && callback(timestamp);
                })
            }
        },
        // 上传图片
        uploadFile(value) {
            const file = value.target.files[0];
            if (file.size > 1024 * 1024) {
                lrz(file, {
                    quality: 0.5    // 自定义使用压缩方式
                }).then((newFile) => {
                    const data = new FormData()
                    data.append("file", newFile.file, file.name)
                    Api.imgPost(data).then(({ data: { data }}) => {
                        this.imgUrl = data[0];
                    })
                })
            } else {
                const data = new FormData()
                data.append("file", file)
                Api.imgPost(data).then(({ data: { data }}) => {
                    this.imgUrl = data[0];
                })
            }
        },
        // 删除文件
        deleteFile() {
            this.imgUrl = '';
        },
        // 提交申诉
        submitFn() {
            Api.uploadUserInfo({
                userName: this.userName,
                account: this.account,
                // userCode: this.userCode,
                legalPerson: this.legalPerson,
                oldPhone: this.phone,
                newPhone: this.newPhone,
                imgUrl: this.imgUrl
            }).then(({ data }) => {
                this.show = true;
            })
        },
        // 返回登陆
        backFn() {
            if (this.$route.query.from === '1') {
                this.$router.push('/personal/setting');
            } else {
                this.$router.push('/account/login');
            }
        }
    }
};
</script>

<style scoped lang="scss">
.app-account-appeal{
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100vh;
    overflow: hidden;
    background: #F4F4F4;
    .van-steps{
        background: transparent;
    }
    .container{
        flex: 1;
        overflow: auto;
        padding-top: .32rem;
        background: url('~@/assets/images/appeal-bg.png') no-repeat;
        background-size: 100% auto;
        .nav-steps{
            display: flex;
            .step{
                position: relative;
                width: 33.3%;
                div{
                    width: .8rem;
                    height: .8rem;
                    text-align: center;
                    line-height: .8rem;
                    margin: 0 auto;
                    background: #E1BA9D;
                    color: #CD8C5C;
                    border-radius: 50%;
                    border: .02rem solid transparent;
                    font-size: .36rem;
                    font-weight: 600;
                }
                p{
                    width: 1.44rem;
                    text-align: center;
                    line-height: .34rem;
                    margin: 0 auto;
                    padding: .18rem 0 .54rem 0;
                    font-size: .24rem;
                    color: #FFFFFF;
                }
                &::after{
                    position: absolute;
                    left: -50%;
                    top: .42rem;
                    width: 100%;
                    border-bottom: .04rem dashed #D7A37D;
                    content: '';
                    transform: scaleX(0.5);
                }
            }
            .first-step::after{
                display: none;
            }
            .active-step{
                div{
                    border-color: #EBD1BE;
                    background: #FFFFFF;
                }
                p{
                    font-weight: 600;
                }
                &::after{
                    border-color: #FFFFFF;
                }
            }
        }
        .user-info{
            margin: 0 .28rem;
            padding: 0  .4rem .6rem .4rem;
            background: #FFFFFF;
            border-radius: .16rem;
            overflow: hidden;
            .input-item{
                margin-top: .4rem;
                .title{
                    display: flex;
                    height: .46rem;
                    align-items: center;
                    .icon{
                        width: .36rem;
                        height: .4rem;
                    }
                    .icon-20{
                        width: .4rem;
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
                    .icon-pwd{
                        width: .36rem;
                        height: .28rem;
                    }
                    .resend{
                        color: #BBBBBB;
                        font-weight: 500;
                        font-size: .32rem;
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
            .input-upload{
                position: relative;
                height: 3.46rem;
                background: #FAFAFA;
                border-radius: .08rem;
                margin: .4rem 0 .12rem 0;
                overflow: hidden;
                .upload-box{
                    position: relative;
                    width: .92rem;
                    height: .92rem;
                    margin: 0 auto;
                    margin-top: 1rem;
                    border: .02rem dashed #EAEAEA;
                    font-size: .4rem;
                    text-align: center;
                    line-height: .92rem;
                    color: #C4C4C4;
                    input{
                        position: absolute;
                        left: 0;
                        top: 0;
                        z-index: 2;
                        width: .92rem;
                        height: .92rem;
                        opacity: 0;
                    }
                }
                p{
                    text-align: center;
                    font-weight: 600;
                    font-size: .28rem;
                    margin-top: .16rem;
                }
                .main-img{
                    width: 100%;
                    height: 100%;
                    position: absolute;
                    left: 0;
                    top: 0;
                }
                .delete-btn{
                    position: absolute;
                    top: .2rem;
                    right: .2rem;
                    z-index: 3;
                    width: .36rem;
                    height: .36rem;
                }
            }
            .file-tips{
                margin: .32rem 0 .4rem 0;
                color: #999999;
                font-size: .24rem;
                line-height: .44rem;
                .show-example{
                    color: #FF4646;
                    margin-left: .2rem;
                    font-weight: 600;
                }
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
        &.btns{
            display: flex;
            justify-content: space-between;
            p{
                width: 3.32rem;
            }
            .prev{
                background: #FFFFFF;
                border: 1px solid #E8E8E8;
                color: #666666;
            }
        }
    }
    // 提交成功提示
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
        .confirm-btn{
            width: 2.68rem;
            height: .8rem;
            margin: .8rem auto .4rem auto;
            text-align: center;
            line-height: .8rem;
            color: #FFFFFF;
            background: #FF4646;
            border-radius: .4rem;
            font-weight: 600;
            font-size: .28rem;
        }
    }
}

.add-cart-spec-sheet{
    background: transparent;
    font-size: .28rem;
    box-sizing: border-box;
    max-height: 85vh;
    .van-action-sheet__content{
        max-height: 85vh;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        background: #FFFFFF;
        border-top-left-radius: .32rem;
        border-top-right-radius: .32rem;
    }
    .spec-box{
        flex: 1;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        position: relative;
        width: 100%;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/spec-bg.png') no-repeat;
        background-size: 100% auto;
        .sheet-title{
            font-size: .32rem;
            line-height: .44rem;
            padding: .4rem .28rem .56rem .28rem;
            text-align: center;
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
        .flex{
            flex: 1;
            overflow: auto;
            padding: 0 .28rem;
        }
        .success-img{
            width: 6.94rem;
            height: 4.78rem;
            border-radius: .24rem;
            img{
                width: 100%;
                height: 100%;
            }
        }
        .error-imgs{
            display: flex;
            justify-content: space-between;
            margin-top: .32rem;
            margin-bottom: .6rem;
            img{
                width: 3.32rem;
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
            background: #FF4646;
            color: #FFFFFF;
            border-radius: .4rem;
        }
    }
}

</style>
