<template>
    <div v-if="theme === 'newStyle'" class="new-product-card">
        <div class="new-item-image">
            <image-load
                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                :original-image="item.mainImg"
                :sid="item.sid"
                :source="source"
                :item="item"
                :page-name="pageName"
            />
            <ul v-if="item.pageFirstSellPoint || item.pageSecondSellPoint" class="sale-pointer">
                <li v-if="item.pageFirstSellPoint">
                    <img src="@/assets/images/bg_sell_point.png" alt="">
                    <span>{{ item.pageFirstSellPoint }}</span>
                </li>
                <li v-if="item.pageSecondSellPoint">
                    <img src="@/assets/images/bg_sell_point.png" alt="">
                    <span>{{ item.pageSecondSellPoint }}</span>
                </li>
            </ul>
            <div class="icon-box">
                <template v-if="item.prescriptionClass">
                    <img
                        v-if="item.prescriptionClass === '处方药'"
                        class="icon-otc"
                        src="@/assets/images/detail_rx.png"
                    >
                    <img
                        v-if="item.prescriptionClass === '甲类OTC'"
                        class="icon-otc"
                        src="@/assets/images/detail_otc.png"
                    >
                    <img
                        v-if="item.prescriptionClass === '乙类OTC'"
                        class="icon-otc"
                        src="@/assets/images/detail_otc_gn.png"
                    >
                </template>
                <img 
                    v-if="item.consistencyEvaluation && item.consistencyEvaluation !== 0"
                    class="icon-zy"
                    src="@/assets/images/detail_zy.png"
                >
                <img 
                    v-if="item.medicalInsuranceSid && item.medicalInsuranceSid !== 0"
                    class="icon-yibao"
                    src="@/assets/images/icon-yibao.png"
                >
            </div>
        </div>
        <div v-if="item.preSale" class="show-activity">
            <span>预售</span>
            <div>{{ item.preSaleDeliveryTimeStr ? '预计'+item.preSaleDeliveryTimeStr+'发货':'预售活动,欢迎来抢购' }}</div>
        </div>
        <div v-else-if="item.activityList && item.activityList.length" class="show-activity">
            <span>促销</span>
            <!-- <template v-if="item.activityTimeList!=null && item.activityTimeList.length">
                <van-count-down :time="item.activityGoodsTime">
                    <template v-slot="timeData">
                        <template v-if="item.activityTipType">{{ item.activityTipType }}</template>
                        <font v-if="item.activityAmount">{{ item.activityAmount }}</font>
                        <template v-if="timeData.days">倒计时<font>{{ timeData.days }}</font>天</template>
                        <template v-else-if="timeData.hours">倒计时<font>{{ timeData.hours }}</font>时</template>
                        <template v-else-if="timeData.minutes">倒计时<font>{{ timeData.minutes }}</font>分</template>
                        <template v-else-if="timeData.seconds">倒计时<font>{{ timeData.seconds }}</font>秒</template>
                    </template>
                </van-count-down>
            </template> -->
            <!-- <template>{{ item.activityList[0] ? item.activityList[0].name:'活动进行中' }}</template> -->
            <div>{{ item.activityList[0] ? item.activityList[0].name:'活动进行中' }}</div>
        </div>
        <div v-else-if="item.couponsList && item.couponsList.length > 0" class="show-activity">
            <span>优惠券</span>
            <div>{{ item.couponsList[0] ? item.couponsList[0].description || '活动进行中' : '活动进行中' }}</div>
        </div>
        <div v-else-if="item.isNew" class="show-activity">
            <span>新品</span>
            <van-count-down v-if="item.newGoodsTime" :time="item.newGoodsTime">
                <template v-slot="timeData">
                    <template v-if="timeData.days">倒计时{{ timeData.days }}天</template>
                    <template v-else-if="timeData.hours">倒计时<font>{{ timeData.hours }}</font>时</template>
                    <template v-else-if="timeData.minutes">倒计时<font>{{ timeData.minutes }}</font>分</template>
                    <template v-else-if="timeData.seconds">倒计时<font>{{ timeData.seconds }}</font>秒</template>
                </template>
            </van-count-down>
            <div v-else>新品活动,欢迎来抢购</div>
        </div>
        <div v-else-if="item.risePrise === 1" class="show-activity">
            <span>即将上涨</span>
            <div>{{ item.riseContent || '欢迎来抢购' }}</div>
        </div>
        <div v-else-if="pageName === 'comingSoon'" class="show-activity">
            <span>即将到货</span>
            <div>{{ item.publishTime || '欢迎来抢购' }}</div>
        </div>
        <ul class="product-info">
            <li class="commodity-name" @click="goDetail(item)">{{ item.commodityName }}</li>
            <li class="icon-row">
                <span v-if="item.purchased" class="icon-purchased">近期已采</span>
                <span v-if="item.couponsList && item.couponsList.length > 0" class="icon-coupon">券</span>
                <template v-for="(list, index) in item.labelList">
                    <img
                        v-if="list.showStatus !== 0"
                        :key="index"
                        :src="$store.getters.userInfo.oss + replaceUrl($store.getters.userInfo.oss, list.iconUrl)"
                        class="icon-label"
                    > 
                </template>
                <template v-for="(list,index) in item.activityList">
                    <img
                        v-if="[1, 6, 8].indexOf(list.activityType) > -1 && index < 1"
                        :key="index"
                        src="@/assets/images/icon-gift.png"
                        class="icon-activity"
                    >
                    <img
                        v-if="list.activityType ===3 && index < 1"
                        :key="index"
                        src="@/assets/images/icon-reduce.png"
                        class="icon-activity"
                    >
                </template>
            </li>
            <li class="row margin-top-7">
                <img class="icon" src="@/assets/images/spec-icon.png" alt="">
                <span class="content">{{ item.spec }}</span>
            </li>
            <li class="row" :style="pageName === 'comingSoon' ? 'padding-bottom:.2rem':''">
                <img class="icon" src="@/assets/images/manufacturer-icon.png" alt="">
                <span class="content">{{ item.manufacturer }}</span>
            </li>
            <template v-if="pageName !== 'comingSoon'">
                <li class="row">
                    <img class="icon" src="@/assets/images/expireDate-icon.png" alt="">
                    <span class="content">优于{{ item.expireDateStr != null ? item.expireDateStr : '' }}</span>
                </li>
                <li class="row row-toCart">
                    <div class="price-detail" @click="goDetail(item)">
                        <span>¥</span>
                        <span>{{ item.price }}</span>
                        <span class="retailPrice">¥ {{ item.retailPrice }}</span>
                    </div>
                    <add-to-cart v-if="pageName === 'ralation'" :item="item" :activity-type="3" :source="source" />
                    <add-to-cart v-else-if="pageName === 'promotion'" :item="item" :activity-type="1" :source="source" />
                    <add-to-cart v-else :item="item" :source="source" :activity-type="item.activityType" />
                </li>
            </template>
        </ul>
    </div>
    <div v-else :class="theme === 'theme-1'? 'page-index-productCard' : 'page-index-productCard-1'">
        <div v-if="theme === 'theme-1'" :class="cardType === 'menu' ? 'goods-list-box' : 'goods-list-box goods-list-item'">
            <!-- <van-list v-model="loading" :finished="finished" :finished-text="'我是有底线的'" :offset="10" @load="onLoad"> -->
            <div v-if="item.activityTimeList!=null && item.activityTimeList.length" class="row row-8" @click="goDetail(item)">
                <div>距活动结束剩</div>
                <van-count-down :time="item.activityGoodsTime">
                    <template v-slot="timeData">
                        <span class="item">{{ timeData.days > 9 ? timeData.days : '0'+timeData.days }}</span>天
                        <span class="item">{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}</span>时
                        <span class="item">{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}</span>分
                        <span class="item">{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}</span>秒
                    </template>
                </van-count-down>
            </div>
            <div v-else-if="item.isNew" class="row row-8" @click="goDetail(item)">
                <div>新品倒计时</div>
                <van-count-down :time="item.newGoodsTime">
                    <template v-slot="timeData">
                        <span class="item">{{ timeData.days > 9 ? timeData.days : '0'+timeData.days }}</span>天
                        <span class="item">{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}</span>时
                        <span class="item">{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}</span>分
                        <span class="item">{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}</span>秒
                    </template>
                </van-count-down>
            </div>
            <div class="list" :style="item.isNew || (item.activityTimeList!=null && item.activityTimeList.length)? 'padding-top: .24rem':''">
                <div class="goods-img">
                    <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :is-product-img="true" :original-image="item.mainImg" :sid="item.targetProductSid?item.targetProductSid:(item.proSid?item.proSid:item.sid)" :item="item" :source="source" />
                    <img v-if="item.medicalInsuranceSid !== 0" class="icon-yibao" src="@/assets/images/icon-yibao.png">
                    <!-- <div v-if="item.expireStatus === 1" :class="item.purchased && isQuickPage ? 'icons-jxq' : 'jxq'">近效期</div> -->
                    <span v-if="item.purchased && isQuickPage" class="purchased-span">近期已采</span>
                </div>
                <div class="goods-info">
                    <div class="row row-1">
                        <span v-if="item.preSale" class="perSaleImg">预售</span>
                        <span class="drug-name flex-1" @click="goDetail(item)">{{ item.commodityName }}</span>
                        <!-- <span v-if="item.brand != null && item.brand != ''" class="item-label label-lsx">{{ item.brand }}</span> -->
                        <!-- <span v-if="item.purchased" class="item-label label-lsx">近期已采</span> -->
                    </div>
                    <div class="row row-2" @click="goDetail(item)">
                        <img class="icon" src="@/assets/images/spec-icon.png" alt="">
                        <span class="flex-1">{{ item.spec }}</span>
                    </div>
                    <div class="row row-6" @click="goDetail(item)">
                        <img class="icon" src="@/assets/images/manufacturer-icon.png" alt="">
                        <span class="flex-1">{{ item.manufacturer }}</span>
                    </div>
                    <div
                        v-if="item.isCmedicine && cardType !== 'materials'"
                        class="row row-3"
                        @click="goDetail(item)"
                    >产地&nbsp;
                        <span>{{ item.producingArea }}</span>
                    </div>
                    <div
                        v-else-if="(item.expireDateStr != null||item.expireDate) && cardType !== 'materials'"
                        class="row row-3"
                        @click="goDetail(item)"
                    >
                        <img class="icon" src="@/assets/images/expireDate-icon.png" alt="">
                        <span class="flex-1">优于{{ item.expireDateStr||item.expireDate.split(" ")[0] }}</span>
                    </div>
                    <!-- <div v-if="cardType === 'ralation'" class="row row-9">
                        <template v-for="(list, index) in item.labelList[0]"> 
                            <p v-if="item.showStatus !== 0" :key="index" class="row row-14">
                                <img :src="$store.getters.userInfo.oss + list.iconUrl" alt="">    
                            </p>
                        </template>
                        <template v-for="(list,index) in item.activityList">
                            <p v-if="(list.activityType ===1 || list.activityType === 6|| list.activityType === 8) && index < 1" :key="index" class="row row-13">
                                <img src="../../assets/images/icon-gift.png" alt="">    
                            </p>
                        </template>
                        <template v-for="(list,index) in item.activityList">
                            <p v-if="list.activityType ===3 && index < 1" :key="index" class="row row-13">
                                <img src="../../assets/images/icon-reduce.png" alt="">   
                            </p>
                        </template>
                        <p v-if="item.couponsList" class="row row-10">
                            <img src="../../assets/images/icon-coupon-red.png" alt="">
                        </p>
                    </div> -->
                    <div class="row row-9">
                        <template v-for="(list, index) in item.labelList"> 
                            <p v-if="list.showStatus !== 0 && (cardType === 'search' || cardType === 'menu' || cardType === 'quick')" :key="index" class="row row-14">
                                <img :src="$store.getters.userInfo.oss + replaceUrl($store.getters.userInfo.oss, list.iconUrl)" alt="">    
                            </p>
                        </template>
                        <template v-for="(list,index) in item.activityList">
                            <p :key="index" class="row row-13">
                                <img v-if="[1,6,8].indexOf(list.activityType-0) > -1 && index<1" src="@/assets/images/icon-gift.png" alt="">
                                <img v-if="[3].indexOf(list.activityType-0) > -1 && index<1" src="@/assets/images/icon-reduce.png" alt="">  
                            </p>
                        </template>
                        <p v-if="item.couponsList" class="row row-10">
                            <img src="../../assets/images/icon-coupon-red.png" alt="">
                        </p>
                    </div>
                    <!-- <div v-if="item.couponsList" class="row row-10">
                        <img src="../../assets/images/icon-coupon-red.png" alt="">
                    </div> -->
                    <!-- <div v-if="cardType !== 'comingSoon'" class="row row-4" @click="goDetail(item)">
                        <span class="price">
                            ￥<span>{{ item.price }}</span>
                        </span>
                        <span class="ls-price">
                            ￥ <span>{{ item.retailPrice }}</span>
                        </span>
                    </div> -->
                    <div v-if="cardType === 'promotion'" class="row row-12">
                        <div>满赠</div>
                        <p>{{ item.actName }}</p>
                    </div>
                    <div v-if="cardType === 'comingSoon'" class="row row-7" @click="goDetail(item)">
                        <span>预计到货时间：{{ item.publishTime }}</span>
                    </div>
                    <!-- <div v-if="cardType !== 'comingSoon'" class="row row-5"> -->
                    <div v-if="item.stock <= 0 && !item.preSale" class="row row-5">
                        <span>预计到货：</span>
                        <span>{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</span>
                    </div>
                    <!-- <template v-if="item.stock > 0">
                            <add-to-cart v-if="cardType === 'ralation'" :item="item" :activity-type="3" :source="source" />
                            <add-to-cart v-else-if="cardType === 'promotion'" :item="item" :activity-type="1" :source="source" />
                            <add-to-cart v-else :item="item" :source="source" />
                        </template>
                        <template v-else>
                            <span class="arrivalTimeStr">预计到货：</span>
                            <span class="arrivalTimeStr">{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</span>
                        </template> -->
                    <!-- </div> -->
                    <div class="row-11">
                        <div v-if="cardType !== 'comingSoon'" class="price-detail" @click="goDetail(item)">
                            <span>¥</span>
                            <span>{{ item.price }}</span>
                            <span class="retailPrice">¥ {{ item.retailPrice }}</span>
                        </div>
                        <add-to-cart v-if="cardType === 'ralation'" :item="item" :activity-type="3" :source="source" />
                        <add-to-cart v-else-if="cardType === 'promotion'" :item="item" :activity-type="1" :source="source" />
                        <add-to-cart v-else :item="item" :source="source" />
                    </div>
                </div>
            </div>
        </div>
        <div v-else class="item-li">
            <div class="icon-span-box-top">
                <span>{{ item.activityType }}</span>
                <!-- <img v-if="item.prescriptionClass && item.prescriptionClass === '处方药'" class="icon-otc" src="@/assets/images/detail_rx.png"> -->
                <!-- <img v-if="item.prescriptionClass && item.prescriptionClass === '甲类OTC'" class="icon-otc" src="@/assets/images/detail_otc.png"> -->
                <!-- <img v-if="item.prescriptionClass && item.prescriptionClass === '乙类OTC'" class="icon-otc" src="@/assets/images/detail_otc_gn.png"> -->
                <!-- <img v-if="item.consistencyEvaluation && item.consistencyEvaluation !== 0" class="icon-zy" src="@/assets/images/detail_zy.png"> -->
                <img v-if="item.medicalInsuranceSid !== 0" class="icon-yibao" src="@/assets/images/icon-yibao.png">
            </div>
            <div class="item-image">
                <image-load
                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                    :original-image="item.mainImg"
                    :sid="item.sid"
                    :source="source"
                    :item="item"
                />
                <!-- <img v-if="item.preSale" class="perSaleImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" alt=""> -->
                <div class="icon-span-box">
                    <div>
                        <span v-if="item.purchased && isQuickPage" class="purchased-span">近期已采</span>
                        <!-- <span v-if="item.expireStatus === 1" class="expire-span">近效期</span> -->
                    </div>
                    <div>
                        <span v-if="item.couponsList && item.couponsList.length > 0" class="icon-text">券</span>
                        <span v-if="item.activityList || item.actSid" class="icon-text">促</span>
                    </div>
                </div>
            </div>
            <div class="item-info">
                <div class="row row-1 clearfix">
                    <span v-if="item.preSale" class="preSaleText">预售</span>
                    <span :class="item.preSale? 'title preSale-title' : 'title'" @click="goDetail(item)">{{ item.commodityName }}</span>
                </div>
                <div class="row row-2" @click="goDetail(item)">{{ item.spec }}</div>
                <div class="row row-3" @click="goDetail(item)">
                    {{ item.manufacturer }}
                </div>
                <div class="row row-4" @click="goDetail(item)">
                    <template v-if="item.expireDateStr != null||item.expireDate">
                        <span>{{ item.isCmedicine ? '产地&nbsp;' : '效期优于&nbsp;' }}</span>
                        <span>{{ item.isCmedicine ? item.producingArea:item.expireDateStr||item.expireDate.split(" ")[0] }}</span>
                    </template>
                </div>
                <div class="row row-7">
                    <template v-if="item.stock <= 0">
                        <span class="arrivalTimeStr"><van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-time.png" />预计到货</span>
                        <span class="arrivalTimeStr">{{ item.arrivalTimeStr ? (item.arrivalTimeIsOverdue ? '待定' : item.arrivalTimeStr) : '待定' }}</span>
                    </template>
                    <template v-else>
                        <div>&nbsp;</div>
                    </template>
                </div>
                <div class="row row-6">
                    <div class="price-detail" @click="goDetail(item)">
                        <span>¥</span>
                        <span>{{ item.price }}</span>
                        <span class="retailPrice">¥ {{ item.retailPrice }}</span>
                    </div>
                    <add-to-cart :item="item" :source="source" />
                </div>
            </div>
        </div>
    </div>
   
</template>

<script>
import addToCart from '@/components/addToCart/index'
import imageLoad from '@/components/imageLoad/index'
import { replaceUrl } from '@/utils/util'

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'ProductCard',
    components: {
        addToCart,
        imageLoad
    },
    props: {
        source: {
            type: String,
            default: 'h5'
        },
        item: {
            type: Object,
            default: () => {
                return {

                }
            }
        },
        cardType: {
            type: String,
            default: ''
        },
        currentType: {
            type: Number,
            default: 1
        },
        theme: {
            type: String,
            default: 'theme-1'
        },
        isQuickPage: {
            type: Boolean,
            default: true
        },
        // 页面名称
        pageName: {
            type: String,
            default: ''
        }
    },
    data() {
        return {
            goodsInfo: null,
            replaceUrl: replaceUrl,
            locationType: navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) ? 'hcjkpay' : 'hcyy'
        }
    },
    mounted() {
        // if (this.cardType === 'newGoods'){
        //     const currentTime = Date.parse(new Date())
        //     const newEndTime = Date.parse(this.item.newEndTime.replace(/-/g, "/"))
        //     const newGoodsTime = newEndTime - currentTime
        //     this.$set(this.item, 'newGoodsTime', newGoodsTime)
        // }
        this.item.activityTimeList = [];
        if (this.item.activityList){
            this.item.activityList.forEach(v => {
                if ((v.activityType === 1 || v.activityType === 3) && v.activityTimeDisplay === true) {
                    this.item.activityTimeList.push(v);
                }
            })
        }
        if (this.item.activityTimeList.length) {
            const currentTime = Date.parse(new Date())
            const activityEndTime = Date.parse(this.item.activityTimeList[0].endTime.replace(/-/g, "/"))
            const activityGoodsTime = activityEndTime - currentTime
            this.$set(this.item, 'activityGoodsTime', activityGoodsTime)
        }
        if (this.item.isNew === true){
            const currentTime = Date.parse(new Date())
            const newEndTime = Date.parse(this.item.newEndTime.replace(/-/g, "/"))
            const newGoodsTime = newEndTime - currentTime
            this.$set(this.item, 'newGoodsTime', newGoodsTime)
        }
    },
    methods: {
        goDetail(item){
            if (this.pageName === 'comingSoon') return;
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
            _czc.push(["_trackEvent", "点击商品", "goods_click", 'goodsName:' + item.commodityName + ';pageName:' + this.$route.meta.title + ";club:" + this.$store.getters.userInfo.currentType])
        }
    }
}
</script>

