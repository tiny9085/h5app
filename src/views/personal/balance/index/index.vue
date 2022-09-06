<template>
    <div class="Page-personal-balance theme-lsx personal-box">
        <div class="tab-box clearfix">
            <van-tabs v-model="accountType" line-width="0" sticky animated @change="changeTabs(false , true, $event)">
                <van-tab title="普通余额" :name="0">
                    <h6 v-if="$route.query.userInfoSid" class="store-name">
                        <img src="@/assets/images/store_icon.png" class="store-icon">
                        <span>{{ subUserName }}</span>
                    </h6>
                    <div class="balance-box" :style="$route.query.userInfoSid? 'margin-top: .24rem;' : 'margin-top: .4rem;'">
                        <div class="row-1">
                            <span>普通余额(元)</span>
                        </div>
                        <div class="row-2">
                            <span>{{ (accountListAmount.balance || 0).toFixed(2) }}</span>
                        </div>
                        <div class="row-3">
                            <span>冻结金额(元)：{{ (accountListAmount.amount || 0).toFixed(2) }}</span>
                        </div>
                    </div>
                    <div class="detailed">
                        <div class="time">
                            <win-custom-time ref="myBalance" @selectTime="changeTabs(true)" />
                        </div>
                        <!-- <div class="detailed-right">
                            <p>支出：¥ 4888.00</p>
                            <p>收入：¥ 2586.00</p>
                        </div> -->
                    </div>
                    <div v-if="accountDetail.length != 0" class="balance-list clearfix">
                        <!-- <div class="title">余额交易明细</div> -->
                        <van-list
                            v-model="loading.accountLoading"
                            :finished="finished.accountFinished"
                            finished-text="人家是有底线的哦!"
                            @load="changeTabs"
                        >
                            <div v-for="(item,index) in accountDetail" :key="index" class="balance-li" :class="index === accountDetail.length - 1 ? 'last-border-bottom' : ''">
                                <div class="row-1 clearfix">
                                    <span>{{ item.accountTypeEnumName }}</span>
                                    <span v-if="item.accountTypeEnumName === '冻结'" class="black">{{ Math.abs(item.amount) || 0 }}</span>
                                    <span v-else :class="item.amount >= 0 ? 'orange' : 'green'">{{ `${item.amount >= 0 ? '+' : '-'} ${Math.abs(item.amount)}` }}</span>
                                </div>
                                <div class="row-2 clearfix">
                                    <span>{{ item.createTime }}</span>
                                    <span>{{ item.orderCode }}</span>
                                </div>
                            </div>
                        </van-list>
                    </div>
                </van-tab>
                <van-tab title="专项款" :name="2">
                    <h6 v-if="$route.query.userInfoSid" class="store-name">
                        <img src="@/assets/images/store_icon.png" class="store-icon">
                        <span>{{ subUserName }}</span>
                    </h6>
                    <div class="special-box" :style="$route.query.userInfoSid? 'margin-top: .24rem;' : 'margin-top: .4rem;'">
                        <div class="row-1">
                            <span>总专项款(元)</span>
                        </div>
                        <div class="row-2">
                            <span>{{ (specialListAmount.balance || 0).toFixed(2) }}</span>
                        </div>
                        <div class="row-3">
                            <span>冻结金额(元)：{{ (specialListAmount.amount || 0).toFixed(2) }}</span>
                        </div>
                        <div class="row-4">
                            <router-link :to="{path: '/personal/specialList', query:{userInfoSid: $route.query.userInfoSid}}">
                                专项款详情
                                <img src="@/assets/images/right_arrow.png" class="right-arrow">
                            </router-link>
                        </div>
                    </div>
                    <div class="special-title">
                        <win-custom-time ref="mySpecial" @selectTime="changeTabs(true)" />
                        <div class="special-type" @click="showSpecialList = true">
                            <p>{{ currentSpecial? currentSpecial.name : '全部专项款' }}</p>
                            <img class="open-arrow" src="@/assets/images/arrow.png" alt="">
                        </div>
                    </div>
                    <div v-if="specialDetail.length != 0" class="balance-list clearfix specail-list">
                        <van-list
                            v-model="loading.specialLoading"
                            :finished="finished.specialFinished"
                            finished-text="人家是有底线的哦!"
                            @load="changeTabs"
                        >
                            <div v-for="(item,index) in specialDetail" :key="index" class="balance-li" :class="index === specialDetail.length - 1 ? 'last-border-bottom' : ''">
                                <div class="row-1 clearfix">
                                    <span>{{ item.accountTypeEnumName }}</span>
                                    <!-- <span>{{ item.specialName }}</span> -->
                                    <span v-if="item.accountTypeEnumName === '冻结'" class="black">{{ Math.abs(item.amount) || 0 }}</span>
                                    <span v-else :class="item.amount >= 0 ? 'orange' : 'green'">{{ `${item.amount >= 0 ? '+' : '-'}${Math.abs(item.amount)} ` }}</span>
                                </div>
                                <div class="row-2 clearfix">
                                    <span>{{ item.createTime }}</span>
                                    <span>{{ item.orderCode }}</span>
                                </div>
                            </div>
                        </van-list>
                    </div>
                </van-tab>
                <van-tab title="返利" :name="1">
                    <h6 v-if="$route.query.userInfoSid" class="store-name">
                        <img src="@/assets/images/store_icon.png" class="store-icon">
                        <span>{{ subUserName }}</span>
                    </h6>
                    <div class="balance-box" :style="$route.query.userInfoSid? 'margin-top: .24rem;' : 'margin-top: .4rem;'">
                        <div class="balance-bd clearfix">
                            <div class="row-1">
                                <span>返利金额</span>
                                <span>(元)</span>
                            </div>
                            <div class="row-2">
                                <span>{{ (rebateListAmount.balance || 0).toFixed(2) }}</span>
                            </div>
                            <div class="row-3">
                                <span>冻结金额(元):{{ (rebateListAmount.amount || 0).toFixed(2) }}</span>
                            </div>
                        </div>
                    </div>
                    <div class="detailed">
                        <div class="time">
                            <win-custom-time ref="myRebate" @selectTime="changeTabs(true)" />
                        </div>
                        <!-- <div class="detailed-right">
                            <p>支出:$4888.00</p>
                            <p>收入:$2586.00</p>
                        </div> -->
                    </div>
                    <div v-if="rebateList.length != 0" class="balance-list clearfix">
                        <van-list
                            v-model="loading.rebateLoading"
                            :finished="finished.rebateFinished"
                            finished-text="人家是有底线的哦!"
                            @load="changeTabs"
                        >
                            <div
                                v-for="(item,index) in rebateList"
                                :key="index"
                                class="balance-li"
                                :style="item.rebateDes ? 'padding-bottom:0':''"
                            >
                                <div class="row-1 clearfix">
                                    <span>{{ item.accountTypeEnumName }}</span>
                                    <span v-if="item.accountTypeEnumName === '冻结'" class="black">{{ Math.abs(item.amount) || 0 }}</span>
                                    <span v-else :class="item.amount >= 0 ? 'orange' : 'green'">{{ `${item.amount >= 0 ? '+' : '-'}${Math.abs(item.amount)}` }}</span>
                                </div>
                                <div class="row-2 clearfix">
                                    <span>{{ item.createTime }}</span>
                                    <span>{{ item.orderCode }}</span>
                                </div>
                                <div v-if="item.rebateDes" class="row-3 clearfix">
                                    <div>备注:</div>
                                    <div>{{ item.rebateDes }}</div>
                                </div>
                            </div>
                        </van-list>
                    </div>
                </van-tab>
            </van-tabs>
        </div>
        <view class="clearfix" />
        <van-dialog id="van-dialog" />
        <!-- 选择专项款 -->
        <van-popup v-model="showSpecialList" class="special-popup" position="bottom" :close-on-click-overlay="false">
            <p class="special-list-title">
                <span>专项款类型</span>
                <span class="close-special-list" @click="closeSpecialFn">&times;</span>
            </p>
            <van-radio-group v-model="currentSpecial" class="special-list">
                <div class="special-item">
                    <span>全部专项款</span>
                    <van-radio name="" />
                </div>
                <div v-for="(item, ind) in specialList" :key="ind" class="special-item">
                    <span>{{ item.name }}</span>
                    <van-radio :name="item" />
                </div>
            </van-radio-group>
        </van-popup>
    </div>
