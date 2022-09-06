<template>
    <div style="background: #F4F4F4;">
        <div v-if="!isApp" class="personal-box" />
        <div class="special-activities-YLLT">
            <div class="pay-finishi">
                <template v-for="item in memberList">
                    <div :key="item.sid" class="member-info" :class="{'member-info-message':!notPayMember.length}">
                        <h6 class="activity-title">
                            <img src="@/assets/images/vector-left.png" alt="">
                            <span>支付结果</span>
                            <img src="@/assets/images/vector-right.png" alt="">
                        </h6>
                        <div class="pay-info">
                            <img src="@/assets/images/lllustration.png" alt="" class="lllustration">

                            <p class="success-tips">恭喜您！已成功参与活动</p>
                            <p class="activity-name">{{ item.des }}</p>

                            <img src="@/assets/images/split-pay.png" alt="" class="split-result">

                            <p class="row"><span>会员编码：</span><span class="right-color">{{ item.userCode }}</span></p>
                            <p class="row">
                                <span>会员名称：</span>
                                <span class="right-color">{{ item.businessName }}</span>
                            </p>
                            <p class="row activity-content">
                                <span>活动类型：</span>
                                <span class="right-color">{{ specialYLLTObj.activityName }}</span>
                            </p>
                            <p class="row activity-content">
                                <span>支付方式：</span>
                                <span class="right-color">{{ payTypeObj[item.channelId] }}</span>
                            </p>
                        </div>
                    </div>
                </template>
            </div>
            <div v-if="notPayMember.length" class="bottom-bar-one">
                <div class="go-special-page" @click="gotoSelectGoods">去选品</div>
                <div class="back-special-list" @click="goBack">继续参与活动</div>
            </div>
            <div v-else class="bottom-bar-two">
                <div class="finish-go" @click="gotoSelectGoods">去选品</div>
            </div>
        </div>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
import Api from '@/api/activity/specialYLLT'
export default {
    name: 'SpecialYLLTPaySuccess',
    data(){
        return {
            winHeight: this.$store.getters.winHeight - 227,
            memberList: [],
            payTypeObj: {
                'BANK_ACCOUNT_TRANSFER': '银行转账',
                'UMS_H5_WX_CODE': '微信支付',
                'UMS_H5_ALIPAY_CODE': '支付宝支付',
                'UMS_POS_PAY': 'POS机支付'
            }
        }
    },
    computed: {
        specialYLLTObj() {
            return this.$store.getters.specialYLLTObj || {}
        },
        isApp() {
            return this.$store.getters.specialYLLTObj.isApp
        },
        notPayMember() {
            return this.$store.getters.notPayMember
        }
    },
    created() {
        this.getData();
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.specialYLLTObj.activityName)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                if (this.$store.getters.notPayMember.length === 0) {
                    responseCallback('0')
                } else {
                    this.$store.commit('setQrCodeParams', {});
                    this.$router.push('/activity/YLLTPay');
                    responseCallback('1')
                }
            });
        }
    },
    beforeDestroy(){
        if (this.isApp) {
            VMnative.callHandler("setTitle", this.specialYLLTObj.activityName)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                if (this.$store.getters.notPayMember.length === 0) {
                    responseCallback('0')
                } else {
                    this.$store.commit('setQrCodeParams', {});
                    this.$router.push('/activity/YLLTPay');
                    responseCallback('1')
                }
            });
        }
    },
    methods: {
        // 去选品
        gotoSelectGoods() {
            if (this.specialYLLTObj.extendVal) {
                const extendVal = JSON.parse(this.specialYLLTObj.extendVal);
                if (extendVal && extendVal[0]) {
                    location.href = this.isApp ? extendVal[0].url : extendVal[0].url + '&source=h5';
                }
            }
        },
        // 返回活动首页
        goBack() {
            this.isApp
                ? this.$router.push('/activity/YLLT?erpCode=' + this.specialYLLTObj.erpCode)
                : this.$router.push('/activity/YLLT?source=h5&erpCode=' + this.specialYLLTObj.erpCode);
        },
        // 获取已参加活动会员信息
        getData() {
            Api.getAllPayMentStatus(this.specialYLLTObj.specialSid).then(({ data: { data }}) => {
                this.memberList = data;
            })
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
            height: .44rem;
            color: #343BEE;
            padding: .28rem 0 .56rem 0;
            span{
                margin: 0 .4rem;
                font-size: .32rem;
            }
            img{
                width: .34rem;
                height: .24rem;
            }
        }
        .pay-finishi{
            margin: .16rem;
            margin-top: 2.34rem;
            .member-info{
                background: #FFFFFF;
                border-radius: .16rem;
                margin-bottom: .24rem;
                .split-result{
                    width: 100%;
                    height: .26rem;
                    margin-top: .2rem;
                }
                .pay-info{
                    text-align: center;
                    .lllustration{
                        width: 2.42rem;
                        height: 1.32rem;
                        margin-bottom: .28rem;
                    }
                    .success-tips{
                        font-weight: 600;
                        font-size: .32rem;
                        margin-bottom: .2rem;
                    }
                    .activity-name{
                        padding: 0 .6rem;
                        color: #666666;
                        line-height: .4rem;
                    }
                }
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
                        padding-left: .46rem;
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
            }
            .member-info-message:last-child{
                margin-bottom: 1.32rem;
                margin-bottom: calc(constant(safe-area-inset-bottom) + 1.32rem);
                margin-bottom: calc(env(safe-area-inset-bottom) + 1.32rem);
            }
        }
        .bottom-bar-one{
            height: 1.12rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ffffff;
            >div{
                width: 3.12rem;
                height: .8rem;
                line-height: .8rem;
                text-align: center;
                border-radius: .4rem;
                font-size: .32rem;
            }
            .go-special-page{
                border: .02rem solid #FF8947;
                color: #FF8947;
                margin-right: .38rem;
            }
            .back-special-list, .finish-go{
                background: linear-gradient(90deg, #FFA16D 10.71%, #FF8947 102.11%);
                box-shadow: 0px .08rem .16rem rgba(255, 138, 72, 0.2);
                color: #ffffff;
                border: .02rem solid #FFA16D;
            }
            .finish-go{
                flex: 1;
                margin: 0 .28rem;
            }
        }
        .bottom-bar-two{
            height: 1.12rem;
            line-height: 1.12rem;
            text-align: center;
            position: fixed;
            bottom: 0;
            bottom: constant(safe-area-inset-bottom);
            bottom: env(safe-area-inset-bottom);
            background: #ffffff;
            width: 100%;
            margin-top: 1.32rem;
            >div{
                height: .8rem;
                line-height: .8rem;
                text-align: center;
                border-radius: .4rem;
                font-size: .32rem;
                margin-top: 0.16rem;
            }
            .go-special-page{
                border: .02rem solid #FF8947;
                color: #FF8947;
                margin-right: .38rem;
            }
            .back-special-list, .finish-go{
                background: linear-gradient(90deg, #FFA16D 10.71%, #FF8947 102.11%);
                box-shadow: 0px .08rem .16rem rgba(255, 138, 72, 0.2);
                color: #ffffff;
                border: .02rem solid #FFA16D;
            }
        }
    }
</style>
