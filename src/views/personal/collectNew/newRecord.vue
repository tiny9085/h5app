<template>
    <ul class="new-record-list" :style="{ height: height + 'px', overflowY: 'auto' }">
        <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦!'" :offset="50" @load="onLoad">
            <li v-for="(item, ind) in collectionList" :key="ind">
                <div class="grneral-goods">
                    <div class="content">
                        <div class="img-box">
                            <image-load
                                :is-product-img="true"
                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                :original-image="item.imgUrl"
                                sid="hasNotDetail"
                            />
                        </div>
                        <div class="goods-info">
                            <div class="row-1 goods-name">{{ item.productName }}</div>
                            <div class="row-2">
                                <span>{{ item.spec }}</span>
                            </div>
                            <div class="row-4">{{ item.manufacturer }}</div>
                            <div class="row-5">
                                <div>
                                    <span>¥</span>
                                    <span>{{ item.price }}</span>
                                </div>
                                <div>
                                    <span>月销量：</span>
                                    <span style="display:inline-block;width:60px">{{ item.salesNum || '未填' }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="submit-time">提交时间：{{ item.createTime }}</div>
                </div>
            </li>
        </van-list>
    </ul>
</template>
<script>
import imageLoad from '@/components/imageLoad/index'
import Api from '@/api/personal/newCollection'
import { Toast } from 'vant';
export default {
    components: {
        imageLoad
    },
    data() {
        return {
            loading: false,
            finished: false,
            collectionList: [],
            current: 1,
            size: 20
        }
    },
    computed: {
        height() {
            return this.$store.getters.winHeight - 45;
        }
    },
    methods: {
        onLoad() {
            Toast.loading({
                message: '加载中...'
            });
            this.loading = true;
            Api.collectionRecord({
                current: this.current,
                size: this.size
            }).then(({ data: { data }}) => {
                this.loading = false
                this.collectionList = [...this.collectionList, ...data.records];
                if (this.current >= data.pages){
                    this.finished = true
                } else {
                    this.current++
                }
                Toast.clear();
            })
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
.new-record-list{
    padding: 0 .16rem;
    margin-top: .24rem;
    padding-top: 45px;
    background: #F1F1F1;
    .grneral-goods{
        padding: .28rem .22rem .36rem .32rem;
        background: #fff;
        margin-bottom: .24rem;
        border-radius: .16rem;
        overflow: hidden;
        position: relative;
        .content{
            display: flex;
        }
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
                color: #999999;
            }

            .row-5 {
                display: flex;
                justify-content: space-between;
                div:nth-child(1) {
                    span:nth-child(1) {
                        font-size: .4rem;
                    }
                    span:nth-child(2) {
                        font-size: .40rem;
                    }
                }
                div:nth-child(2) {
                    font-size: .28rem;
                    color: #999999;
                }
            }
        }
        .submit-time{
            height: .6rem;
            line-height: .6rem;
            background: #F9F9F9;
            border-radius: .12rem;
            margin-top: .2rem;
            padding-left: .32rem;
            color: #999999;
        }
    }
}
</style>