</template>

<script>
import {  Dialog } from 'vant';
import WinCustomTime from '@/components/customTime/index'
import Api from '@/api/personal/index'
import moment from 'moment'
export default {
    components: {
        WinCustomTime
    },
    data(){
        return {
            specialDetail: [],
            rebateList: [],
            accountDetail: [],
            specialListAmount: {},
            rebateListAmount: {},
            accountListAmount: {},
            showSpecialList: false,
            currentSpecial: '',
            accountType: this.$route.query.active || 0,
            specialList: [],
            subUserName: localStorage.getItem('personalSubUserName'),
            current: 1,
            loading: {
                accountLoading: false,
                specialLoading: false,
                rebateLoading: false
            },
            finished: {
                accountFinished: false,
                specialFinished: false,
                rebateFinished: false
            },
            numbers: {
                accountCurrent: 1,
                specialCurrent: 1,
                rebateCurrent: 1
            }
        }
    },
    computed: {
        
    },
    mounted(){
        this.changeTabs()
        this.getUserSpecialList()
        this.getUserBalance();
        if (this.$route.name === 'balance') this.$store.commit('setCartRightText', '分店账户')
        document.getElementsByTagName("body")[0].className = "product-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "product-index");
    },
    methods: {
        changeTabs(empty, type, e){
            if (e !== undefined) this.accountType = e;
            switch (this.accountType - 0) {
                case 0:
                    if (this.accountDetail.length && type) return; // tab切换维持原来的数据分页信息
                    if (empty) this.accountDetail = [];// 筛选条件改变清空原来的数据
                    this.getAccountDetail(this.$refs['myBalance'], {
                        current: this.numbers.accountCurrent
                    })
                    break;
                case 2:
                    // this.getUserSpecialList()
                    if (this.specialDetail.length && type) return;
                    if (empty) this.specialDetail = [];
                    this.getAccountDetail(this.$refs['mySpecial'], {
                        current: this.numbers.specialCurrent
                    })
                    break;
                case 1:
                    if (this.rebateList.length && type) return;
                    if (empty) this.rebateList = [];
                    this.getAccountDetail(this.$refs['myRebate'], {
                        current: this.numbers.rebateCurrent
                    })
                    break;
            }
        },
        /**
         * 查询会员余额、返利、专项款
         */
        getUserBalance() {
            Api.getInfo({
                userInfoSid: this.$route.query.userInfoSid || ''
            }).then(res => {
                const data = res.data.data || [];
                data.forEach(v => {
                    switch (v.type - 0) {
                        case 0:
                            this.accountListAmount = v || {};
                            break;
                        case 2:
                            this.specialListAmount = v || {};
                            break;
                        case 1:
                            this.rebateListAmount = v || {};
                            break;
                    }
                })
            })
        },

        /**
         * 查询会员专项款列表
         */
        getUserSpecialList() {
            Api.getSpe({
                userInfoSid: this.$route.query.userInfoSid || ''
            }).then(res => {
                this.specialList = res.data.data || [];
            })
        },

        /**
         * 查看专项款使用范围
         */
        showRange(item) {
            const description = item.description
            Dialog.alert({
                title: '专项款使用范围',
                confirmButtonText: '我知道了',
                message: description
            })
        },
        /**
         * 查询用户交易明细
         */
        getAccountDetail(timeRef, obj) {
            let createTime = moment().startOf('month').format('YYYY-MM-DD');
            let endTime = moment().endOf('month').format('YYYY-MM-DD');
            if (timeRef) {
                // 获取时间
                if (timeRef.endType === 'month') {
                    if (timeRef.currentTime) {
                        createTime = moment(timeRef.currentTime).startOf('month').format('YYYY-MM-DD');
                        endTime = moment(timeRef.currentTime).endOf('month').format('YYYY-MM-DD');
                    }
                } else {
                    createTime = timeRef.startTime.split('.').join('-');
                    endTime = timeRef.endTime.split('.').join('-');
                }
            }
            Api.getUserInfo({
                current: obj.current,
                size: 20,
                accountType: this.accountType,
                createTime,
                endTime,
                userInfoSid: this.$route.query.userInfoSid ? this.$route.query.userInfoSid : '',
                accountSpecialSid: this.currentSpecial ? this.currentSpecial.sepecalSid : ''
            }).then(res => {
                if (obj.current >= res.data.data.pages) {
                    switch (this.accountType - 0) {
                        case 0:
                            this.accountDetail = this.accountDetail.concat(res.data.data.records || []);
                            this.finished.accountFinished = true;
                            break;
                        case 2:
                            this.specialDetail = this.specialDetail.concat(res.data.data.records || []);
                            this.finished.specialFinished = true;
                            break;
                        case 1:
                            this.rebateList = this.rebateList.concat(res.data.data.records || []);
                            this.finished.rebateFinished = true;
                            break;
                    }
                } else {
                    switch (this.accountType - 0) {
                        case 0:
                            this.accountDetail = this.accountDetail.concat(res.data.data.records || []);
                            this.numbers.accountCurrent++;
                            break;
                        case 2:
                            this.specialDetail = this.specialDetail.concat(res.data.data.records || []);
                            this.numbers.specialCurrent++;
                            break;
                        case 1:
                            this.rebateList = this.rebateList.concat(res.data.data.records || []);
                            this.numbers.rebateCurrent++;
                            break;
                    }
                }
            })
        },
        closeSpecialFn() {
            this.showSpecialList = false;
            this.changeTabs(true);
        }
    }
}
</script>

