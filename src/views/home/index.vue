<template>
    <div class="Page-home-index">
        <div :class="isScroll ?'top':'top scroll-top'">
            <template v-for="(item, idx) in $store.getters.userInfo.clubs">
                <div v-if="currentClub===item.code && item.desc.split(' ').length !== 1" :key="idx" class="floor-1">
                    <span>{{ item.desc.split(' ')[0] }}</span>
                    <img :src="item.icon" alt="">
                    <span>{{ item.desc.split(' ')[1] }}</span>
                </div>
                <div v-if="currentClub===item.code && item.desc.split(' ').length === 1" :key="idx" class="floor-1">
                    <img :src="item.icon" alt="">
                    <span>{{ item.desc }}</span>
                </div>
            </template>
            <div :class="scrollHeight <= 50 ? 'floor-2' : 'floor-2 fixedFloor'">
                <img src="@/assets/images/icon-logo-w.png" alt="">
                <van-cell-group>
                    <van-field placeholder="商品名/首字母/商品ID/厂家/标签/商标" :left-icon="'https://imga.hnhcyy.com/fed/b2b-wechat/icon-search.png'" @focus="goSearch" />
                </van-cell-group>
                <img :src="message" alt="" @click="goMessage">
                <div v-if="info" class="info" />
            </div>
        </div>
        <div class="swiper-box">
            <template v-if="bannerList.length">
                <van-swipe :autoplay="3000" indicator-color="#fff">
                    <van-swipe-item v-for="(item, index) in bannerList" :key="index">
                        <image-load
                            :default-image="`https://imga.hnhcyy.com/fed/b2b-wechat/default-banner${currentClub}.png`"
                            :original-image="item.mobileImageUrl"
                            :item="item"
                            :oss-width="710"
                            :oss-height="360"
                            :original="'banner'"
                        />
                    </van-swipe-item>
                </van-swipe>
            </template>
            <template v-else>
                <div class="van-swipe">
                    <img :src="`https://imga.hnhcyy.com/fed/b2b-wechat/default-banner${currentClub}.png`" alt="">
                </div>
            </template>
        </div>
        <div v-if="isShowPreSale" class="pre-sale-box" @click="goPerSale">
            <span>预售</span>
            <span>欢迎来到预售专区！</span>
            <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow-1.png" alt="">
        </div>
        <div class="icon-list">
            <div v-for="(item, index) in iconList" :key="index" class="icon-item" @click="goPage(item.skipType,item.linkUrl)">
                <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.iconUrl" />
                <span>{{ item.title }}</span>
            </div>
        </div>
        <!-- <template v-if="$store.getters.userInfo.currentType === 1 || $store.getters.userInfo.currentType === 4">
            <floor-list :list="floorList" :position="1" />
            <div class="item-list clearfix">
                <div class="top-banner">
                    <van-swipe v-if="promotionImg.length !== 0" :autoplay="3000">
                        <van-swipe-item v-for="item in promotionImg" :key="item">
                            <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.mobileImageUrl" :item="item" :oss-width="710" :oss-height="220" :original="'banner'" />
                        </van-swipe-item>
                    </van-swipe>
                    <img v-else src="https://imga.hnhcyy.com/fed/b2b-wechat/cuxiao-bg-1.png" alt="">
                </div>
                <div class="promotion-box">
                    <div class="floor-title" @click="getMorePromotion">
                        <span>限时促销</span>
                        <span>
                            <span>更多</span>
                            <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                        </span>
                    </div>
                    <van-swipe @change="changePromotion">
                        <van-swipe-item v-for="aindex in Math.ceil(promotionList.length / 4)" :key="aindex">
                            <div class="item-hd">
                                <template v-for="(item, bindex) in promotionList">
                                    <div v-if="(aindex-1) * 4 <= bindex && bindex < aindex * 4" :key="bindex" :class="(bindex % 4) === 0 ? 'item-box' : (bindex % 4) === 1 ? 'item-box item-box-1' : (bindex % 4) === 2 ? 'item-box item-box-2' : 'item-box item-box-3'">
                                        <product-card :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                                    </div>
                                </template>
                            </div>
                        </van-swipe-item>
                    </van-swipe>
                </div>
            </div>
            <floor-list :list="floorList" :position="2" />
            <div class="item-list clearfix">
                <div class="floor-box">
                    <div class="floor-title" @click="getMoreNew">
                        <span>新品抢购</span>
                        <span>
                            <span>更多</span>
                            <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                        </span>
                    </div>
                    <van-swipe @change="changeNewsGoods">
                        <van-swipe-item v-for="aindex in Math.ceil(newGoodsList.length / 4)" :key="aindex">
                            <div class="item-hd">
                                <template v-for="(item, bindex) in newGoodsList">
                                    <product-card v-if="(aindex-1) * 4 <= bindex && bindex < aindex * 4" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                                </template>
                            </div>
                        </van-swipe-item>
                    </van-swipe>
                </div>
            </div>
        </template>
        <template v-else> -->
        <div class="floor-item-list item-list clearfix">
            <template v-if="currentClub === 1 || currentClub === 4">
                <floor-list :list="floorList" :position="1" />
                <div v-if="JYmedicalCare.length" class="floor-box">
                    <div class="floor-title" @click="goClassifyList('江佑医疗',187,199)">
                        <span>江佑医疗</span>
                        <span>
                            <span>更多</span>
                            <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                        </span>
                    </div>
                    <van-swipe @change="changeNewsGoods('江佑医疗',187,199)">
                        <van-swipe-item v-for="aindex in Math.ceil(JYmedicalCare.length / 2)" :key="aindex">
                            <div class="item-hd">
                                <template v-for="(item, bindex) in JYmedicalCare">
                                    <product-card
                                        v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2"
                                        :key="bindex"
                                        :item="item"
                                        :card-type="'smart-mall-index'"
                                        :current-type="1"
                                        :theme="'theme-2'"
                                    />
                                </template>
                            </div>
                        </van-swipe-item>
                    </van-swipe>
                </div>
            </template>
            <floor-list :list="floorList" :position="2" />
            <div v-if="CWpatentMedicine.length" class="floor-box">
                <div class="floor-title" @click="goClassifyList('中西成药',145)">
                    <span>中西成药</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods('中西成药',145)">
                    <van-swipe-item v-for="aindex in Math.ceil(CWpatentMedicine.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in CWpatentMedicine">
                                <product-card
                                    v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2"
                                    :key="bindex"
                                    :item="item"
                                    :card-type="'smart-mall-index'"
                                    :current-type="1"
                                    :theme="'theme-2'"
                                />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
            <floor-list :list="floorList" :position="3" />
            <div v-if="oralGoods.length" class="floor-box">
                <div class="floor-title" @click="goClassifyList('中药饮片',166)">
                    <span>中药饮片</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods('中药饮片',166)">
                    <van-swipe-item v-for="aindex in Math.ceil(oralGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in oralGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
            <floor-list :list="floorList" :position="4" />
            <div v-if="outGoods.length" class="floor-box">
                <div class="floor-title" @click="goClassifyList('保健食品',181)">
                    <span>保健食品</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods('保健食品',181)">
                    <van-swipe-item v-for="aindex in Math.ceil(outGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in outGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
            <floor-list :list="floorList" :position="5" />
            <div v-if="medicineGoods.length" class="floor-box">
                <div class="floor-title" @click="goClassifyList('医疗器械',187)">
                    <span>医疗器械</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods('医疗器械',187)">
                    <van-swipe-item v-for="aindex in Math.ceil(medicineGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in medicineGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
            <floor-list :list="floorList" :position="6" />
            <div v-if="nutritionGoods.length" class="floor-box">
                <div class="floor-title" @click="goClassifyList('消毒用品',10)">
                    <span>消毒用品</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods('消毒用品',10)">
                    <van-swipe-item v-for="aindex in Math.ceil(nutritionGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in nutritionGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
            <floor-list :list="floorList" :position="7" />
            <div v-if="proGoods.length" class="floor-box">
                <div class="floor-title" @click="goClassifyList('食品百货',177)">
                    <span>食品百货</span>
                    <span>
                        <span>更多</span>
                        <img class="arrow" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-arrow.png" alt="">
                    </span>
                </div>
                <van-swipe @change="changeNewsGoods('食品百货',177)">
                    <van-swipe-item v-for="aindex in Math.ceil(proGoods.length / 2)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in proGoods">
                                <product-card v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
        <!-- </template> -->
        <floor-list :list="floorList" :position="8" />
        <floor-list :list="floorList" :position="9" />
        <!-- <floor-list :list="floorList" :position="3" /> -->
        <!-- 热销推荐 -->
        <!-- <div class="item-list clearfix">
            <div class="floor-box">
                <div class="floor-title">
                    <span>热销商品</span>
                </div>
                <van-swipe @change="changeNewsGoods">
                    <van-swipe-item v-for="aindex in Math.ceil(hotGoodsList.length / 4)" :key="aindex">
                        <div class="item-hd">
                            <template v-for="(item, bindex) in hotGoodsList">
                                <product-card v-if="(aindex-1) * 4 <= bindex && bindex < aindex * 4" :key="bindex" :item="item" :card-type="'smart-mall-index'" :current-type="1" :theme="'theme-2'" />
                            </template>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div> -->
        <!-- <floor-list :list="floorList" :position="4" /> -->
        <!-- 弹窗广告 -->
        <van-popup v-model="showPop" :close-on-click-overlay="false" @closed="closeBtn">
            <div class="active-box">
                <img :src="winPopInfo.mainImg" alt="" @click="goPopPage(winPopInfo)">
            </div>
            <div class="close-btn">
                <img src="@/assets/images/close.png" alt="" @click="closeBtn">
            </div>
        </van-popup>
        <!-- 优惠券弹窗 -->
        <van-popup v-model="showCoupon" overlay-class="couponPop">
            <div class="coupon-box">
                <div class="couponInfoList">
                    <!-- <div v-for="(item, index) in couponList" :key="index" class="couponInfo">
                        <div class="left">
                            <div class="discount">
                                <span>￥</span>
                                <span>{{ item.discount }}</span>
                            </div>
                            <div v-if="item.buyMone !== 0" class="sill">
                                满{{ item.buyMoney }}可用
                            </div>
                            <div v-else class="sill">无门槛</div>
                        </div>
                        <div class="right">
                            <div class="row-1"><span>{{ item.typeName }}</span></div>
                            <div class="row-2">{{ item.productDesc }}</div>
                            <div class="row-3">使用时间：</div>
                            <div class="row-4">{{ item.useStartTimeStr }}-{{ item.useEndTimeStr }}</div>
                        </div>
                    </div> -->
                </div>
                <van-button round @click="closeCoupon">查看优惠券</van-button>
            </div>
        </van-popup>
        <div class="bottom" />
        <van-dialog
            v-model="showGspDate"
            show-cancel-button
            confirm-button-text="前往更新"
            cancel-button-text="取消"
            confirm-button-color="#fff"
            cancel-button-color="#999999"
            class-name="custom-gsp-dialog"
            @confirm="gotoQualification"
            @cancel="cancalGsp"
        >
            <div slot="title" class="gsp-title">资质更新</div>
            <p class="tips">温馨提示: 资质将/已过期，请尽快更新!</p>
            <ul class="user-list">
                <li v-for="(item, ind) in stores" :key="ind">
                    <div v-if="[1, 2].indexOf(item.gspStatus) > -1" class="user-store">
                        <p>{{ item.name }}</p><span>{{ item.gspStatus === 2 ? '(已过期)' : '(将过期)' }}</span>
                    </div>
                </li>
            </ul>
        </van-dialog>
        <van-popup
            v-model="showGuide"
            :close-on-click-overlay="false"
            class="guide-popup"
            @click="nextGuide"
            @open="openGuide"
            @close="closeGuide"
        >
            <p class="skip-guide" @click.stop="skipeGuide">跳过引导</p>
            <div v-if="currentGuidePage === 1">
                <img
                    v-if="winHeight > 700"
                    src="@/assets/images/guide.png"
                    :style="isShowPreSale?'marginTop:6.5rem':'marginTop:5.5rem'"
                    class="guide-1"
                >
                <img
                    v-else
                    src="@/assets/images/guide-1.png"
                    :style="isShowPreSale?'marginTop:2.8rem':'marginTop:1.8rem'"
                    class="guide-1"
                >
            </div>
            <div v-if="winHeight > 800" class="guide-bottom">
                
                <img
                    v-show="currentGuidePage === 2"
                    src="@/assets/images/guide-2.png"
                    :style="isShowPreSale?'marginTop:8.2rem':'marginTop:7.2rem'"
                    class="guide-2"
                >
                <img
                    v-show="currentGuidePage === 3"
                    src="@/assets/images/guide-3.png"
                    :style="isShowPreSale?'marginTop:8.2rem':'marginTop:7.2rem'"
                    class="guide-3"
                >
                <img
                    v-show="currentGuidePage === 4"
                    src="@/assets/images/guide-4.png"
                    :style="isShowPreSale?'marginTop:8.2rem':'marginTop:7.2rem'"
                    class="guide-4"
                >
            </div>
            <div v-else class="guide-top">
                <img
                    v-show="currentGuidePage === 2"
                    src="@/assets/images/guide-top-2.png"
                    :style="isShowPreSale?'marginTop:4.62rem':'marginTop:3.8rem'"
                    class="guide-2"
                >
                <img
                    v-show="currentGuidePage === 3"
                    src="@/assets/images/guide-top-3.png"
                    :style="isShowPreSale?'marginTop:4.62rem':'marginTop:3.8rem'"
                    class="guide-3"
                >
                <img
                    v-show="currentGuidePage === 4"
                    src="@/assets/images/guide-top-4.png"
                    :style="isShowPreSale?'marginTop:4.62rem':'marginTop:3.7rem'"
                    class="guide-4"
                >
            </div>
            <!-- 在下面的按钮 -->
            <div
                v-if="(currentGuidePage === 1 && winHeight > 700) || (currentGuidePage > 1 && winHeight > 800)"
                class="next-btn"
                v-html="currentGuidePage === 4 ? '开启全新体验' : `下一步(<span> ${currentGuidePage}</span> /4)`"
            >{{currentGuidePage === 4 ? '开启全新体验' : `下一步(<span> ${currentGuidePage}</span> /4)`}}</div>
            <!-- 在上面的按钮 -->
            <div
                v-else
                class="next-btn-top"
                :style="{
                    top: currentGuidePage === 1 ? '3.9rem':'5.2rem', 
                    marginTop: isShowPreSale && currentGuidePage === 1? '.9rem' : isShowPreSale ? '.8rem': ''
                }"
                v-html="currentGuidePage === 4 ? '开启全新体验' : `下一步(<span> ${currentGuidePage}</span> /4)`"
            >{{currentGuidePage === 4 ? '开启全新体验' : `下一步(<span> ${currentGuidePage}</span> /4)`}}</div>
        </van-popup>
    </div>
