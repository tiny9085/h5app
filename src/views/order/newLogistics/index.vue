<template>
    <div class="logistics-box" :style="{minHeight:winHeight+'px'}">
        <div class="top-div" />
        <div v-if="logisticInfoList.length !== 0" class="order-code">
            <img src="@/assets/images/icon-logistics.png" alt="">
            <div class="order-code-box">
                <div class="row row-1">
                    <span>订单编号：</span>
                    <span>{{ orderId }}</span>
                </div>
                <div v-if="expressNum && expressNum !== 0" class="row row-2">
                    <span>包裹数量：</span>
                    <span>共<b>{{ expressNum }}</b>个包裹</span>
                </div>
            </div>
        </div>
        <van-collapse v-model="activeName" accordion="true" @change="onChange">
            <template v-if="logisticInfoList">
                <van-collapse-item v-for="(item,index) in logisticInfoList" :key="index" :name="index">
                    <div slot="title" class="title">
                        <span>快递单号:</span>
                        <span>{{ item[index] ? item[index].shippingCode : '' }}</span>
                        <span class="copy" @click="copy(item[index].shippingCode)">复制</span>
                    </div>
                    <div slot="value" class="select">
                        <span v-if="activeName === 0">收起</span>
                        <span v-else>展开</span>
                    </div>
                    <div class="logistics-box clearfix">
                        <template v-if="item">
                            <div v-for="(item1,index1) in item" :key="index1" class="logistics-li active clearfix">
                                <div class="l">
                                    <div :style="index1==0? 'color:#333333': ''">{{ item1.timeA }}</div>
                                    <div>{{ item1.timeB }}</div>
                                </div>
                                <!--  0 在途 1 揽件 2 疑难 3 签收 4 退签 5 派件 6 退回 -->
                                <div class="r">
                                    <template v-if="index1!=0">
                                        <img class="icon icon-state" src="@/assets/images/icon-after.png" alt="">
                                        <!-- <div v-if="item1.shippingState == 0" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-0-onTheWay-gray.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 1" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-1-package-gray.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 2" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-2-difficult-gray.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 3" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-3-signing-gray.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 4" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-4-refund-gray.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 5" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-5-piece-gray.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 6" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-6-return-gray.png" />
                                        </div> -->
                                    </template>
                                    <template v-if="index1==0">
                                        <img class="icon icon-state" src="@/assets/images/icon-current.png" alt="">
                                        <!-- <div v-if="item1.shippingState == 0" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-0-onTheWay.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 1" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-1-package.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 2" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-2-difficult.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 3" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-3-signing.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 4" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-4-refund.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 5" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-5-piece.png" />
                                        </div>
                                        <div v-if="item1.shippingState == 6" class="icon icon-state">
                                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-6-return.png" />
                                        </div> -->
                                    </template>
                                    <div :style="index1==0? 'color:#666666': ''">{{ item1.shippingStateDesc }}</div>
                                    <div :style="index1==0? 'color:#666666': ''">{{ item1.detail }}</div>
                                </div>
                            </div>
                        </template>
                        
                    </div>
                </van-collapse-item>
            </template>
        </van-collapse>
    </div>
</template>
<script>
import Api from '@/api/order/index'
import { Toast } from 'vant';
export default {
    data() {
        return {
            activeName: 0,
            logisticInfoList: [],
            logisticsId: this.$route.query.logisticsId,
            orderId: '',
            expressNum: Number(this.$route.query.expressNum)
        };
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "log-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "log-index");
    },
    created(){
        this.getLogi()
    },
    methods: {
        /**
         * 切换折叠项
         */
        onChange(event) {
            this.activeName = event;
        },
        /**
         * 获取物流信息
         */
        getLogi(){
            Api.getLogiInfo(this.logisticsId).then(data => {
                const item = data.data.data || {}
                item.forEach((logi, i) => {
                    if (i === 0) this.orderId = logi.orderId;
                    const timeA = logi.shippingUpdateTime.split(" ")[0].substring(5)
                    let timeB = logi.shippingUpdateTime.split(" ")[1]
                    timeB = timeB.substring(0, timeB.length - 3)
                    logi.timeA = timeA
                    logi.timeB = timeB
                })
                this.logisticInfoList.push(item);
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
            Toast({
                message: '复制成功',
                duration: 500
            })
            // document.removeChild(el)
            return flag;
        }
    }
};
</script>
<style  lang="scss">
.log-index{
    background: #F1F1F1;
}
.logistics-box {
    // background: #F4F4F4;
    .copy{
        padding: .08rem .1rem 0.06rem;
        color: #ED3129;
        font-size: .24rem;
        background: #FFE9E8;
        border-radius: .08rem;
    }
    .order-code {
        font-size: .28rem;
        background: #FFF;
        margin: 0.28rem 0.24rem 0.28rem 0.16rem;
        display: flex;
        align-items: center;
        border-radius: 0.08rem;
        img{
            height: 1.12rem;
            width: 1.12rem;
            padding: .04rem 0 .08rem;
            margin-right: .24rem;
        }
        .order-code-box{  
            line-height: 1;
            .row{
                &.row-1{
                    padding-bottom: .16rem;
                }
                &.row-2 {
                    span:nth-child(2){
                        color: #999999;
                    }
                }
                span {
                    b {
                        color: #ED3129;
                    }
                    &:nth-child(1) {
                        color: #999999;
                        margin-left: 0.2rem;
                    }
                    &:nth-child(2) {
                        color:#333333;
                    }
                }
            }
        }
    }
    .van-collapse-item{
        margin: 0 0.2rem 0.2rem 0.2rem;
        .title{
            font-size: .28rem;
            position: relative;
            padding-left: .28rem;
            span:nth-child(1){
                color: #999999;
            }
            span:nth-child(2){
                color: #333333;
            }
        }
        .van-cell__value{
            display: contents;
        }
        .select{
            color: #bbbbbb;
            font-size: 0.24rem;
        }
    }
    .van-cell{
        border-radius: 0.08rem;
        padding: 0.28rem 0.16rem 0.26rem 0;
    }
    .van-cell:not(:last-child)::after{
        border-bottom: 2px solid #dddddd;
        left: 0;
    }
    .van-collapse-item__wrapper{
        border-bottom-left-radius: 0.08rem;
        border-bottom-right-radius: 0.08rem;
    }
    .van-collapse-item__content{
        padding: 0.28rem;
    }
    .logistics-box {
        background: #FFF;
        border-radius:.10rem;
        overflow: hidden;
        .logistics-li {
            color: #999;
            .l {
                font-size: .28rem;
                float: left;
                div:nth-child(2){
                    font-size: 0.24rem;
                    text-align: right;
                }
            }
            .r {
                float: right;
                font-size:.28rem;
                width: 5.30rem;
                position: relative;
                padding-bottom: .90rem;
                &::after {
                    position: absolute;
                    content: ' ';
                    top: .20rem;
                    left: -.26rem;
                    width: .02rem;
                    height: 100%;
                    background: #E4E4E4;
                }
                .icon {
                    position: absolute;
                    z-index: 1;
                    &.icon-state {
                        display: inline-block;
                        left: -.38rem;
                        top: .08rem;
                        text-align: center;
                        line-height: .50rem;
                        width: .28rem;
                        height: .28rem;
                        border-radius: 50%;
                        color: #FFF;
                    }
                }
            }
            &:last-child {
                .r {
                    padding-bottom: 0;
                    &::after {
                        display: none;
                    }
                }
            }

        }
    }
}
</style>
