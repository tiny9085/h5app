<template>
    <app-template system="bi" @init="init">
        <a class="btn" :href="locationType+'://bi/memberDetail?userInfoSid=19638&archiveCode=BBMMMM11323'">客户详情</a>
        <div class="app-customer-box" :style="[{'min-height':winHeight+'px'}]">
            <div class="search-bar-box">
                <van-search
                    v-model.trim="keyword"
                    left-icon=""
                    right-icon="search"
                    placeholder="请输入搜索关键词"
                    @search="search"
                >
                    <template #label>
                        <a @click="show = true">{{ activeWord }}<van-icon name="arrow-down" /></a>
                    </template>
                    <template #action>
                        <div @click="search">搜索</div>
                    </template>
                </van-search>
                <van-tabs v-model="active" @click="tabClick">
                    <van-tab>
                        <template slot="title"><p>({{ unSignedCount }})</p><p>客户待签收</p></template>
                    </van-tab>
                    <van-tab>
                        <template slot="title"><p>({{ signedCount }})</p><p>客户已签收</p></template>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="customer-list">
                <div v-if="active===1" class="search-tab">
                    <a :class="searchParams.type===5 ? 'active' : ''" @click="tabClick(5)">客户全部发出({{ signedAllSendCount }})</a>
                    <a :class="searchParams.type===4 ? 'active' : ''" @click="tabClick(4)">客户部分发出({{ signedOneSendCount }})</a>
                    <a :class="searchParams.type===3 ? 'active' : ''" @click="tabClick(3)">客户未发出({{ signedUnSendCount }})</a>
                </div>
                <van-list
                    v-model="loading"
                    :finished="finished"
                    finished-text="没有更多了"
                    :immediate-check="false"
                    @load="fetchList"
                >
                    <div v-for="item in customerData" :key="item" class="customer-li">
                        <div class="customer-icon"><i /></div>
                        <div class="customer-info">
                            <h3>{{ item.userName }}</h3>
                            <dl>
                                <dt>会员编号</dt>
                                <dd>{{ item.userCode }}<a class="btn-copy" @click="copy(item.userCode)" /></dd>
                            </dl>
                            <dl>
                                <dt>手机号</dt>
                                <dd>{{ item.contactTel }}<a class="btn-copy" @click="copy(item.userCode)" /></dd>
                            </dl>
                            <div class="customer-btns">
                                <a :class="['btn',{ 'disable' : item.receiveCode1 === '' && item.receiveCode2 === ''}]" @click="logisticsDetail(item,1)">收函物流</a>
                                <a :class="['btn',{ 'disable' : item.sendCode1 === '' && item.sendCode2 === ''}]" @click="logisticsDetail(item,2)">发函物流</a>
                                <!-- <a class="btn" :href="locationType+'://bi/memberDetail?customerSid=111'">客户详情</a> -->
                            </div>
                        </div>
                    </div>
                </van-list>
            </div>
        </div>
        <van-action-sheet v-model="show" :actions="actions" @select="onSelect" />
    </app-template>
