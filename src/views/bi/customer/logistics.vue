<template>
    <app-template system="bi" @init="init">
        <div class="app-customer-logistics-box" :style="[{'min-height':winHeight+'px'}]">
            <div class="customer-box">
                <div class="customer-icon"><i /></div>
                <div class="customer-info">
                    <h3>{{ customerDetail.userName }}</h3>
                    <dl>
                        <dt>会员编号</dt>
                        <dd>{{ customerDetail.userCode }}</dd>
                    </dl>
                </div>
            </div>
            <div class="logistics-box">
                <div class="logistics-list">
                    <a v-if="type===1" :class="[{'active': activeCode === customerDetail.receiveCode1},{'disable': !customerDetail.receiveCode1}]" @click="fetchLogisticsDetail(customerDetail.receiveCode1)">收函1</a>
                    <a v-if="type===1" :class="[{'active': activeCode === customerDetail.receiveCode2},{'disable': !customerDetail.receiveCode2}]" @click="fetchLogisticsDetail(customerDetail.receiveCode2)">收函2</a>
                    <a v-if="type===2" :class="[{'active': activeCode === customerDetail.sendCode1},{'disable': !customerDetail.sendCode1}]" @click="fetchLogisticsDetail(customerDetail.sendCode1)">发函1</a>
                    <a v-if="type===2" :class="[{'active': activeCode === customerDetail.sendCode2},{'disable': !customerDetail.sendCode2}]" @click="fetchLogisticsDetail(customerDetail.sendCode2)">发函2</a>
                </div>
                <div class="logistics-info">
                    <h4>
                        快递单号
                        <span>{{ activeCode }}</span>
                        <span class="copy" @click="copy(activeCode)">复制</span>
                    </h4>
                    <van-loading v-if="loading" size="24px" vertical>加载中...</van-loading>
                    <van-steps direction="vertical" :active="0" inactive-color="#EBEBEB" active-color="#666666">
                        <van-step v-for="item in logisticsData" :key="item">
                            <template slot="active-icon">
                                <div class="active-icon" />
                            </template>
                            <h3>{{ item.REMARK }}</h3>
                            <p class="time">{{ dateFormat(item.ACCEPTTIME,'MM-DD') }}<br>{{ dateFormat(item.ACCEPTTIME,'hh:mm') }}</p>
                            <template slot="finish-icon">
                                <div class="finish-icon">发</div>
                            </template>
                        </van-step>
                    </van-steps>
                </div>
            </div>
        </div>
    </app-template>
