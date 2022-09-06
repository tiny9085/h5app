<template>
    <div class="Page-index-detail">
        <div v-if="goodsInfo" style="background:#ffffff;">
            <div id="_1" class="swiperBox">
                <van-swipe ref="swiperRef" indicator-color="#fff" :loop="false" :style="isShowVideo ? 'z-index: 9' : ''" @change="changeSwipe($event)">
                    <van-swipe-item v-for="(item, index) in goodsBannerList" :key="index" @click="preViewImg(goodsBannerList,index)">
                        <image-load :is-product-img="true" default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.imgUrl" :oss-width="800" :oss-height="800" />
                        <van-icon v-if="isShowVideo" class="closeVideo" name="clear" @click="closeVideo" />
                    </van-swipe-item>
                    <video :id="isShowVideo ? 'videoContent-show' : 'videoContent'" disablePictureInPicture controlsList="nodownload noremoteplayback" :src="videoSrc" controls autoplay />
                    <template #indicator>
                        <div class="custom-indicator">
                            {{ current + 1 }}/{{ goodsBannerList.length }}
                        </div>
                    </template>
                </van-swipe>
                <template v-if="!isShowVideo && videoStroge !== ''">
                    <div v-if="goodsInfo.stock <= 0 ||(goodsInfo.preSaleStock&&goodsInfo.preSaleStock <= 0)" class="video-box-1" @click="showVideo">
                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-play.png" />
                        <span>视频</span>
                    </div>
                    <div v-else class="video-box" @click="showVideo">
                        <img class="slide-image" :src="`https://imga.hnhcyy.com/fed/b2b-wechat/detail_play${currentClub}.png`" alt="">
                    </div>
                </template>
                <div class="label-box">
                    <template v-for="(item, index) in goodsInfo.labelList"> 
                        <img v-if="item.showStatus !== 0" :key="index" :src="$store.getters.userInfo.oss + item.iconUrl" class="labelList">
                    </template>
                </div>
                <div v-if="isUnScope()" class="sold-out">
                    <img class="slide-image" src="@/assets/images/not_range.png" alt="">
                </div>
                <div v-else class="sold-out">
                    <img
                        v-if="goodsInfo.stock <= 0 && !goodsInfo.preSale"
                        class="slide-image"
                        src="@/assets/images/soldOut.png"
                        alt=""
                    >
                    <img
                        v-if="goodsInfo.preSaleStock <= 0 && goodsInfo.preSale"
                        class="slide-image"
                        src="https://imga.hnhcyy.com/fed/b2b-wechat/preSale-out.png"
                        alt=""
                    >
                </div>
                <div v-if="isFixed" class="fixed-title">
                    <img src="@/assets/images/back_go.png" alt="" style="width:0.48rem;" @click="goback">
                    <ul>
                        <li v-for="(item,index) in titleBox" :key="index" :class="(title===index+1)?'active':''" @click="changeTile(index)">{{ item }}</li>
                    </ul>
                </div>
                <div v-else>
                    <img class="goback " src="https://imga.hnhcyy.com/fed/b2b-wechat/goback.png" alt="" @click="goback">
                </div>
            </div>
            <ul v-if="$store.getters.userInfo.currentType === 6" class="show-price">
                <li>
                    <span>{{ goodsInfo.preSale ? '预售价': '报团价' }}</span>
                    <div>¥ {{ (goodsInfo.price||0).toFixed(2) }}</div>
                </li>
                <li>
                    <span>建议出货价</span>
                    <div>¥ {{ (goodsInfo.exportPrice || 0).toFixed(2) }}</div>
                </li>
                <li>
                    <span>建议零售价</span>
                    <div>¥ {{ (goodsInfo.retailPrice || 0).toFixed(2) }}</div>
                </li>
            </ul>
            <ul v-else class="show-price">
                <li>
                    <span>抱团价</span>
                    <div>¥ {{ (goodsInfo.price||0).toFixed(2) }}</div>
                </li>
                <li>
                    <span>建议零售价</span>
                    <div>{{ (goodsInfo.retailPrice || 0).toFixed(2) }}</div>
                </li>
                <li>
                    <span>赚</span>
                    <div>¥ {{ ((goodsInfo.retailPrice * goodsInfo.grossProfit) || 0).toFixed(2) }}</div>
                </li>
                <li>
                    <span>毛利率</span>
                    <div>¥ {{ ((goodsInfo.grossProfit * 100) || 0).toFixed(2) }}%</div>
                </li>
            </ul>
            
            <div class="goods-info-box">
                <div v-if="goodsInfo.activityTimer.length" class="row-8">
                    <div style="margin-left: 0.1rem;">距活动结束剩</div>
                    <van-count-down :time="goodsInfo.activityTime">
                        <template v-slot="timeData">
                            <span class="time">{{ timeData.days > 9 ? timeData.days : '0'+timeData.days }}</span>天
                            <span class="time">{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}</span>小时
                            <span class="time">{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}</span>分
                            <span class="time">{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}</span>秒
                        </template>
                    </van-count-down>
                </div>
                <div v-else-if="goodsInfo.isNew" class="row-8">
                    <div>新品倒计时</div>
                    <van-count-down :time="goodsInfo.newGoodsTime">
                        <template v-slot="timeData">
                            <span class="time">{{ timeData.days > 9 ? timeData.days : '0'+timeData.days }}</span>天
                            <span class="time">{{ timeData.hours > 9 ? timeData.hours : '0'+timeData.hours }}</span>小时
                            <span class="time">{{ timeData.minutes > 9 ? timeData.minutes : '0'+timeData.minutes }}</span>分
                            <span class="time">{{ timeData.seconds > 9 ? timeData.seconds : '0'+timeData.seconds }}</span>秒
                        </template>
                    </van-count-down>
                </div>
                <!-- <div class="sell-goods-num row row-3">
                    <div class="price">
                        <div v-if="goodsInfo.preSale" class="pre-sale-box">预售价</div>
                        <div class="note">
                            ￥<span class="goods-price">{{ (goodsInfo.price||0).toFixed(2) }}</span>
                        </div>
                    </div>                
                    <div class="num">
                        <span>数量：</span>
                        <van-stepper 
                            v-model="goodsInfo.quantity" 
                            integer 
                            :min="goodsInfo.minNum" 
                            :max="goodsInfo.stock > 0 ? (goodsInfo.maxNum < goodsInfo.stock ? goodsInfo.maxNum : goodsInfo.stock) : goodsInfo.maxNum" 
                            :step="goodsInfo.step" 
                            @blur="changeNum" 
                        />
                    </div>
                </div> -->
                <div v-if="goodsInfo.preSale" class="pre-sell-info">
                    <template v-if="goodsInfo.preSaleStock > 0">
                        <span v-if="goodsInfo.preSaleDeliveryTimeStr">
                            预计发货时间<span class="send-time">{{ goodsInfo.preSaleDeliveryTimeStr }} </span>
                        </span>
                        <span v-else>发货时间待定</span>
                    </template>
                    <template v-else>
                        <span class="send-time-1">本期预售已完毕</span>
                    </template>
                </div>
                <div v-if="goodsInfo.stock <= 0" class="pre-sell-info">
                    预计到货时间
                    <span class="send-time">{{ goodsInfo.arrivalTimeStr ? (goodsInfo.arrivalTimeIsOverdue ? '待定' : goodsInfo.arrivalTimeStr) : '待定' }}</span>
                </div>
                <div class="goods-name">
                    {{ goodsInfo.commodityName }}
                    <img v-if="goodsInfo.prescriptionClass==='甲类OTC'" class="labelList" src="@/assets/images/detail_otc.png" alt="" style="width:.72rem;">
                    <img v-if="goodsInfo.prescriptionClass==='乙类OTC'" class="labelList" src="@/assets/images/detail_otc_gn.png" alt="" style="width:.72rem;">
                    <img v-if="goodsInfo.prescriptionClass==='处方药'" class="labelList" src="@/assets/images/details_rx.png" alt="" style="width:.48rem;"> 
                    <img v-if="goodsInfo.consistencyEvaluation!==0" class="labelList" src="@/assets/images/detail_zy.png" alt="" style="width:.72rem;"> 
                    <img v-if="goodsInfo.medicalInsuranceSid !== 0" class="labelList" src="@/assets/images/detail_yb.png" alt="" style="width:.48rem;">              
                </div>
                
                <div class="row goods-tips">
                    <div v-if="goodsInfo.purchased" class="icons icons-yc">近期已采</div>
                    <div v-if="goodsInfo.huddle == 1" class="icons icons-bt">抱团</div>
                    <div v-if="goodsInfo.isNew" class="icons icons-xp">新品</div>
                    <div v-if="goodsInfo.expireStatus !== 0" class="icons icons-jxq">近效期</div>
                </div>

                <!-- 卖点 -->
                <div v-if="goodsInfo.firstSellPoint" class="row-9">
                    <p v-if="goodsInfo.firstSellPoint" class="sale-point">{{ goodsInfo.firstSellPoint }}</p>
                    <p v-if="goodsInfo.secondSellPoint" class="sale-point">{{ goodsInfo.secondSellPoint }}</p>
                </div>
               
                <!-- <div v-if="$store.getters.userInfo.currentType === 6" class="row row-4">
                    <div v-if="goodsInfo.retailPrice - goodsInfo.price > 0" class="row-4-1">
                        <div class="row-4-price">建议出货价</div>
                        <div class="row-4-2">
                            <span>￥</span>
                            {{ (goodsInfo.exportPrice || 0).toFixed(2) }}
                        </div>
                    </div>
                    <div class="line-1" />
                    <div class="row-4-1">
                        <div class="row-4-price">建议零售价</div>
                        <div class="row-4-2">
                            <span>￥</span>
                            <span>{{ (goodsInfo.retailPrice || 0).toFixed(2) }}</span>
                        </div>
                    </div>
                </div>              
                <div v-else class="row row-4">
                    <div class="row-4-1">
                        <div class="row-4-price">建议零售价</div>
                        <div class="row-4-2">
                            <span>￥</span>
                            <span>{{ (goodsInfo.retailPrice || 0).toFixed(2) }}</span>
                        </div>
                    </div>
                    <div class="line-1" />
                    <div v-if="goodsInfo.retailPrice - goodsInfo.price > 0" class="row-4-1">
                        <div class="row-4-price">赚</div>
                        <div class="row-4-2">
                            <span>￥</span>
                            {{ ((goodsInfo.retailPrice * goodsInfo.grossProfit) || 0).toFixed(2) }}
                        </div>
                    </div>
                    <div class="line-1" />
                    <div class="row-4-1">
                        <div class="row-4-price">毛利率</div>
                        <div class="row-4-2">{{ ((goodsInfo.grossProfit * 100) || 0).toFixed(2) }}%</div>
                    </div>
                </div> -->
            </div>

            <div v-if="couponsList.length > 0||goodsInfo.activityList.length!==0" class="activity">
                <div class="good-title">
                    <div class="line" />
                    <div>促销</div>
                </div>
                <div class="row-2">
                    <div v-if="couponsList.length>0" class="couponList" @click="showCoupon">
                        <div class="custom-title">优惠券</div>
                        <div class="row">
                            <div class="row" style="height:0.4rem;">
                                <div class="cou-price">
                                    ￥{{ couponsList[0].promotionCouponsRule.discount }}
                                </div>
                                <div class="cou-info hidden3">
                                    {{ couponsList[0].description }}
                                </div>
                            </div>
                            <div class="use-cou row">领券 <van-icon name="arrow" /> </div>
                        </div>
                    </div>
                    <div v-if="goodsInfo.activityList.length!==0">
                        <div v-for="(item, index) in goodsInfo.activityList" :key="index" class="col">
                            <div class="activity-title">
                                <div class="type-name">{{ item.promotionRule.typeName }}</div>
                            </div>
                            <div class="activity-name">{{ item.name }}</div>
                        </div>
                    </div>
                    
                </div>
            </div>

            <div v-for="(item, index) in goodsInfo.activityList" :key="index">
                <div v-if="[2,3,4].indexOf(item.activityType)>-1" class="package-box">
                    <div class="good-title row">
                        <div class="row">
                            <div class="line" />
                            <div>{{ item.promotionRule.typeName }}</div>
                        </div>
                        <div class="arrow-text" @click="openGood(item)">
                            <van-icon :name="item.isOpenGood?'arrow-down':'arrow-up'" />
                        </div>
                    </div>
                    <div class="goods-info">{{ item.name }}</div>
                    <div v-show="item.isOpenGood">
                        <div class="price-box">
                            <div class="package-info">
                                <div>套餐价:</div>
                                <div class="price">
                                    <span>¥</span>
                                    <span>{{ (item.totalPrice||0 ).toFixed(2) }}</span>
                                    <div v-if="item.originalPrice" class="original-price">¥<s>{{ item.originalPrice }}</s></div>
                                </div>
                            </div>
                            <stepper-number
                                source="h5"
                                :item="item"
                                :activity-type="item.activityType"
                            />
                            <div class="btn-box">
                                <add-to-cart :item="item" :activity-type="item.activityType" />
                            </div>
                        </div>
                        <div class="product-title">套餐商品</div>
                        <div v-for="(items, aindex) in item.promotionProduct" :key="aindex" class="pkg-box">
                            <div class="pkg-box-item">
                                <div class="col-1 col">
                                    <div class="row-1">
                                        <image-load
                                            :is-product-img="true"
                                            default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                            :original-image="items.mainImg"
                                            :sid="items.proSid"
                                            :item="items"
                                        />
                                    </div>
                                </div>
                                <div class="col-2 col">
                                    <div class="row row-1">
                                        <span>{{ items.productName }}</span>
                                    </div>
                                    <div class="row row-2">{{ items.spec }}</div>
                                    <div class="row row-4">{{ items.manufacturer }}</div>
                                    <div v-if="items.expireDateStr != null" class="row-3">
                                        <span>效期优于 </span>
                                        {{ items.expireDateStr }}
                                    </div>
                                </div>
                                <div class="col-3 col">
                                    <div class="row-1  row">
                                        <span>×</span>
                                        <span>{{ items.proReachNum }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>                  
                        <div v-if="item.promotionGifts.length>0" class="product-title">赠品</div>
                        <div class="gift-box">
                            <div v-for="(gift, bindex) in item.promotionGifts" :key="bindex" class="gift-list">                           
                                <image-load
                                    :is-product-img="true"
                                    class="img-box"
                                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                    :original-image="gift.mainImg"
                                    :sid="gift.proSid"
                                    :item="gift"
                                />
                                <div class="gift-info">
                                    <div class="floor-1">
                                        <div class="brand">赠品</div>
                                        <span>{{ gift.commodityName }}</span>
                                    </div>  
                                    <div class="floor-2">
                                        <div class="spec">{{ gift.spec }}</div>
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
            
            <div v-if="attrList.length != 0" class="goods-info-box-1">
                <div class="good-title">
                    <div class="line" />
                    <div>规格参数</div>
                </div>
                <div class="attr-box">
                    <div v-for="(item, index) in attrList" :key="index" class="info-row">
                        <div class="info-row-name">
                            {{ item.name }}
                        </div>
                        <div v-if="item.name == '库存'" class="info-row-content">{{ item.value > 1000 ? '>1000' : item.value }}</div>
                        <div v-else class="info-row-content">{{ item.value }}</div>
                    </div>
                </div>
            </div>

            <div v-if="goodsInfo.relationList && goodsInfo.relationList.length" class="relation-box">
                <div class="good-title  recommed-box">
                    <div class="row">
                        <div class="line" />
                        <div>相关推荐</div>
                    </div>
                    <div class="more" @click="getmore">
                        <div class="row"><span>更多</span><van-icon name="arrow" /></div>
                    </div>
                </div>
                <div class="floor-2">
                    <van-swipe :indicator-color="'#ED3129'" :width="340" :loop="false">
                        <van-swipe-item v-for="aindex in Math.ceil(goodsInfo.relationList.length / 2)" :key="aindex">
                            <template v-for="(item, bindex) in goodsInfo.relationList">
                                <div v-if="(aindex-1) * 2 <= bindex && bindex < aindex * 2" :key="bindex" class="goods-box">
                                    <div class="row-1" @click="goDetail(item.targetProductSid)">
                                        <image-load
                                            :is-product-img="true"
                                            default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                            :original-image="item.mainImg"
                                            :item="item"
                                        />
                                    </div>
                                    <div class="row-2">
                                        <div class="goodname">
                                            <div class="name1 hidden3">{{ item.commodityName }}</div>
                                        </div>
                                        <div class="price">￥<span>{{ item.price }}</span></div>
                                    </div>
                                </div>
                            </template>
                        </van-swipe-item>
                    </van-swipe>
                </div>
            </div>
            <div id="_2" />
            <div class="goods-detail-box">
                <div class="good-title">
                    <div class="line" />
                    <div>商品详情</div>
                </div>
                <div v-if="goodsInfo.details!==''" class="detail-info">
                    <div v-html="goodsInfo.details" />
                </div>
                <div v-else class="detail-info detail-info-good">
                    <img class="labelList" src="@/assets/images/no_detail.png" alt="" style="width:4.82rem;">
                    <p>暂无商品详情！</p>
                </div>
            </div>
            <template v-if="goodsInfo.manual">
                <div id="_3" />
                <div class="goods-detail-box">
                    <div class="good-title">
                        <div class="line" />
                        <div>说明书</div>
                    </div>
                    <div class="detail-info">
                        <div v-html="goodsInfo.manual" />
                    </div>
                    <!-- <div v-else class="detail-info detail-info-good">
                        <img class="labelList" src="@/assets/images/no_detail.png" alt="" style="width:4.82rem;">
                        <p>暂无说明书！</p>
                    </div> -->
                </div>
            </template>
            <div class="add-cart-box">
                <div class="cart-icon-box" @click="goCart">
                    <div class="buy-car-box">
                        <van-icon class-prefix="iconfont icon-gouwuche-detail" />
                        <div class="good-car">购物车</div>
                        <div class="num">{{ cartNums }}</div>
                    </div>
                </div>
                <add-to-cart
                    :item="goodsInfo"
                    theme="productDetail"
                />
                
            </div>
        </div>

        <!-- 优惠券弹窗 -->
        <van-action-sheet v-model="show" :round="false" title="优惠券" class="detail-coupon-sheet">
            <coupon-box v-for="(item, index) in couponsList" :key="index" :coupon="item" :is-detail="true" />
        </van-action-sheet>
    </div>
</template>

<script>
import Api from '@/api/product/detail'
import StepperNumber from '@/components/stepperNumber/index';
import addToCart from '@/components/addToCart/index'
import imageLoad from '@/components/imageLoad/index'
import couponBox from '@/components/couponDetail/index'
import { Toast, Dialog, ImagePreview } from 'vant'

export default {
    name: 'Detail',
    components: {
        imageLoad,
        addToCart,
        couponBox,
        StepperNumber
    },
    data() {
        return {
            isFixed: false,
            goodsInfo: null,
            goodsBannerList: [],
            attrList: [],
            show: false,
            couponsList: [],
            showPreSaleTips: false,
            isShowVideo: false,
            videoSrc: '',
            current: 0,
            videoStroge: '',
            titleBox: ['基础信息', '商品详情'],
            title: 1
        }
    },
    computed: {
        cartNums: function(){
            return this.$store.getters.cartNum
        },
        userInfoScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.userInfoScope : [];
        },
        currentClub: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : null
        }
    },
    beforeCreate() {
        Toast.loading({
            message: '加载中...',
            forbidClick: true,
            duration: 0
        })
    },
    mounted() {
        window.addEventListener('scroll', this.handleScroll, true)
        this.loadGoodsInfo()
        this.$store.commit('setCartNum');
    },
    beforeDestroy() {
        window.removeEventListener('scroll', this.handleScroll, true)
    },
    methods: {
        handleScroll() {
            var scrollTop = document.documentElement.scrollTop || document.body.scrollTop
            this.isFixed = scrollTop > 0
        },
        changeTile(index){
            this.title = index + 1
            document.querySelector("#" +  '_' + this.title).scrollIntoView(true)
        },
        openGood(item){
            item.isOpenGood = !item.isOpenGood;
        },
        loadGoodsInfo() {
            Api.fetchGoods(this.$route.params.sid).then((res) => {
                const data = res.data.data;
                const timestamp = res.data.timestamp;
                if (!data){
                    Toast.clear()
                    Toast.fail("暂无商品")
                    setTimeout(() => {
                        if (this.$route.query.isAlive === '1'){
                            this.$router.push('/')
                        } else {
                            this.$router.back(-1)
                        }
                    }, 1000)
                } else {
                    this.titleBox = data.manual ? ['基础信息', '商品详情', '说明书'] : ['基础信息', '商品详情']
                    data.quantity = data.minNum
                    // data.quantity = data.minNum < data.stock ? data.minNum : data.stock
                    const currentTime = Date.parse(new Date(timestamp))
                    if (data.isNew) {
                        const newEndTime = Date.parse(data.newEndTime.replace(/-/g, "/"))
                        data.newGoodsTime = newEndTime - currentTime
                    }
                    // 活动倒计时
                    data.activityTimer = [];
                    data.activityList = data.activityList || [];
                    data.activityList.forEach(v => {
                        v.isOpenGood = true
                        if ((v.activityType === 1 || v.activityType === 3) && v.activityTimeDisplay === true) {
                            data.activityTimer.push(v);
                        }
                        if ([2, 4].indexOf(v.activityType - 0) > -1) this.$set(v, 'packageQuantity', 1);
                    })
                    if (data.activityTimer.length) {
                        const activityTime = Date.parse(data.activityTimer[0].endTime.replace(/-/g, "/"))
                        data.activityTime = activityTime - currentTime
                    }
                    this.goodsInfo = data || {}
                    data.imgList.forEach(img => {
                        if (img.imgUrl.indexOf('.mp4') === -1){
                            this.goodsBannerList.push(img)
                        } else {
                            this.videoStroge = this.$store.getters.userInfo.oss + img.imgUrl
                        }
                    })
                    this.couponsList = data.couponsList || []
                    this.attrList = data.attrList || []
                    Toast.clear()
                }
            }).catch((res) => {
                Toast.clear()
            })
        },
        changeNum(){
            this.goodsInfo.quantity = Math.ceil(this.goodsInfo.quantity / this.goodsInfo.step) * this.goodsInfo.step
        },
        goDetail(sid) {
            this.$router.push(`/product/detail/${sid}`)
        },
        /**
         * 展示优惠券
         */
        showCoupon(){
            this.show = true
        },
        /**
         * 预览图片
         */
        preViewImg(item, idx){
            const imgArr = []
            item.forEach(img => {
                imgArr.push(this.$store.getters.userInfo.oss + img.imgUrl + `?x-oss-process=image/resize,w_800/watermark,image_ZmVkL2IyYi1jb21tb24vc3lfODAweDgwMC5wbmc=,t_100`)
            })
            ImagePreview({ images: imgArr, className: 'preViewImg', startPosition: idx })
        },
        goCart(){
            this.$router.push('/cart/index?comeFrom=detail')
        },
        goback() {
            if (this.$route.query.isAlive === '1'){
                this.$router.push('/')
            } else {
                this.$router.go(-1)
            }
        },
        // 相关推荐
        getmore(){
            const relationList = [];
            this.goodsInfo.relationList.forEach(v => {
                relationList.push(v.productInfo);
            })
            localStorage.setItem('relationList', JSON.stringify(relationList));
            this.$router.push('/product/recom-goods')
        },
        /**
         * 展示视频
         */
        showVideo(e){
            window.event ? window.event.cancelBubble = true : e.stopPropagation();
            if (this.isWifi()){
                this.isShowVideo = true
                this.$refs['swiperRef'].swipeTo(0)
                if (this.videoSrc === ''){
                    this.videoSrc = this.videoStroge
                }
            } else {
                Dialog.confirm({
                    message: '当前为运营商网络, 继续播放将消耗流量',
                    confirmButtonText: '继续播放',
                    cancelButtonText: '停止播放',
                    className: 'isWifi',
                    getContainer: '.Page-index-detail'
                }).then(() => {
                    this.isShowVideo = true
                    this.$refs['swiperRef'].swipeTo(0)
                    if (this.videoSrc === ''){
                        this.videoSrc = this.videoStroge
                    }
                }).catch(() => {
                    // on cancel
                    return false
                });
            }
        },
        // 判断是否wifi环境
        isWifi() {
            try {
                let wifi = true
                const ua = window.navigator.userAgent
                const con = window.navigator.connection
                // 如果是微信
                if (/MicroMessenger/.test(ua)) {
                    if (ua.indexOf('WIFI') >= 0) {
                        return true;
                    } else {
                        wifi = false
                    }
                    // 如果支持navigator.connection
                } else if (con) {
                    const network = con.type
                    if (network !== 'wifi' && network !== '2' && network !== 'unknown') {
                        wifi = false
                    }
                }
                return wifi
            } catch (e) {
                return false
            }
        },
        /**
         * 切换轮播图
         */
        changeSwipe(e){
            this.current = e;
            if (e === 0 && this.videoSrc !== ''){
                this.isShowVideo = true
                setTimeout(() => {
                    document.getElementById('videoContent-show') && document.getElementById('videoContent-show').play()
                }, 1)
            } else {
                document.getElementById('videoContent-show') && document.getElementById('videoContent-show').pause()
                this.isShowVideo = false
            }
        },
        /**
         * 关闭视频
         */
        closeVideo(e){
            window.event ? window.event.cancelBubble = true : e.stopPropagation();
            document.getElementById('videoContent-show') && document.getElementById('videoContent-show').pause()
            document.getElementById('videoContent-show').currentTime = 0
            this.isShowVideo = false
            this.videoSrc = ''
        },
        /**
         * 无经营范围
         */
        isUnScope() {
            if (this.goodsInfo.businessScope || this.goodsInfo.businessScope === 0) {
                const data = this.userInfoScope.filter(v => v.isMain === 1)[0];
                return (data.scopeSidSet || []).indexOf(this.goodsInfo.businessScope) === -1;
            } else {
                return false;
            }
        }
    }

}
</script>