<style lang="scss">
.product-index{
    background: #f1f1f1;
}
.Page-personal-balance{
        position: absolute;
        height: 100%;
        width: 100%;
        top:0;
        left: 0;
        background: #f1f1f1;
    .store-name{
        display: flex;
        padding: .24rem;
        padding-bottom: 0;
        color: #333333;
        font-size: .28rem;
        .store-icon{
            width: .32rem;
            height: .32rem;
            margin-right: .12rem;
        }
    }
    
    .tab-box {
        .van-tabs {
            padding-top: 0px;
            position: relative;
            .van-tabs__nav--line{
                padding-bottom: 0;
            }
            .van-tab {
                font-size: .28rem;
                color: #666;
                font-weight: 400;
                &.van-tab--active {
                    color: #ED3129;
                    font-size: 0.32rem;
                    font-weight: 600;
                }
            }
        }
        .van-tabs .van-tab.van-tab--active::after {
                position: absolute;
                box-sizing: border-box;
                content: ' ';
                pointer-events: none;
                right: 0.8rem;
                bottom: -0.04rem;
                left: 0.8rem;
                border-bottom: 8px solid #ED3129;
                transform: scaleY(.5);
                border-radius: 0.08rem;
            }
        .van-tab__pane-wrapper{
            padding: 0 0.16rem;
            background: #f1f1f1;
        }

        .balance-box {
            width: 100%;
            height: 2.82rem;
            background: url(https://imga.hnhcyy.com/fed/b2b-wechat/2.png?v=1) 50% 50% no-repeat;
            background-size: 100%;
            // margin-top: .4rem;
            line-height: 1;
            color: #FFF;

            .row-1 {
                padding-top: .42rem;
                text-align: center;

                span {
                    font-size: .32rem;
                    font-weight: 400;
                }
            }

            .row-2 {
                padding-top: .12rem;
                text-align: center;

                span {
                    font-size: .48rem;
                    font-weight: 600;
                }
            }

            .row-3{
                text-align: center;
                padding-top: .78rem;
                span{
                    font-size: .28rem;
                    font-weight: 400;
                }
            }
        }
        .detailed{
            box-sizing: border-box;
            height: 1.2rem;
            width: 100%;
            background: #FFFAEC;
            color: #666;
            font-size: 0.24rem;
            display: flex;
            justify-content: space-between;
            border-bottom-left-radius: .16rem;
            border-bottom-right-radius: .16rem;
            .custom-time .custom-item{
                background: #fff;
                margin: .3rem;
                border: none;
                line-height: 0.64rem
            }
        }
        .last-border-bottom::before{
            display: none;
        }
        .balance-list {
            margin-top: -0.02rem;

            .title {
                font-size: .32rem;
                color: #333333;
                padding: 10px .20rem 15px .20rem;
                line-height: 1;
            }

            .balance-month {
                height: 25px;
                line-height: 25px;
                padding: 0 .20rem;
                font-size: .28rem;
                color: #666666;
                background: #F4F4F4;
            }
            .balance-li {
                margin-top: .2rem;
                padding: .32rem 0;
                background: #FFFFFF;
                overflow: hidden;
                border-radius: .16rem;
                .row-1 {
                    padding: 0 .28rem;
                    margin-bottom: .2rem;
                    span {
                        font-size: .29rem;
                        color: #333;

                        &:nth-child(1) {
                            float: left;
                        }

                        &:nth-child(2) {
                            float: right;
                            font-weight: 600;
                            font-size: 0.32rem;
                            &.orange {
                                color: #FF7005;
                            }

                            &.green {
                                color: #333333;
                            }
                            &.black {
                                color: #333333;
                            }
                        }
                    }
                }

                .row-2 {
                    padding: 0 .28rem;
                    span {
                        font-size: .24rem;
                        color: #A3A3A3;
                        margin-bottom: .2rem;

                        &:nth-child(1) {
                            float: left;
                        }

                        &:nth-child(2) {
                            color: #999;
                            float: right;
                        }
                    }
                }
                .row-3{
                    display: flex;
                    overflow: hidden;
                    padding: .22rem .28rem;
                    background: #FBFBFB;
                    color: #999999;
                    font-weight: 500;
                    font-size: .28rem;
                    line-height: .4rem;
                    div{
                        &:nth-child(1) {
                            width: .84rem;
                        }
                        &:nth-child(2) {
                            flex: 1;
                        }
                    }
                }
            }
            .border-bottom::before{
                left: 11px;
                // bottom: -1.8px;
            }
        }
        .specail-list.balance-list .balance-li {
            .row-1 span{
                &:nth-child(2) {
                    float: right;
                    padding-left:.4rem;
                    margin-left: .4rem;
                }
                &:nth-child(3) {
                    float: right;
                    font-weight: 600;
                    font-size: 0.32rem;
                    &.orange {
                        color: #FF7005;
                    }

                    &.green {
                        color: #333333;
                    }
                    &.black {
                        color: #333333;
                    }
                }
            }
        }

        .special-box{
            width: 100%;
            height: 3.4rem;
            background: url('../../../../assets/images/blance_bg.png') 50% 50% no-repeat;
            background-size: contain;
            // margin: .4rem 0 0 0;
            line-height: 1;
            color: #FFF;

            .row-1 {
                padding-top: .42rem;
                text-align: center;

                span {
                    font-size: .32rem;
                }
                
            }

            .row-2 {
                padding-top: .12rem;
                text-align: center;

                span {
                    font-size: 0.48rem;
                    font-weight: 600;
                }
            }

            .row-3{
                text-align: center;
                padding-top: 0.78rem;
                font-size: 0.28rem;
                a{
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    span{
                        font-size: .28rem;
                    }
                    .van-icon{
                        font-size: .24rem;
                        margin-left: .10rem;
                    }
                }
            }
            .row-4{
                padding-top: 0.28rem;
                text-align: center;
                a{
                    font-size: .28rem;
                }
            }
            .right-arrow{
                width: .32rem;
                position: relative;
                top: .07rem;
            }
            .custom-time .custom-item .open-arrow{
                top:0.05rem
            }
        }
        .special-title{
            box-sizing: border-box;
            height: 1.2rem;
            width: 100%;
            background: #FFFAEC;
            color: #666;
            font-size: 0.24rem;
            display: flex;
            justify-content: space-between;
            .custom-time .custom-item{
                background: #fff;
                margin: .3rem;
                border: none;
                line-height: 0.64rem
            }
        }

        .special-type{
            position: relative;
            height: .6rem;
            line-height: .56rem;
            border-radius: .3rem;
            box-sizing: border-box;
            margin: .3rem;
            p{
                width: 2.4rem;
                overflow: hidden;
                text-overflow:ellipsis;
                white-space: nowrap;
                border-radius: .3rem;
                height: .6rem;
                padding: 0 .5rem 0 .2rem;
                font-size: .32rem;
                background: #fff;
                line-height: 0.6rem;
            }
            .open-arrow{
                width: .48rem;
                height: .48rem;
                position: absolute;
                right: .06rem;
                top: .05rem;
            }
        }
    }
// 搜索专项款类型
.special-popup{
    .special-list-title{
        position: relative;
        height: .96rem;
        line-height: .96rem;
        text-align: center;
        font-size: .32rem;
        margin: 0 .32rem;
        box-shadow:0px 1px 0px 0px rgba(228,228,228,1);
        .close-special-list{
            font-size: .48rem;
            color: #CCCCCC;
            position: absolute;
            right: 0;
        }
    }
    .special-list{
        margin: .08rem .32rem;
        .special-item{
            display: flex;
            line-height: .6rem;
            span{
                flex: 1;
                font-size: .32rem;
                color: #333333;
            }

        }
    }
}
    .van-list__finished-text{
        background: #f1f1f1;
    }
}

</style>