<style lang="scss">
@mixin overflowText{
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.page-index-productCard-1,.page-index-productCard{
    .price-detail{
        display: flex;
        align-items: center;
        span {
            &:nth-child(1) {
                font-size: .24rem;
                color: #ed3129;
                padding-right: .04rem;
            }

            &:nth-child(2) {
                font-size: 0.36rem;
                color: #ed3129;
                font-weight: bold;
            }

            &.retailPrice {
                max-width: 1rem;
                font-size: .28rem;
                @include overflowText;
                color: #999999;
                margin-left: .18rem;
            }
        }
    }
}

.page-index-productCard{
    .goods-list-box {
        background: #fff;
        &.goods-list-item{
            .row-8{
                width: auto;
                background-color: #FF645A;
                box-shadow: 0px 4px 12px 0px rgba(247,62,49,0.25);                
                border-radius: 0px 0px 0px 8px;
                color: #fff;
                font-size: 0.22rem;
                line-height: 0.4rem;
                margin-left: 3.6rem;
                div{
                    margin-left: 0.16rem;
                }
                .van-count-down{
                    color: #fff;
                    font-size: 0.22rem;
                }
            }
            .list{
                margin: 0 0 0.2rem 0;
                display: flex;
                .goods-img{
                    position: relative;
                    width: 2rem;
                    .icon-yibao{
                        height: 0.4rem;
                        width: 0.4rem;
                        position: absolute;
                        top: 0;
                        right: 0;
                    }
                    .purchased-span{
                        position: absolute;
                        color: #FF9A38;
                        font-size: 0.24rem;
                        bottom: 0;
                        left: 0.44rem;
                        height: 0.4rem;
                        width: 1.12rem;
                        background: #FFF3E7;
                        border-radius: 0.24rem;
                        line-height: 0.4rem;
                        text-align: center;
                    }
                    .jxq{
                        position: absolute;
                        bottom: 0rem;
                        left: 0.44rem;
                        height: 0.4rem;
                        width: 1.12rem;
                        background: #FF7768;
                        border-radius: 0.2rem;
                        line-height: 0.4rem;
                        text-align: center;
                        color: #ffffff;
                        font-size: 0.2rem;
                    }
                    .icons-jxq{
                        position: absolute;
                        bottom: 0.64rem;
                        left: 0.44rem;
                        height: 0.4rem;
                        width: 1.12rem;
                        background: #FF7768;
                        border-radius: 0.2rem;
                        line-height: 0.4rem;
                        text-align: center;
                        color: #ffffff;
                        font-size: 0.2rem;
                    }
                    .image-box{
                        height: 2rem;
                        width: 2rem;
                        .van-image__img{
                            height: 100%;
                            width: 100%;
                        }
                    }
                }
                .goods-info{
                    padding-left: 0.18rem;
                    .row-1{
                        display: flex;
                        height: 0.44rem;
                        .drug-name{
                            flex: 1;
                            font-size: 0.32rem;
                            color: #333333; 
                            font-weight: 600;
                            overflow: hidden;
                            text-overflow:ellipsis;
                            white-space: nowrap;
                        }
                        .perSaleImg{
                            display: inline-table;
                            height: 0.3rem;
                            width: 0.6rem;
                            color: #ED3129;
                            font-size: 0.24rem;
                            border: 0.02rem solid #FF4646;
                            text-align: center;
                            line-height: 0.32rem;
                            border-radius: 0.04rem;
                            margin: 0.04rem 0.12rem 0 0;
                        }
                    }
                    .row-2{
                        font-size: 0.24rem;                  
                        font-weight: 500;
                        color: #999999;
                        margin: 0.04rem 0 0.16rem 0;
                    }
                    .row-6{
                        font-size: 0.28rem;
                        color: #666666;
                        margin-bottom: 0.12rem;
                    }
                    .row-3{
                        font-size: 0.28rem;
                        color: #999999;
                        margin-bottom: 0.18rem;
                        span{
                            color: #666666;
                        }
                    }
                    .row-9{
                        display: flex;
                        flex-wrap: wrap;
                        p{
                            margin-right: 0.08rem;
                            margin-bottom: 0.1rem;
                        }
                        .row-14{
                            // width: 1.02rem;
                            height: 0.36rem;
                            img{
                                height: 100%;
                                // width: 100%;
                            }
                        }
                        .row-13{
                            width: 0.6rem;
                            height: 0.36rem;
                            img{
                                height: 100%;
                                width: 100%;
                            }
                        }
                        .row-10{
                            width: 0.72rem;
                            height: 0.36rem;
                            img{
                                height: 100%;
                                width: 100%;
                            }
                        }
                    }
                    .row-4{
                        margin-top: 0.16rem;
                        .price{
                            color: #ED3129;
                            font-size: 0.32rem;
                            span{
                                font-size: 0.4rem;
                            }
                        }
                        .ls-price{
                            margin-left: 0.06rem;
                            color: #999999;
                            font-size: 0.24rem;
                            span{
                                font-size: 0.28rem;
                            }
                        }
                    }
                    .row-11{
                        display: flex;
                        // margin-top: 0.32rem;
                        margin-bottom: 0.04rem;
                    }
                    .row-5{
                        color: #ed3129;
                        font-size: 0.24rem;
                        font-weight: 500;
                        padding-top: 0.16rem;
                    }
                }
            }
        }
    } 

    .goods-list-box{
        margin: .2rem .2rem 0 .2rem;
        .row-8{
            height: 0.4rem;
            width: 3.88rem;
            background-color: #FF645A;
            box-shadow: 0px 4px 12px 0px rgba(247,62,49,0.25);                
            border-radius: 0px 0px 0px 8px;
            display: flex;
            color: #fff;
            font-size: 0.22rem;
            line-height: 0.4rem;
            margin-left: 1.48rem;
                div{
                    margin-left: 0.16rem;
                }
                .van-count-down{
                    color: #fff;
                    font-size: 0.22rem;
                }
        }
        .list{
            display: flex;
            position: relative;
            .goods-img{
                position: relative;
                width: 2.04rem;
                height: 2.04rem;
                .image-box{
                    position: relative;
                    background: #F3F4F6;
                    border-radius: .08rem;
                    .van-image__img{
                        border-radius: .08rem;
                    }
                }
                .icon-yibao{
                    height: 0.4rem;
                    width: 0.4rem;
                    position: absolute;
                    top: .08rem;
                    right: .08rem;
                    z-index: 2;
                }
            }
            .goods-info{
                padding-left: .2rem;
                flex: 1;
                overflow: hidden;
                .row{
                    display: flex;
                    align-items: center;
                    height: .4rem;
                    overflow: hidden;
                    .icon{
                        width: .28rem;
                        height: .28rem;
                        margin-right: .08rem;
                    }
                    .flex-1{
                        flex: 1;
                        color: #999999;
                        font-size: 0.24rem; 
                        overflow: hidden;
                        text-overflow:ellipsis;
                        white-space: nowrap;
                    }
                }
                .row-1{
                    display: flex;
                    height: 0.44rem;
                    .drug-name{
                        font-size: 0.32rem;
                        color: #333333; 
                        font-weight: 600;
                        overflow: hidden;
                        text-overflow:ellipsis;
                        white-space: nowrap;
                    }
                    .perSaleImg{
                        display: inline-table;
                        height: 0.3rem;
                        width: 0.6rem;
                        color: #ED3129;
                        font-size: 0.24rem;
                        border: 0.02rem solid #FF4646;
                        text-align: center;
                        line-height: 0.32rem;
                        border-radius: 0.04rem;
                        margin: 0.04rem 0.12rem 0 0;
                    }
                }
                // .row-2{
                //     font-size: 0.24rem;                  
                //     color: #999999;
                //     margin: 0.08rem 0 0.1rem 0;
                //     overflow: hidden;
                //     text-overflow:ellipsis;
                //     white-space: nowrap;
                //     max-width: 3.4rem;
                // }
                // .row-6{
                //     font-size: 0.26rem;
                //     color: #666666;
                //     overflow: hidden;
                //     text-overflow:ellipsis;
                //     white-space: nowrap;
                //     margin-bottom: 0.1rem;
                // }
                // .row-3{
                //     font-size: 0.24rem;
                //     color: #999999;
                //     margin-bottom: 0.12rem;
                //     span{
                //         color: #666666;
                //     }
                // }
                .row-9{
                    display: flex;
                    flex-wrap: wrap;
                    margin-top: .12rem;
                    p{
                        margin-right: 0.08rem;
                        margin-bottom: 0.1rem;
                    }
                    .row-14{
                            // width: 1.02rem;
                            height: 0.36rem;
                            img{
                                height: 100%;
                                // width: 100%;
                            }
                        }
                    .row-13{
                        width: 0.6rem;
                        height: 0.36rem;
                        img{
                            height: 100%;
                            width: 100%;
                        }
                        }
                    .row-10{
                        width: 0.72rem;
                        height: 0.36rem;
                        img{
                            height: 100%;
                            width: 100%;
                        }
                    }
                }
                .row-4{
                    margin-top: 0.06rem;
                    .price{
                        color: #ED3129;
                        font-size: 0.32rem;
                    }
                    .ls-price{
                        margin-left: 0.16rem;
                        color: #999999;
                        font-size: 0.24rem;
                    }
                }
                .row-5{
                    color: #ed3129;
                    font-size: 0.24rem;
                    font-weight: 500;
                    padding-top: 0.16rem;
                }
            }
        }
    }
}
.page-index-productCard-1{
    position: relative;
    box-sizing: border-box;
    width: 3.44rem;
    height: 6.68rem;
    text-align: left;
    background: #fff;
    border-radius: .16rem;
    margin-bottom: .16rem;
    .icon-span-box-top{
        width: calc(100%);
        padding: 0 .14rem;
        position: absolute;
        top: .12rem;
        left: 0;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        z-index: 9;
        .icon-yibao{
            width: .48rem;
            height: .48rem;
            margin-left: .16rem;
        }
        .icon-otc{
            width: .72rem;
        }
        .icon-zy{
            width: .72rem;
            margin-left: .16rem;
        }
    }
    .item-li {
        .item-image {
            width: 3.44rem;
            height: 3.44rem;
            padding-bottom: 0.36rem;
            text-align: center;
            position: relative;
            .van-image{
                width: 100%;
                height: 100%;
                display: flex;
                justify-content: center;
                img {
                    width: 100%;
                    height: 100%;
                    border-top-left-radius: .16rem;
                    border-top-right-radius: .16rem;
                }
            }

            .perSaleImg{
                position: absolute;
                top: 0;
                left: -.2rem;
                width: .76rem;
                height: .44rem;
            }

            .icon-span-box{
                position: absolute;
                width: 100%;
                bottom: -.02rem;
                left: 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                div{
                    display: flex;
                    align-items: center;
                }
                .icon-text{
                    line-height: 1;
                    display: inline-block;
                    font-size: .24rem;
                    color: #FF4646;
                    border: 0.03rem solid #FF4646;
                    border-radius: .08rem;
                    font-weight: 600;
                    padding: .04rem;
                    margin-right: .1rem;
                    &:nth-last-child(1){
                        margin: 0;
                    }
                }
            }

            .purchased-span{
                font-size: .2rem;
                padding: .04rem .1rem;
                border-radius: .18rem;
                background: #FFF5E4;
                color: #FFB735;
                margin-right: .1rem;
            }

            .expire-span{
                font-size: .2rem;
                padding: .04rem .12rem;
                border-radius: .18rem;
                background: #FF7768;
                color: #ffffff;
            }
        }

        .item-info {
            padding: 0 .24rem;
            line-height: 1;
            margin-top: .24rem;
            .row-1 {
                display: flex;
                align-items: center;
                // justify-content: space-between;
                
                .preSaleText{
                    padding: .04rem .06rem .01rem;
                    color: #ED3129;
                    font-size: .24rem;
                    border-radius: .04rem;
                    border: .02rem solid #FF4646;
                    margin-right: .08rem;
                }

                .title {
                    display: inline-block;
                    max-width: 3.35rem;
                    color: #030303;
                    font-size: 0.32rem;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                    line-height: .32rem;
                    &.preSale-title{
                        max-width: 2.2rem;
                    }
                }
            }

            .row-2 {
                max-width: 3.35rem;
                font-size: 0.24rem;
                padding-top: .12rem;
                color: #999;
                line-height: 1;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .row-3,
            .row-4 {
                display: flex;
                align-items: center;
                color: #000;
                font-size: 0.24rem;
            }

            .row-3 {
                max-width: 2.94rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                padding: 0.12rem 0;
                display: inline-block;
            }

            .row-4 {
                padding-bottom: 0.12rem;
                height: .48rem;
                line-height: .48rem;
                span:nth-child(1){
                    color: #999;
                }
            }

            // .row-5 {
            //     display: flex;
            //     align-items: center;
            //     padding-top: .12rem;

            //     span {
            //         &:nth-child(1) {
            //             font-size: 0.24rem;
            //             color: #ed3129;
            //             padding-right: 0.04rem;
            //         }

            //         &:nth-child(2) {
            //             font-size: 0.36rem;
            //             color: #ed3129;
            //             font-weight: bold;
            //             margin-right: 0.08rem;
            //         }

            //         &.retailPrice {
            //             font-size: 0.24rem;
            //             color: #999999;
            //             margin-left: .2rem;
            //         }
            //     }

            //     .van-icon {
            //         float: right;
            //         font-size: 0.48rem;
            //         color: #ed3129;
            //         margin-right: 0.2rem;
            //     }
            // }

            .row-6 {
                display: flex;
                align-items: center;
                justify-content: space-between;
                
                .van-icon {
                    font-size: .92rem;
                    color: #ed3129;
                }

                .sold-out-icon {
                    color: #666666 !important;
                }
            }

            .row-7{
                display: flex;
                align-items: center;
                padding: .12rem 0 .24rem;
                min-height: .36rem;
                line-height: .36rem;
                .arrivalTimeStr{
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #ED3129;
                    font-size: .24rem;
                    height: .36rem;
                    line-height: .36rem;
                }
                span:nth-child(1){
                    width: 1.4rem;
                    background: #FFEDED;
                    border-radius: .08rem;
                    margin-right: .12rem;
                    .van-icon{
                        width: .24rem;
                        height: .24rem;
                        margin-right: .04rem;
                    }
                }
            }
        }
    }
}

.new-product-card{
    width: 3.44rem;
    background: #fff;
    margin-top: .2rem;
    border-radius: .12rem;
    .new-item-image{
        width: 3.44rem;
        height: 3.44rem;
        position: relative;
        overflow: hidden;
        .sale-pointer{
            position: absolute;
            left: -.08rem;
            top: 0;
            z-index: 2;
            li{
                display: flex;
                color: #ffffff;
                font-weight: 600;
                font-size: .24rem;
                &:nth-child(2){
                    margin-top: .02rem;
                }
                img{
                    width: .06rem;
                    height: .4rem;
                    border-radius: 0;
                }
                span{
                    display: inline-block;
                    padding: 0 .08rem;
                    height: .32rem;
                    line-height: .32rem;
                    border-bottom-right-radius: 0.08rem;
                    background: linear-gradient(90deg, #FF6B2B 42.24%, #FFAA2B 96.74%);
                }
            }
        }
        .image-box{
            img{
                border-radius: .12rem .12rem 0px 0px;
            }
            .sold-out,.has_not_range{
                width: 1.56rem;
                height: 1.56rem;
                margin-left: -.78rem;
                margin-top: -.78rem;
            }
        }
        .icon-box{
            position: absolute;
            right: .04rem;
            top: .04rem;
            z-index: 2;
            display: flex;
            align-items: center;
            >img{
                margin-right: .04rem;
            }
            .icon-yibao{
                width: .36rem;
                height: .36rem;
            }
            .icon-otc{
                width: .56rem;
                height: .28rem;
            }
            .icon-zy{
                width: .46rem;
                height: .4rem;
            }
        }
    }
    .show-activity{
        display: flex;
        height: .52rem;
        background: #FFEDE7;
        color: #FF4646;
        align-items: center;
        width: 100%;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        span{
            margin: 0 .16rem 0 .2rem;
            padding: 0 .1rem;
            height: .32rem;
            text-align: center;
            line-height: .32rem;
            background: #FF4646;
            color: #fff;
            border-radius: .3rem;
            font-weight: 600;
            font-size: .24rem;
        }
        .van-count-down{
            color: #FF4646;
        }
        >div{
            flex: 1;
            @include overflowText;
            padding-right: .04rem;
        }
        font{
            font-weight: 600;
        }
    }
    .product-info{
        padding-top: .16rem;
        .row-price{
            .price{
                color: #FF4646;
                font-size: .28rem;
                span{
                    font-size: .36rem;
                    font-weight: 600;
                    margin-left: .1rem;
                }
            }
            .retail-price{
                margin-left: .18rem;
                color: #999999;
            }
        }
        .commodity-name{
            @include overflowText;
            padding: 0 .2rem;
            font-size: .28rem;
            font-weight: 600;
        }
        .icon-row{
            display: flex;
            align-items: center;
            @include overflowText;
            margin: 0 .08rem;
            >*{
                margin: .07rem 0 .07rem .12rem;
                height: .36rem;
                line-height: .36rem;
            }
            .icon-activity{
                width: .64rem;
            }
            .icon-purchased{
                width: 1.12rem;
                text-align: center;
                background: #FFF4E3;
                color: #FFB931;
                font-size: 0.24rem;
                border-radius: 0.04rem;
            }
            .icon-coupon{
                width: .36rem;
                text-align: center;
                background: #FFEDE7;
                color: #FF4646;
                border-radius: .04rem;
            }
            .icon-label{
                width: 1.2rem;
            }
        }
        .margin-top-7{
            margin-top: .14rem;
        }
        .row{
            display: flex;
            align-items: center;
            color: #999999;
            padding: 0 .2rem;
            .icon{
                width: .28rem;
                height: .28rem;
                border-radius: .04rem;
                font-size: .24rem;
                font-style: normal;
                text-align: center;
                line-height: .28rem;
                margin-right: .08rem;
            }
            .content{
                flex: 1;
                height: .4rem;
                line-height: .4rem;
                @include overflowText;
            }
        }
        .row-toCart{
            margin-top: .2rem;
            height: .88rem;
            border-top: .02rem solid #F5F5F5;
        }
        .price-detail{
            display: flex;
            align-items: center;
            span {
                &:nth-child(1) {
                    font-size: .24rem;
                    color: #ed3129;
                    padding-right: .04rem;
                }

                &:nth-child(2) {
                    font-size: 0.36rem;
                    color: #ed3129;
                    font-weight: bold;
                }

                &.retailPrice {
                    font-size: .28rem;
                    max-width: 1rem;
                    @include overflowText;
                    color: #999999;
                    margin-left: .18rem;
                }
            }
        }
    }
}

</style>
