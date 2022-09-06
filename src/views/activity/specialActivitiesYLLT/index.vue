<template>
    <app-template @init="init">
        <div v-if="!isApp" class="personal-box" />
        <div v-if="memberPayFlag.length>0" class="special-activities-YLLT">
            <!-- 协议 -->
            <van-dialog
                v-model="show"
                class="agreement-dialog"
                :show-confirm-button="false"
            >
                <div slot="default">
                    <h6 class="agreement-title">协议内容</h6>
                    <div class="content">
                        <!-- 协议书有广义和狭义之分。广义的协议书是指社会集团或个人处理各种社会关系、事务时常用的“契约”类文书，
                        包括合同、议定书、条约、公约、联合宣言、联合声明、条据等。
                        狭义的协议书指国家、政党、企业、团体或个人就某个问题经过谈判或共同协商，取得一致意见后，订立的一种具有经济或其它关系的契约性文书。
                        协议书是应用写作的重要组成部分。
                        协议书是社会生活中，协作的双方或数方，为保障各自的合法权益，经双方或数方共同协商达成一致意见后，签订的书面 -->
                        <img v-if="club === 1" src="@/assets/images/agreementConten-1.png" alt="">
                        <img v-if="club === 2" src="@/assets/images/agreementConten-2.png" alt="">
                        <img v-if="club === 3" src="@/assets/images/agreementConten-3.png" alt="">
                    </div>
                </div>
                <div class="agreement-footer" :style="`color:${agreeBtnColor}`" @click="agreeFn">{{ agreeBtnStr }}</div>
            </van-dialog>
            <!-- 活动列表 -->
            <ul class="list">
                <div v-for="item in specialDetail.extendValListMap" :key="item">
                    <li v-if="item.sn === 1" class="first-activity-item">
                        <h6 class="activity-title">
                            <img src="@/assets/images/vector-left.png" alt="">
                            <span>{{ item.title }}</span>
                            <img src="@/assets/images/vector-right.png" alt="">
                        </h6>
                        <!-- <p class="activity-content">预订货<span>36.68</span>万元，按百分之零点零六<span>(0.06%)</span>占比赠送十年返利额</p> -->
                        <p class="activity-content">{{ item.des }}</p>
                        <div class="join-in" @click="gotoPay(item)">立即参与</div>
                    </li>
                    <li v-else class="activity-item">
                        <div class="item-top">
                            <span class="activity-name">{{ item.title }}</span>
                            <span class="sub-btn" @click="gotoPay(item)">立即参与</span>
                        </div>
                        <div class="item-bottom">{{ item.des }}</div>
                    </li>
                </div>
                <li class="account-info">
                    <template v-if="club === 1">
                        <div class="account-title">
                            <img src="@/assets/images/title-icon.png" alt="">
                            <span class="account-title-content">尾款请对公转账至如下账户</span>
                            <span class="sub-btn" @click="copy">复制信息</span>
                        </div>
                        <div v-if="specialDetail.supplySid - 0 === 1" class="account-content">
                            <p><span>户名：</span><span>湖南恒昌医药集团股份有限公司</span></p>
                            <p><span>账号：</span><span>8111601011800095394</span></p>
                            <p><span>开户行：</span><span>中信银行长沙分行营业部</span></p>
                            <p><span>联行号：</span><span>302551040114</span></p>
                        </div>
                        <div v-else-if="specialDetail.supplySid - 0 === 4" class="account-content">
                            <p><span>户名：</span><span>恒昌医药(重庆)有限公司</span></p>
                            <p><span>账号：</span><span>123913488110102</span></p>
                            <p><span>开户行：</span><span>招商银行股份有限公司长沙北辰支行</span></p>
                            <p><span>联行号：</span><span>308551024490</span></p>
                        </div>
                        <div v-else class="account-content">
                            <p><span>户名：</span><span>天津和治恒昌医药有限公司</span></p>
                            <p><span>账号：</span><span>8111401013300459052</span></p>
                            <p><span>开户行：</span><span>中信银行天津北辰支行</span></p>
                            <p><span>联行号：</span><span>302110023350</span></p>
                        </div>
                    </template>
                    <template v-else-if="club === 2">
                        <div class="account-title">
                            <img src="@/assets/images/title-icon.png" alt="">
                            <span class="account-title-content">尾款请对公转账至如下账户</span>
                            <span class="sub-btn" @click="copy">复制信息</span>
                        </div>
                        <div v-if="specialDetail.supplySid - 0 === 1" class="account-content">
                            <p><span>户名：</span><span>湖南恒昌医药集团股份有限公司</span></p>
                            <p><span>账号：</span><span>66110078801300000548</span></p>
                            <p><span>开户行：</span><span>上海浦东发展银行股份有限公司长沙左家塘支行</span></p>
                            <p><span>联行号：</span><span>310551000104</span></p>
                        </div>
                        <div v-else-if="specialDetail.supplySid - 0 === 4" class="account-content">
                            <p><span>户名：</span><span>恒昌医药(重庆)有限公司</span></p>
                            <p><span>账号：</span><span>431501888013001447846</span></p>
                            <p><span>开户行：</span><span>交通银行股份有限公司长沙井湾子支行</span></p>
                            <p><span>联行号：</span><span>301551000067</span></p>
                        </div>
                        <div v-else class="account-content">
                            <p><span>户名：</span><span>天津和治恒昌医药有限公司</span></p>
                            <p><span>账号：</span><span>122911286910516</span></p>
                            <p><span>开户行：</span><span>招商银行股份有限公司长沙北辰支行</span></p>
                            <p><span>联行号：</span><span>308551024490</span></p>
                        </div>
                    </template>
                    <template v-else-if="club === 3">
                        <div class="account-title">
                            <img src="@/assets/images/title-icon.png" alt="">
                            <span class="account-title-content">尾款请对公转账至如下账户</span>
                            <span class="sub-btn" @click="copy">复制信息</span>
                        </div>
                        <div v-if="specialDetail.supplySid - 0 === 1" class="account-content">
                            <p><span>户名：</span><span>湖南恒昌医药集团股份有限公司</span></p>
                            <p><span>账号：</span><span>43050175363600000419</span></p>
                            <p><span>开户行：</span><span>中国建设银行股份有限公司长沙万芙南路支行</span></p>
                            <p><span>联行号：</span><span>105551004244</span></p>
                        </div>
                        <div v-else-if="specialDetail.supplySid - 0 === 4" class="account-content">
                            <p><span>户名：</span><span>恒昌医药(重庆)有限公司</span></p>
                            <p><span>账号：</span><span>431501888013001447846</span></p>
                            <p><span>开户行：</span><span>交通银行股份有限公司长沙井湾子支行</span></p>
                            <p><span>联行号：</span><span>301551000067</span></p>
                        </div>
                        <div v-else class="account-content">
                            <p><span>户名：</span><span>天津和治恒昌医药有限公司</span></p>
                            <p><span>账号：</span><span>431501888013001192360</span></p>
                            <p><span>开户行：</span><span>交通银行股份有限公司长沙井湾子支行</span></p>
                            <p><span>联行号：</span><span>301551000067</span></p>
                        </div>
                    </template>
                </li>
            </ul>
        </div>
    </app-template>
