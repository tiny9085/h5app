<template>
    <app-template @init="init">
        <div class="Page-subject celarfix" :style="[{'padding-top':isApp ? '0' :'0.92rem'}]">
            <div class="goods-list">
                <van-list v-model="loading" :finished="finished" :finished-text="'没有更多数据了'" :offset="50" immediate-check="false" @load="onLoad">
                    <div v-for="(item, index) in productData" :key="index" class="package-box">
                        <div v-if="item.activityType == 2 || item.activityType == 4 || item.activityType == 1 || item.activityType == 3">
                            <div class="package-box-title">
                                <span>{{ item.promotionRule.typeName }}</span>
                            </div>
                            <div class="tips">
                                {{ item.name }}
                                <div class="triangle triangle-left" />
                                <div class="triangle triangle-right" />
                            </div>
                            <div v-for="(items, aindex) in item.promotionProduct" :key="aindex" class="pkg-box">
                                <div class="pkg-box-item">
                                    <div class="col-1 col">
                                        <div class="row-1">
                                            <image-load
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="items.mainImg"
                                                :sid="items.proSid"
                                                :source="isApp ? 'app' : 'h5'"
                                                :item="items"
                                            />
                                        </div>
                                    </div>
                                    <div class="col-2 col">
                                        <div class="row row-1">
                                            <span>{{ items.productName }}</span>
                                        </div>
                                        <div class="row row-2">{{ items.spec }}</div>
                                        <div v-if="items.expireDateStr != null" class="row row-3">效期优于 {{ items.expireDateStr }}</div>
                                        <div class="row row-4">{{ items.manufacturer }}</div>
                                    </div>
                                    <div class="col-3 col">
                                        <div class="row-1">
                                            <span>×</span>
                                            <span>{{ items.proReachNum }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="package-info">
                                <span>活动价：</span>
                                <span>¥</span>
                                <span>{{ (item.totalPrice || 0).toFixed(2) }}</span>
                            </div>
                            <div v-if="item.promotionGifts.length !== 0" class="gift-box">
                                <div v-for="(gift, bindex) in item.promotionGifts" :key="bindex" class="gift-list">
                                    <div class="brand">赠品</div>
                                    <image-load
                                        class="img-box"
                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                        :original-image="gift.mainImg"
                                        :sid="gift.proSid"
                                        :source="isApp ? 'app' : 'h5'"
                                        :item="gift"
                                    />
                                    <div class="gift-info">
                                        <div class="floor-1">
                                            <span>{{ gift.commodityName }}</span>
                                        </div>
                                        <div class="floor-2">
                                            {{ gift.spec }}
                                            <div class="num">
                                                <span>×</span>
                                                <span>{{ gift.count }}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="btn-box">
                                <template v-if="item.stockStatus">
                                    <add-to-cart :item="item" :activity-type="item.activityType" :source="isApp ? 'app' : 'h5'" />
                                </template>
                                <template v-else>
                                    <span class="arrivalTimeStr">预计到货：</span>
                                    <span class="arrivalTimeStr">{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</span>
                                </template>
                            </div>
                        </div>
                    </div>    
                </van-list>
            </div>
            <a v-show="scrollHeight >= 50" class="back-top" href="#TOP">
                <van-icon name="down" />
                <p>回到顶部</p>
            </a>
        </div>
    </app-template>
</template>

<style lang="scss">
    .Page-subject{
        background: #F4F4F4;
        .arrivalTimeStr{
            color: #ed3129;
            font-size: .24rem;
        }
        .sold-out {
            position: absolute;
            top: 0;
            right: 0;
            width: 1.6rem;
            height: 1.6rem;
        }
    }
    .back-top {
        z-index: 99;
        position: fixed;
        text-align: center;
        bottom: 100px;
        width:1rem;
        height:1rem;
        background:rgba(255,255,255,.8);
        box-shadow:0px 4px 13px 3px rgba(153,153,153,0.3);
        border-radius:50%;
        right: 0.2rem;
        color: #666;
        font-size: .16rem;
        transform: translateZ(0);
        .van-icon {
            margin-top: .2rem;
            transform: rotateX(180deg);
            font-size: .38rem;
            color: #999;
            font-weight: bold;
            opacity: .8;
        }
        p {
            margin-top: -2px;
        }
    }
    .package-box {
        background: #fff;
        margin: .2rem .2rem 0;
        border-radius: .08rem;

        .package-box-title {
            padding: 0.2rem;
            display: flex;
            align-items: center;
            line-height: 1;
            flex-direction: column;
            align-items: flex-start;

            span:nth-child(1) {
                font-size: 0.36rem;
                color: #333333;
                padding: .08rem 0;
            }

            span:nth-child(2) {
                font-size: 0.28rem;
                line-height: .32rem;
                color: #666666;
            }
        }

        .tips{
            background: #FDEAE9;
            padding: .12rem .4rem .12rem .6rem;
            color: #ED3129;
            font-size: .28rem;
            line-height: .4rem;
            width: 6.7rem;
            position: relative;
            left: -.4rem;
            text-align: justify;
            .triangle{
                position: absolute;
                border-width: .1rem;
                border-style: solid;
                &.triangle-left{
                    bottom: -.2rem;
                    left: .2rem;
                    border-color: #FABCBF #FABCBF transparent transparent;
                }
                &.triangle-right{
                    bottom: -.2rem;
                    right: 0;
                    border-color: #FABCBF transparent transparent #FABCBF;
                }
            }
        }

        .pkg-name {
            font-size: 0.28rem;
            color: #666666;
            padding: 0 0.4rem;
        }

        .pkg-box {
            .pkg-box-item {
                display: flex;
                padding: 0.32rem 0.2rem 0.2rem;
                border-bottom: 0.01rem solid #e4e4e4;
                &:last-child {
                    border: none;
                }
            }

            .col-1 {
                margin-right: 0.2rem;

                .row-1 {
                    width: 1.48rem;
                    height: 1.48rem;
                    position: relative;
                    img {
                        width: 100%;
                        height: 100%;
                    }
                }
            }

            .col-2 {
                margin-right: 0.6rem;
                width: 3.9rem;

                .row-1 {
                    display: flex;
                    align-items: center;

                    span:nth-child(1) {
                        color: #333333;
                        font-size: 0.32rem;
                        max-width: 2.7rem;
                        overflow: hidden;
                        white-space: nowrap;
                        text-overflow: ellipsis;
                    }
                }

                .row-2 {
                    padding-top: 0.08rem;
                    color: #999999;
                    font-size: 0.24rem;
                }

                .row-3 {
                    padding-top: 0.2rem;
                }

                .row-3,
                .row-4 {
                    color: #666666;
                    font-size: 0.28rem;
                }
            }

            .col-3 {
                display: flex;
                align-items: center;

                span:nth-child(1) {
                    color: #cccccc;
                    font-size: 0.38rem;
                }

                span:nth-child(2) {
                    color: #333333;
                    font-size: 0.28rem;
                }
            }
        }

        .package-info {
            line-height: 1;
            display: flex;
            align-items: center;
            padding: 0.08rem 0 0.2rem 1.9rem;

            span {
                color: #ed3129;

                &:nth-child(1) {
                    font-size: 0.28rem;
                }

                &:nth-child(2) {
                    font-size: 0.28rem;
                }

                &:nth-child(3) {
                    font-size: 0.36rem;
                    font-weight: 700;
                    padding-right: 0.2rem;
                }

                &:nth-child(4) {
                    font-size: 0.24rem;
                    color: #999999;
                    text-decoration: line-through;
                    padding-right: 0.44rem;
                }
            }

            van-icon {
                color: #ed3129;
                font-size: 0.52rem;
            }
        }
        .btn-box {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 0.4rem 0.2rem 0.2rem;
            margin-bottom: .2rem;
            padding-left: 1.9rem;

            .van-icon {
                font-size: 0.52rem;
                color: #ed3129;
                padding-left: 2.34rem;
            }
        }

        .gift-list {
            display: flex;
            align-items: center;
            padding: 0.2rem;

            .van-checkbox {
                .van-checkbox__icon {
                    width: 0.32rem;
                    height: 0.32rem;
                }
            }

            .brand {
                font-size: 0.24rem;
                color: #ffffff;
                padding: 0 0.08rem;
                background: #ed3129;
                opacity: 0.5;
                margin: 0 0.12rem 0 .2rem;
            }

            .img-box {
                width: 0.6rem;
                height: 0.6rem;
                margin-right: 0.2rem;

                img {
                    width: 0.6rem;
                    height: 0.6rem;
                    margin-right: 0.2rem;
                }
            }

            .gift-info {
                width: 4.9rem;

                .floor-1 {
                    display: flex;
                    align-items: center;
                    line-height: 1;
                    padding-bottom: 0.08rem;

                    span:nth-child(1) {
                        color: #666666;
                        font-size: 0.28rem;
                        max-width: 2.8rem;
                        text-overflow: ellipsis;
                        overflow: hidden;
                        white-space: nowrap;
                    }
                }

                .floor-2 {
                    color: #999999;
                    font-size: 0.24rem;
                    display: flex;
                    align-items: center;
                    line-height: 1;
                    justify-content: space-between;

                    .num {
                        padding-left: 1rem;
                        display: flex;
                        align-items: center;

                        span:nth-child(1) {
                            color: #cccccc;
                            font-size: 0.32rem;
                            padding-right: 0.08rem;
                        }

                        span:nth-child(2) {
                            color: #999999;
                            font-size: 0.22rem;
                        }
                    }
                }
            }
        }
    }
</style>

<script>
import AppTemplate from '@/components/appTemplate/Index'
import VMnative from '@/utils/VMnative'
import addToCart from '@/components/addToCart/index'
import imageLoad from '@/components/imageLoad/index'
import Api from '@/api/activity/package'
export default {
    components: {
        AppTemplate,
        addToCart,
        imageLoad
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            productData: [],
            loading: false,
            finished: false,
            scrollHeight: 0,
            page: 1
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "套餐专区")
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        }
        window.addEventListener('scroll', this.scroll);
    },
    methods: {
        init() {
            this.fecthProduct()
        },
        fecthProduct() {
            Api.fetchGoods({
                types: '2,4',
                current: 1,
                size: 20,
                sourceType: 0
            }).then(({ data }) => {
                this.productData = data.data.records || []
            })
        },
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        onLoad(){
            setTimeout(() => {
                Api.fetchGoods({ current: this.page + 1, size: 20, types: '2,4', sourceType: 0 }).then(({ data: { data }}) => {
                    this.productData = this.productData.concat(data.records || [])
                    this.loading = false
                    if (this.page >= data.pages) {
                        this.finished = true
                    } else {
                        this.page++
                    }
                })
            }, 500)
        }
    }
}
</script>
