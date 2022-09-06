<template>
    <div v-if="theme === 'col'" class="goods-card">
        <div class="item-image">
            <a :href="'hcyy://commodity/commodityDetail?proSid='+data[sidName]">
                <div v-if="data.stock <= 0" class="no-stock" />
                <img :src="'https://imga.hnhcyy.com/'+data.mainImg+'?x-oss-process=image/resize,m_fill,h_300,w_300'">
            </a>
        </div>
        <div class="item-info">
            <div class="row-1 clearfix">
                <a :href="'hcyy://commodity/commodityDetail?proSid='+data[sidName]"><span class="title">{{ data.commodityName }}</span></a>
                <span v-if="data.brand" class="brand">{{ data.brand }}</span>
            </div>
            <div class="row-2">{{ data.spec }}</div>
            <div class="row-3">效期优于 {{ data.expireDateStr || data.productInfo.expireDateStr }}</div>
            <div class="row-4">{{ data.manufacturer }}</div>
            <div class="row-5">
                <span>¥</span>
                <span>{{ data.price }}</span>
                <span class="retailPrice">¥{{ data.retailPrice }}</span>
            </div>
            <div class="activity-tips">
                <template v-if="data.actName||data.activityList">
                    <span v-if="data.actName">{{ data.actName||data.activityList[0].activityContent }}</span>
                    <template v-for="item in data.activityList" v-else>
                        <span v-if="item.type==='1'||item.type===1" :key="item.activityId">
                            {{ item.activityContent }}
                        </span>
                    </template>
                </template>
                <template v-else>
                    &nbsp;&nbsp;
                </template>
            </div>
            <div class="row-6">
                <van-stepper v-model="data.quantity" :step="data.step" :min="data.minNum < data.stock ? data.minNum : data.stock" :max="data.maxNum > data.stock ? data.stock : data.maxNum" @blur="changeNum(data)" />
                <van-icon :class="[{'no-stock':data.stock <= 0 }]" name="shopping-cart-o" @click="addToCart(data)" />
            </div>
        </div>
    </div>
    <div v-else class="recommend-li clearfix">
        <a class="item-image" :href="'hcyy://commodity/commodityDetail?proSid='+data[sidName]">
            <div v-if="data.stock <= 0" class="no-stock" />
            <img :src="'https://imga.hnhcyy.com/'+data.mainImg+'?x-oss-process=image/resize,m_fill,h_300,w_300'">
        </a>
        <div class="item-info">
            <div class="row row-1">
                <a class="title" :href="'hcyy://commodity/commodityDetail?proSid='+data[sidName]">{{ data.commodityName }}</a>
                <span v-if="data.brand" class="item-label">{{ data.brand }}</span>
            </div>
            <div class="row row-2">{{ data.spec }}</div>
            <div class="row row-4">效期优于 {{ data.expireDateStr || data.productInfo.expireDateStr }}</div>
            <div class="row row-5">{{ data.manufacturer }}</div>
            <div class="row row-6">
                <span>¥</span>
                <span>{{ data.price }}</span>
                <span>¥{{ data.retailPrice }}</span>
            </div>
            <div class="activity-tips">
                <template v-if="data.actName||data.activityList">
                    <span v-if="data.actName">{{ data.actName||data.activityList[0].activityContent }}</span>
                    <template v-for="item in data.activityList" v-else>
                        <span v-if="item.type==='1'||item.type===1" :key="item.activityId">
                            {{ item.activityContent }}
                        </span>
                    </template>
                </template>
                <template v-else>
                    &nbsp;&nbsp;
                </template>
            </div>
            <div class="row row-7">
                <van-stepper v-model="data.quantity" :step="data.step" :min="data.minNum < data.stock ? data.minNum : data.stock" :max="data.maxNum > data.stock ? data.stock : data.maxNum" @blur="changeNum(data)" />
                <van-icon :class="[{'no-stock':data.stock <= 0 }]" name="shopping-cart-o" @click="addToCart(data)" />
            </div>
        </div>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
export default {
    props: {
        data: {
            type: Object,
            default: () => {
                return {}
            }
        },
        sidName: {
            type: String,
            default: 'sid'
        },
        theme: {
            type: String,
            default: 'col'
        }
    },
    methods: {
        /**
         * 加入购物车
         */
        addToCart(item){
            const data = {
                productId: item.sid,
                quantity: item.quantity,
                expiredStatus: item.expireStatus,
                expiredDate: item.expireDate
            }
            if (item.stock > 0){
                VMnative.callHandler("addToCart", data)
            } else {
                this.$toast('库存不足')
            }
        },
        /**
         * 改变步进器数量
         */
        changeNum(item){
            // 商品数量为0时默认数量为1
            if (!item.quantity)item.quantity = 1;

            const numFlag = item.quantity - item.minNum;
            if (numFlag % item.step) {
                const num = (Math.floor(numFlag / item.step) + 1) * item.step + item.minNum;
                if (item.stock > num) {
                    // 数量根据step向上取
                    if (item.quantity % item.step) item.quantity = num;
                }
            }
            
            if (item.stock > item.maxNum) {
                // 数量大于总数量时
                if (item.maxNum < item.quantity) {
                    item.quantity = item.maxNum;
                }
            } else {
                if (item.stock < item.quantity) {
                    item.quantity = item.stock;
                }
            }
        }
    }
}
</script>

<style lang="scss">

