<template>
    <app-template @init="init">
        <div class="Page-subject celarfix" :style="[{'padding-top':isApp ? '0' :'0.92rem'}]">
            <div class="top-banner" />
            <div class="item-hd">
                <van-list v-model="loading" :finished="finished" :finished-text="'没有更多数据了'" :offset="50" immediate-check="false" @load="onLoad">
                    <product-card v-for="(item, index) in productData" :key="index" :item="item" theme="theme-2" :card-type="'search'" :current-type="1" :source="isApp ? 'app' : 'h5'" />
                </van-list>
            </div>
            <div class="bottom-banner" />
            <a v-show="scrollHeight >= 50" class="back-top" href="#TOP">
                <van-icon name="down" />
                <p>回到顶部</p>
            </a>
        </div>
    </app-template>
</template>

<script>
import AppTemplate from '@/components/appTemplate/Index'
import productCard from '@/components/productCard/index'
import VMnative from '@/utils/VMnative'
import Api from '@/api/activity/sale'

export default {
    components: {
        AppTemplate,
        productCard
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
            VMnative.callHandler("setTitle", "抗击疫情，我们在行动！")
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
            Api.productPageByLabels({
                label: '抗击疫情',
                current: this.page,
                size: 10
            }).then(({ data }) => {
                this.productData = data.data.records || []
            })
        },
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        onLoad(){
            Api.productPageByLabels({ label: '抗击疫情', current: this.page + 1, size: 10 }).then(({ data: { data }}) => {
                this.productData = this.productData.concat(data.records || [])
                this.loading = false
                if (this.page >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
            })
        }
    }
}
</script>

<style lang="scss">
.Page-subject {
    background-color: #E10015;
    .top-banner {
        width:100%;
        height: 3.8rem;
        background-image:url('https://imga.hnhcyy.com/fed/b2b-h5/subject/special/banner@2x.png');
        background-size: cover;
        background-position: top center;
        background-repeat: no-repeat;
    }
    .bottom-banner {
        width:100%;
        height: 1rem;
        background-image:url('https://imga.hnhcyy.com/fed/b2b-h5/subject/special/bottom_banner@2x.png');
        background-size: cover;
        background-position: bottom center;
        background-repeat: no-repeat;
        opacity: .4;
    }
    // .van-list{
    //     display: flex;
    //     flex-wrap: wrap;
    //     justify-content: space-between;
    // }
    .item-hd {
        width: calc(100% - 0.3rem);
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        margin: 0 .15rem;
        background: #FFF;
        .van-list{
            display: flex;
            flex-wrap: wrap;
        }
    }

    .van-list__finished-text{
        clear: both;
    }

    .item-li {
        position: relative;
        min-height: 306px;
        float: left;
        overflow: hidden;
        &::before {
            position: absolute;
            content: " ";
            left: 0;
            bottom: 0.1rem;
            width: 220%;
            z-index: 1;
            border-top: 1px solid #eaeaea;
            -webkit-transform-origin: 0 0;
            transform-origin: 0 0;
            -webkit-transform: scale(0.5, 0.5);
            transform: scale(0.5, 0.5);
        }

        &::after {
            position: absolute;
            content: " ";
            left: 0;
            top: -0.05rem;
            height: 198%;
            z-index: 1;
            border-right: 1px solid #eaeaea;
            -webkit-transform-origin: 0 0;
            transform-origin: 0 0;
            -webkit-transform: scale(0.5, 0.5);
            transform: scale(0.5, 0.5);
        }

        .item-image {
            width: 3.19rem;
            height: 3.19rem;
            background: #fff;
            padding: 0 0.2rem;
            position: relative;

            img {
                width: 100%;
                height: 100%;
            }

            .sold-out {
                position: absolute;
                top: 1.4rem;
                left: 1.18rem;
                width: 1.4rem;
                height: 1.4rem;
                z-index: 2;
            }
        }

        .item-info {
            padding: 0 0.2rem 0.22rem;
            .van-stepper .van-stepper__input {
                width: .9rem;
            }
            .row-1 {
                display: flex;
                align-items: center;
                padding-top: 0.08rem;

                .title {
                    display: inline-block;
                    max-width: 1.75rem;
                    color: #030303;
                    // font-weight: bold;
                    font-size: 0.32rem;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }
            }

            .row-2 {
                font-size: 0.24rem;
                color: #999;
                line-height: 1;
                max-width: 3.2rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .row-3,
            .row-4 {
                color: #000;
                font-size: 0.24rem;
            }

            .row-3 {
                padding-top: 0.12rem;
            }

            .row-4 {
                padding-bottom: 0.12rem;
                max-width: 3.2rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .row-5 {
                display: flex;
                align-items: center;

                span {
                    &:nth-child(1) {
                        font-size: 0.24rem;
                        color: #ed3129;
                        padding-right: 0.04rem;
                    }

                    &:nth-child(2) {
                        font-size: 0.36rem;
                        color: #ed3129;
                        font-weight: bold;
                        margin-right: 0.08rem;
                    }

                    &.activityType {
                        padding: 0.01rem 0.1rem;
                        color: #ed3129;
                        font-size: 0.2rem;
                        border: 1px solid #ed3129;
                        border-radius: 8px;
                        margin-right: 0.2rem;
                        margin-left: .1rem;
                        line-height: 1;
                    }

                    &.retailPrice {
                        font-size: 0.24rem;
                        color: #999999;
                    }
                }
                
                img{
                    width: .56rem;
                }

                .van-icon {
                    float: right;
                    font-size: 0.48rem;
                    color: #ed3129;
                    margin-right: 0.2rem;
                }
            }

            .row-6 {
                display: flex;
                align-items: center;
            }
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
}
</style>
