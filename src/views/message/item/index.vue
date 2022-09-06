<template>
    <div class="Page-index-message" :style="{padding:newsInfoList.length?'0.8rem 0':'0',minHeight:winHeight+'px'}">
        <van-list :finished="finished" :finished-text="'我是有底线的哦！'" :offset="10" @load="onLoad">
            <div v-for="(item, index) in newsInfoList" :key="index" class="info-box">
                <div class="time">{{ item.updateTime }}</div>
                <div class="content-box">
                    <div class="content">
                        <div class="title">{{ item.title }}</div>
                    </div>
                    <template v-if="$route.params.type === 'systemQty'">
                        <div class="note-text" v-html="item.content" />
                        <div v-if="item.isHiden" class="show-more" @click="showMore(item.index)">
                            <img src="@/assets/images/pull.png" alt="">
                        </div>
                    </template>
                    <template v-else-if="$route.params.type === 'orderQty'">
                        <div class="note-text" @click="$router.push({path:'/order/detail',query:{orderId:item.businessId}})" v-html="item.content" />
                        <div class="showDetail" @click="$router.push({path:'/order/detail',query:{orderId:item.businessId}})">
                            <span>前往查看</span>
                            <div><img src="@/assets/images/right-arrow.png" alt=""></div>
                        </div>
                    </template>
                    <template v-else>
                        <div class="mess-img" @click="jumpPage(item)"><img :src="$store.getters.userInfo.oss+item.mobileImgUrl"></div>
                        <div class="note-text" @click="jumpPage(item)" v-html="item.content" />
                        <div class="showDetail" @click="jumpPage(item)">
                            <span>前往查看</span>
                            <div><img src="@/assets/images/right-arrow.png" alt=""></div>
                        </div>
                    </template>
                </div>
            </div>
        </van-list>
        <div v-if="newsInfoList.length==0" class="no-message" :style="{height:winHeight+'px'}">
            <div><img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-message.png" alt=""></div>
            <span>暂无消息</span>
        </div>
    </div>
</template>