.goods-card {
    float: left;
    position: relative;
    padding: 0 .2rem .2rem .2rem;
    box-sizing: border-box;
    width: 50%;
    text-align: left;
    border-bottom: .5px solid rgba(228, 228, 228, 1);
    background: #FFF;
    height: 366px;
    &:nth-child(1n) {
        border-right: .5px solid rgba(228, 228, 228, 1);
    }
    &:nth-child(2n) {
        border-right: 0;
    }
    .item-image {
        width: 3rem;
        height: 3rem;
        background: #fff;
        margin-left: .15rem;
        position: relative;
        img {
            width: 100%;
            height: 100%;
        }
        .no-stock {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-position: center center;
            background-repeat: no-repeat;
            background-size: 50% 50%;
            background-image: url('https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/soldOut.png')
        }
    }
    .item-info {
        .row-1 {
            display: flex;
            align-items: center;
            padding-top: .08rem;
            justify-content: space-between;
            a{
                display: flex;
                align-items: center;
                .title {
                    max-width: 2.1rem;
                    color: #030303;
                    font-size: .32rem;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }
            }
            span {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
        }

        .row-2 {
            font-size: .24rem;
            color: #999;
            line-height: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .row-3,
        .row-4 {
            color: #000;
            font-size: .24rem;
        }

        .row-3 {
            padding-top: .02rem;
        }

        .row-4 {
            padding-bottom: .12rem;
            max-width: 3.2rem;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .row-5 {
            display: flex;
            align-items: center;
            padding-bottom: .11rem;
            span {
                &:nth-child(1) {
                    font-size: .24rem;
                    color: #ed3129;
                    padding-right: .04rem;
                }

                &:nth-child(2) {
                    font-size: .36rem;
                    color: #ed3129;
                    font-weight: bold;
                    margin-right: .08rem;
                }

                &.activityType {
                    padding: 0 .1rem;
                    color: #ed3129;
                    font-size: .2rem;
                    border: .02rem solid #ed3129;
                    border-radius: .16rem;
                    margin-right: .2rem;
                }

                &.retailPrice {
                    font-size: .24rem;
                    color: #999999;
                }
            }

            .van-icon {
                float: right;
                font-size: .48rem;
                color: #ed3129;
                margin-right: .2rem;
            }
        }
        .row-6 {
            display: flex;
            align-items: center;
            justify-content: space-between;
            .van-icon {
                font-size: .48rem;
                color: #ed3129;
                &.no-stock {
                    color: #666;
                }
            }
        }
        .activity-tips {
            height: .48rem;
            color: #ed3129;
            span {
                display: block;
                font-size: .2rem;
                background:rgba(237,49,41,0.08);
                border-radius:14px;
                padding: 0 .12rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                margin-bottom: .11rem;
            }
        }
    }
}

.recommend-li {
    position: relative;
    padding: .20rem 0;
    display: flex;
    background: #FFF;
    &::before {
        position: absolute;
        content: ' ';
        left: 0;
        bottom: 0;
        width: 200%;
        z-index: 1;
        border-top: 1px solid #EAEAEA;
        -webkit-transform-origin: 0 0;
        transform-origin: 0 0;
        -webkit-transform: scale(.5, .5);
        transform: scale(.5, .5);
    }

    &:last-child {
        &::before {
            display: none;
        }
    }

    .item-image {
        width: 2.00rem;
        height: 2.00rem;
        background: #FFF;
        position: relative;
        img {
            width: 100%;
            height: 100%;
        }
        .no-stock {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-position: center center;
            background-repeat: no-repeat;
            background-size: 50% 50%;
            background-image: url('https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/soldOut.png')
        }
    }

    .item-info {
        padding: 0 .30rem 0 .20rem;

        .row-1 {
            display: flex;
            align-items: center;
            padding-top: .08rem;

            .title {
                display: inline-block;
                max-width: 3.00rem;
                color: #030303;
                // font-weight: bold;
                font-size: .32rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .item-label {
                margin-left: 0.08rem;
                font-size: 0.22rem;
                padding: 0 0.08rem;
                border-radius: 0.16rem;
                color: #ed3129;
                border: 0.02rem solid #ed3129;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
        }

        .row-2 {
            font-size: .24rem;
            color: #999;
        }

        .row-3,
        .row-4,
        .row-5 {
            color: #666;
            font-size: .28rem;
        }

        .row-3 {
            padding-top: 12rem;
        }

        .row-5 {
            width: 4.60rem;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            padding-bottom: .12rem;
        }

        .activity-tips {
            height: .48rem;
            color: #ed3129;
            overflow: hidden;
            width: 4.60rem;
            text-overflow: ellipsis;
            white-space: nowrap;
            span {
                display: block;
                font-size: .2rem;
                background:rgba(237,49,41,0.08);
                border-radius:14px;
                padding: 0 .12rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                margin-bottom: .11rem;
            }
        }

        .row-6 {
            padding-bottom: .16rem;

            span {
                &:nth-child(1) {
                    font-size: .24rem;
                    color: #ED3129;
                    padding-right: .04rem;
                }

                        &:nth-child(2) {
                            font-size: .36rem;
                            color: #ED3129;
                            font-weight: bold;
                            margin-right: .20rem;
                        }

                        &:nth-child(3) {
                            font-size: .24rem;
                            color: #999999;
                        }
                    }

                    .label {
                        float: right;
                        font-size: .24rem;
                        color: #ED3129;
                        padding: .08rem .12rem;
                        border-radius: .28rem;
                        background: rgba(237, 49, 41, .1);
                    }
                }

                .row-7 {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    width: 4.60rem;

                    .van-icon {
                        font-size: .48rem;
                        color: #ED3129;
                    }

                    .sold-out-icon {
                        color: #666666 !important;
                    }
                }
            }
        }
</style>