</template>
<script>
import AppTemplate from '@/components/appTemplate/Index'
import Api from '@/api/bi/customer'
import VMnative from '@/utils/VMnative'
export default {
    name: 'AccountService',
    components: {
        AppTemplate
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            active: 0,
            keyword: '',
            searchParams: {
                type: 1,
                current: 1,
                size: 10
            },
            scrollHeight: 0,
            customerData: [],
            unSignedCount: 0,
            signedCount: 0,
            signedAllSendCount: 0,
            signedOneSendCount: 0,
            signedUnSendCount: 0,
            loading: false,
            finished: false,
            show: false,
            activeWord: '会员名称',
            activeCode: 1,
            actions: [
                { name: '会员名称', value: 1 }, 
                { name: '会员编号', value: 2 }
            ],
            locationType: navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) ? 'hcjkpay' : 'hcyy'
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
            VMnative.callHandler("setTitle", "发函客户")
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    },
    activated(){
        if (localStorage.getItem('customer@scroll')){
            this.scrollToPosition(Number(localStorage.getItem('customer@scroll')))
            localStorage.removeItem('customer@scroll')
        }
        
        VMnative.callHandler("setTitle", "发函客户")
        VMnative.registerHandler('goBack', (data, responseCallback) => {
            VMnative.callHandler("close", {})
        });
    },
    methods: {
        onSelect(item) {
            // 默认情况下点击选项时不会自动收起
            // 可以通过 close-on-click-action 属性开启自动收起
            this.show = false;
            this.activeWord = item.name
            this.activeCode = item.value
            if (this.keyword !== ''){
                this.search()
            }
        },
        tabClick(v){
            this.finished = false
            this.searchParams.current = 1
            this.customerData = []
            if (v === 0){
                this.searchParams.type = 1
                this.fetchList()
            } else if (v === 1) {
                this.searchParams.type = 2
                this.fetchList()
            } else {
                this.searchParams.type = v
                this.fetchList()
            }
        },
        init(){
            this.fetchList(1)
        },
        search(){
            this.timeout = setTimeout(() => {
                this.searchParams.current = 1
                this.finished = false
                this.customerData = []
                this.fetchList()
            }, 500)
        },
        fetchList(){
            this.loading = true
            if (this.activeCode === 1){
                delete this.searchParams.userCode
                this.searchParams.userName = this.keyword
            } else if (this.activeCode === 2){
                delete this.searchParams.userName
                this.searchParams.userCode = this.keyword
            }
            Api.fetchConfirmations(this.searchParams).then(({ data: { data }}) => {
                this.customerData = this.customerData.concat(data.list.records || [])
                this.unSignedCount = data.unSignedCount
                this.signedCount = data.signedCount
                this.signedAllSendCount = data.signedAllSendCount
                this.signedOneSendCount = data.signedOneSendCount
                this.signedUnSendCount = data.signedUnSendCount
                this.loading = false
                if (this.searchParams.current >= data.list.pages){
                    this.finished = true
                } else {
                    this.searchParams.current++
                }
            }).catch(() => {
                this.loading = false
                this.finished = true;
            })
        },
        scrollToPosition(position){
            setTimeout(function(){
                window.scrollTo(0, position)
            }, 0)
        },
        logisticsDetail(item, type){
            // type 1收函物流 2发函物流
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            localStorage.setItem("customer@scroll", scrollTop);
            this.$router.push({
                name: 'BiCustomerLogistics',
                params: item,
                query: {
                    type: type
                }
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
.app-customer-box{
    position: relative;
    background: #F3F3F3;
    clear: both;
    .search-bar-box {
        position: fixed;
        z-index: 1;
        top: 0;
        width: 100%;
        .van-search__label {
            a {
                font-size: 14px;
                font-weight: 400;
                color: #666666;
            }
            .van-icon-arrow-down {
                position: relative;
                bottom: -2px;
                margin-left: 4px;
            }
        }
    }
    .van-tabs--line {
        padding-top: 0;
        box-shadow: 0px 3px 4px 0px rgba(0, 0, 0, 0.03);
        .van-tabs__nav--line {
            padding-bottom: 0px;
        }
        .van-tabs__line {
            bottom: 0;
            width: 62px !important;
        }
        .van-tabs__wrap {
            height: auto;
            p {
                line-height: 22px !important;
            }
        }
        .van-tab__text {
            padding: 0px 0 9px 0;
            font-size: 16px;
        }
    }
    .customer-list {
        padding: 110px 12px 12px 12px;
        .search-tab {
            display: flex;
            justify-content: space-between;
            padding: 0 0 16px 0;
            a {
                display: inline-block;
                height: 30px;
                line-height: 30px;
                border-radius: 15px;
                padding: 0 15px;
                color: #333333;
                border: 1px solid #333333;
                &.active {
                    background: #FFF3F3;
                    border: 1px solid #ED3129;
                }
            }
        }
        .customer-li {
            background: #FFFFFF;
            box-shadow: 0px 2px 7px 0px rgba(0, 0, 0, 0.08);
            border-radius: 10px;
            padding: 16px 14px;
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
                    color: #333333;
                    line-height: 20px;
                    // min-height: 32px;
                }
                dl {
                    display: flex;
                    font-size: 13px;
                    font-weight: 400;
                    line-height: 18px;
                    padding-top: 4px;
                    dt {
                        color: #888888;
                        width: 90px;
                        padding-right: 6px;
                    }
                    dd {
                        font-weight: 500;
                        color: #333333;
                        a {
                            position: relative;
                            bottom: -3px;
                            margin-left: 13px;
                            display: inline-block;
                            width: 16px;
                            height: 16px;
                            background-position: center center;
                            background-size: contain;
                            background-repeat: no-repeat;
                        }
                        .btn-copy {
                            background-image: url(../../../assets/images/bi/icon-copy.png);
                        }
                        .btn-call {
                            background-image: url(../../../assets/images/bi/icon-phone.png);
                        }
                    }
                }
            }
            .customer-btns {
                padding-top: 12px;
                text-align: right;
                a {
                    display: inline-block;
                    font-size: 14px;
                    font-weight: bold;
                    color: #ED3129;
                    height: 30px;
                    line-height: 30px;
                    padding: 0 15px;
                    background: #FFF3F3;
                    border-radius: 15px;
                    border: 1px solid #ED3129;
                    margin-left: 10px;
                    &.disable {
                        color: #999999;
                        background: #EFEFEF;
                        border: 1px solid #CCCCCC;
                        &:active {
                            background: #EFEFEF;
                        }
                    }
                    &:active {
                        background: #f7e4e4;
                    }
                }
            }
        }
    }
}
</style>
