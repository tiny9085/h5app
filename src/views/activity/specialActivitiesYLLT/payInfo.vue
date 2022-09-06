<template>
    <div>
        <div v-if="!isApp" class="personal-box" />
        <div class="special-activities-YLLT">
            <!-- 支付页 -->
            <div class="pay-info-box">
                <h6 class="activity-title">
                    <img src="@/assets/images/vector-left.png" alt="">
                    <span>{{ specialYLLTObj.title }}</span>
                    <img src="@/assets/images/vector-right.png" alt="">
                </h6>
                <p class="row">
                    <span>会员名称：</span>
                    <span @click="openMemberList">{{ qrCodeParams.userName ? qrCodeParams.userName : '请选择活动会员' }}
                        <img v-if="memberList.length > 1" src="@/assets/images/select-member.png" alt="">
                    </span>
                </p>
                <p class="row"><span>会员编码：</span><span class="right-color">{{ qrCodeParams.userCode }}</span></p>
                <p class="row activity-content">
                    <span>活动政策：</span>
                    <span class="right-color">{{ specialYLLTObj.des }}</span>
                </p>
                <img class="split-pay" src="@/assets/images/split-pay.png" alt="">
                <!-- <div v-if="qrCodeParams.userCode && specialYLLTObj.supplySid - 0 === 1" class="qr-code-box">
                    <vue-qrcode :value="JSON.stringify(qrCodeParams)" :options="{width:260}" />
                </div> -->
                
            </div>
            <div class="bottom-bar">
                <van-button
                    :disabled="!qrCodeParams.userCode"
                    :loading="paying"
                    loading-type="spinner"
                    loading-text="支付中"
                    round
                    size="small"
                    class="finish-go"
                    @click="createTransferOrder"
                >确 定</van-button>
                <!-- <van-button
                        v-if="specialYLLTObj.supplySid - 0 === 1"
                        :disabled="!qrCodeParams.userCode"
                        :loading="paying"
                        loading-type="spinner"
                        loading-text="支付中"
                        round
                        size="small"
                        class="pay-btn"
                        @click="gotoPay"
                    >立即支付</van-button> -->
            </div>
        </div>
        <!-- 选择会员页 -->
        <van-action-sheet
            v-model="showMember"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <div slot="title" class="sheet-text">
                    <span>请选择活动会员</span>
                    <img src="@/assets/images/close-sheet.png" alt="" @click="showMember = false">
                </div>
                <van-radio-group v-model="qrCodeParams.userCode" class="member-list">
                    <van-radio
                        v-for="item in memberList"
                        :key="item.sid"
                        :name="item.userCode"
                        :class="{'checked-member': qrCodeParams.userCode === item.userCode}"
                    >{{ item.name }}  {{ item.flag === 1 ? '(已参加)' : '' }}</van-radio>
                    <div class="comfirm-btn" @click="submitMember">确定</div>
                </van-radio-group>
            </div>
        </van-action-sheet>
    </div>
</template>

