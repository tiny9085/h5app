<template>
    <div class="message-list" :style="[{'height': winHeight + 'px'}]">
        <div class="top-div" />
        <div v-for="(item, index) in infoList" :key="index" class="info-box">
            <router-link :to="`/message/item/${item.name}`">
                <div class="img">
                    <img :src="item.imgUrl">
                    <div v-if="item.infoNum !== 0" class="info" />
                </div>
                <div class="name">
                    <div>{{ item.title }}</div>
                    <!-- <div class="info-tips">您有一条新的{{ item.title }}</div> -->
                </div>
                <div class="arrow">
                    <img :src="item.image" alt="">
                </div>
            </router-link>
        </div>
    </div>
</template>

<script>
import Api from '@/api/message/message'
import systemIcon from '@/assets/images/system-icon.png'
import promotionIcon from '@/assets/images/promotion-icon.png'
import orderIcon from '@/assets/images/order-icon.png'
import arrivalIcon from '@/assets/images/arrival-icon.png'
import newProductIcon from '@/assets/images/newProduct-icon.png'
import upIcon from '@/assets/images/up-icon.png'
import arrowIcon from '@/assets/images/arrow-icon.png'
export default {
    name: 'MessageList',
    data() {
        return {
            infoList: [
                {
                    imgUrl: systemIcon,
                    infoNum: 0,
                    title: '系统消息',
                    name: 'systemQty',
                    image: arrowIcon
                },
                {
                    imgUrl: promotionIcon,
                    infoNum: 0,
                    title: '优惠促销',
                    name: 'promotionQty',
                    image: arrowIcon
                },
                {
                    imgUrl: orderIcon,
                    infoNum: 0,
                    title: '订单消息',
                    name: 'orderQty',
                    image: arrowIcon
                },
                {
                    imgUrl: arrivalIcon,
                    infoNum: 0,
                    title: '到货通知',
                    name: 'arrivalQty',
                    image: arrowIcon
                },
                {
                    imgUrl: newProductIcon,
                    infoNum: 0,
                    title: '新品消息',
                    name: 'newProductQty',
                    image: arrowIcon
                },
                {
                    imgUrl: upIcon,
                    infoNum: 0,
                    title: '上涨通知',
                    name: 'markUpQty',
                    image: arrowIcon
                }
            ]
        }
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    activated(){
        this.getMessageQty()
    },
    methods: {
        /**
         * 获取消息数量
         */
        getMessageQty(){
            Api.fetchMessageCount().then(({ data: { data }}) => {
                this.infoList.forEach(item => {
                    item.infoNum = data[item.name]
                })
            })
        }
    }
}
</script>

<style lang="scss">
.message-list {
    background:#f1f1f1;
    .info-box:nth-child(2){
        margin-top: 0.2rem;
    }
    .info-box {
        position: relative;
        margin: 0 .16rem;
        a {
            background:#fff;
            display: flex;
            align-items: center;
            padding: 0.28rem 0.22rem 0.28rem 0.4rem;
            .img {
                height: 0.64rem;
                width: 0.64rem;
                img {
                    height: 0.64rem;
                    width: 0.64rem;
                }
                .info {
                    &::before{
                        content: " ";
                        border: 0.08rem solid #FF4646;
                        border-radius:50%;
                        position: absolute;
                        z-index: 1000;
                        left: 2.68rem;
                        top: .4rem;
                        box-shadow: 0px 0px .08rem 0px rgba(255, 70, 70, 0.25);
                    }
                }
            }

            .name {
                position: relative;
                font-size: 0.32rem;
                color: #333333;
                padding-left: 0.28rem;
                margin-right: 0.82rem;
                width: 5rem;

                .info-tips {
                    font-size: 0.28rem;
                    color: #666666;
                }
            }

            .time {
                font-size: 0.24rem;
                color: #666666;
            }

            .arrow{
                height: 0.48rem;
                width: 0.48rem;
                img{
                    height: 0.48rem;
                    width: 0.48rem;
                }
            }
        }
    }
    .info-box:not(:last-child)::after {
        position: absolute;
        box-sizing: border-box;
        content: ' ';
        pointer-events: none;
        right: 0;
        bottom: 0;
        left: 1.3rem;
        border-bottom: 1px solid #ebedf0;
        -webkit-transform: scaleY(.5);
        transform: scaleY(.5);
    }
    .info-box:nth-child(2) a{
        border-top-left-radius:0.12rem;
        border-top-right-radius:0.12rem;
        padding-top: 0.42rem;
    }
    .info-box:last-child a{
        border-bottom-left-radius:0.12rem;
        border-bottom-right-radius:0.12rem;
    }
}
</style>
