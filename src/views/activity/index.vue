<template>
    <app-template @init="init">
        <div class="page-activity-index">
            <div v-if="!isApp" class="top-div" />
            <div class="activity-top">
                <!-- <div v-if="!isApp" class="title">
                    <img src="@/assets/images/icon-goback-w.png" alt="" @click="goback">
                    <span>活动专区</span>
                </div> -->
                <van-tabs :active="activeTabs" animated :ellipsis="false" @change="changeTabs($event)">
                    <van-tab v-for="(item, index) in activeTabsList" :key="index" :title="item" />
                </van-tabs>
            </div>
            <div class="activity-content-box">
                <div v-if="activeTabs===0" class="theme-1-box">
                    <div class="top-btn-box">
                        <van-button :class="isPackage ? '' : 'active-btn'" :icon="'https://imga.hnhcyy.com/fed/b2b-wechat/icon-single-product-' + (isPackage ? 'g' : 'r') + '.png'" :color="isPackage ? '#E4E4E4' : '#F3E0DF'" round @click="changeSingle">单品</van-button>
                        <van-button :class="isPackage ? 'active-btn' : ''" :icon="'https://imga.hnhcyy.com/fed/b2b-wechat/icon-package-product-' + (isPackage ? 'r' : 'g') + '.png'" :color="isPackage ? '#F3E0DF' : '#E4E4E4'" round @click="changePackage">套餐</van-button>
                    </div>
                    <div class="goods-list">
                        <template v-if="!isPackage">
                            <template v-if="singleProductParams.goodsList&&singleProductParams.goodsList.length<1">
                                <div class="no-data">
                                    <img src="@/assets/images/emptyCart.png">
                                    <span>暂无数据</span>       
                                </div>
                            </template>
                            <div v-else class="single-list-box">
                                <van-list v-model="singleProductParams.loading" :finished="singleProductParams.finished" :finished-text="'人家是有底线的哦!'" :offset="50" @load="singleOnLoad">
                                    <product-card v-for="(item, index) in singleProductParams.goodsList" :key="index" :item="item.promotionProduct[0]" :current-type="1" theme="theme-1" :source="isApp ? 'app' : 'h5'" />
                                </van-list>
                            </div>
                        </template>
                        <template v-else>
                            <template v-if="packageProductParams.goodsList&&packageProductParams.goodsList.length<1">
                                <div class="no-data">
                                    <img src="@/assets/images/emptyCart.png">
                                    <span>暂无数据</span>       
                                </div>
                            </template>
                            <div v-else class="package-list-box">
                                <van-list v-model="packageProductParams.loading" :finished="packageProductParams.finished" :finished-text="'人家是有底线的哦!'" :offset="50" @load="packageOnLoad">
                                    <div v-for="(item, index) in packageProductParams.goodsList" :key="index" class="package-box">
                                        <div v-if="item.activityType == 2 || item.activityType == 4 || item.activityType == 1 || item.activityType == 3">
                                            <div class="package-box-title">
                                                <span>{{ item.promotionRule.typeName }}</span>
                                            </div>
                                            <div class="tips">
                                                {{ item.tips }}
                                                <!-- <div class="triangle triangle-left" />
                                                <div class="triangle triangle-right" /> -->
                                            </div>
                                            <div class="price-box">
                                                <div class="row-1">
                                                    <span>套餐价:</span>
                                                    <span>￥</span>
                                                    <span>{{ item.totalPrice }}</span>
                                                </div>
                                                <div class="row-2">
                                                    <span>原价:￥{{ item.originalPrice }}</span>
                                                </div>
                                            </div>
                                            <div class="btn-box">
                                                <template v-if="item.stockStatus">
                                                    <stepper-number
                                                        :source="isApp ? 'app' : 'h5'"
                                                        :item="item"
                                                        :activity-type="item.activityType"
                                                    />
                                                    <add-to-cart :item="item" :activity-type="item.activityType" :source="isApp ? 'app' : 'h5'" />
                                                </template>
                                                <template v-else>
                                                    <span class="arrivalTimeStr">预计到货：</span>
                                                    <span class="arrivalTimeStr">{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</span>
                                                </template>
                                            </div>
                                            <div class="package-product-box">
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
                                                            <div class="row row-2">
                                                                <div class="row-2-col-1">{{ items.spec }}</div>
                                                                <div class="row-2-col-2">
                                                                    <span>×</span>
                                                                    <span>{{ items.proReachNum }}</span>
                                                                </div>
                                                            </div>
                                                            <div class="row row-4">{{ items.manufacturer }}</div>
                                                            <div v-if="items.expireDateStr != null" class="row row-3">
                                                                <span>效期优于</span>
                                                                <span>{{ items.expireDateStr }}</span>
                                                            </div>
                                                        </div>
                                                    </div>
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
                                            </div>
                                        </div>
                                    </div>    
                                </van-list>
                            </div>
                        </template>
                    </div>
                </div>
                <div v-if="activeTabs===1" class="theme-2-box">
                    <template v-if="hasNoPackage2">
                        <div class="no-data">
                            <img src="@/assets/images/emptyCart.png">
                            <span>暂无数据</span>       
                        </div>
                    </template>
                    <template v-else>
                        <div v-if="edit" style="height:0.4rem;" />
                        <div class="package-list-box">
                            <van-list v-model="packageProductParams2.loading" :finished="packageProductParams2.finished" :finished-text="'人家是有底线的哦!'" :offset="50" immediate-check="false" @load="packageOnLoad2">
                                <div v-for="(item, index) in packageProductParams2.goodsList" :key="index" class="package-box">
                                    <div v-if="item.activityType == 2 || item.activityType == 4 || item.activityType == 1 || item.activityType == 3">
                                        <div class="package-box-title">
                                            <span>{{ item.promotionRule.typeName }}</span>
                                        </div>
                                        <div class="tips">
                                            {{ item.tips }}
                                            <!-- <div class="triangle triangle-left" />
                                            <div class="triangle triangle-right" /> -->
                                        </div>
                                        <div class="price-box">
                                            <div class="row-1">
                                                <span>套餐价:</span>
                                                <span>￥</span>
                                                <span>{{ item.totalPrice }}</span>
                                            </div>
                                            <div class="row-2">
                                                <span>原价:￥{{ item.originalPrice }}</span>
                                            </div>
                                        </div>
                                        <div class="btn-box">
                                            <template v-if="item.stockStatus">
                                                <stepper-number
                                                    :source="isApp ? 'app' : 'h5'"
                                                    :item="item"
                                                    :activity-type="item.activityType"
                                                />
                                                <add-to-cart :item="item" :activity-type="item.activityType" :source="isApp ? 'app' : 'h5'" />
                                            </template>
                                            <template v-else>
                                                <span class="arrivalTimeStr">预计到货：</span>
                                                <span class="arrivalTimeStr">{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</span>
                                            </template>
                                        </div>
                                        <div class="package-product-box">
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
                                                        <div class="row row-2">
                                                            <div class="row-2-col-1">{{ items.spec }}</div>
                                                            <div class="row-2-col-2">
                                                                <span>×</span>
                                                                <span>{{ items.proReachNum }}</span>
                                                            </div>
                                                        </div>
                                                        <div class="row row-4">{{ items.manufacturer }}</div>
                                                        <div v-if="items.expireDateStr != null" class="row row-3">
                                                            <span>效期优于</span>
                                                            <span>{{ items.expireDateStr }}</span>
                                                        </div>
                                                    </div>
                                                </div>
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
                                        </div>
                                    </div>
                                </div>    
                            </van-list>
                        </div>
                    </template>
                </div>
                <div v-if="activeTabs===2" class="theme-3-box">
                    <template v-for="(item, ind) in subjectList">
                        <ul :key="ind" class="subject-list" :style="!subjectList.length?'padding: 0':'padding: 0.28rem 0.24rem;'">
                            <li @click="gotoSubject(item)">
                                <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.mobileImgUrl" :source="isApp ? 'app' : 'h5'" :is-auto="true" />
                                <!-- <h6>{{ item.title }}</h6>
                                <p><img src="@/assets/images/date_icon.png" class="date_icon" />{{ item.startTime + '-' + item.endTime }}</p> -->
                            </li>
                        </ul>
                    </template>
                    <div v-if="hasNoSubjectData" class="no-data">
                        <img src="@/assets/images/emptyCart.png">
                        <span>暂无数据</span>   
                    </div>
                </div>
                <div v-if="activeTabs===3" class="theme-4-box">
                    <template v-if="!hasNoCouponData">
                        <van-list v-model="couponParams.loading" :finished="couponParams.finished" :finished-text="'人家是有底线的哦!'" :immediate-check="false" :offset="50" @load="couponOnLoad">
                            <coupon-box v-for="(item, index) in couponParams.conponList" :key="index" :coupon="item" :source="isApp ? 'app' : 'h5'" @fetchList="fetchList" />
                        </van-list>
                    </template>
                    <template v-else>
                        <div class="no-data">
                            <img src="@/assets/images/emptyCart.png">
                            <span>暂无数据</span>       
                        </div>
                    </template>
                </div>
            </div>
            <!-- <div v-if="activeTabs !== 2 && activeTabs !== 3 && scrollHeight > 50" class="go-to-cart" @click="goToCart">
                <img src="@/assets/images/icon-cart.png" alt="">
            </div> -->
        </div>
    </app-template>
</template>

<script>
import Api from '@/api/activity/activity'
import AppTemplate from '@/components/appTemplate/Index'
import productCard from '@/components/productCard/index'
import addToCart from '@/components/addToCart/index'
import imageLoad from '@/components/imageLoad/index'
import couponBox from '@/components/couponDetail/index'
import StepperNumber from '@/components/stepperNumber/index';
import VMnative from '@/utils/VMnative'
import { Toast } from 'vant'
export default {
    name: 'Activity',
    components: {
        AppTemplate,
        productCard,
        addToCart,
        imageLoad,
        couponBox,
        StepperNumber
    },
    data(){
        return {
            isApp: this.$route.query.source !== 'h5',
            activeTabsList: [
                '满赠专区',
                '满减专区',
                '专题会场',
                '优惠券'
            ],
            locationType: navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) ? 'hcjkpay' : 'hcyy',
            activeTabs: 0,
            isPackage: false,
            hasNoPackage2: false,
            hasNoSubjectData: false,
            hasNoCouponData: false,
            singleProductParams: {
                current: 1,
                size: 16,
                types: 1,
                sourceType: 0,
                loading: false,
                finished: false,
                goodsList: []
            },
            packageProductParams: {
                current: 1,
                size: 16,
                types: 2,
                sourceType: 0,
                loading: false,
                finished: false,
                goodsList: []
            },
            packageProductParams2: {
                current: 1,
                size: 16,
                types: 4,
                sourceType: 0,
                loading: false,
                finished: false,
                goodsList: []
            },
            couponParams: {
                conponList: [],
                loading: false,
                finished: false,
                current: 1
            },
            scrollHeight: 0,
            subjectList: [],
            edit: false
        }
    },
    created(){
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        }
        window.addEventListener('scroll', this.scroll)
    },
    mounted(){
        VMnative.callHandler("setTitle", "活动专区")
    },
    methods: {
        init() {
            // activeTabs(0-满赠专区；1-满减专区；2-专题会场；3-优惠券)
            // isPackage(仅在activeTabs=0时配置，0-单品；1-套餐)
            this.activeTabs = parseInt(this.$route.query.activeTabs) || 0
            this.isPackage = this.$route.query.isPackage ? (this.$route.query.isPackage !== '0') : false
            switch (this.activeTabs){
                case 0:
                    if (!this.isPackage){
                        this.singleProductParams.current = 1
                    } else {
                        this.packageProductParams.current = 1
                    }
                    this.singleOnLoad();
                    this.packageOnLoad();
                    break;
                case 1:
                    this.packageProductParams2.current = 1
                    break;
                case 2:
                    this.getSubjectList();
                    break;
                case 3:
                    this.couponParams.current = 1
                    this.fetchList()
            }
        },
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        /**
         * 切换tab
         */
        changeTabs(e){
            this.activeTabs = e
            this.packageProductParams.current = 1
            this.packageProductParams2.current = 1
            this.couponParams.current = 1
            this.singleProductParams.current = 1
            if (e === 3 && this.couponParams.conponList.length === 0){
                this.fetchList()
            } else if (e === 2) {
                this.getSubjectList();
            }
        },
        /**
         * 切换单品
         */
        changeSingle(){
            this.isPackage = false
        },
        /**
         * 切换套餐
         */
        changePackage(){
            this.isPackage = true
            // if (this.packageProductParams.goodsList.length === 0){
            //     this.packageOnLoad()
            // }
        },
        // 查询优惠券列表
        fetchList(){
            Toast.loading()
            Api.fetchCouponList({ current: this.couponParams.current, size: 10 }).then(({ data: { data }}) => {
                Toast.clear()
                this.couponParams.conponList = data.records || []
                this.hasNoCouponData = !this.couponParams.conponList.length
            })
        },
        /**
         * 优惠券加载更多
         */
        couponOnLoad() {
            Api.fetchCouponList({ current: this.couponParams.current + 1, size: 10 }).then(({ data: { data }}) => {
                Toast.clear()
                this.couponParams.conponList = this.couponParams.conponList.concat(data ? data.records || [] : [])
                this.couponParams.loading = false;
                if (this.couponParams.current + 1 >= data.pages){
                    this.couponParams.finished = true
                } else {
                    this.couponParams.current++
                }
            })
        },
        /**
         * 满赠单品加载更多
         */
        singleOnLoad(){
            Api.fetchGoods({ current: this.singleProductParams.current, size: 16, types: 1, sourceType: 0 }).then(({ data: { data }}) => {
                this.singleProductParams.goodsList = this.singleProductParams.goodsList.concat(data ? data.records || [] : [])
                this.singleProductParams.loading = false
                if (!data || this.singleProductParams.current >= data.pages){
                    this.singleProductParams.finished = true
                } else {
                    this.singleProductParams.current++
                }
            })
        },
        /**
         * 满赠套餐加载更多
         */
        packageOnLoad(){
            Api.fetchGoods({ current: this.packageProductParams.current, size: 16, types: 2, sourceType: 0 }).then(({ data: { data }}) => {
                this.packageProductParams.goodsList = this.packageProductParams.goodsList.concat(data ? data.records || [] : [])
                this.packageProductParams.loading = false
                if (!data || this.packageProductParams.current >= data.pages){
                    this.packageProductParams.finished = true
                } else {
                    this.packageProductParams.current++
                }
            })
        },
        /**
         * 满减套餐加载更多
         */
        packageOnLoad2(){
            Api.fetchGoods({ current: this.packageProductParams2.current, size: 16, types: 4, sourceType: 0 }).then(({ data: { data }}) => {
                this.packageProductParams2.goodsList = this.packageProductParams2.goodsList.concat(data ? data.records || [] : [])
                this.packageProductParams2.loading = false
                this.edit = true
                if (!data || this.packageProductParams2.current >= data.pages){
                    this.packageProductParams2.finished = true
                } else {
                    this.packageProductParams2.current++
                }
                this.hasNoPackage2 = !this.packageProductParams2.goodsList.length
            })
        },
        /**
         * 返回上一页
         */
        goback() {
            this.$router.push('/')
        },
        /**
         * 跳转购物车
         */
        goToCart(){
            if (!this.isApp){
                this.$router.push('/cart/index')
            } else {
                VMnative.callHandler('gotoCart')
            }
        },
        /**
         * 查看专题详情
         */
        gotoSubject(row) {
            const pathUrl = this.isApp ? '/activity/subject' : '/activity/subject?source=h5'
            this.$router.push({
                path: pathUrl,
                query: {
                    sid: row.sid,
                    title: row.title
                }
            })
        },
        /**
         * 获取专题活动
         */
        getSubjectList() {
            Api.fetchSubjectList().then(({ data: { data }}) => {
                this.subjectList = data.records;
                this.hasNoSubjectData = !this.subjectList.length
            })
        },
        // 跳转详情
        goDetail(item){
            if (item.targetProductSid){
                if (this.source !== 'app'){
                    this.$router.push(`/product/detail/${item.targetProductSid}`)
                } else {
                    window.location.href = this.locationType + '://commodity/commodityDetail?proSid=' + item.targetProductSid
                }
            } else if (item.proSid){
                if (this.source !== 'app'){
                    this.$router.push(`/product/detail/${item.proSid}`)
                } else {
                    window.location.href = this.locationType + '://commodity/commodityDetail?proSid=' + item.proSid
                }
            } else {
                if (this.source !== 'app'){
                    this.$router.push(`/product/detail/${item.sid}`)
                } else {
                    window.location.href = this.locationType + '://commodity/commodityDetail?proSid=' + item.sid
                }
            }
        }
    }
}
</script>