<script>
import Api from '@/api/activity/specialYLLT'
// import VueQrcode from "@chenfengyuan/vue-qrcode"
import VMnative from '@/utils/VMnative'
// import { Dialog } from 'vant'
export default {
    name: 'SpecialYLLTPay',
    // components: {
    //     VueQrcode
    // },
    data(){
        return {
            show: false,
            showMember: false,
            memberList: [],
            paying: false,
            timer: null
        }
    },
    computed: {
        specialYLLTObj() {
            return this.$store.getters.specialYLLTObj || {}
        },
        isApp() {
            return this.$store.getters.specialYLLTObj.isApp
        },
        qrCodeParams() {
            return this.$store.getters.qrCodeParams || {
                userCode: '',
                userName: '',
                activityName: '',
                amount: 0,
                sepecalSid: '',
                userInfoSid: '',
                sn: '',
                supplySid: ''
            }
        }
    },
    activated() {
        this.getNotPayMember();
        // this.refreshStatus();
    },
    created(){
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.specialYLLTObj.activityName)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                this.$router.push('/activity/YLLT');
                responseCallback('1')
            });
        }
        this.getMemberData();
        this.getNotPayMember();
        // this.refreshStatus();
        console.log(this.qrCodeParams)
        console.log(this.specialYLLTObj)
        if (!this.qrCodeParams.userCode) {
            this.qrCodeParams.sepecalSid = this.specialYLLTObj.specialSid;
            this.qrCodeParams.sn = this.specialYLLTObj.sn;
            this.qrCodeParams.activityName = this.specialYLLTObj.activityName + '-' + this.specialYLLTObj.title;
            this.qrCodeParams.amount = this.specialYLLTObj.amount;
            this.qrCodeParams.supplySid = this.specialYLLTObj.supplySid;
            this.$route.meta.title = this.specialYLLTObj.activityName;
        }
    },
    beforeDestroy(){
        // clearInterval(this.timer);
        if (this.isApp) {
            VMnative.callHandler("setTitle", this.specialYLLTObj.activityName)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                this.$router.push('/activity/YLLT');
                responseCallback('1')
            });
        }
    },
    methods: {
        // 立即支付
        gotoPay() {
            this.paying = true;
            const params = {
                userInfoSid: this.qrCodeParams.userInfoSid,
                specialSid: this.specialYLLTObj.specialSid,
                supplySid: this.qrCodeParams.supplySid,
                sn: this.qrCodeParams.sn
            }
            const ua = window.navigator.userAgent.toLowerCase();
            if (ua.indexOf('micromessenger') > -1) {
                params.channelId = 'UMS_H5_WX_CODE';
            } else {
                params.channelId = 'UMS_H5_ALIPAY_CODE';  
            }
            Api.sepecalOnlyNumber(params).then(({ data: { data }}) => {
                this.$store.commit('setQrCodeParams', this.qrCodeParams);
                if (ua.indexOf('micromessenger') > -1) {
                    this.paying = false;
                    // 微信内支付 
                    const appid = 'wx4696e4b4b8ae570d'
                    // const redirect_uri = encodeURIComponent('http://m.hnhcyy.com/#/activity/YLLTPaySuccess')
                    const redirect_uri = encodeURIComponent('http://m-qa.b2b.hcyy.top/#/activity/YLLTPaySuccess')
                    const url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + redirect_uri + '&response_type=code&scope=snsapi_base#wechat_redirect'
                    window.location.href = url
                } else {
                    clearInterval(this.timer);
                    this.getNotPayMember();
                    location.href = data.payAddress;
                }
            }).catch(() => {
                this.paying = false;
            })
        },
        // 获取会员参与专项活动信息
        getMemberData() {
            Api.memberDetail(this.specialYLLTObj.specialSid).then(({ data: { data }}) => {
                this.memberList = data;
                if (this.memberList && this.memberList.length === 1) {
                    this.qrCodeParams.userName = this.memberList[0].name;
                    this.qrCodeParams.userCode = this.memberList[0].userCode;
                    this.qrCodeParams.userInfoSid = this.memberList[0].userInfoSid;
                }
            })
        },
        openMemberList() {
            if (this.memberList.length > 1) this.showMember = true;
        },
        // 获取订单生成状态
        // getPayStatus() {
        //     Api.checkSepecalOrderPayStatus(this.cashflowCode).then(({ data: { data }}) => {
        //         if (data) {
        //             const expireTime = data.expireTime.split('-').join('/');
        //             if (new Date(expireTime).getTime() > new Date().getTime()) {
        //                 // 订单未失效
        //                 if (data.status === 2) {
        //                     this.paying = false;
        //                     this.getNotPayMember();
        //                 }
        //             } else {
        //                 if (this.timer) clearInterval(this.timer);
        //             }
        //         }
        //     })
        // },
        // 刷新订单生成状态
        refreshStatus() {
            this.timer = setInterval(() => {
                this.getNotPayMember();
            }, 5000)
        },
        // 确定会员
        submitMember() {
            this.paying = false;
            const obj = this.memberList.filter(item => item.userCode === this.qrCodeParams.userCode)[0];
            if (obj) {
                if (obj.flag === 1) {
                    this.$router.push(`/activity/YLLTPaySuccess`);
                } else {
                    this.qrCodeParams.userName = obj.name;
                    this.qrCodeParams.userInfoSid = obj.userInfoSid;
                    this.showMember = false;
                }
            }
        },
        // 创建银行转账订单
        createTransferOrder() {
            this.paying = true;
            const params = {
                userInfoSid: this.qrCodeParams.userInfoSid,
                specialSid: this.specialYLLTObj.specialSid,
                supplySid: this.qrCodeParams.supplySid,
                sn: this.qrCodeParams.sn,
                channelId: 'BANK_ACCOUNT_TRANSFER'
            }
            Api.sepecalOnlyNumber(params).then(({ data: { data }}) => {
                // clearInterval(this.timer);
                this.getNotPayMember();
            }).catch(() => {
                this.paying = false;
            })
            // Dialog.confirm({
            //     title: '温馨提示',
            //     message: '确定档次无误并使用银行转账吗？<p>一经确定无法修改</p>',
            //     asyncClose: true,
            //     cancelButtonText: "我再想想",
            //     confirmButtonText: "确 认",
            //     cancelButtonColor: '#999999',
            //     confirmButtonColor: '#FFF',
            //     className: 'mergBtn'
            // }).then(() => {
            //     this.paying = true;
            //     const params = {
            //         userInfoSid: this.qrCodeParams.userInfoSid,
            //         specialSid: this.specialYLLTObj.specialSid,
            //         supplySid: this.qrCodeParams.supplySid,
            //         sn: this.qrCodeParams.sn,
            //         channelId: 'BANK_ACCOUNT_TRANSFER'
            //     }
            //     Api.sepecalOnlyNumber(params).then(({ data: { data }}) => {
            //         clearInterval(this.timer);
            //         this.getNotPayMember();
            //     }).catch(() => {
            //         this.paying = false;
            //     })
            // }).catch(() => {
            //     Dialog.close();
            // });
        },
        // 查询是否有未参加的门店
        getNotPayMember() {
            if (this.qrCodeParams.userCode && !this.showMember) {
                Api.memberDetail(this.specialYLLTObj.specialSid).then(({ data: { data }}) => {
                    const currentMember = data.filter(item => item.userCode === this.qrCodeParams.userCode)[0];
                    if (currentMember && currentMember.flag === 1) {
                        this.paying = false;
                        const memberPayFlag = data.filter(item => item.flag === 0);
                        this.$store.commit('setNotPayMember', memberPayFlag);
                        this.$router.push('/activity/YLLTPaySuccess');
                    }
                }).catch(() => {
                    this.paying = false;
                })
            }
        }
    }
}
</script>