<script>
import Api from '@/api/message/message'
import {   Toast } from 'vant';
export default {
    name: 'MessageItem',
    data(){
        return {
            newsInfoList: [],
            type: 1,
            finished: false,
            current: 1
        }
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    created(){
        switch (this.$route.params.type){
            case 'systemQty':
                this.type = 1;
                break;
            case 'promotionQty':
                this.type = 2;
                break;
            case 'orderQty':
                this.type = 3;
                break;
            case 'arrivalQty':
                this.type = 4;
                break;
            case 'newProductQty':
                this.type = 5;
                break;
            case 'markUpQty':
                this.type = 6;
                break;
        }
        // this.onLoad()
    },
    methods: {
        /**
         * 获取消息列表
         */
        onLoad(){
            Toast.loading({
                message: '加载中...'
            });
            Api.fetchMessageList({ type: this.type, current: this.current, size: 10  }).then(({ data: { data }}) => {
                this.newsInfoList = this.newsInfoList.concat(data ? data.records || [] : [])
                if (this.current >= data.pages){
                    this.finished = true
                } else {
                    this.current++
                }
                Toast.clear();
            })
        },
        // 点击跳转对应页面
        jumpPage(item) {
            // if (sid !== 0){
            //     if (this.source !== 'app'){
            //         this.$router.push(`/product/detail/${sid}`)
            //     } else {
            //         window.location.href = 'hcyy://commodity/commodityDetail?proSid=' + sid
            //     }
            // } else if (item !== {}){
            if (item.mobileJumpType === 1){
                this.$router.push(`/product/detail/${item.mobileBusinessValue}`)
            } else if (item.mobileJumpType === 2){
                this.goInnerPage(item.mobileBusinessValue)
                // this.$router.push('/product/promotion')
            } else if (item.mobileJumpType === 3){
                if (item.mobileBusinessValue === '' || item.mobileBusinessValue == null){
                    return
                }
                if (item.mobileBusinessValue.indexOf('?') !== -1){
                    window.location.href = item.mobileBusinessValue + '&source=h5'
                } else {
                    window.location.href = item.mobileBusinessValue + '?source=h5'
                }
            } else if (item.mobileJumpType === 4){
                const firstSid = JSON.parse(item.mobileBusinessValue).parentTypeId
                const secondSid = JSON.parse(item.mobileBusinessValue).typeId
                this.$router.push('/menu?firstSid=' + firstSid + "&secondSid=" + secondSid)
            } 
            // }
        },
        /**
         * 跳转内部链接
         */
        goInnerPage(url){
            let linkUrl = ''
            switch (url){
                case '1': // 近期已采
                    // linkUrl = '/quick/index';
                    // localStorage.setItem("quickType", 1);
                    linkUrl = '/quick/index?quickType=1'
                    break;
                case '2': // 近期未采
                    // linkUrl = '/quick/index';
                    // localStorage.setItem("quickType", 2);
                    linkUrl = '/quick/index?quickType=2'
                    break;
                case '3': // 新品抢购
                    linkUrl = '/product/new-goods';
                    break;
                case '4': // 即将到货
                    linkUrl = '/product/coming-soon';
                    break;
                case '5': // 处方药首页
                    linkUrl = '/smart-mall/index';
                    break;
                case '6': // 即将上涨
                    linkUrl = '/product/get-rise';
                    break;
                case '7': // 宣传物料
                    linkUrl = '/product/materials';
                    break;
                case '8': // 我的优惠券
                    linkUrl = '/personal/coupon';
                    break;
                case '9': // 预售专区
                    if (localStorage.getItem("isShowNeedKnow") === 'true'){
                        linkUrl = '/product/needToknow?source=h5'
                    } else {
                        linkUrl = '/product/preSale';
                    }
                    break;
                case '10': // 领券中心
                    linkUrl = '/couponList/index';
                    break;
                case '11': // 恒昌资讯
                    linkUrl = '/news/index';
                    break;
                case '12': // 新品收集
                    linkUrl = '/personal/collectNew?source=h5&title=新品收集';
                    break;
            }
            this.$router.push(linkUrl)
        }
    }
}
</script>
<style lang="scss">
.Page-index-message{
    background: #F4F4F4;
    .info-box{
        padding: .40rem .20rem 0;
        .time{
            width: 2.40rem;
            padding: .06rem .15rem;
            background: rgba(0, 0, 0, .2);
            color: #ffffff;
            font-size: .24rem;
            margin: 0 auto;
            border-radius: .10rem;
        }
        .content-box{
            margin-top: .20rem;
            background: #ffffff;
            border-radius: .20rem;
            .content{
                padding: .30rem .20rem 0.3rem;
                // height: 202rem;
                overflow: hidden;
            }
            .showMore{
                padding: .30rem .20rem .20rem;
            }
            .title{
                color: #333333;
                font-size: .32rem;
                // padding-bottom: .30rem;
                line-height: 1;
            }
            
            .show-more{
                padding: .16rem 0 .28rem;
                display: flex;
                justify-content: center;
                align-items: center;
                border-top: .01rem solid #EAEAEA;
                img{
                    width: .30rem;
                    height: .30rem;
                }
            }
            .showDetail{
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: .20rem .20rem .26rem .20rem;
                border-top: .01rem solid #EAEAEA;
                line-height: 1;
                span{
                    color: #333333;
                    font-size: .30rem;
                }
                div{
                    img{
                        display: block;
                        color: #666666;
                        width: .17rem;
                        height: .29rem;
                    }
                }
            }
        }
    }
    .note-text{
        line-height: .40rem;
        color: #999999;
        font-size: .24rem;
        padding: 0rem .20rem .20rem;
    }
    .no-message{
        display: flex;
        flex-direction: column;
        align-items: center;
        img{
            width: 3.32rem;
            height: 3.12rem;
            margin-top: 2.64rem;
        }
        span{
            font-size: .36rem;
            color:#333333;
            padding-top: .54rem;
        }
    } 
    .mess-img{
        padding: 0rem  0.2rem 0 0.2rem;
       img{
            width: 100%;
            height: 3.74rem;
            border-radius: .10rem;
       }
    }
}
</style>