</template>
<script>
import AppTemplate from '@/components/appTemplate/Index'
import Api from '@/api/bi/customer'
import moment from 'moment'
import VMnative from '@/utils/VMnative'
export default {
    name: 'AccountService',
    components: {
        AppTemplate
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            customerDetail: {},
            logisticsData: [],
            type: 1,
            inited: false
        }
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    created(){
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "发函物流详情")
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                responseCallback('1')
                this.$router.go(-1)
            });
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    },
    activated(){
        this.customerDetail = this.$route.params || {}
        this.type = this.$route.query.type

        VMnative.callHandler("setTitle", "发函物流详情")
        VMnative.registerHandler('goBack', (data, responseCallback) => {
            responseCallback('1')
            this.$router.go(-1)
        });

        if (this.inited){
            this.init()
        }
    },
    methods: {
        init(){
            if (this.$route.query.type === 1){
                const activeCode = this.customerDetail.receiveCode1 || this.customerDetail.receiveCode2
                this.fetchLogisticsDetail(activeCode)
            } else {
                const activeCode = this.customerDetail.sendCode1 || this.customerDetail.sendCode2
                this.fetchLogisticsDetail(activeCode)
            }

            this.inited = true
        },
        dateFormat(str1, str2){
            return moment(str1).format(str2)
        },
        fetchLogisticsDetail(code){
            if (!code){ return false }
            this.logisticsData = []
            this.activeCode = code
            this.loading = true
            Api.fetchConfirmationsDetail({
                billCode: code,
                billName: 'send_code1_status'
            }).then(({ data: { data }}) => {
                this.logisticsData = data || []
                this.loading = false
            }).catch(() => {
                this.loading = false
            })
        },
        /**
         * 复制订单号
         */
        copy(copyInner, e) {
            window.event ? window.event.cancelBubble = true : e.stopPropagation();
            var el = document.createElement('input');
            el.value = copyInner;
            el.style.opacity = '0';
            document.body.appendChild(el);
            var editable = el.contentEditable;
            var readOnly = el.readOnly;
            el.contentEditable = true;
            el.readOnly = false;
            var range = document.createRange();
            range.selectNodeContents(el);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
            el.setSelectionRange(0, 999999);
            el.contentEditable = editable;
            el.readOnly = readOnly;
            el.select();
            var flag = document.execCommand('copy');
            this.$toast({
                message: '复制成功',
                duration: 500
            })
            return flag;
        }
    }
}
</script>
<style lang="scss">
.app-customer-logistics-box {
    position: relative;
    background-image: url(../../../assets/images/bi/bg-logistics.png);
    background-size: contain;
    background-position: top center;
    background-repeat: no-repeat;
    background-color: #F3F3F3;
    clear: both;
    .customer-box {
        padding: 27px 12px;
        margin-bottom: 12px;
        display: flex;
        justify-content: space-between;
        &:last-child {
            margin-bottom: 0px;
        }
        .customer-icon {
            padding-right: 10px;
            i {
                display: block;
                width: 30px;
                height: 30px;
                background-image: url(../../../assets/images/bi/icon-store.png);
                background-position: center center;
                background-size: contain;
                background-repeat: no-repeat;
            }
        }
        .customer-info {
            width: calc(100% - 40px);
            h3 {
                font-size: 14px;
                font-weight: bold;
                color: #FFFFFF;
                line-height: 20px;
            }
            dl {
                display: flex;
                font-size: 13px;
                font-weight: 400;
                line-height: 18px;
                padding-top: 4px;
                dt {
                    color: #EBEBEB;
                    width: 90px;
                    padding-right: 6px;
                }
                dd {
                    font-weight: 500;
                    color: #FFFFFF;
                }
            }
        }
    }
    .logistics-box {
        position: relative;
        top: -20px;
        min-height: calc(100vh - 206px);
        background: #F3F3F3;
        border-radius: 20px 20px 0px 0px;
        padding: 0px 12px;
        .logistics-list {
            display: flex;
            padding: 16px 0;
            a {
                display: inline-block;
                height: 30px;
                line-height: 30px;
                border-radius: 15px;
                padding: 0 22px;
                margin-right: 20px;
                color: #333333;
                border: 1px solid #333333;
                &.active {
                    background: #FFF3F3;
                    border: 1px solid #ED3129;
                }
                &.disable {
                    color: #999999;
                    background: #EFEFEF;
                    border: 1px solid #CCCCCC;
                }
            }
        }
        .logistics-info {
            background: #FFFFFF;
            border-radius: 10px;
            height: 100%;
            overflow: auto;
            padding: 16px 15px;

            h4 {
                font-size: 14px;
                color: #333333;
                display: flex;
                align-items: center;
                padding-bottom: .28rem;
                line-height: 1;

                span:nth-child(1) {
                    font-weight: 700;
                    margin: 0 .06rem;
                }

                span:nth-child(2) {
                    border-radius: .08rem;
                    padding: 0 .12rem 0 .14rem;
                    height: .32rem;
                    line-height: .32rem;
                    color: #ED3129;
                    border: .02rem solid #ED3129;
                    background: #FFF3F3;
                    font-size: 10px;
                }
            }

            .van-steps {
                .active-icon {
                    width: 12px;
                    height: 12px;
                    border-radius: 50%;
                    background: #FE8B3D;
                    box-shadow: #FE8B3D 0 0 12px;
                    position: relative;
                    left: -15px;
                    top: 16px;
                }
                .finish-icon {
                    width: 24px;
                    height: 24px;
                    position: relative;
                    left: -15px;
                    top: 16px;
                    background: #FFF3F3;
                    color: #ED3129;
                    font-size: 10px;
                }
                .van-step--vertical:first-child::before {
                    left: 20px;
                }
                .van-step--vertical {
                    padding: 0 0 0 36px;
                    .van-step__title--active {
                        span {
                            color: #ED3129;
                        }
                    }
                    &.van-hairline {
                        font-size: 13px;
                        line-height: 36px;
                        padding-bottom: 32px;
                        &:nth-last-child(1){
                            padding-bottom: 10px;
                        }
                    }
                    .van-step__circle-container {
                        top: 0;
                        left: 35px;
                    }
                    .van-step__line {
                        left: 20px;
                        top: 20px;
                    }
                    .van-step__title {
                        font-size: 12px;
                        color: #999999;
                        .time {
                            position: absolute;
                            left: -28px;
                            top: 5px;
                            width: 60px;
                            line-height: 16px;
                            color: #999999;
                            font-size: 10px;
                        }
                    }
                } 
            }
        }
    }
}
</style>