<style lang="scss">
    #app{
        height: 100%;
        .app-wrapper{
            height: 100%;
            .app-main{
                height: 100%;
                .app-page-box{
                    height: 100%;
                    background: #F4F4F4;
                }
            }
        }
    }
    .special-activities-YLLT{
        font-size: .28rem;
        overflow: hidden;
        min-height: 4.34rem;
        background: url(https://imga.hnhcyy.com/fed/b2b-wechat/special_yllt_bg.png?v=1) no-repeat;
        background-size: 100%;
        .activity-title{
            display: flex;
            align-items: center;
            justify-content: center;
            color: #343BEE;
            span{
                margin: .28rem .4rem .2rem .4rem;
                font-size: .32rem;
            }
            img{
                width: .34rem;
                height: .24rem;
            }
        }
        .pay-info-box{
            margin: .16rem;
            margin-top: 2.34rem;
            padding-bottom: .28rem;
            background: linear-gradient(0deg, #FFFFFF, #FFFFFF);
            box-shadow: 0px .08rem .32rem rgba(145, 146, 183, 0.1);
            border-radius: .16rem;
            height: 8.6rem;
            overflow: scroll;
            .row{
                margin: 0 .28rem;
                height: .96rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: .02rem solid #EEEEEE;
                img{
                    width: .12rem;
                    height: .22rem;
                    margin-left: .1rem;
                }
                .right-color{
                    color: #666666;
                    flex: 1;
                    text-align: right;
                }
                :nth-child(2){
                    flex: 1;
                    text-align: right;
                }
            }
            .activity-content{
                height: auto;
                padding: .32rem 0;
                border: none;
            }
            .split-pay{
                width: 100%;
                height: .26rem;
            }
            .qr-code-box{
                display: flex;
                justify-content: center;
                img{
                    width: 2.96rem;
                    height: 2.96rem;
                    margin-top: .52rem;
                }
            }
            .pay-btn{
                margin-left: .38rem;
                color: #FFFFFF;
                background: linear-gradient(90deg, #FFA16D -2.42%, #FF8947 102.42%);
                box-shadow: 0px .08rem .16rem rgba(255, 138, 72, 0.2);
            }
        }
        .bottom-bar{
            height: 1.12rem;
            line-height: 1.12rem;
            text-align: center;
            position: fixed;
            bottom: 0;
            bottom: constant(safe-area-inset-bottom);
            bottom: env(safe-area-inset-bottom);
            background: #ffffff;
            width: 100%;
            .finish-go{
                width: 100%;
                height: .8rem;
                line-height: .8rem;
                text-align: center;
                border-radius: .4rem;
                font-size: .32rem;
                margin-top: 0.16rem;
            }
            .finish-go{
                background: linear-gradient(90deg, #FFA16D 10.71%, #FF8947 102.11%);
                box-shadow: 0px .08rem .16rem rgba(255, 138, 72, 0.2);
                color: #ffffff;
                border: .02rem solid #FFA16D;
            }
        }
        .van-loading{
            width: unset;
            vertical-align: unset;
        }
    }
    .select-member-sheet{
        .sheet-text{
            padding: 0 .28rem;
            height: 1.18rem;
            line-height: 1.18rem;
            font-weight: 600;
            font-size: .32rem;
            border-bottom: .02rem solid #EEEEEE;
            display: flex;
            justify-content: space-between;
            align-items: center;
            img{
                width: .24rem;
                height: .24rem;
            }
        }
        .member-list{
            margin: .24rem 0 .28rem 0;
            padding: 0 .28rem;
            max-height: 6.54rem;
            overflow-y: scroll;
            .van-radio{
                display: flex;
                align-items: center;
                height: .92rem;
                padding: 0 .28rem;
                border-radius: .12rem;
                margin-top: .16rem;
                .van-radio__label{
                    margin-left: .32rem;
                    font-size: .28rem;
                }
            }
            .checked-member{
                background: #FFF5E4;
                .van-radio__label{
                    color: #FF8947;
                }
            }
            .van-radio__icon--checked{
                i.van-icon{
                    background-color: #FFA16D;
                    border-color: #FFA16D;
                }
                .van-icon-success::before{
                    content: '';
                    width: .12rem;
                    height: .12rem;
                    background: #FFFFFF;
                    border-radius: 50%;
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    margin-left: -.06rem;
                    margin-top: -.06rem;
                }
            }
        }
        .comfirm-btn{
            margin-top: .6rem;
            height: .8rem;
            line-height: .8rem;
            text-align: center;
            color: #FFFFFF;
            font-size: .32rem;
            background: linear-gradient(90deg, #FFA16D -2.42%, #FF8947 102.42%);
            box-shadow: 0px .08rem .16rem rgba(255, 138, 72, 0.2);
            border-radius: .4rem;
        }
    }
    .mergBtn{
        .van-dialog__confirm{
            background: #FF8947;
            border-radius: 0;
        }
        .van-dialog__message{
            color: #333333;
        }
        .van-dialog__header{
            font-weight: 600;
        }
    }
</style>