<style lang="scss">
.jxq .van-dialog__message{
    color: #666666!important;
}
.package-dialog{
    .van-dialog__header{
        padding: .4rem 0 .3rem 0!important;
        span{
            font-size: .32rem;
            font-weight: 600;
        }
    }
    .van-icon-cross{
        position: absolute;
        top: 10px;
        right: 10px;
    }
    .van-dialog__content{
        margin:0 .2rem .8rem .2rem;
    }
    .van-dialog__confirm{
        background-color: #ed3129;
    }
    .content{
        display: flex;
        align-items: center;
        img{
            width: .32rem;
            height: .34rem;
            margin-right: .14rem;
        }
    }
}
.Page-index-detail {
    background: #eee;
    padding-bottom:.9rem;
    // box-sizing: border-box;
    .num{
        .van-stepper__input{
            height: .6rem;
            line-height: .6rem;
        }
    }
    .fixed-title{
        position: fixed;
        top: 0;
        left: 0;
        height: 0.68rem;
        width: 100%;
        background: #FF4646;
        display: flex;
        align-items: center;
        z-index: 111;
        padding: 0 0.26rem;
        box-sizing: border-box;
        animation: reback .2s ease-in forwards;
        ul{
            display: flex;
            width: 98%;
            justify-content: space-around;
            font-size: 0.32rem;
            color: #fff;
            li{
                position: relative;
            }
            li.active::after{
                content: "";
                width: .36rem;
                height: .04rem;
                background: #FFFFFF;
                border-radius: .04rem;
                position: absolute;
                bottom: -.04rem;
                left: 0;
                right: 0;
                margin: auto;
            }
        }
    }
    @keyframes reback {
        0%{
            top: -.3rem;
        }
        100% {
            top: 0;
        }
    }
    .van-swipe__indicator{
        width: .22rem;
        height: .08rem;
        background: #FF4646;
        box-shadow: 0 0 .08rem 0 rgba(237,49,41,0.14);
        border-radius: .06rem;
    }
    .van-dialog{
        &.isWifi{
            .van-dialog__cancel{
                color: #333;
            }
            .van-dialog__confirm{
                background: #ed3129;
                color: #ffffff;
            }
        }
    }
    .detail-coupon-sheet{
        z-index: 2019 !important;
        background: #f6f6f6;
        .van-action-sheet__content{
            height:6.84rem;
            overflow: auto;
        }
    }
    .hidden3 {
        text-overflow: ellipsis;
        overflow: hidden;
        word-break: break-all;
        white-space: nowrap;
    }
    .label-box{
        position: absolute;
        bottom: 0.18rem;
        left: 0.4rem;
        width: 5.1rem;
        display: flex;
        flex-wrap:wrap-reverse;
        img{
            width: 1.36rem;
            height: 0.5rem;
            margin-right: 0.2rem;
            margin-bottom: 0.22rem;
        }
    }
    .goods-tips {
        display: flex;
        .icons {
            width: 1.12rem;
            height: .4rem;
            line-height: .4rem;
            text-align: center;
            margin-right: 0.16rem;
            border-radius: .2rem;
            font-size: 0.2rem;
            margin-bottom: 0.2rem;
            &.icons-jxq {
                color: #FFFFFF;
                background:#FF7768;
            }
            &.icons-yc {
                color: #FF9A38;
                background: #FFF3E7;
            }
            &.icons-bt {
                color: #FF928D;
                background: #FFF2F1;
            }
            &.icons-xp{
                color: #13A9FF;
                background: #E8FBFF;
            }
    }
}
    .swiperBox {
        width: 100%;
        height:7.5rem;
        position: relative;
        .video-box{
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            top: 0;
            margin: auto;
            z-index: 99;
            width: 1.08rem;
            height: 1.08rem;
            img{
                height: 100%;
                width: 100%;
            }
        }
        .video-box-1{
           position: absolute;
            bottom: 1.64rem;
            left: 0;
            right: 0;
            margin: auto;
            z-index: 99;
            width: 1.46rem;
            height: .52rem;
            background-color:rgba(0,0,0,0.4);      
            border-radius: .26rem;
            display: flex;
            align-items: center;
            .van-icon{
                font-size: .52rem;
                color: #ffffff;
                margin-right: .08rem;
                display: block;
            }
            span{
                color: #ffffff;
                font-size: .28rem;
                display: block;
            } 
        }
        #videoContent{
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }
        #videoContent-show{
            position: absolute;
            top: 0;
            left: 0;
            width: 7.5rem;
            height: 7.5rem;
            background: black;
            z-index: 8;
        }
        .closeVideo{
            position: absolute;
            left: .8rem;
            top: .58rem;
            font-size: .5rem;
            color: #fff;
            z-index: 9;
        }

        .van-swipe {
            height:7.5rem;
            .van-image{
                width: 100%;
                height: 100%;
            }
            .slide-image {
                width: 100%;
                height: 100%;
                img {
                    width: 100%;
                    height: 5.8rem;
                }
            }
            .custom-indicator {
                position: absolute;
                right: .4rem;
                bottom: .4rem;
                padding: 0.08rem .18rem;
                font-size: .24rem;
                background: rgba(0, 0, 0, 0.5);
                border-radius: .24rem;
                color: #fff;
            }
        }

        .sold-out {
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            margin: auto;
            width: 2.4rem;
            height:2.4rem;
            .slide-image {
                width: 100%;
                height: 100%;
                img {
                    width: 100%;
                    height: 100%;
                }
            }
        }
        .goback {
            position: absolute;
            top: 0.6rem;
            left: 0.2rem;
            color: #797979;
            font-size: 0.48rem;
            width: 0.48rem;
            height: 0.48rem;
            z-index: 9;
        }
    }
    // .sell-goods-num{
    //     margin-bottom: 0.24rem;
    // }
    .recommed-box{
        display: flex;
        align-items: center;
        justify-content: space-between;
        .more{
          color: #BBBBBB;
          font-size: 0.26rem;
        }
    }
    .good-title{
        font-size: 0.32rem;
        font-weight: 600;
        color: #333333;
        display: flex;
        align-items: center;
        .line{
            width: .06rem;
            height: .28rem;
            background: linear-gradient(180deg, #ED3129 0%, #FFBBB5 100%);
            border-radius: .04rem;
            margin-right: 0.12rem;
        }
    }
    .row {
        display: flex;
        align-items: center;
    }
    .row-3 {
        justify-content: space-between;
        .price {
            color: #ed3129;
            font-size: 0.48rem;
            padding-right: 0.2rem;
            display: flex;
            align-items:center;
             .pre-sale-box{
                width: 1.12rem;
                height: .60rem;
                background: #FF3C3C;
                border-radius: .38rem;
                font-size: 0.26rem;
                color: #fff;
                line-height: 0.6rem;
                text-align: center;
                font-weight: normal;
                margin-right: 0.16rem;
            }
            .note{
                font-size: 0.4rem;
            }
            .goods-price{
                font-weight: 600;
                font-size: 0.48rem;
            }
        }
        .num{
            display: flex;
            align-items: center;
            >span{
                font-size: 0.32rem;
                color: #666;
            }
        }
    }
    .show-price{
        display: flex;
        align-items: center;
        height: 1.2rem;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/detail-price-bg.png') no-repeat;
        background-size: 100% auto;
        li{
            position: relative;
            box-sizing: border-box;
            width: 1.7rem;
            padding: 0 .2rem;
            text-align: center;
            color: #ffffff;
            span{
                line-height: .36rem;
            }
            div{
                line-height: .4rem;
            }
            &:after{
                position: absolute;
                right: 0;
                top: 50%;
                margin-top: -.2rem;
                width: .02rem;
                height: .4rem;
                background: #ffffff;
                opacity: .2;
                content: '';
            }
        }
        >:nth-child(1){
            flex: 1;
            text-align: left;
            div{
                line-height: .56rem;
                font-size: .4rem;
            }
        }
    } 
    .goods-info-box {
        background: #fff;
        padding: 0.4rem 0.4rem 0.36rem 0.4rem;
        line-height: 1;
        .pre-sell-info{
            color:#888888;
            font-size: 0.28rem;
            margin-bottom: 0.24rem;
            .pre-no-stock{
                width: 1.28rem;
                height: .40rem;
                line-height: 0.4rem;
                background: #FFF2F1;
                color: #ED3129;
                border-radius: .08rem;
                font-size: 0.26rem;
                display: inline-block;
                text-align: center;
            }
            .send-time{
              color: #ED3129;
              margin-left: 0.12rem;
            }
            .send-time-1{
              color: #ED3129;
            }
        }    
        .goods-name {
            font-size: 0.36rem;
            font-weight: 700;
            margin-bottom: 0.24rem;
        }
        .labelList {
            vertical-align: middle;
        }        
        .row-1 {
            font-size: 0.28rem;
            color: #ed3129;
            display: flex;
            flex-direction: column;
            line-height: 1;
            align-items: flex-start;
            .sale-point-1 {
                padding-bottom: 0.08rem;
            }
        }

        .row-2 {
            margin-top: 0.12rem;
            background: #666666;
            font-size: 0.24rem;
            color: #fff;
            padding: 0.04rem 0.12rem;
        }

        .row-4 {
            margin-top: 0.24rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            .line-1{
                width: .02rem;
                height: .42rem;
                background: #EEEEEE;
            }
            .row-4-1{
                width: 33.33333%;
                text-align: center;
                font-size: 0.28rem;
                .row-4-price{
                  color: #999999;
                  margin-bottom: 0.08rem;
                }
                .row-4-2{
                    color: #ED3129;
                }
            }
            .row-4-1:first-child{
                text-align: left;
            }
             .row-4-1:last-child{
                 text-align: right;
                 border-right: none;
             }
        }

        .row-5 {
            font-size: 0.32rem;
            color: #333333;
            span{
                color: #ed3129;
                font-size: .24rem;
            }

            .van-stepper{
                display: flex;
                align-items: center;
                margin-left: 0.2rem;
                .van-stepper__minus:before, .van-stepper__plus:before,.van-stepper__minus::after, .van-stepper__plus::after{
                    display: none;
                }
                .van-stepper__minus{
                    background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-min.png?v=1') 50% 50% no-repeat;
                    background-size: contain;
                }
                .van-stepper__plus{
                    background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon-plus.png?v=1') 50% 50% no-repeat;
                    background-size: contain;
                }
            }
        }
        .row-8 {
            background: #FF3C3C;
            border-radius: 0.38rem;
            height: 0.76rem;
            margin-bottom: 0.24rem;
            font-size: 0.28rem;
            color: #fff;
            display: flex;
            align-items: center;
            padding: 0 0.1rem;
            box-sizing: border-box;
            justify-content: space-between;
            .van-count-down{
                color: #fff;
            }
            .time {
                padding: 0.08rem 0.12rem;
                color: #ed3129;
                border-radius: 0.08rem;
                margin: 0 0.08rem;
                background: #fff;
                font-size: 0.28rem;
                box-sizing: border-box;
            }
        }
        .row-9{
            background-image: url('../../../assets/images/sell-info.png');
            background-repeat: no-repeat;
            background-size: 100% 100%;
            padding:0.22rem;
            box-sizing: border-box;
            .sale-point{
                line-height: 0.34rem;
                font-size: 0.24rem;
                margin-bottom: 0.16rem;
                color: #666666;
            }
            .sale-point:last-child{
                margin-bottom: 0;
            }
        }
    }

    .goods-info-box-1 {
        margin-top: 0.24rem;
        padding:.4rem;
        background: #fff;
        .attr-box{
            margin-top: 0.28rem;
            border: .02rem solid #EEEEEE;
        }
        .info-row {
            display: flex;
            // align-items: center;
            font-size: 0.28rem;
            // line-height: .7rem;
            border-bottom: 0.02rem solid #eeeeee;
            box-sizing: border-box;
            color: #666666;
            &:last-child{
                border-bottom: none;
            }
            .info-row-name {
                text-align: justify;
                text-align-last: justify;
                color: #999999;
                padding: 0.2rem;
                width: 1.58rem;
                border-right: 0.02rem solid #eeeeee;
            }
            .info-row-content{
                width: 5.1rem;
                box-sizing: border-box;
                padding: 0.2rem;
            }
        }
    }

    .activity {
        color: #333333;
        font-size: 0.32rem;
        margin-top: 0.2rem;
        background: #fff;
        line-height: 1;
        padding: 0.4rem 0.4rem 0.12rem 0.4rem;
        .row-1 {
            width: 1rem;
            font-size: .28rem;
            color: #666666;
        }
        .row-2 {
            margin-top: 0.28rem;
            .col {
                padding-bottom: 0.28rem;
                overflow: hidden;
                .activity-title {
                    float: left;
                    width: 1.8rem;
                    .type-name{
                        display: inline-block;
                        height: 0.48rem;
                        line-height: 0.48rem;
                        border-radius: 0.24rem;
                        border: 0.02rem solid #ED3129;
                        font-size: 0.24rem;
                        color: #ED3129;
                        overflow: hidden;
                        padding: 0 0.16rem;
                        box-sizing: border-box;  
                        font-weight: 600;
                    }
                }
                .activity-name {
                    font-size: 0.28rem;
                    width: 4.7rem;
                    margin-left: 0.18rem;
                    text-align:justify;
                    color: #666;
                    float: left;
                    line-height: 0.4rem;
                    padding: 0.06rem 0;
                    box-sizing: border-box;
                }
            }
        }
    }

    .couponList{
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 0.24rem;
        padding-bottom:0.28rem;
        .cou-price{
            background-image:url('../../../assets/images/coupon-bg.png') ;
            background-repeat:no-repeat;
            background-size:100% 100%;
            width:.94rem;
            height: 0.4rem;
            line-height: 0.4rem;
            text-align: center;
            color: #ED3129;
            margin-right: 0.12rem;
        }
        .cou-info{
            width: 2.6rem;
            height: 100%;
            line-height: 0.4rem;
            font-size: 0.24rem;
            color: #666;
        }
        .custom-title{
            font-size: 0.24rem;
            color: #ed3129;
            padding:0.1rem;
            border: 1px solid #ed3129;
            border-radius: 0.24rem;
            // margin-right:1rem;
            width: .96rem;
            box-sizing: border-box; 
            font-weight: 600;
        }
        .use-cou{
            color: #666666;
            font-size: 0.28rem;
            margin-left: 0.2rem;
        }
    }
    .package-box {
        background: #fff;
        margin-top: 0.2rem;
        padding: 0.4rem;
        box-sizing: border-box;
        .good-title{
            margin-bottom: 0.28rem;
            justify-content: space-between;
        }
        .arrow-text{
            color: #999;
        }
        .goods-info{
            font-size: 0.28rem;
            line-height: .4rem;
            color: #666666;
        }
        .price-box{
            background: #FFF0F0;
            border-radius: .12rem;
            margin-top: 0.24rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: .28rem .16rem .24rem .28rem;
            .price{
                font-weight: 500;
                margin-top: 0.08rem;
                span:last-child{
                  font-size: 0.36rem;
                }
            }
            .package-info{
                flex: 1;
                font-size: 0.28rem;
                color: #ED3129;
            }
            .original-price{
                color: #CCCCCC;
            }
        }
        .product-title{
            color: #666666;
            font-size: 0.28rem;
            margin-top: 0.24rem;
            font-weight: 500;
        }
        .pkg-name {
            font-size: 0.28rem;
            color: #666666;
            padding: 0 0.4rem;
        }

        .pkg-box {
            margin-top: 0.24rem;
            .pkg-box-item {
                display: flex;
                align-items: center;
                padding: 0.2rem 0.24rem;
                box-sizing: border-box;
                background: #F6F6F6;
                border-radius: 0.12rem;
                margin-bottom: 0.16rem;
                &:last-child {
                    border: none;
                    margin-bottom: 0;
                }
            }

            .col-1 {
                margin-right: 0.16rem;

                .row-1 {
                    width: 1.48rem;
                    height: 1.48rem;

                    img {
                        width: 100%;
                        height: 100%;
                    }
                }
            }

            .col-2 {
                width: 4rem;
                margin-right: 0.2rem;
                .row-1 {
                    display: flex;
                    align-items: center;

                    span:nth-child(1) {
                        color: #333333;
                        font-size: 0.32rem;
                        max-width: 2.8rem;
                        overflow: hidden;
                        white-space: nowrap;
                        text-overflow: ellipsis;
                    }
                }

                .row-2 {
                    padding-top: 0.06rem;
                    color: #888;
                    font-size: 0.24rem;
                }

                .row-3 {
                    padding-top: 0.08rem;
                    span{
                        color: #888;
                    }
                }

                .row-3,
                .row-4 {
                    color: #333;
                    font-size: 0.24rem;
                    padding-top: 0.08rem;
                }
            }

            .col-3 {
                display: flex;
                align-items: center;
                span:nth-child(1) {
                    color: #999;
                    font-size: 0.38rem;
                }

                span:nth-child(2) {
                    color: #999;
                    font-size: 0.28rem;
                }
            }
        }
        .gift-box{
            margin-top: 0.24rem;
        }
        .gift-list {
            display: flex;
            align-items: center;
            padding: 0.24rem;   
            background: #F6F6F6;
            border-radius: .12rem;
            margin-bottom: 0.24rem;
            box-sizing: border-box;
            &:last-child {
                margin-bottom: 0;
            }
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
                margin-right: 0.1rem;
            }

            .img-box {
                width: 0.6rem;
                height: 0.6rem;
                margin-right: 0.2rem;

                img:not(.has_not_range) {
                    width: 0.6rem;
                    height: 0.6rem;
                    margin-right: 0.2rem;
                }
            }

            .gift-info {
                // width: 4.7rem;
                .spec{
                    width: 4.7rem;
                }
                .floor-1 {
                    display: flex;
                    align-items: center;
                    line-height: 1;
                    padding-bottom: 0.08rem;
                    span:last-child{
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
                        display: flex;
                        align-items: center;
                        margin-left: 0.2rem;
                        span:nth-child(1) {
                            color: #999;
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
    .relation-box {
        margin-top: 0.24rem;
        padding: 0.4rem;
        background: #fff;
        .floor-1 {
            display: flex;
            padding: 0 0.24rem;
            justify-content: space-between;
            font-size: 0.24rem;
            color: rgba(51, 51, 51, 1);
            .title {
                font-weight: 600;
                font-size: 0.36rem;
            }
        }
        .floor-2 {
            .van-swipe{
                height: 4.7rem;
            }
            .van-swipe-item{
                display: flex;
                margin-top: 0.28rem;
            }
            .van-swipe__indicators{
                bottom: 0;
            }
            .van-swipe__indicator{
                background-color: #9e9e9e;
            }
            .goods-box{
                height: 4rem;
                width: 2.8rem;
                background: #F6F6F6;
                border-radius: .12rem;
                margin-right: 0.28rem;
                text-align: center;
                font-size: 0.28rem;
                color: #030303;
                padding: 0 0.2rem;
                box-sizing: border-box;
                .row-2{
                    margin-top: 0.2rem;
                }
                .price{
                   font-size: 0.32rem;
                   margin-top: 0.2rem;
                   color: #ED3129; 
                }
            }
        }
    }

    .recommend-list {
        background: #fff;

        .recommend-title {
            color: #ed3129;
            font-size: 0.36rem;
            line-height: 1;
            padding: 0.28rem 0.2rem 0.08rem 0.2rem;
            font-weight: bold;

            .van-icon {
                position: relative;
                width: 0.44rem;
                height: 0.36rem;
                bottom: -0.04rem;
                margin-right: 0.2rem;
            }
        }

        .recommend-li {
            position: relative;
            padding: 0.2rem;
            display: flex;

            &::before {
                position: absolute;
                content: " ";
                left: 0;
                bottom: 0;
                width: 200%;
                z-index: 1;
                border-top: 1px solid #eaeaea;
                -webkit-transform-origin: 0 0;
                transform-origin: 0 0;
                -webkit-transform: scale(0.5, 0.5);
                transform: scale(0.5, 0.5);
            }

            &:last-child {
                &::before {
                    display: none;
                }
            }

            .item-image {
                float: left;
                width: 1.04rem;
                height: 1.04rem;
                margin-right: 0.2rem;
                img {
                    width: 100%;
                    height: 100%;
                }
            }

            .item-info {
                line-height: 1;

                .row-1 {
                    display: flex;
                    align-items: center;

                    .title {
                        max-width: 3.8rem;
                        color: #030303;
                        font-weight: bold;
                        font-size: 0.32rem;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                        padding-top: 0.08rem;
                    }

                    .label-sj {
                        padding: 0.04rem 0.08rem;
                        top: 0;
                    }
                }

                .row-2 {
                    font-size: 0.24rem;
                    color: #999;
                    padding-bottom: 0.2rem;
                    padding-top: 0.08rem;
                    display: flex;
                    justify-content: space-between;
                    width: 5.5rem;
                    div {
                        font-size: 0.28rem;
                        color: #333333;
                        display: flex;
                        align-items: center;
                        span {
                            font-size: 0.36rem;
                            color: #cccccc;
                        }
                    }
                }

                .row-4 {
                    span {
                        display: inline-block;
                        padding: 0.04rem 0.14rem;
                        font-size: 0.24rem;
                        color: #ffffff;
                        background: #ed3129;
                    }
                }
                .row-5 {
                    color: #666;
                    font-size: 0.28rem;
                }

                .row-5 {
                    padding: 0.08rem 0;
                    max-width: 4rem;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }
            }

            .item-info-1 {
                position: relative;
                text-align: right;
                line-height: 1;

                div:nth-child(2) {
                    padding: 0.5rem 0 0.04rem;
                    font-size: 0.24rem;
                    color: #333333;

                    span {
                        color: #cccccc;
                        padding-right: 0.12rem;
                    }
                }

                div:nth-child(3) {
                    font-size: 0.24rem;
                    color: #ed3129;
                    text-decoration: line-through;
                }
            }
        }
    }

    .goods-detail-box {
        margin-top: 0.24rem;
        background: #fff;
        padding: 0.4rem;
        font-size: 0.28rem;
        .detail-info{
            margin-top: 0.28rem;
        }
        .detail-info-good{
            text-align: center;
            color: #BBBBBB;
            font-size: 0.32rem;
            margin-top: 1.18rem;
            p{
                margin-top: 0.44rem;
            }
        }
        img {
            width: 100%;
            height: 100%;
        }
    }

    .add-cart-box {
        position: fixed;
        bottom: 0;
        width: 100%;
        display: flex;
        align-items: center;
        z-index: 99;
        line-height: 1;
        box-shadow: 0 -0.02rem 0 0 #eee;
        transform: translateZ(0);
        background: #ffffff;
        .cart-icon-box {
            width: 50%;
            font-size: 0.32rem;
            color: #666666;
            height: 0.88rem;
            display: flex;
            align-items: center;
           justify-content: space-around;
            .buy-car-box{
                display: flex;
                align-items: center;
            }
            .num{
                background: #FF4646;
                border-radius: .20rem;
                padding: 0 0.1rem;
                height: 0.4rem;
                line-height: 0.4rem;
                box-sizing: border-box;
                color: #fff;
            }
            .good-car{
                margin: 0 0.24rem;
            }
            i {
                font-size: 0.48rem;
                margin-top: -0.05rem;
            }
        }

        .add-cart {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #FF4646;
            color: #ffffff;
            font-size: 0.36rem;
            padding: 0 0.6rem;
            height: 0.88rem;
            box-sizing: border-box;
        }
        .add-cart-btn-disable{
            // background: #cccccc;
            color: #fff;          
            background: rgba(255, 70, 70, 0.99);
            opacity: 0.2;
        }
        .no-add-cart {
            background: rgba(241, 135, 132, 1);
        }

        .pre-sale-btn{
            width: 4.4rem;
            height: .88rem;
            background: linear-gradient(to right, #F6D17E,#FBC681);
            border-radius: .4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 .4rem;
            color: #774000;
            &.pre-sale-btn-disable{
                background: #cccccc;
                color: #fff;
            }
            .left-text{
                font-size: .2rem;
                width: 1.7rem;
                text-align: center;
                line-height: .28rem;
            }
            .right-text{
                font-size: .36rem;
                font-weight: 600;
            }
        }
    }
    // #preSaleTips{
    //     &.van-dialog{
    //         .van-dialog__header{
    //             color: #333333;
    //             font-size: .32rem;
    //             padding-top: .4rem;
    //             padding-bottom: .32rem;
    //             font-weight: 600;
    //         }
    //         .van-dialog__content{
    //             padding: 0 .3rem .32rem .34rem;
    //             text-align: center;
    //             div:nth-child(1){
    //                 color: #333333;
    //                 font-size: .28rem;
    //                 font-weight: 500;
    //                 padding-bottom: .22rem;
    //             }
    //             div:nth-child(2){
    //                 font-size: .24rem;
    //                 color: #666666;
    //                 font-weight: 500;
    //                 .needToKnow{
    //                     color: #0091FF;
    //                 }
    //             }
    //         }
    //         .van-dialog__footer--buttons{
    //             .van-dialog__cancel{
    //                 color: #999999;
    //                 font-size: .36rem;
    //             }
    //             .van-dialog__confirm{
    //                 background: #ed3129;
    //                 color: #ffffff;
    //                 font-size: .36rem;
    //             }
    //         }
    //     }
    // }
    #preSaleTip{
    &.van-dialog{
        .van-dialog__header{
            color: #666666;
            font-size: .36rem;
            padding-top: .4rem;
            margin-bottom: .4rem;
            font-weight: 600;
        }
        .van-dialog__content{
            padding: 0 .3rem .32rem .34rem;
            div:nth-child(1){
                color: #666666;
                font-size: .32rem;
                padding-bottom: .32rem;
            }
            div:nth-child(2){
                font-size: .28rem;
                color: #888888;
                background: #FBFBFB;
                padding: 0.12rem 0.26rem;
                .needToKnow{
                    color: #ED3129;
                }
            }
        }
        .van-dialog__footer--buttons{
            .van-dialog__cancel{
                color: #999999;
                font-size: .36rem;
            }
            .van-dialog__confirm{
                background: #ed3129;
                color: #ffffff;
                font-size: .36rem;
            }
        }
    }
}
}
</style>
