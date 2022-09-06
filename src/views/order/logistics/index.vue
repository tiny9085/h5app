<template>
    <div class="logistics-box" :style="{minHeight:winHeight+'px'}">
        <div class="top-div" />
        <div v-if="logisticsInfo.length !== 0" class="order-code">
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
            <template v-if="logisticsInfo.length !== 0">
                <van-collapse-item v-for="(item,index) in logisticsInfo" :key="index" :name="item.shippingCode+','+index">
                    <div slot="title" class="title">
                        <span>快递单号:</span>
                        <span>{{ item.shippingCode }}</span>
                        <span class="copy" @click="copy(item.shippingCode)">复制</span>
                        <!-- <van-icon name="question-o" /> -->
                    </div>
                    <div slot="value" class="select">
                        <span v-if="activeName === ''">收起</span>
                        <span v-else>展开</span>
                    </div>
                    <div class="logistics-box clearfix">
                        <div v-for="(logistics,i) in item.orderTrackList" :key="i" class="logistics-li active clearfix">
                            <div class="l">
                                <div :style="i==0? 'color:#333333': ''">{{ logistics.timeA }}</div>
                                <div>{{ logistics.timeB }}</div>
                            </div>
                            <div class="r">
                                <template v-if="i!==0">
                                    <img class="icon icon-state" src="@/assets/images/icon-after.png" alt="">
                                    <!-- <div v-if="logistics.shippingState == 0" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-0-onTheWay-gray.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 1" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-1-package-gray.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 2" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-2-difficult-gray.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 3" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-3-signing-gray.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 4" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-4-refund-gray.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 5" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-5-piece-gray.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 6" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-6-return-gray.png" />
                                    </div> -->
                                </template>
                                <template v-if="i===0">
                                    <img class="icon icon-state" src="@/assets/images/icon-current.png" alt="">
                                    <!-- <div v-if="logistics.shippingState == 0" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-0-onTheWay.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 1" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-1-package.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 2" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-2-difficult.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 3" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-3-signing.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 4" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-4-refund.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 5" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-5-piece.png" />
                                    </div>
                                    <div v-if="logistics.shippingState == 6" class="icon icon-state">
                                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-6-return.png" />
                                    </div> -->
                                </template>
                                <div :style="i==0? 'color:#666666': ''">{{ logistics.shippingStateDesc }}</div>
                                <div :style="i==0? 'color:#666666': ''">{{ logistics.detail }}</div>
                            </div>
                        </div>
                    </div>
                </van-collapse-item>
            </template>
        </van-collapse>
        <div v-if="noPage" class="no-data">
            <img src="@/assets/images/emptyCart.png">
            <span>暂无数据！</span>
        </div>
    </div>
</template>
<script>
import Api from '@/api/order/index'
import { Toast } from 'vant';
export default {
    data() {
        return {
            activeName: 0,
            logisticsInfo: [],
            orderId: this.$route.query.orderId,
            expressNum: Number(this.$route.query.expressNum),
            noPage: false
        };
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "logistics-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "logistics-index");
    },
    created(){
        this.getLogi()
    },
    methods: {
        /**
         * 切换折叠项
         */
        onChange(event) {
            this.activeName = event
            const code = event.split(',')[0]
            const i = parseInt(event.split(',')[1])
            if (event !== ''){
                if (this.logisticsInfo[i].orderTrackList.length === 0){
                    Api.getLogiInfo(code).then(({ data: { data }}) => {
                        if (data.length !== 0){
                            for (const j in data) {
                                const timeA = data[j].shippingUpdateTime.split(" ")[0].substring(5)
                                let timeB = data[j].shippingUpdateTime.split(" ")[1]
                                timeB = timeB.substring(0, timeB.length - 3)
                                data[j].timeA = timeA
                                data[j].timeB = timeB
                            }
                            this.$set(this.logisticsInfo[i], 'orderTrackList', data)
                        }
                    })
                }
            }
        },
        /**
         * 获取物流列表
         */
        getLogi(){
            Api.getLogi(this.orderId).then(data => {
                const item = data.data.data || {}
                for (const i in item){
                    item[i].orderTrackList = []
                }
                this.logisticsInfo = item;
                this.noPage = !this.logisticsInfo.length
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
.logistics-index{
    background: #F1F1F1;
}
// .logistics-box {
//     background: #F4F4F4;
//     .copy{
//         padding: .06rem .1rem;
//         color: #ED3129;
//         font-size: .24rem;
//         background: #FFEAE9;
//         border-radius: .18rem;
//         margin-left: .5rem;
//     }
//     .order-code {
//         font-size: .28rem;
//         background: #FFF;
//         margin: 0.28rem 0.24rem 0.28rem 0.16rem;
//         display: flex;
//         align-items: center;
//         border-radius: 0.08rem;
//         img{
//             height: 1.12rem;
//             width: 1.12rem;
//         }
//         span {
//             &:nth-child(1) {
//                 color: #333;
//             }
//             &:nth-child(2) {
//                 color: #666;
//                 margin-left: 0.2rem;
//             }
//             &.copy{
//                 margin-left: .1rem;
//             }
//         }
//     }
//     .van-collapse-item{
//         .title{
//             font-size: .28rem;
//             position: relative;
//             padding-left: .60rem;
//             span:nth-child(1){
//                 color: #666666;
//                 padding-right: .08rem;
//             }
//             span:nth-child(2){
//                 color: #333333;
//             }
//             .van-icon{
//                 position: absolute;
//                 left: 0;
//                 top: .04rem;
//                 font-size: .36rem;
//             }
//         }
//     }
//     .logistics-box {
//         background: #FFF;
//         border-radius:.10rem;
//         overflow: hidden;
//         .logistics-li {
//             color: #777;
//             .l {
//                 font-size: .24rem;
//                 width: 1.10rem;
//                 float: left;
//             }
//             .r {
//                 float: right;
//                 font-size:.28rem;
//                 width: 5.30rem;
//                 position: relative;
//                 padding-bottom: .90rem;
//                 &::after {
//                     position: absolute;
//                     content: ' ';
//                     top: .20rem;
//                     left: -.40rem;
//                     width: .02rem;
//                     height: 100%;
//                     background: #E4E4E4;
//                 }
//                 .icon {
//                     position: absolute;
//                     z-index: 1;
//                     &.icon-dot {
//                         left: -.46rem;
//                         top: .20rem;
//                         width: .16rem;
//                         height: .16rem;
//                         border-radius: 50%;
//                         background: #E4E4E4;
//                     }
//                     &.icon-state {
//                         display: inline-block;
//                         left: -.64rem;
//                         top: .08rem;
//                         text-align: center;
//                         line-height: .50rem;
//                         width: .50rem;
//                         height: .50rem;
//                         border-radius: 50%;
//                         color: #FFF;
//                         .van-icon{
//                             width: .50rem;
//                             height: .50rem;
//                         }
//                     }
//                 }
//             }
//             &:last-child {
//                 .r {
//                     padding-bottom: 0;
//                     &::after {
//                         display: none;
//                     }
//                 }
//             }

//         }
//     }
// }
.logistics-box {
    background: #F1F1F1;
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
    .no-data {
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 9.2rem;

        img {
            width: 4.96rem;
            height: 4.96rem;
            margin-top: 1.44rem;
        }

        span {
            color:#BBBBBB;
            font-size: 0.32rem;
            padding-top: 0.54rem;
        }
    }
}
</style>