</template>
<script>
import messageSrcW from '@/assets/images/icon-message-w.png'
import imageLoad from '@/components/imageLoad/index'
import floorList from '@/components/floorTemplate/index'
import productCard from '@/components/productCard/index'

import Api from '@/api/home'
import Apis from '@/api/message/message'
import ApiPre from '@/api/product/getRise'

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'App',
    components: {
        imageLoad,
        productCard,
        floorList
    },
    data() {
        return {
            error_img: "https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png",
            noMoreData: false,
            iconList: [],
            // promotionList: [],
            // newGoodsList: [],
            scrollHeight: 0,
            bannerList: [],
            // promotionImg: [],
            newGoodsImg: [],
            // hotGoodsList: [],
            floorList: [],
            currentPage: 1,
            loading: false,
            finished: false,
            showPop: false,
            showCoupon: false,
            winPopInfo: {},
            oralGoods: [],
            outGoods: [],
            medicineGoods: [],
            nutritionGoods: [],
            JYmedicalCare: [],
            proGoods: [],
            couponList: [],
            isShowPreSale: false,
            showGspDate: false,
            message: messageSrcW,
            info: false,
            CWpatentMedicine: [],
            showGuide: false,
            currentGuidePage: 1
        }
    },
    computed: {
        currentClub: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : null
        },
        isScroll: function() {
            return this.scrollHeight <= 50
        },
        qftFlag: function() {
            return localStorage.getItem('qftFlag')
        },
        stores() {
            return this.$store.getters.userInfo.stores || [];
        },
        winHeight() {
            return this.$store.getters.winHeight;
        }
    },
    watch: {
        '$store.getters.userInfo.currentType': function(val){
            this.isShowPreSaleFunc()
        }
    },
    created() {
        window.addEventListener('scroll', this.scroll)
        this.$store.commit("setHasToolbar", true)
        this.$store.commit('setCartNum');
    },
    activated(){
        this.getBannerList()
        this.$store.commit('setShowSpecialAgreement', '');
        this.getMessageQty()
        if (localStorage.getItem('scrollPosition')){
            this.scrollToPosition(Number(localStorage.getItem('scrollPosition')))
            localStorage.removeItem('scrollPosition')
        }
    },
    mounted() {
        this.scrollToPosition(0)
        if (this.$store.getters.token){
            this.getBannerList()
            this.getIconList()
            this.getPop()
            this.isShowPreSaleFunc()
            this.getCouponList()
            this.getFloorList()
            this.getMessageQty()
            this.getGoods(187, 199);
            this.getGoods(145);
            this.getGoods(166);
            this.getGoods(181);
            this.getGoods(187);
            this.getGoods(10);
            this.getGoods(177);
        } else {
            this.$router.replace('/account/login')
        }
    },
    methods: {
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        // 滚动到指定位置
        scrollToPosition(position){
            setTimeout(function(){
                window.scrollTo(0, position)
            }, 1000)
        },
        // 滑动分类添加埋点
        changeNewsGoods(value, sid){
            _czc.push(["_trackEvent", "分类", "滑动", value, sid, '俱乐部:' + this.$store.getters.userInfo.currentType]);
        },
        // 跳转分类
        goClassifyList(value, sid, secondSid){
            // 点击分类更多添加埋点
            _czc.push("_trackEvent", "分类", "点击", value, sid, '俱乐部:' + this.$store.getters.userInfo.currentType);
            this.$router.push({
                path: '/menu',
                query: {
                    firstSid: sid,
                    secondSid
                }
            })
        },
        /**
         * 是否显示预售专区
         */
        isShowPreSaleFunc(){
            ApiPre.fetchGoods({ current: 1, size: 12, searchType: 7 }).then(({ data: { data }}) => {
                if (data.total !== 0){
                    this.isShowPreSale = true
                } else {
                    this.isShowPreSale = false
                }
            })
        },
        /**
         * 获取首页banner
         */
        getBannerList() {
            Api.fetchBanner({ 'source': 0, bannerTypeId: 1, sourceType: 0 }).then(res => {
                this.bannerList = res.data.data
            })
        },
        /**
         * 获取限时促销和新品抢购顶部图片
         */
        // getOtherImg(bannerTypeId){
        //     Api.fetchBanner({ 'source': 0, bannerTypeId: bannerTypeId, sourceType: 0 }).then(res => {
        //         if (bannerTypeId === 2){
        //             this.newGoodsImg = res.data.data
        //         } else if (bannerTypeId === 8) {
        //             this.promotionImg = res.data.data
        //         }
        //     })
        // },
        /**
         * 获取首页icon
         */
        getIconList() {
            Api.fetchIcon().then(({ data: { data }}) => {
                this.iconList = data
                if (!localStorage.isShowGuide) {
                    this.showGuide = true;
                } else {
                    if (this.qftFlag !== 'false') this.getQft()
                }
            })
        },
        // /**
        //  * 获取首页促销推荐
        //  */
        // getDeseno() {
        //     Api.fetchPromotion({ current: 1, size: 12, sourceType: 0, types: 1 }).then(({ data: { data }}) => {
        //         this.promotionList = data ? data.records || [] : []
        //         this.promotionList = this.promotionList.map(v => {
        //             if (v.promotionProduct && v.promotionProduct.length) {
        //                 return Object.assign({}, v.promotionProduct[0])
        //             }
        //         })
        //     })
        // },
        // /**
        //  * 获取首页新品推荐
        //  */
        // getNewGoodsList(){
        //     Api.fetchNewGoods({ current: 1, size: 12, searchType: 1 }).then(({ data: { data }}) => {
        //         this.newGoodsList = data ? data.records || [] : []
        //     })
        // },
        /**
         * 获取首页楼层
         */
        getFloorList(){
            Api.fetchFloorList({ sourceType: 0 }).then(({ data: { data }}) => {
                this.floorList = data
            })
        },
        // 查询是否有优惠券
        getCouponList(){
            Api.fetchCouponList({ gainAddress: 'FIRST_LOGIN' }).then(({ data: { data }}) => {
                this.couponList = data || []
                if (this.couponList.length > 0){
                    this.showCoupon = true
                } else {
                    this.showCoupon = false
                }
            })
        },
        // 关闭优惠券弹窗
        closeCoupon(){
            this.showCoupon = false
            this.$router.push('/personal/coupon');
        },
        /**
         * 获取消息数量
         */
        getMessageQty(){
            Apis.fetchMessageCount().then(({ data: { data }}) => {
                if (data.arrivalQty !== 0 || data.markUpQty !== 0 || data.newProductQty !== 0 || data.orderQty !== 0 || data.promotionQty !== 0 || data.systemQty !== 0){
                    this.info = true
                } else {
                    this.info = false
                }
            })
        },
        // 跳转消息中心
        goMessage(){
            this.$router.push('/message/list')
            _czc.push(["_trackEvent", "点击按钮", "button_click", "消息" + ";club:" + this.$store.getters.userInfo.currentType])
        },
        // 点击跳转对应页面
        goPage(type, link) {
            if (type === 1) {
                this.goInnerPage(link)
            } else if (type === 2) {
                if (link.indexOf('?') !== -1){
                    window.location.href = link + '&source=h5'
                } else {
                    window.location.href = link + '?source=h5'
                }
            } else if (type === 3) {
                this.$router.push('/menu?firstSid=' + JSON.parse(link).parentTypeId + '&secondSid=' + JSON.parse(link).typeId)
            }
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
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "近期已采" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '2': // 近期未采
                    // linkUrl = '/quick/index';
                    // localStorage.setItem("quickType", 2);
                    linkUrl = '/quick/index?quickType=2'
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "近期未采" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '3': // 新品抢购
                    linkUrl = '/product/new-goods';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "新品抢购" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '4': // 即将到货
                    linkUrl = '/product/coming-soon';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "即将到货" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '5': // 处方药首页
                    linkUrl = '/smart-mall/index';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "处方药首页" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '6': // 即将上涨
                    linkUrl = '/product/get-rise';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "即将上涨" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '7': // 宣传物料
                    linkUrl = '/product/materials';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "宣传物料" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '8': // 我的优惠券
                    linkUrl = '/personal/coupon';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "我的优惠券" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '9': // 预售专区
                    if (localStorage.getItem("isShowNeedKnow") === 'true'){
                        linkUrl = '/product/needToknow?source=h5'
                    } else {
                        linkUrl = '/product/preSale';
                    }
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "预售专区" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '10': // 领券中心
                    linkUrl = '/couponList/index';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "领券中心" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '11': // 恒昌资讯
                    linkUrl = '/news/index';
                    _czc.push(["_trackEvent", "点击图标", "icon_click", "恒昌资讯" + ";club:" + this.$store.getters.userInfo.currentType])
                    break;
                case '12': // 新品收集
                    linkUrl = '/personal/collectNew?source=h5&title=新品收集';
                    break;
            }
            this.$router.push(linkUrl)
        },
        /**
         * 跳转预售专区
         */
        goPerSale(){
            if (localStorage.getItem("isShowNeedKnow") === 'true'){
                this.$router.push('/product/needToknow?source=h5')
            } else {
                this.$router.push('/product/preSale')
            }
        },
        /**
         * 获取楼层商品
         */
        getGoods(params, secondSid){
            Api.fetchGoods({
                current: 1,
                size: 12,
                firstClassSid: params,
                secondClassSid: secondSid,
                huddleType: 1
            }).then(({ data: { data }}) => {
                if (secondSid && params === 187) {
                    this.JYmedicalCare = data.records;
                    return;
                }
                switch (params){
                    case 166: 
                        this.oralGoods = data.records
                        break
                    case 181: 
                        this.outGoods = data.records
                        break
                    case 187: 
                        this.medicineGoods = data.records
                        break
                    case 10: 
                        this.nutritionGoods = data.records
                        break
                    case 177: 
                        this.proGoods = data.records
                        break   
                    case 145: 
                        this.CWpatentMedicine = data.records;
                        break;
                }
            })
        },
        // 跳转详情
        goDetail(sid, name) {
            this.$router.push(`/product/detail/${sid}`)
            _czc.push("_trackEvent", "点击商品", "goods_click", 'goodsName:' + name + ';pageName: 首页' + ";club:" + this.$store.getters.userInfo.currentType)
        },
        // 跳转搜索
        goSearch() {
            this.$router.push(`/product/search/${'bt'}`)
            _czc.push("_trackEvent", "点击搜索框", "search_click", "首页" + ";club:" + this.$store.getters.userInfo.currentType)
        },
        /**
         * 弹窗
         */
        getPop(){
            if (!localStorage.getItem('popFlag') && localStorage.isShowGuide){
                Api.fetchWinPop({ source: 0 }).then(({ data: { data }}) => {
                    if (data.length === 0) return
                    this.showPop = true
                    let infoData = data
                    const index = Math.floor(Math.random() * infoData.length)
                    infoData = infoData[index]
                    infoData['mainImg'] = this.$store.getters.userInfo.oss + infoData.mobileImgUrl
                    this.winPopInfo = infoData
                })
            } else {
                this.showPop = false
            }
        },
        /**
         * 弹窗跳转
         */
        goPopPage(item){
            if (item.mobileType === 1){
                this.$router.push(`/product/detail/${item.mobileBusinessValue}`)
            } else if (item.mobileType === 2){
                this.goInnerPage(item.mobileBusinessValue)
                // this.$router.push('/product/promotion')
            } else if (item.mobileType === 3){
                if (item.mobileBusinessValue === '' || item.mobileBusinessValue == null){
                    return
                }
                if (item.mobileBusinessValue.indexOf('?') !== -1){
                    window.location.href = item.mobileBusinessValue + '&source=h5'
                } else {
                    window.location.href = item.mobileBusinessValue + '?source=h5'
                }
            } else if (item.mobileType === 4){
                const firstSid = JSON.parse(item.mobileBusinessValue).parentTypeId
                const secondSid = JSON.parse(item.mobileBusinessValue).typeId
                this.$router.push('/menu?firstSid=' + firstSid + "&secondSid=" + secondSid)
            }
            localStorage.setItem("popFlag", true)
        },
        /**
         * 关闭弹窗
         */
        closeBtn(){
            this.showPop = false
            localStorage.setItem("popFlag", true)
        },
        /**
         * 资质过期提醒
         */
        getQft() {
            const isFree = this.$store.getters.userInfo.isFree
            if (isFree) this.showGspDate = true;
        },
        gotoQualification() {
            this.showGspDate = false;
            localStorage.setItem("qftFlag", false)
            this.$router.push({
                path: '/personal/qualification'
            })
        },
        cancalGsp() {
            this.showGspDate = false;
            localStorage.setItem("qftFlag", false)
        },
        /**
         * 查询热销商品
         */
        fetchHotGoods() {
            Api.fetchNewGoods({ current: this.currentPage, size: 12, searchType: 3, huddle: 1 }).then(({ data: { data }}) => {
                this.hotGoodsList = this.hotGoodsList.concat(data ? data.records || [] : [])
            })
        },
        // 引导图
        nextGuide() {
            if (this.currentGuidePage < 4) {
                this.currentGuidePage++;
            } else {
                this.showGuide = false;
                localStorage.setItem('isShowGuide', true);
                if (this.qftFlag !== 'false') this.getQft();
                this.getPop();
            }
        },
        // 跳过
        skipeGuide() {
            this.showGuide = false;
            localStorage.setItem('isShowGuide', true);
            if (this.qftFlag !== 'false') this.getQft();
            this.getPop();
        },
        // 打开引导弹窗
        openGuide() {
            document.body.style.overflow = 'hidden';
        },
        // 关闭引导弹出
        closeGuide() {
            document.body.style.overflow = 'auto';
        }
        // /**
        //  * 查询热销商品
        //  */
        // fetchHotGoods() {
        //     Api.fetchNewGoods({ current: this.currentPage, size: 12, searchType: 3, huddle: 1 }).then(({ data: { data }}) => {
        //         this.hotGoodsList = this.hotGoodsList.concat(data ? data.records || [] : [])
        //     })
        // }
    }
}
</script>
<style lang="scss">
.custom-gsp-dialog{
    border-radius: .12rem;
    width: 6.86rem;
    .van-dialog__header{
        padding: 0;
    }
    .van-dialog__content{
        max-height: 4.9rem;
        overflow-y: auto;
    }
    .gsp-title{
        font-weight:500;
        color: #666666;
        font-size: .36rem;
        padding-top: 0.4rem;
    }
    .tips{
        text-align: center;
        color: #888888;
        font-size: 0.26rem;
        margin-top: 0.1rem;
    }
    .user-list {
        padding: .1rem .24rem .38rem .24rem;
        li{
            .user-store{
                display: flex;
                line-height: .4rem;
                margin-bottom: 0.12rem;
                padding: 0.12rem 0.16rem;
                background: #F6F6F6;
                border-radius: 0.08rem;
                p{
                    flex: 1;
                    font-size: .28rem;
                    color: #333333;
                    margin: 0;
                }
                span{
                    // width: 1.3rem;
                    margin-left: .1rem;
                    color: #ED3129;
                    font-size: .24rem;
                }
            }
        }
    }
    .van-dialog__confirm{
        background: #ED3129;
    }
    .van-dialog__cancel{
        border-top: .02rem solid #E4E4E4;
    }
}
%textOver {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
.Page-home-index {
    background: #f4f4f4;
    .bottom{
        margin-top: .24rem;
    }
    .floor-title{
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: .14rem 0 .22rem;
        span{
            font-size: .32rem;
            color: #333;
            font-weight: 600;
            line-height: .52rem;
            height: .44rem;
            line-height: .48rem;
        }
        span:nth-child(2){
            display: flex;
            align-items: center;
            span{
                font-size: .26rem;
                color: #BBBBBB;
                font-weight: 400;
            }
        }
        img{
            width: .32rem;
            height: .32rem;
        }
    }
    .coupon-box{
        width: 5.6rem;
        height: 8.4rem;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/coupon-bg.png') 50% 50% no-repeat;
        background-size: contain;
        position: relative;
        .couponInfoList{
            position: absolute;
            width: 5.4rem;
            height: 3.94rem;
            top: 3.18rem;
            left: .1rem;
            overflow: auto;
            .couponInfo{
                &:last-child{
                    margin: 0;
                }
                background: url('https://imga.hnhcyy.com/fed/b2b-wechat/coupon-bg-4.png') 50% 50% no-repeat;
                background-size: contain;
                width: 100%;
                height: 1.92rem;
                margin-bottom: .1rem; 
                display: flex;
                line-height: 1;
                .left{
                    width: 2rem;
                    margin: .1rem 0;
                    border-right: .02rem dotted #FBC4C2;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    .discount{
                        color: #ED3129;
                        padding-bottom: .36rem;
                        span:nth-child(1){
                            font-size: .32rem;
                        }
                        span:nth-child(2){
                            font-size: .52rem;
                        }
                    }
                    .sill{
                        font-size: .28rem;
                        color: #666666;
                    }
                }
                .right{
                    width: 3.06rem;
                    margin: .2rem .16rem;
                    .row-1{
                        span{
                            display: inline-block;
                            max-width: 2.82rem;
                            @extend %textOver;
                            padding: .06rem .12rem;
                            line-height: .4rem;
                            border-radius: .22rem;
                            text-align: center;
                            background: rgba(237,49,41,0.09);
                            color: #ED3129;
                            font-size: .28rem;
                            margin-bottom: .12rem;

                        }
                    }
                    .row-2{
                        color: #999999;
                        font-size: .24rem;
                        margin-bottom: .12rem;
                        @extend %textOver;
                    }
                    .row-3{
                        margin-bottom: .02rem;
                    }
                    .row-3, .row-4{
                        font-size: .24rem;
                        color: #666666;
                        @extend %textOver;
                    }
                }
            }
        }
        .van-button{
            position: absolute;
            bottom: .52rem;
            left: 1.98rem;
            padding: .14rem .34rem;
            height: auto;
            line-height: 1;
            background-color: transparent;
            color: #fff;
            font-size: .28rem;
        }
    }
    .floor-item-list{
        .floor-title{
            span{
                color: #666666;
            }
        }
    }
    .qftPop{
        z-index: 9999 !important;
    }
    .van-popup:not(.guide-popup) {
        width: 5.60rem;
        height: 8.40rem;
        margin: auto;
        background: transparent;

        .active-box {
            width: 100%;
            height: 7.56rem;

            img {
                width: 100%;
                height: 100%;
            }
        }

        .close-btn {
            width: .52rem;
            height: .52rem;
            position: absolute;
            bottom: .10rem;
            left: 0;
            right: 0;
            margin: auto;
            z-index: 5555;

            img {
                width: 100%;
                height: 100%;
            }
        }
    }
    .top {
        height: 4.2rem;
        background: #E43232;
        border-bottom-left-radius: 2.6rem .6rem;
        border-bottom-right-radius: 2.6rem .6rem;
        &.scroll-top{
            background: transparent;
        }
        .floor-1 {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.24rem;
            color: #ffffff;
            height: 0.6rem;
            padding: 0.06rem 0 0;
            img {
                height: 0.48rem;
                padding: 0 0.22rem;
            }
        }
        .floor-2 {
            display: flex;
            align-items: center;
            padding: 0.16rem 0.2rem;
            position: relative;
            .info {
                height: 0.12rem;
                width: 0.12rem;
                box-shadow: 0px 0px 8px 0px rgba(255, 209, 0, 0.25);
                background: #FFD100;
                position: absolute;
                top: 0.28rem;
                right: 0.2rem;
                border-radius: 50%;
            }
            img {
                width: 0.48rem;
                height: 0.48rem;
            }
            .van-cell-group {
                position: relative;
                padding: 0.1rem 0.2rem;
                margin: 0 0.2rem;
                background: #f4f4f4;
                border-radius: 0.68rem;
                width: 80%;
                .van-icon{
                    img{
                        position: relative;
                        top: 0;
                        left: 0;
                    }
                }
                img {
                    position: absolute;
                    top: 0.1rem;
                    left: 0.4rem;
                }
                .van-cell {
                    padding: 0;
                    background: #f4f4f4;
                    display: flex;
                    align-items: center;
                    line-height: 1;
                    .van-field__control {
                        font-size: 0.26rem;
                        color: #999999;
                    }
                }
            }
            [class*="van-hairline"]::after {
                border: none;
            }
        }
        .fixedFloor {
            position: fixed;
            top: 0;
            left: 0;
            background: #ed3129;
            width: 7.1rem;
            z-index: 9;
            transform: translateZ(0);
        }
    }
    .swiper-box {
        padding: 0.16rem 0.2rem 0;
        margin-top: -2.6rem;
        margin-bottom: .2rem;
        .van-swipe {
            width: 100%;
            height: 3.6rem;
            .van-image {
                width: 100%;
                height: 100%;
            }
            img {
                width: 100%;
                height: 100%;
                border-radius: .16rem;
            }
            // .van-swipe__indicator {
            //     background-color: rgba(0, 0, 0, 0.5);
            //     width: 0.08rem;
            //     height: 0.08rem;
            // }
        }
    }
    .pre-sale-box{
        position: relative;
        margin: 0 .2rem;
        padding: .16rem .2rem;
        height: .48rem;
        background: #281313;
        box-shadow: 0px 0px .24rem 0px rgba(0, 0, 0, 0.15);
        border-radius: .4rem;
        display: flex;
        align-items: center;
        span:nth-child(1){
            width: .9rem;
            height: .48rem;
            line-height: .48rem;
            text-align: center;
            background: linear-gradient(90deg, #FF6100 0%, #FF3200 100%);
            border-radius: .24rem;
            font-size: .28rem;
            color: #fff;
        }
        span:nth-child(2){
            font-size: .28rem;
            font-weight: 500;
            color: #FFFFFF;
            line-height: .28rem;
            margin-left: .36rem;
        }
        .arrow{
            width: .28rem;
            height: .28rem;
            position: absolute;
            right: .18rem;
            top: .26rem;
        }
    }
    .icon-list {
        display: flex;
        background: #fff;
        margin: .2rem .2rem 0;
        border-radius: .16rem;
        padding: .2rem 0;
        flex-wrap: wrap;
        .icon-item {
            padding: 0.1rem 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 25%;
            text-align: center;
            img {
                width: 0.76rem;
                height: 0.76rem;
                margin-bottom: 0.12rem;
            }
            span {
                display: block;
                font-size: 0.28rem;
            }
        }
    }
    .happy-new-year{
        padding: 0 .2rem;
        img{
            width: 100%;
        }
    }
    .item-list {
        .floor-box{
            border-radius: .16rem;
            max-height: 15.4rem;
            margin: .12rem .2rem 0;
        }
        .item-hd{
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            .page-index-productCard-1{
                margin: 0;
            }
            .item-box{
                margin: .12rem;
                background: linear-gradient(136deg, #FFFFFF 0%, #FFF9F9 100%);
                border-radius: .16rem;
                &.item-box-1{
                    background: linear-gradient(136deg, #FFFFFF 0%, #F4FBFF 100%);
                    margin: .12rem .12rem .12rem 0;
                }
                &.item-box-2{
                    background: linear-gradient(136deg, #FFFFFF 0%, #FBF4FF 100%);
                    margin: 0 .12rem .12rem .12rem;
                }
                &.item-box-3{
                    background: linear-gradient(136deg, #FFFFFF 0%, #FFFCF1 100%);
                    margin: 0 .12rem .12rem 0;
                }
                .page-index-productCard-1{
                    width: 3.36rem;
                    height: 6.77rem;
                    padding: .12rem;
                    margin: 0;
                    background: transparent;
                }
            }
        }
        &.item-list-border {
            margin-top: 0.48rem;
            border-bottom: 1px solid rgba(228, 228, 228, 1);
        }

        &.item-list-border:last-child {
            border-bottom: 0 solid rgba(228, 228, 228, 1);
        }

        .item-title {
            display: flex;
            justify-content: space-between;

            .item-tips {
                width: 1.86rem;
                height: 0.48rem;
                border-radius: 0 2rem 2rem 0;
                font-size: 0.36rem;
                color: #fff;
                line-height: 0.48rem;
                text-align: center;
                font-weight: 600;
            }

            .item-text {
                margin-right: 0.18rem;
                font-size: 0.28rem;
                color: rgba(51, 51, 51, 1);
                display: flex;
                align-items: center;

                img {
                    margin-left: 0.08rem;
                    width: 0.28rem;
                    height: 0.28rem;
                }
            }
        }

        .top-banner {
            width: 7.1rem;
            height: 2.2rem;
            margin: .3rem .2rem 0;
            .van-swipe{
                .van-swipe__indicators{
                    bottom: .39rem;
                    .van-swipe__indicator{
                        width: 0.12rem;
                        height: .12rem;
                        border-radius: 50%;
                        &.van-swipe__indicator--active{
                            width: 0.12rem;
                        }
                    }
                }
            }
            img {
                width: 7.1rem;
                height: 2.2rem;
                border-radius: .16rem;
            }
        }
        .van-swipe {
            .van-swipe__track{
                padding-bottom: .24rem;
            }

            .van-swipe__indicators {
                bottom: 0;

                .van-swipe__indicator {
                    // width: 0.12rem;
                    // height: 0.08rem;
                    // border-radius: .04rem;
                    opacity: .2;
                    background-color: #FF4646;
                    &.van-swipe__indicator--active{
                        // width: .24rem;
                        opacity: 1;
                    }
                }
            }
        }
        .has_not_range,
        .sold-out{
            height: 1.6rem;
            width: 1.6rem;
            top: 50%;
            left: 50%;
            margin-left: -.8rem;
            margin-top: -.8rem;
        }
        .promotion-box{
            background: #fff;
            border-radius: .16rem;
            max-height: 15.4rem;
            margin: .24rem .2rem 0;
            padding-bottom: .4rem;
            .floor-title{
                padding: .28rem .18rem .22rem .28rem;
            }
        }
    }
    .guide-popup{
        width: 100%;
        height: 100vh;
        background: transparent;
        transform: translate3d(0, 0, 0);
        top: 0;
        left: 0;
        .guide-1{
            width: 5.36rem;
            margin: 0 auto;
            margin-left: 1.08rem;
            margin-top: 5.94rem;
        }
        .guide-2{
            width: 6.7rem;
            margin-left: .4rem;
        }
        .guide-3{
            width: 5.54rem;
            margin-left: 1rem;
        }
        .guide-4{
            width: 5.34rem;
            margin-left: 1.08rem;
        }
        .next-btn,.next-btn-top{
            width: 2.58rem;
            height: .8rem;
            margin: 0 auto;
            margin-top: .4rem;
            text-align: center;
            line-height: .8rem;
            border-radius: .4rem;
            border: .02rem dashed #ffffff;
            font-size: .32rem;
            color: #ffffff;
            span{
                color: #FFD200;
                font-size: .48rem;
            }
        }
        .next-btn-top{
            margin-top: 0;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }
        .skip-guide{
            width: 1.4rem;
            height: .52rem;
            text-align: center;
            line-height: .52rem;
            border-radius: .4rem;
            border: .5px solid rgba(255, 255, 255, 0.4);
            background: #00000080;
            color: #A7A7A7;
            position: absolute;
            top: .8rem;
            right: .4rem;
        }
    }
}
</style>