</template>

<script>
import Api from '@/api/activity/specialYLLT'
import AppTemplate from '@/components/appTemplate/Index'
import VMnative from '@/utils/VMnative'
import { Toast } from 'vant'
export default {
    name: 'SpecialYLLT',
    components: {
        AppTemplate
    },
    data(){
        return {
            agreeBtnStr: '同意(10s)',
            countdownTime: 10,
            agreeBtnColor: '#BBBBBB',
            specialDetail: { extendValListMap: [] },
            memberPayFlag: false,
            show: false
        }
    },
    computed: {
        specialYLLTObj() {
            return this.$store.getters.specialYLLTObj
        },
        isApp() {
            if (this.$route.query.source === 'h5') {
                return false;
            } else {
                return this.$store.getters.specialYLLTObj.hasOwnProperty('isApp') ? this.$store.getters.specialYLLTObj.isApp : true
            }
        },
        club(){
            return this.$store.getters.userInfo.currentType * 1
        }
    },
    created(){
        this.$store.commit('setQrCodeParams', {});
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", this.$route.meta.title)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                this.$store.commit('setShowSpecialAgreement', '');
                this.$store.commit('setSpecialYLLTObj', {});
                responseCallback('0')
            });
        }
    },
    beforeDestroy(){
        clearInterval(this.timer);
        if (this.isApp) {
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                this.$store.commit('setShowSpecialAgreement', '');
                this.$store.commit('setSpecialYLLTObj', {});
                responseCallback('0')
            });
        }
    },
    methods: {
        init(){
            this.query();
            this.countdownTime = 10;
            this.timer = setInterval(() => {
                this.countdownTime--;
                if (this.countdownTime > 0) {
                    this.agreeBtnStr = `同意(${this.countdownTime}s)`;
                } else {
                    clearInterval(this.timer);
                    this.agreeBtnColor = '#FF8947';
                    this.agreeBtnStr = `同意`;
                }
            }, 1000)
        },
        // 获取专项活动信息和档次
        query() {
            Api.fetchList(this.$route.query.erpCode || this.specialYLLTObj.erpCode).then(({ data: { data }}) => {
                this.specialDetail = data;
                this.$route.meta.title = data.name;
                // 获取店铺详情查看是否有未参加活动的店铺
                Api.memberDetail(data.sid).then(({ data: { data }}) => {
                    this.memberPayFlag = data.filter(item => item.flag === 0);
                    this.$store.commit('setNotPayMember', this.memberPayFlag);
                    if (this.memberPayFlag.length === 0) {
                        this.$store.commit('setSpecialYLLTObj', {
                            activityName: this.specialDetail.name,
                            amount: this.specialDetail.minPayPrice,
                            specialSid: this.specialDetail.sid,
                            supplySid: this.specialDetail.supplySid,
                            extendVal: this.specialDetail.extendVal,
                            isApp: this.isApp,
                            erpCode: this.$route.query.erpCode || this.specialYLLTObj.erpCode
                        })
                        this.$router.push('/activity/YLLTPaySuccess');
                    } else {
                        this.show = this.$store.getters.showSpecialAgreement === '';
                    }
                })
            })
        },
        agreeFn() {
            if (this.countdownTime < 1) {
                this.$store.commit('setShowSpecialAgreement', 1);
                this.show = false;
            }
        },
        // 立即参与
        gotoPay(item) {
            if (this.memberPayFlag.length > 0) {
                this.$store.commit('setSpecialYLLTObj', {
                    activityName: this.specialDetail.name,
                    amount: this.specialDetail.minPayPrice,
                    specialSid: this.specialDetail.sid,
                    des: item.des,
                    title: item.title,
                    supplySid: this.specialDetail.supplySid,
                    sn: item.sn,
                    extendVal: this.specialDetail.extendVal,
                    isApp: this.isApp,
                    erpCode: this.$route.query.erpCode || this.specialYLLTObj.erpCode
                })
                this.$store.commit('setCashflowCode', '');
                this.$router.push(`/activity/YLLTPay`);
            }
        },
        // 复制
        copy(e) {
            const copyInner = 
                this.specialDetail.supplySid - 0 === 1 
                    ? '户名：湖南恒昌医药集团股份有限公司，账号：8111601011800095394，开户行：中信银行长沙分行营业部，联行号：302551040114。'
                    : '户名：天津和治恒昌医药有限公司，账号：8111401013300459052，开户行：中信银行天津北辰支行，联行号：302110023350。'
            window.event ? window.event.cancelBubble = true : e.stopPropagation();
            var el = document.createElement('input');
            el.value = copyInner;
            el.style.opacity = '0';
            document.body.appendChild(el);
            var editable = el.contentEditable;
            var readonly = el.readonly;
            el.contentEditable = true;
            el.readonly = false;
            var range = document.createRange();
            range.selectNodeContents(el);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
            el.setSelectionRange(0, 999999);
            el.contentEditable = editable;
            el.readonly = readonly;
            el.select();
            document.execCommand('copy');
            Toast({
                message: '复制成功',
                duration: 500
            })
            // document.body.removeChild(el)
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
        .list{
            margin: 0 .16rem;
            padding-top: 2.34rem;
        }
        .sub-btn{
            width: 1.52rem;
            height: .52rem;
            text-align: center;
            line-height: .52rem;
            background: #EFF0FF;
            border: .02rem solid rgba(51, 58, 237, 0.2);
            box-sizing: border-box;
            border-radius: .26rem;
            color: #333AED;
            font-size: .24rem;
        }
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
        .first-activity-item{
            // margin-top: 2.34rem;
            background: linear-gradient(180deg, #D9DBFF 0%, #FFFFFF 30.43%);
            box-shadow: 0px .08rem .32rem rgba(145, 146, 183, 0.1);
            border-radius: .16rem;
            padding: .28rem;
            padding-top: 0;
            .activity-content{
                font-weight: 600;
                line-height: .52rem;
                span{
                    color: #FF8947;
                }
            }
            .join-in{
                margin-top: .2rem;
                height: .8rem;
                line-height: .8rem;
                text-align: center;
                color: #FFFFFF;
                background: linear-gradient(90deg, #FFA16D -2.42%, #FF8947 102.42%);
                box-shadow: 0px .08rem .16rem rgba(255, 138, 72, 0.2);
                border-radius: .4rem;
                font-size: .32rem;
                font-weight: 600;
                letter-spacing: 2px;
            }
        }
        .activity-item{
            margin-top: .24rem;
            border-radius: .16rem;
            background: linear-gradient(0deg, #FFFFFF, #FFFFFF);
            box-shadow: 0px .08rem .32rem rgba(145, 146, 183, 0.1);
            .item-top{
                display: flex;
                align-items: center;
                height: .88rem;
                padding: 0 .28rem;
                border-bottom: .02rem solid #EEEEEE;
                &::before{
                    display: inline-block;
                    content: '';
                    width: .16rem;
                    height: .16rem;
                    border-radius: 50%;
                    border: solid .08rem#FFA16D;
                    margin-right: .2rem;
                }
                .activity-name{
                    flex: 1;
                    font-weight: 600;
                }
            }
            .item-bottom{
                padding: .24rem .28rem;
                line-height: .4rem;
            }
        }
        .account-info{
            margin-top: .24rem;
            margin-bottom: .16rem;
            margin-bottom: calc(constant(safe-area-inset-bottom) + .16rem);
            margin-bottom: calc(env(safe-area-inset-bottom) + .16rem);
            background: linear-gradient(0deg, #E8E8E8, #E8E8E8);
            border-radius: .16rem;
            .account-title{
                height: .88rem;
                display: flex;
                align-items: center;
                padding: 0 .28rem;
                border-bottom: .02rem solid #F4F4F4;
                img{
                    width: .32rem;
                    height: .32rem;
                    margin-right: .2rem;
                }
                .account-title-content{
                    flex: 1;
                    font-weight: 600;
                }
            }
            .account-content{
                padding: .24rem .28rem;
                line-height: .52rem;
                p{
                    display: flex;
                    justify-content: space-between;
                }
            }
        }
    }
    .agreement-dialog{
        width: 7rem;
        top: 50%;
        .agreement-title{
            height: 1.04rem;
            line-height: 1.04rem;
            font-size: .32rem;
            text-align: center;
        }
        .content{
            max-height: 7.04rem;
            overflow-y: auto;
            margin: .28rem;
            margin-top: 0;
            background: #F4F4F4;
            border-radius: .12rem;
            line-height: .44rem;
            color: #666666;
            img{
                width: 6.3rem;
            }
        }
        .agreement-footer{
            height: .88rem;
            line-height: .88rem;
            text-align: center;
            border-top: .02rem solid #EEEEEE;
            color: #BBBBBB;
            font-weight: 600;
            font-size: .32rem;
        }
    }
</style>
