<template>
    <div class="order-good-list" :style="{minHeight: winHeight+'px'}">
        <div class="floor-1">
            共<span>{{ num }}</span>件商品
        </div>
        <div class="floor-2">
            <div v-for="(item1,index) in goodsList" :key="index">
                <div class="orderGeneralDetailList">
                    <div
                        v-for="(item,index1) in item1.orderGeneralDetailList"
                        :key="index1"
                        class="grneral-goods-list"
                    >
                        <div v-if="(item.activityTypeDesc||item.promotionTips)&&(item.level>-1 || item.level === undefined) && item.orderGiftList && item.orderGiftList.length" class="activity-title">
                            <div class="row-1">{{ item.activityTypeDesc }}</div>
                            <div class="row-2">
                                <i v-if="[1, 5, 6, 8].indexOf(item.activityType) > -1" class="activity-name">满赠</i>
                                <i v-if="[3, 9].indexOf(item.activityType) > -1" class="activity-name">满减</i>
                                <span>{{ item.ladderTips || item.promotionTips }}</span>
                            </div>
                        </div>
                        <div class="grneral-goods">
                            <div class="img-box">
                                <img v-if="item.saleType === 2 || item.presell" class="preSaleImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" alt="">
                                <image-load
                                    :is-product-img="true"
                                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                    :original-image="item.imgUrl||item.productImg"
                                    :sid="item.productSid"
                                    :item="item"
                                />
                            </div>
                            <div class="goods-info">
                                <div class="row-1 goods-name" @click="goDetail(item.productSid)">{{ item.commodityName || item.productName }}</div>
                                <div class="row-2">
                                    <span>{{ item.spec || item.productSpec }}</span>
                                </div>
                                <!-- <div v-if="item.expireDate" class="row-3">效期优于:{{ item.expireDate.split(" ")[0] }}</div> -->
                                <div class="row-4">{{ item.manufacturer }}</div>
                                <div class="row-5">
                                    <div>
                                        <span>¥</span>
                                        <span>{{ (item.price||0).toFixed(2) }}</span>
                                        <span>¥</span>
                                        <span>{{ (item.retailPrice||0).toFixed(2) }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div v-if="item.saleType === 2 || item.presell" class="preSaleTime">
                            <img src="@/assets/images/icon_presale.png">
                            <span v-if="item.predictShippingDate">此商品为预售商品，预计{{ item.predictShippingDate }}前发货</span>
                            <span v-else>此商品为预售商品，发货时间待定</span>
                        </div>
                        <div v-if="item.orderGiftList">
                            <div v-if="item.orderGiftList.length != 0" class="giftList-box">
                                <template v-for="(item2,index2) in item.orderGiftList">
                                    <div :key="index2" class="gift-box">
                                        <div class="row-1">
                                            <img v-if="item2.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                            <image-load
                                                :is-product-img="true"
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="item2.giftImg"
                                                :sid="item2.productSid"
                                                :item="item2"
                                            />
                                        </div>
                                        <div class="row-2">
                                            <div class="col-1">
                                                <span class="goods-zp">赠品</span>
                                                <span @click="goDetail(item2.productSid)">{{ item2.giftName }}</span>
                                            </div>
                                            <div class="col-3">
                                                <span>{{ item2.giftSpec }}</span>
                                                <span>× {{ item2.quantity }}</span>
                                            </div>
                                        </div>
                                    </div>
                                </template>
                            </div>
                        </div>
                        <div class="subtotal-info">
                            <span>小计</span>
                            <span>¥{{ (item.finalAmount || item.amount|| (item.quantity * item.price) || 0 ).toFixed(2) }}</span>
                            <span>数量：{{ item.quantity||0 }}</span>
                        </div>
                    </div>
                </div>
                <div class="orderPackageDetailList">
                    <div v-for="(item,index1) in item1.orderPackageDetailList" :key="index1" class="package-box">
                        <div class="package-goods">
                            <div class="package-title">{{ item.activityTypeDesc }}</div>
                            <div class="package-price">
                                <span>套餐价：<font>¥{{ (item.discountPrice||0).toFixed(2) }}</font></span>
                                <span v-if="item.originalPrice">原价：¥{{ (item.originalPrice||0).toFixed(2) }}</span>
                            </div>
                            <div v-if="(item.level>-1 || item.level === undefined) && item.promotionTips && item.orderGiftList && item.orderGiftList.length" class="tips">
                                <span class="activity-name">满赠</span>
                                <p>{{ item.promotionTips }}</p>
                            </div>
                            <div v-for="(item2,index2) in item.productList" :key="index2" class="list">
                                <div class="img-box">
                                    <image-load
                                        :is-product-img="true"
                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                        :original-image="item2.productImg"
                                        :sid="item2.productSid"
                                        :item="item2"
                                    />
                                </div>
                                <div class="goods-info">
                                    <div class="row row-1 goods-name" @click="goDetail(item2.productSid)">{{ item2.productName || item2.commodityName }}</div>
                                    <div class="row row-2">
                                        <span>{{ item2.productSpec || item2.spec }}</span>
                                        <span>× {{ item2.baseQuantity }}</span>
                                    </div>
                                    <!-- <div v-if="item2.expireDate" class="row row-3">效期优于:{{ item2.expireDate.split(" ")[0] }}</div> -->
                                    <div class="row row-4">{{ item2.manufacturer }}</div>
                                </div>
                            </div>
                            <div v-if="item.orderGiftList">
                                <div v-if="item.orderGiftList.length != 0" class="giftList-box">
                                    <div v-for="(item2,index2) in item.orderGiftList" :key="index2" class="gift-box">
                                        <div class="row-1">
                                            <img v-if="item2.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                            <image-load
                                                :is-product-img="true"
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="item2.giftImg"
                                                :sid="item2.productSid"
                                                :item="item2"
                                            />
                                        </div>
                                        <div class="row-2">
                                            <div class="col-1">
                                                <span class="goods-zp">赠品</span><span @click="goDetail(item2.productSid)">{{ item2.giftName }}</span>
                                            </div>
                                            <div class="col-3">
                                                <span>{{ item2.giftSpec }}</span>
                                                <span>× {{ item2.quantity }}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="subtotal-info">
                                <span>小计</span>
                                <span>¥{{ ( item.finalAmount || item.amount||0).toFixed(2) }}</span>
                                <span>数量：{{ item.quantity || item.packageQuantity || 0 }}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="orderGroupDetailList">
                    <div v-for="(item,index1) in item1.orderGroupDetailList" :key="index1" class="grneral-goods-list">
                        <div v-if="item.activityType !== null" class="activity-title">
                            <div class="row-1">{{ item.activityTypeDesc }}</div>
                            <div class="row-2">
                                <i v-if="[1, 5, 6, 8].indexOf(item.activityType) > -1" class="activity-name">满赠</i>
                                <i v-if="[3, 9].indexOf(item.activityType) > -1" class="activity-name">满减</i>
                                <span>{{ item.promotionTips }}</span>
                            </div>
                        </div>
                        <div v-for="(item2,index2) in item.orderGeneralDetailList" :key="index2" class="group-goods">
                            <div class="grneral-goods">
                                <div class="img-box">
                                    <image-load
                                        :is-product-img="true"
                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                        :original-image="item2.productImg"
                                        :sid="item2.productSid"
                                        :item="item2"
                                    />
                                <!-- <van-icon v-if="item2.medicalInsuranceSid !== 0" class="icon-yibao" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yibao.png?v=1" /> -->
                                </div>
                                <div class="goods-info">
                                    <div class="row-1 goods-name" @click="goDetail(item2.productSid)">{{ item2.productName }}</div>
                                    <div class="row-2">
                                        <span>{{ item2.productSpec }}</span>
                                    </div>
                                    <!-- <div v-if="item2.expireDate" class="row-3">效期优于:{{ item2.expireDate.split(" ")[0] }}</div> -->
                                    <div class="row-4">{{ item2.manufacturer }}</div>
                                    <div class="row-5">
                                        <div>
                                            <span>¥</span>
                                            <span>{{ (item2.price||0).toFixed(2) }}</span>
                                            <span>¥</span>
                                            <span>{{ (item2.retailPrice||0).toFixed(2) }}</span>
                                        </div>
                                    </div>
                                </div>    
                            </div>
                            <div v-if="item2.orderGiftList">
                                <div v-if="item2.orderGiftList.length != 0" class="giftList-box">
                                    <div v-for="(item3,index3) in item2.orderGiftList" :key="index3" class="gift-box">
                                        <div class="goods-zp">
                                            赠品
                                        </div>
                                        <div class="row-1">
                                            <img v-if="item3.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                            <image-load
                                                :is-product-img="true"
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="item3.giftImg"
                                                :sid="item3.productSid"
                                                :item="item3"
                                            />
                                        </div>
                                        <div class="row-2">
                                            <div class="col-1">
                                                <span @click="goDetail(item3.productSid)">{{ item3.giftName }}</span>
                                            </div>
                                            <div class="col-3">
                                                <span>{{ item3.giftSpec }}</span>
                                            </div>
                                        </div>
                                        <div class="row-3">
                                            <span>×</span>
                                            <span>{{ item3.quantity }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>  
                        </div>   
                    </div>
                </div>
            </div>
            <div class="order-gift">
                <template v-for="(item,index) in giftList">
                    <div v-if="item.currentLadder.giftList && item.currentLadder.giftList.length" :key="index" class="other-gift-box">
                        <div class="other-showgood">
                            <span class="activity-name">{{ item.currentLadder.activityTypeDesc || '组合' }}</span>
                            <div class="promotion-tips">{{ item.currentLadder.promotionTips }}</div>
                        </div>
                        <div class="giftList-box">
                            <div v-for="gift in item.currentLadder.giftList" :key="gift" class="gift-box">
                                <div class="row-1">
                                    <img v-if="gift.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                    <image-load
                                        :is-product-img="true"
                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                        :original-image="gift.giftImg"
                                        :sid="gift.productSid"
                                        :item="gift"
                                    />
                                </div>
                                <div class="row-2">
                                    <div class="col-1">
                                        <span @click="goDetail(gift.productSid)">{{ gift.giftName }}</span>
                                    </div>
                                    <div class="col-3">
                                        <span>{{ gift.giftSpec }}</span>
                                        <span>× {{ gift.quantity }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>
    </div>
</template>
<script>
import imageLoad from '@/components/imageLoad/index'
export default {
    components: {
        imageLoad
    },
    data(){
        return {
            goodsList: JSON.parse(localStorage.getItem('goodsLists')) || [],
            giftList: JSON.parse(localStorage.getItem("giftList")) || [],
            num: localStorage.getItem('goodnum')
        }
    },
    computed: {
        winHeight(){
            return this.$store.getters.winHeight
        }
    },
    mounted() {

    },
    methods: {
        // 跳转详情
        goDetail(sid) {
            this.$router.push(`/product/detail/${sid}`)
        }
    }
}
</script>
<style lang="scss">
%textOver {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.order-good-list {
    padding: 46px .16rem .28rem .16rem;
    background: #F1F1F1;
    box-sizing: border-box;
    .goods-zp{
        width: .76rem;
        height: .32rem;
        line-height: .32rem;
        text-align: center;
        background: #FFAAA7;
        border-radius: .16rem;
        font-size: .24rem;
        color: #ffffff;
        margin-right: .12rem;
    }
    .activity-name {
        height: .3rem;
        padding: 0 .1rem;
        font-style: normal;
        color: #ed3129;
        text-align: center;
        border-radius: 0.16rem;
        font-size: .2rem;
        border: 1px solid #ed3129;
        margin-right: .1rem;
        line-height: .3rem!important;
    }
    .giftList-box{
        overflow: hidden;
        background: #F9F9F9;
        border-radius: .12rem;
        padding: .4rem .28rem 0 .28rem;
        margin-top: .4rem;
    }
    .preSaleTime{
        display: flex;
        height: .56rem;
        line-height: .56rem;
        margin-top: .28rem;
        color: #FF6E00;
        font-size: .24rem;
        background: #FFF6EE;
        border-radius: .08rem;
        margin-bottom: -.2rem;
        img{
            width: .28rem;
            margin: .14rem;
        }
        span{
            flex: 1;
        }
    }
    .grneral-goods,
    .list {
        margin-top: .4rem;
        display: flex;
        position: relative;
        .img-box {
            width: 1.2rem;
            height: 1.2rem;
            position: relative;
            margin-right: .48rem;
            .preSaleImg{
                position: absolute;
                width: .76rem;
                height: .44rem;
                top: .2rem;
                left: 0;
                top: 0;
                z-index: 999;
            }
            .icon-yibao {
                position: absolute;
                top: 0;
                right: 0;
                font-size: .40rem;
            }

            img {
                width: 100%;
                height: 100%;
            }
        }
        .goods-info {
            font-size: .28rem;
            color: #666666;
            width: 5rem;
            .goods-name{
                color: #333333;
                font-size: .32rem;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
                font-weight: 600;
            }
            .row-2 {
                justify-content: space-between;
                display: flex;
                span {
                    color: #999999;
                    font-size: .24rem;
                }
                span:nth-child(1){
                    flex: 1;
                    @extend %textOver;
                }
            }

            .row-2{
                padding: .12rem 0;
                font-size: .24rem;
            }
            .row-4 {
                padding: .12rem 0;
                font-size: .28rem;
            }

            .row-5 {
                justify-content: space-between;

                div {
                    span:nth-child(1) {
                        font-size: .32rem;
                    }

                    span:nth-child(2) {
                        font-size: .40rem;
                    }

                    span:nth-child(3) {
                        margin-left: .28rem;
                    }

                    span:nth-child(3), span:nth-child(4) {
                        font-size: .28rem;
                        color: #999999;
                    }
                }

                div:nth-child(1) {
                    color: #ED3129
                }

                div:nth-child(2) {
                    color: #666666
                }
            }
        }
    }
    .gift-box {
        display: flex;
        align-items: center;
        margin-bottom: .4rem;
        .row-1 {
            width: .6rem;
            height: .6rem;
            margin-right: .28rem;
            position: relative;
            .gift-presell{
                width: .4rem;
                position: absolute;
                left: 0;
                top: 0;
                z-index: 2;
            }
            .image-box img {
                width: 100%;
                height: 100%;
            }
        }
        .row-2 {
            flex: 1;
            overflow: hidden;
            line-height: .36rem;
            .col-1 {
                display: flex;
                span:nth-child(2){
                    flex: 1;
                    color: #666666;
                    font-size: .28rem;
                    @extend %textOver;
                }
            }
            .col-3 {
                display: flex;
                margin-top: .08rem;
                span {
                    color: #999999;
                    font-size: .24rem;
                    &:nth-child(1){
                        flex: 1;
                        @extend %textOver;
                    }
                }
            }
        }
    }
    .floor-1 {
        padding: .4rem 0 .28rem .12rem;
        font-size: .28rem;
        color: #333333;
        span {
            display: inline-block;
            padding: 0 .08rem;
            color: #ED3129;
            font-size: .32rem;
        }
    }

    .floor-2 {
        background: #f4f4f4;
        .order-gift{
            margin-top: 0.2rem;
        }
        .subtotal-info{
            display: flex;
            padding: .28rem 0;
            color: #999999;
            font-size: .36rem;
            line-height: .5rem;
            span:nth-child(2){
                flex: 1;
                color: #333333;
                font-weight: 600;
                margin-left: .16rem;
            }
            span:nth-child(3){
                font-size: .28rem;
            }
        }
        .grneral-goods-list {
            overflow: hidden;
            padding: 0 .24rem 0 .28rem;
            background: #fff;
            margin-bottom: .2rem;
            border-radius: .16rem;
            .activity-title {
                padding-top: .32rem;
                .row-1 {
                    font-size: .32rem;
                    color: #333333;
                    font-weight: 600;
                    padding-bottom: .34rem;
                }
                .row-2 {
                    display: flex;
                    font-size: .28rem;
                    color: #666666;
                    font-weight: 600;
                    line-height: .36rem;
                    span{
                        @extend %textOver;
                        flex: 1;
                    }
                }
            }
        }
        .package-box {
            background: #FFF;
            margin-bottom: .28rem;
            padding: 0 .28rem;
            border-radius: .16rem;
            .package-title {
                font-size: .32rem;
                font-weight: 600;
                padding: .32rem 0;
            }
            .package-price {
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: .88rem;
                line-height: .88rem;
                font-size: .28rem;
                padding: 0 .24rem;
                background: #F6F6F6;
                border-radius: .12rem;
                span:nth-child(1) {
                    color: #666666;
                }
                font{
                    color: #ED3129;
                    font-size: .36rem;
                }
                span:nth-child(2) {
                    color: #BBBBBB;
                    text-decoration: line-through;
                }
            }
            .tips {
                display: flex;
                overflow: hidden;
                margin-top: .28rem;
                font-size: .28rem;
                color: #666666;
                p{
                    flex: 1;
                    line-height: .36rem;
                    // @extend %textOver;
                }
                .activity-name{
                    margin-right: .2rem;
                }
            }
        }
        .other-gift-box {
            background: #fff;
            padding: .4rem .28rem .28rem .28rem;
            border-radius: .16rem;
            margin-bottom: .28rem;
            .other-showgood{
                display: flex;
                // align-items: center;
            }
            .promotion-tips {
                flex: 1;
                // @extend %textOver;
                font-size: .28rem;
                color: #666666;
                margin-left: .1rem;
                font-weight: 600;
            }
        }
    }
}
</style>