<style lang="scss">
    #app{
        height: 100%;
        .app-wrapper{
            height: 100%;
            .app-main{
                height: 100%;
                .app-page-box{
                    height: 100%;
                }
            }
        }
    }
    .page-activity-index{
        background: #F4F4F4;
        min-height: 100%;
        position: relative;
        .go-to-cart{
            position: fixed;
            bottom: 1.54rem;
            right: .44rem;
            width: .88rem;
            height: .88rem;
            border-radius: 50%;
            background:linear-gradient(329deg,rgba(237,49,41,.8) 0%,rgba(238,82,82,.8) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            img{
                width: .52rem;
                height: .52rem;
            }   
        }
        .no-data {
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 10.5rem;
            
            img {
                width: 4.96rem;
                height: 4.96rem;
                margin-top: 1.44rem;
            }

            span {
                color: #bbbbbb;
                font-size: .36rem;
                padding-top: .4rem;
            }
        }
        .activity-top{
            width: 7.5rem;
            height: 4.72rem;
            background: linear-gradient(180deg, #FE6C6C 0%, #E71C1C 100%);
            border-bottom-right-radius: 1.5rem 0.6rem;
            border-bottom-left-radius: 1.5rem 0.6rem;
            .van-tabs--line{
                padding: .32rem .2rem 0;
                z-index: 1;
                .van-tabs__wrap{
                    line-height: .88rem;
                    height: 1.8rem;
                    &::after{
                        border: none
                    }
                    .van-tabs__nav{
                        background-color: transparent;
                        .van-tab{
                            color: #fff;
                            background: #FB7171;
                            border-radius: .4rem;
                            line-height: .88rem;
                            height: 1.8rem;
                            width: 1.76rem;
                            padding: 0;
                            align-items: normal;
                            &.van-tab--active{
                                background: linear-gradient(180deg, #FFDE00 0%, #FF8500 100%);
                                .van-tab__text{
                                    color: #ffffff;
                                }
                            }
                        }
                        .van-tabs__line{
                            display: none;
                            background-color: transparent;
                        }
                    }
                }
            }
        }
        .activity-content-box{
            // min-height: calc(100% - 2.12rem);
            margin: -3.52rem .2rem 0;
            background: #fff;
            border-radius: .4rem;
            position: relative;
            z-index: 2;
            .package-list-box{
                background: #f4f4f4;
                border-radius: .08rem;
                .package-box{
                    background: #fff;
                    margin-bottom: .24rem;
                }
                .package-box:nth-child(1){
                    border-bottom-left-radius: .4rem;
                    border-bottom-right-radius: .4rem;
                }
                .package-box:not(:nth-child(1)){
                    border-radius: .4rem;
                }
                .package-box-title {
                    padding: .4rem .28rem .28rem;
                    display: flex;
                    align-items: center;
                    line-height: 1;
                    flex-direction: column;
                    align-items: flex-start;

                    span:nth-child(1) {
                        font-size: 0.32rem;
                        color: #333333;
                        font-weight: 600;
                    }

                    span:nth-child(2) {
                        font-size: 0.28rem;
                        line-height: .32rem;
                        color: #666666;
                    }
                }

                .tips{
                    padding: 0 .28rem;
                    font-size: .28rem;
                    color: #666666;
                    line-height: .36rem;
                    // background: #FDEAE9;
                    // padding: .12rem .4rem .12rem .6rem;
                    // line-height: .4rem;
                    // width: 6.7rem;
                    // position: relative;
                    // left: -.4rem;
                    // text-align: justify;
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

                .price-box{
                    background: #FBFBFB;
                    border-radius: .12rem;
                    border: .02rem solid #EEEEEE;
                    margin: .24rem .28rem .28rem;
                    padding: .26rem .28rem;
                    display: flex;
                    align-items: center;
                    color: #BBBBBB;
                    font-size: .28rem;
                    .row-1{
                        margin-right: .4rem;
                        span:nth-child(1){
                            font-size: .28rem;
                            color: #666666;
                            margin-right: .14rem;
                        }
                        span:nth-child(2){
                            font-size: .28rem;
                            color: #ED3129;
                        }
                        span:nth-child(3){
                            font-size: .36rem;
                            color: #ED3129;
                        }
                    }
                    .row-2{
                        text-decoration:line-through;
                    }
                }

                .pkg-name {
                    font-size: 0.28rem;
                    color: #666666;
                    padding: 0 0.4rem;
                }
                .package-product-box{
                    padding: .28rem 0;
                    margin: 0 .28rem;
                    border-top: .02rem solid #F6F6F6;
                    .pkg-box {
                        .pkg-box-item {
                            display: flex;
                            padding-bottom: .4rem;
                            // padding: 0.32rem 0.2rem 0.2rem;
                            border-bottom: 0.01rem solid #e4e4e4;
                            &:last-child {
                                border: none;
                            }
                        }
    
                        .col-1 {
                            margin-right: 0.28rem;
    
                            .row-1 {
                                width: 1.6rem;
                                height: 1.6rem;
                                position: relative;
                                .van-image{
                                    width: 100%;
                                    height: 100%;
                                }
                                // img {
                                //     width: 100%;
                                //     height: 100%;
                                //     position: absolute;
                                //     top: 0;
                                //     left: 0;
                                // }
                            }
                        }
    
                        .col-2 {
                            line-height: 1;
                            width: 4.6rem;
    
                            .row-1 {
                                display: flex;
                                align-items: center;
    
                                span:nth-child(1) {
                                    color: #333333;
                                    font-size: 0.32rem;
                                    font-weight: 600;
                                    max-width: 4.6rem;
                                    overflow: hidden;
                                    white-space: nowrap;
                                    text-overflow: ellipsis;
                                    line-height: .38rem;
                                }
                            }
    
                            .row-2 {
                                padding-top: 0.1rem;
                                color: #999999;
                                font-size: 0.24rem;
                                display: flex;
                                justify-content: space-between;
                                font-weight: 500;
                                .row-2-col-2{
                                    display: flex;
                                    align-items: center;
                                    span:nth-child(1){
                                        font-size: .36rem;
                                    }
                                    span:nth-child(2){
                                        color: #333333;
                                    }
                                }
                            }
    
                            .row-3 {
                                padding-top: .12rem;
                                span:nth-child(1){
                                    color: #999999;
                                    margin-right: .08rem;
                                }
                            }
                            .row-4{
                                padding-top: 0.24rem;
                                max-width: 4.6rem;
                                overflow: hidden;
                                white-space: nowrap;
                                text-overflow: ellipsis;
                            }
    
                            .row-3,
                            .row-4 {
                                color: #666666;
                                font-size: 0.28rem;
                            }
                        }
    
                        // .col-3 {
                        //     display: flex;
                        //     align-items: center;
                        //     .row-1 {
                        //         display: flex;
                        //         align-items: center;
                        //     }
    
                        //     span:nth-child(1) {
                        //         color: #cccccc;
                        //         font-size: 0.38rem;
                        //     }
    
                        //     span:nth-child(2) {
                        //         color: #333333;
                        //         font-size: 0.28rem;
                        //     }
                        // }
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
                            background: #ed3129;
                            opacity: 0.5;
                            margin-right: .28rem;
                            width: .76rem;
                            height: .32rem;
                            line-height: .32rem;
                            text-align: center;
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
                            width: 4rem;

                            .floor-1 {
                                display: flex;
                                align-items: center;
                                // line-height: 1;
                                padding-bottom: 0.08rem;

                                span:nth-child(1) {
                                    color: #666666;
                                    font-size: 0.28rem;
                                    max-width: 4.9rem;
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
                    justify-content: space-between;
                    padding: .04rem .28rem .32rem;
                    .van-icon {
                        font-size: 0.84rem;
                        color: #ed3129;
                    }
                }

            }
            .van-list__loading{
                background: transparent;
                padding-top: .42rem;
            }
            .van-list__finished-text{
                background: #F4F4F4;
                border-radius: 0 0 .4rem .4rem;
                margin-top: .16rem;
                // bottom: 0;
                // position: absolute;
                // width: 100%;
            }
            .theme-1-box{
                height: 100%;
                .top-btn-box{
                    padding: .32rem .2rem;
                    display: flex;
                    .van-button--normal {
                        padding: .16rem .4rem;
                        font-size: .28rem;
                        height: auto;
                        line-height: 1;
                        display: flex;
                        align-items: center;
                        &.active-btn{
                            .van-button__text{
                                color: #ed3129;
                            }
                        }
                        .van-button__text{
                            color: #666666;
                        }
                        &:nth-child(1){
                            margin-right: .2rem;
                        }
                    }
                }
                .goods-list{
                    .single-list-box{
                        .van-list{
                            .goods-list-box{
                                margin: 0;
                                .list{
                                    padding: .2rem .2rem 0 .2rem;
                                    position: relative;
                                    margin-bottom: 0;
                                    padding-bottom: .1rem!important;
                                }
                                .row{
                                    height: auto;
                                }
                                .list::after{
                                    position: absolute;
                                    content: ' ';
                                    width: 100%;
                                    height: .01rem;
                                    top: 0;
                                    left: 0;
                                    background: #E4E4E4;
                                    transform: scaleY(.5);
                                }
                            }
                            .goods-list-box:first-child{
                                border-radius: .08rem .08rem 0 0;
                            }
                            .goods-list-box:nth-last-child(1){
                                border-radius: 0 0 .08rem .08rem;
                            }
                        }
                    }
                }
            }
            .theme-2-box{
                height: 100%; 
                .package-box:nth-child(1){
                    .package-box-title{
                        padding: 0rem .28rem 0.4rem .28rem;
                    }
                }
            }
            .theme-3-box{
                height: 100%;
                // .subject-list{
                    // li{
                    //     // background: #fff;
                    // }
                    // .image-box{
                    //     width: 6.7rem;
                    //     margin: 0rem auto;
                    //     height: 3.86rem;
                    //     .van-image{
                    //         width: 6.7rem;
                    //         height: 100%;
                    //         margin-top: 0.24rem;
                    //         img{
                    //             width: 100%;
                    //             height: 100%;
                    //             border-radius: .2rem;
                    //         }
                    //     }
                    // }
                    // .date_icon{
                    //     width: .32rem;
                    //     margin-right: .2rem;
                    //     vertical-align: text-top;
                    // }
                    // li{
                    //     margin-bottom: .2rem;
                    //     // h6{
                    //     //     font-weight: normal;
                    //     //     color: #000000;
                    //     //     font-size: .32rem;
                    //     //     line-height: .6rem;
                    //     //     padding-left: .06rem;
                    //     // }
                    //     // p{
                    //     //     color: #333333;
                    //     //     font-size: .28rem;
                    //     //     line-height: .4rem;
                    //     //     padding-left: .06rem;
                    //     // }
                    // }
                // }
                .subject-list{
                    // background: #fff;
                    // padding: 0.28rem 0.24rem;
                    li{
                        height: 3.5rem;
                        // width: 6.7rem;
                        // margin: 0 auto;
                        .van-image{
                            height: 100%;
                            width: 100%;
                        }
                    }
                }
            }
            .theme-4-box{
                .van-list{
                    background: #f1f1f1;
                    padding: 0.36rem 0.28rem 0.16rem;
                    border-radius: .4rem;
                    .couponDetail-box{
                        margin: 0 0 0.24rem 0;
                        .useBtn{
                            margin-left: 1.12rem !important;
                        }
                        .receiveBtn{
                            margin-left: 1.12rem !important;
                        }
                    }
                }
            }
        }
    }
</style>
