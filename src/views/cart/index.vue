<template>
    <div class="Page-cart-list" :style="[{'height':winHeight+'px'}]">
        <template v-if="!emptyCart">
            <ul>
                <li v-for="(store, index) in storeList" :key="index" class="store">
                    <div v-if="store.cart.generalProductList.length != 0 || store.cart.packageProductList.length !== 0 || store.cart.groupProductList.length !== 0">
                        <div
                            v-if="$store.getters.userInfo.stores.length > 1"
                            :class="{'close-top': !store.toggleFlag, 'top-guoqi': !store.isGSPExpired && !showCancel, 'top': true}"
                        >
                            <div class="title-top-box">
                                <h5 :class="!store.isGSPExpired && !showCancel ? 'guoqi-h5' : ''">
                                    <template v-if="!showCancel">
                                        <van-checkbox v-model="store.checked" class="is-checked" :disabled="!store.isGSPExpired" @click="selectStore(store)" />
                                    </template>
                                    <template v-else>
                                        <van-checkbox v-model="store.checked" class="is-checked" @click="selectStore(store)" />
                                    </template>
                                    <span class="store-name">{{ store.name }}</span>
                                </h5>
                                <p class="store-total">
                                    <span>抱团小计：<font>￥{{ store.huddleAmount.toFixed(2) }}</font></span>
                                    <span>中药小计：<font>￥{{ store.herbAmount.toFixed(2) }}</font></span>
                                </p>
                                <p class="store-total">
                                    <span>非药小计：<font>￥{{ store.notMedicineAmount.toFixed(2) }}</font></span>
                                </p>
                                <img v-if="!store.isGSPExpired" class="qfy-guoqi" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-zizhiguoqi.png?v=2" alt="">
                            </div>
                            <div class="toggle-btn" @click="toggleStore(store)">
                                {{ store.toggleFlag ? '收起' : '展开' }}<van-icon :name="store.toggleFlag ? 'arrow-up' : 'arrow-down'" />
                            </div>
                        </div>
                        <div v-else :class="['only-one', 'top', {'close-top': !store.toggleFlag, 'top-guoqi': !store.isGSPExpired && !showCancel}]">
                            <div class="title-top-box">
                                <h5 :class="!store.isGSPExpired && !showCancel ? 'guoqi-h5' : ''">
                                    <span class="store-name">{{ store.name }}</span>
                                </h5>
                                <img v-if="!store.isGSPExpired" class="qfy-guoqi" src="@/assets/images/icon-zizhiguoqi.png" alt="">
                            </div>
                        </div>
                        <div
                            v-if="store.restrict"
                            :class="['special-tips', {'close-special-tips': !store.toggleFlag }]"
                        >
                            <div class="special-content">
                                <div class="flex-left">
                                    <img v-if="store.toggleFlag" src="@/assets/images/hi.png" alt="">
                                    <img v-else src="@/assets/images/hi-white.png" alt="">
                                    <span v-if="store.minProductQuantity>0&&store.surplusCount>=store.minProductQuantity">已满 {{ store.minProductQuantity }} 个品种可使用专项款</span>
                                    <span v-else>还需采购 {{ (store.minProductQuantity - store.surplusCount) || 0 }} 个专项品种可使用专项款</span>
                                </div>
                                <span class="goto-special" @click="gotoSelectGoods(store.specialUrl)">{{ store.minProductQuantity>0&&store.surplusCount>=store.minProductQuantity ? '继续选品': '去选品' }}
                                    <img v-if="store.toggleFlag" src="@/assets/images/special-arrow2.png" alt="">
                                    <img v-else src="@/assets/images/special-arrow.png" alt="">
                                </span>
                            </div>
                        </div>
                        <div :class="store.toggleFlag ? 'product-list-box' : 'product-list-box product-list-box-hide'">
                            <!-- 普通商品 -->
                            <ol
                                v-for="(item, aindex) in store.cart.generalProductList"
                                :key="aindex"
                                class="store-content"
                                :style="{paddingBottom: !getMissNum(item) ? '.26rem' : ''}"
                            >
                                <li class="isChecked" :style="item.stock <= 0 || item.isUnScope ? 'opacity: .4': ''">
                                    <van-icon
                                        v-if="showCancel"
                                        class-prefix="btn-remove"
                                        name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png?v=1"
                                        @click="remove(item, 1, index, aindex)"
                                    />
                                    <div v-if="item.activityTypeDesc" class="package-title">
                                        <span>{{ item.activityTypeDesc }}</span>
                                    </div>
                                    <h6 v-if="item.nextPromotionActivityTips || item.promotionTips" class="activity">
                                        <img
                                            v-if="[1, 5 , 6, 8].indexOf(item.activityType-0) > -1"
                                            src="@/assets/images/icon-gift.png"
                                            class="activity-name"
                                        >
                                        <img
                                            v-if="[3, 9].indexOf(item.activityType-0) > -1"
                                            src="@/assets/images/icon-reduce.png"
                                            class="activity-name"
                                        >
                                        <span class="activity-tips">{{ item.nextPromotionActivityTips || item.ladderTips || item.promotionTips }}</span>
                                        <span
                                            v-show="item.isShow"
                                            class="goTogether"
                                            @click="goTogether(item.promotionId)"
                                        >去凑单<img src="@/assets/images/go-together.png" alt=""></span>
                                    </h6>
                                    <div class="product">
                                        <van-checkbox
                                            v-model="item.checked"
                                            :disabled="(item.stock <= 0 || !store.isGSPExpired || item.isUnScope) && !showCancel"
                                            class="is-checked"
                                            @change="selectNormal($event, item, index)"
                                        />
                                        <dl>
                                            <dt>
                                                <image-load
                                                    :is-product-img="true"
                                                    class="product-img"
                                                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                    :sid="item.productSid"
                                                    :original-image="item.imgUrl"
                                                    :item="item"
                                                />
                                                <div class="goods-status">
                                                    <span v-if="item.nearExpire" class="nearExpire">近效期</span>
                                                    <!-- <span v-if="item.understock" class="understock">缺货</span>
                                                    <span v-if="item.unShelve" class="unShelve">已下架</span> -->
                                                </div>
                                            </dt>
                                            <dd>
                                                <p class="product-name">
                                                    <i v-if="item.presell" class="perSaleImg">预售</i><span>{{ item.commodityName }}</span>
                                                </p>
                                                <p class="product-spec">{{ item.spec }}</p>
                                                <p>{{ item.manufacturer }}</p>
                                                <p v-if="item.expireDate != null" class="product-expire-date">效期优于 {{ item.expireDate }}</p>
                                                <p class="activity-icon">
                                                    <img v-if="item.huddle" src="@/assets/images/bt.png" class="product-bt">
                                                    <img v-if="item.herb" src="@/assets/images/zy.png" class="product-zy">
                                                    <!-- <img v-if="item.notMedicine" src="@/assets/images/fy.png" class="product-zy"> -->
                                                    <template v-for="(list, i) in item.labelList"> 
                                                        <p v-if="list.showStatus !== 0 " :key="i">
                                                            <img :src="$store.getters.userInfo.oss + replaceUrl($store.getters.userInfo.oss, list.iconUrl)" alt="">    
                                                        </p>
                                                    </template>
                                                </p>
                                                <p><span class="product-price">￥{{ item.price.toFixed(2) }}</span><span class="origin-price">￥{{ item.retailPrice.toFixed(2) }}</span></p>
                                                
                                            </dd>
                                        </dl>
                                    </div>
                                    <div v-if="item.presell" class="preSaleTime">
                                        <img src="@/assets/images/icon_presale.png">
                                        <span v-if="item.predictShippingDate">此商品为预售商品，预计{{ item.predictShippingDate }}前发货</span>
                                        <span v-else>此商品为预售商品，发货时间待定</span>
                                    </div>
                                    <div v-if="!item.understock && item.promotionLadderList.length" class="giftList-box">
                                        <div class="giftTips">
                                            <span v-if="item.level === -1">不参与活动、不需要赠品</span>
                                            <span v-else-if="item.giftOption != null && item.giftOption > 0 && item.selectGiftOption > 0">您可以选择下列{{ item.giftOption }}种赠品</span>
                                            <span v-else>您可以选择下列赠品</span>
                                            <p
                                                class="replace-gift-btn"
                                                @click="changeGift(item, index, aindex, 'generalProductList')"
                                            >换赠品<img src="@/assets/images/icon_red_down_arrow.png"></p>
                                            
                                        </div>
                                        <div v-for="(gift, i) in item.giftList" :key="i" class="gift-box">
                                            <van-checkbox
                                                v-model="gift.checked"
                                                :disabled="gift.isUnScope||!item.checked || gift.stock < gift.quantity || !store.isGSPExpired || gift.optionType === 2"
                                                class="is-checked"
                                                @change="selectGift($event, item, gift)"
                                                @click="giftClick(gift)"
                                            />
                                            <div style="position:relative">
                                                <img v-if="gift.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                                <image-load
                                                    :is-product-img="true"
                                                    class="img-box"
                                                    default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                    :original-image="gift.giftImg"
                                                    :sid="gift.productSid"
                                                    :item="gift"
                                                />
                                            </div>
                                            <div class="gift-info">
                                                <div class="floor-1">
                                                    <font v-if="gift.expireStatus === 1" color="#FF4646">近效期-</font>
                                                    <span @click="goDetail(gift.productSid)">{{ gift.giftName }}</span>
                                                </div>
                                                <div class="floor-2">
                                                    <div>{{ gift.giftSpec }}</div>
                                                    <span v-if="gift.isUnScope" class="num no-stock">无经营范围</span>
                                                    <span v-else-if="gift.stock < gift.quantity" class="num no-stock">库存不足</span>
                                                    <template v-else>
                                                        <font>×</font>
                                                        <span class="num"> {{ gift.quantity }}</span>
                                                    </template>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="product-bottom">
                                        <span><font>小计</font>￥{{ (item.quantity * item.price).toFixed(2) }}</span>
                                        <stepper-number :item="item" :is-cart="true" :index="index" />
                                    </div>
                                    <div
                                        v-show="getMissNum(item)"
                                        class="rounding-up"
                                    ><img src="@/assets/images/hi.png" alt=""><span>再加购{{ getMissNum(item) }}{{ item.unit }}满整件将优先发货哟</span></div>
                                </li>
                            </ol>
                            <!-- 套餐商品 -->
                            <ol v-for="(item, bindex) in store.cart.packageProductList" :key="bindex" class="package-box">
                                <div class="package-goods">
                                    <div class="package-title">
                                        <van-checkbox v-model="item.checked" :disabled="(!store.isGSPExpired) && !showCancel" class="is-checked" @change="selectPackage($event, item, index)" />
                                        <span class="activity-type-desc">{{ item.activityTypeDesc }}</span>
                                        <van-icon v-if="showCancel" class-prefix="btn-remove" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png?v=1" @click="remove(item, 2, index, bindex)" />
                                    </div>
                                    <div class="activity-subtotal">
                                        <span>套餐价：<font>¥{{ (item.discountPrice||0).toFixed(2) }}</font></span>
                                        <span v-if="item.originalPrice">原价：¥{{ (item.originalPrice||0).toFixed(2) }}</span>
                                    </div>
                                    <div class="tips">
                                        <img
                                            v-if="[1,2, 5 , 6, 8].indexOf(item.activityType-0) > -1"
                                            src="@/assets/images/icon-gift.png"
                                            class="activity-name"
                                        >
                                        <img
                                            v-if="[3,4,9].indexOf(item.activityType - 0) > -1"
                                            src="@/assets/images/icon-reduce.png"
                                            class="activity-name"
                                        >
                                        <span class="activity-tips">{{ item.promotionTips }}</span>
                                    </div>
                                    <div v-for="(product, i) in item.productList" :key="i" class="list" :style="i===0?'padding-top:.2rem':''">
                                        <div class="goods-img">
                                            <image-load
                                                :is-product-img="true"
                                                class="image"
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="product.imgUrl"
                                                :sid="product.productSid"
                                                :item="product"
                                            />
                                        </div>
                                        <div class="goods-info">
                                            <div class="row-1">
                                                <span @click="goDetail(product.productSid)">{{ product.commodityName }}</span>
                                            </div>
                                            <div class="row-2">
                                                <span>{{ product.spec }}</span>
                                                <span>× {{ product.baseQuantity }}</span>
                                            </div>
                                            <div class="row-4">{{ product.manufacturer }}</div>
                                            <div v-if="product.expireDate != null" class="row-3 product-expire-date">效期优于 {{ product.expireDate }}</div>
                                            <div class="activity-icon">
                                                <img v-if="product.huddle" src="@/assets/images/bt.png" class="product-bt">
                                                <img v-if="product.herb" src="@/assets/images/zy.png" class="product-zy">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div v-if="!item.understock && item.promotionLadderList.length" class="giftList-box">
                                    <div class="giftTips" :style="item.level === -1 ? 'padding-bottom:.2rem':''">
                                        <span v-if="item.level === -1">不参与活动、不需要赠品</span>
                                        <span v-else-if="item.giftOption != null&& item.giftOption > 0 && item.selectGiftOption > 0">您可以选择下列{{ item.giftOption }}种赠品</span>
                                        <span v-else>您可以选择下列赠品</span>
                                        <p
                                            class="replace-gift-btn"
                                            @click="changeGift(item, index, bindex, 'packageProductList')"
                                        >换赠品<img src="@/assets/images/icon_red_down_arrow.png"></p>
                                    </div>
                                    <div v-for="(gift, j) in item.giftList" :key="j" class="gift-box">
                                        <van-checkbox
                                            v-model="gift.checked"
                                            class="is-checked"
                                            :disabled="gift.isUnScope || !item.checked || !store.isGSPExpired || gift.optionType === 2 || gift.stock < gift.quantity"
                                            @change="selectGift($event, item, gift)"
                                            @click="giftClick(gift)"
                                        />
                                        <div style="position:relative">
                                            <img v-if="gift.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                            <image-load
                                                :is-product-img="true"
                                                class="img-box"
                                                default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                :original-image="gift.giftImg"
                                                :sid="gift.productSid"
                                                :item="gift"
                                            />
                                        </div>
                                        <div class="gift-info">
                                            <div class="floor-1">
                                                <font v-if="gift.expireStatus === 1" color="#FF4646">近效期-</font>
                                                <span @click="goDetail(gift.productSid)">{{ gift.giftName }}</span>
                                            </div>
                                            <div class="floor-2">
                                                <div>{{ gift.giftSpec }}</div>
                                                <span v-if="gift.isUnScope" class="num no-stock">无经营范围</span>
                                                <span v-else-if="gift.stock < gift.quantity" class="num no-stock">库存不足</span>
                                                <template v-else>
                                                    <font>×</font>
                                                    <span class="num"> {{ gift.quantity }}</span>
                                                </template>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="product-bottom">
                                    <span><font>小计</font>￥{{ (item.packageQuantity * item.discountPrice).toFixed(2) }}</span>
                                    <stepper-number :item="item" :is-cart="true" :activity-type="item.activityType" :index="index" />
                                </div>
                            </ol>
                            <!-- 满减商品 -->
                            <ol v-for="(item, cindex) in store.cart.groupProductList" :key="cindex" class="store-content">
                                <div v-if="item.productList.length !==0">
                                    <li class="isChecked">
                                        <van-icon
                                            v-if="showCancel"
                                            class-prefix="btn-remove"
                                            name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png?v=1"
                                            @click="remove(product, 3, index, cindex, i)"
                                        />
                                        <div class="package-title">
                                            <van-checkbox v-model="item.checked" :disabled="(!store.isGSPExpired) && !showCancel" class="is-checked" @change="selectGroupProduct($event, item)" />
                                            <span>{{ item.activityTypeDesc }}</span>
                                        </div>
                                        <h6 v-if="item.promotionTips" class="activity">
                                            <img
                                                v-if="[1, 5 , 6, 8].indexOf(item.activityType-0) > -1"
                                                src="@/assets/images/icon-gift.png"
                                                class="activity-name"
                                            >
                                            <img
                                                v-if="[3,9].indexOf(item.activityType-0) > -1"
                                                src="@/assets/images/icon-reduce.png"
                                                class="activity-name"
                                            >
                                            <span class="activity-tips">{{ item.promotionTips }}</span>
                                            <span v-if="item.activityType == 9" class="reduced">(已减{{ item.preferentialAmount }}元)</span>
                                            <span v-if="item.activityType == 9" class="almost">还差{{ item.differenceAmount }}元</span>
                                            <span v-if="item.activityType == 9" class="goTogether" @click="goTogether(item.promotionId)">去凑单</span>
                                        </h6>
                                        <div v-for="(product, i) in item.productList" :key="i" class="product">
                                            <template v-if="!showCancel">
                                                <van-checkbox v-model="product.checked" class="is-checked" :disabled="product.stock <= 0 || !store.isGSPExpired" @change="selectNormal($event, product, index, item)" />
                                            </template>
                                            <template v-else>
                                                <van-checkbox v-model="product.checked" class="is-checked" @change="selectNormal($event, product, index, item)" />
                                            </template>
                                            <dl>
                                                <dt>
                                                    <image-load
                                                        :is-product-img="true"
                                                        class="product-img"
                                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                        :original-image="product.imgUrl"
                                                        :sid="product.productSid"
                                                        :item="product"
                                                    />
                                                    <div class="goods-status">
                                                        <span v-if="item.nearExpire" class="nearExpire">近效期</span>
                                                        <!-- <span v-if="item.understock" class="understock">缺货</span>
                                                        <span v-if="item.unShelve" class="unShelve">已下架</span> -->
                                                    </div>
                                                </dt>
                                                <dd>
                                                    <p class="product-name">
                                                        <span @click="goDetail(item.productSid)">{{ product.commodityName }}</span>
                                                    </p>
                                                    <p v-if="product.expireDateStr != null" class="product-expire-date">效期优于 {{ product.expireDate }}</p>
                                                    <p class="product-spec">{{ product.spec }}</p>
                                                    <p>{{ product.manufacturer }}</p>
                                                    <p class="activity-icon">
                                                        <img v-if="product.huddle" src="@/assets/images/bt.png" class="product-bt">
                                                        <img v-if="product.herb" src="@/assets/images/zy.png" class="product-zy">
                                                    </p>
                                                    <p><span class="product-price">￥{{ product.price.toFixed(2) }}</span><span class="origin-price">￥{{ product.retailPrice.toFixed(2) }}</span></p>
                                                </dd>
                                            </dl>
                                        </div>
                                        <div v-for="(gift, j) in item.giftList" :key="j" class="product-gift">
                                            <div class="giftTips">
                                                <span v-if="item.giftOption != null">您可以选择下列{{ item.giftOption }}种赠品</span>
                                            </div>
                                            <div class="gift-box">
                                                <van-checkbox
                                                    v-model="gift.checked"
                                                    :disabled="gift.isUnScope||!item.checked || !store.isGSPExpired || gift.optionType === 2 || gift.stock < 1"
                                                    class="is-checked"
                                                    @change="selectGift($event, item, gift)"
                                                />
                                                <div class="brand">赠品</div>
                                                <div style="position:relative">
                                                    <img v-if="gift.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                                    <image-load
                                                        :is-product-img="true"
                                                        class="img-box"
                                                        default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                                        :original-image="gift.giftImg"
                                                        :sid="gift.sid"
                                                        :item="gift"
                                                    />
                                                </div>
                                                <div class="gift-info">
                                                    <div class="floor-1">
                                                        <font v-if="gift.expireStatus === 1" color="#FF4646">近效期-</font>
                                                        <span @click="goDetail(item.productSid)">{{ gift.giftName }}</span>
                                                    </div>
                                                    <div class="floor-2">
                                                        <div>{{ gift.giftSpec }}</div>
                                                        <span class="num">{{ gift.quantity }}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="product-bottom">
                                            <span><font>小计</font>￥{{ (product.quantity * product.price).toFixed(2) }}</span>
                                            <stepper-number
                                                :item="product"
                                                :is-cart="true"
                                                :index="index"
                                                :activity-type="item.activityType"
                                                :group="item"
                                            />
                                        </div>
                                    </li>
                                </div>
                            </ol>
                        </div>
                    </div>
                </li>
            </ul>
            <div v-if="!firstLoading" class="footer-bar" :class="$store.getters.hasToolbar ? '' : 'no-tool-bar'">
                <div class="other-amount">
                    <div class="huddle">
                        <p>¥{{ huddleAmount.toFixed(2) }}</p>
                        <p>抱团合计</p>
                    </div>
                    <div class="herb">
                        <p>¥{{ herbAmount.toFixed(2) }}</p>
                        <p>中药合计</p>
                    </div>
                    <div class="medicine">
                        <p>¥{{ notMedicineAmount.toFixed(2) }}</p>
                        <p>非药合计</p>
                    </div>
                </div>
                <div class="bottom-toolbar">
                    <div class="left">
                        <van-checkbox v-model="checked" @click="onChangeAll($event)">全选</van-checkbox>
                        <div class="total-box">
                            <div class="row-1">
                                <span>合计：</span>
                                <span>¥{{ Math.abs(totalAmount).toFixed(2) }}</span>
                            </div>
                            <div class="row-2">
                                <span>优惠：</span>
                                <span>¥{{ discountAmount.toFixed(2) }}</span>
                            </div>
                        </div>
                    </div>
                    <van-button
                        :disabled="isloading"
                        :class="{noProduct: cartNums === 0}"
                        @click="operateCart"
                    >
                        {{ showCancel ? '移出购物车' : '去结算(' + cartNums + ')' }}
                    </van-button>
                </div>
            </div>
        </template>
        <template v-else>
            <div v-if="refreshFlag && !isloading">
                <div class="no-data">
                    <img src="@/assets/images/refresh.png">
                    <span>数据获取失败，请尝试刷新!</span>
                    <div @click="getCartList">重新刷新</div>
                </div>
                <div v-if="invalidCartNum" class="empty-cart">
                    <span>{{ invalidCartNum }}个商品因下架等原因未显示</span>
                    <p @click="emptyInvalid"><img src="@/assets/images/empty-cart.png" alt="">清空</p>
                </div>
            </div>
            <div v-if="!refreshFlag && !isloading">
                <div class="no-data">
                    <img src="@/assets/images/emptyCart.png">
                    <span>暂无商品，快去选购吧！</span>
                    <div @click="goShopping">
                        前 往
                    </div>
                </div>
                <div v-if="invalidCartNum" class="empty-cart">
                    <span>{{ invalidCartNum }}个商品因下架等原因未显示</span>
                    <p @click="emptyInvalid"><img src="@/assets/images/empty-cart.png" alt="">清空</p>
                </div>
            </div>
        </template>
        <van-popup
            v-model="replaceDialog"
            round
            class="replace-gift-popup"
            position="bottom"
            :close-on-click-overlay="false"
        >
            <div class="popup-content">
                <p class="title">更换赠品<van-icon name="cross" class="close-btn" @click="replaceDialog=false" /></p>
                <van-radio-group v-model="replaceRadio">
                    <van-radio
                        v-for="item in currentObj.promotionLadderList"
                        :key="item"
                        :name="item.level"
                        @click="changePromotionLadder(item)"
                    >
                        {{ item.promotionTips }}
                    </van-radio>
                </van-radio-group>
            </div>
            <div class="submit-gift" @click="savePromotionLadder">确 定</div>
        </van-popup>
    </div>
</template>
<script>
import './sass/cart.scss'
import imageLoad from '@/components/imageLoad/index'
import stepperNumber from '@/components/stepperNumber/index'
import Api from '@/api/product/cart'
import { Toast, Dialog } from 'vant'
import { replaceUrl } from '@/utils/util'
export default {
    name: 'PageCartList',
    components: {
        imageLoad,
        stepperNumber
    },
    data() {
        return {
            replaceUrl: replaceUrl,
            storeList: [],
            timer: null,
            huddleAmount: 0,
            herbAmount: 0,
            notMedicineAmount: 0,
            totalAmount: 0,
            discountAmount: 0,
            cartNums: 0,
            checked: false,
            showCancel: false,
            emptyCart: null,
            isloading: false,
            replaceDialog: false,
            selectGroupList: [],
            replaceRadio: '', // 当前活动阶梯
            currentObj: {
                generalProductList: [],
                index: '',
                ind: ''
            }, // 当前商品
            promotionLadder: {}, // 选择的阶梯
            replaceType: '',
            winHeight: this.$store.getters.winHeight - 47,
            allProductSize: 0, // 计算全选
            refreshFlag: false,
            firstLoading: true,
            specailInfo: [] // 用户购物车内专项款商品信息
        }
    },
    computed: {
        userInfoScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.userInfoScope : [];
        },
        invalidCartNum(){
            return this.$store.getters.cartNum
        }
    },
    watch: {
        '$store.getters.navbarRightClick': function(val) {
            this.showCancelAction()
        },
        storeList: function(val){
            if (val.length === 0){
                this.emptyCart = true
            } else {
                for (let i = 0; i < this.storeList.length; i++){
                    if (this.storeList[i].cart.generalProductList.length === 0 && this.storeList[i].cart.groupProductList.length === 0 && this.storeList[i].cart.packageProductList.length === 0){
                        this.emptyCart = true
                    } else {
                        this.emptyCart = false
                        return
                    }
                }
            }
        },
        emptyCart: function(val){
            if (val){
                if (!this.$route.query.comeFrom){
                    this.winHeight = this.$store.getters.winHeight - 47
                } else {
                    this.winHeight = this.$store.getters.winHeight
                }
            } else {
                if (!this.$route.query.comeFrom){
                    this.winHeight = this.$store.getters.winHeight - 135
                } else {
                    this.winHeight = this.$store.getters.winHeight - 88
                }
            }
        },
        showCancel: function(val){
            if (val) {
                this.$store.commit('setCartRightText', '完成')
            } else {
                this.$store.commit('setCartRightText', '管理')
            }
        }
    },
    created(){
        if (this.$route.query.comeFrom){
            this.$store.commit("setHasToolbar", false)
        } else {
            this.$store.commit("setHasToolbar", true)
        }
    },
    beforeDestroy() {
        this.$store.commit("setCartAdded");
    },
    mounted() {
        this.$store.commit('setCartRightText', '管理')
        this.$store.commit('setCartNum');
        this.getSpecialProduct();
        this.getCartList()
        localStorage.setItem('selectCoupon', null)
        localStorage.setItem('selectLogisticsArr', null)
    },
    methods: {
        // 去选品
        gotoSelectGoods(specialUrl) {
            location.href = specialUrl;
        },
        // 计算使用专项款剩余商品数量
        calSpecialCount(userSid, sid) {
            const obj = {
                restrict: false,
                isSpecial: false,
                minProductQuantity: 0,
                specialSid: '',
                url: ''
            }
            const store = this.specailInfo.filter(v => v.userSid === userSid);
            if (store && store[0] && store[0].accountUsage.specialAccountUsageList.length) {
                obj.minProductQuantity = store[0].accountUsage.specialAccountUsageList[0].minProductQuantity;
                obj.specialSid = store[0].accountUsage.specialAccountUsageList[0].specialSid;
                if (store[0].accountUsage.specialAccountUsageList[0].extendVal) {
                    const extendVal = JSON.parse(store[0].accountUsage.specialAccountUsageList[0].extendVal);
                    if (extendVal && extendVal[0]) obj.url = extendVal[0].url + '&source=h5';
                }
                if (store[0].accountUsage.specialAccountUsageList[0].restrict) {
                    obj.restrict = true;
                    const ableProductSids = store[0].accountUsage.specialAccountUsageList[0].ableProductSids || [];
                    if (ableProductSids.indexOf(sid) === -1) {
                        return obj;
                    } else {
                        obj.isSpecial = true;
                        return obj;
                    }
                } else {
                    return obj;
                }
            } else {
                return obj;
            }
        },
        // 获取店铺专项款商品
        getSpecialProduct() {
            Api.accountPredict().then(({ data: { data }}) => {
                this.specailInfo = data || [];
            })
        },
        // 清空失效商品
        emptyInvalid() {
            Api.deleteGoods().then(re => {
                this.$store.commit('setCartNum');
            })
        },
        // 点击展开、收缩单门店购物车
        toggleStore(item){
            item.toggleFlag = !item.toggleFlag;
        },
        /**
         * 判断是店铺是否有经营范围
         */
        isUnScope(userSid, businessScope) {
            if (businessScope || businessScope === 0) {
                const data = this.userInfoScope.filter(v => v.userSid === userSid)[0];
                return (data.scopeSidSet || []).indexOf(businessScope) === -1;
            } else {
                return false;
            }
        },
        /**
         * 获取购物车列表
         */
        getCartList() {
            this.refreshFlag = false;
            this.isloading = true;
            Toast.loading({
                message: '加载中...',
                forbidClick: true,
                duration: 0
            })
            let allLen = 0;// 计算购物车是否有商品，控制页面高度
            this.allProductSize = 0;// 可以选中的商品数量，计算全选状态的改变
            this.cartNums = 0;
            let indexFlag = 0;
            Api.fetchCartList().then(({ data: { data }}) => {
                data.forEach((store, index) => {
                    store.checked = store.checked || false
                    store.huddleAmount = 0 // 抱团小计
                    store.herbAmount = 0 // 中药小计
                    store.notMedicineAmount = 0
                    // 解决线上购物车列表会返回没有商品的店铺
                    if (
                        (store.cart.generalProductList && store.cart.generalProductList.length) ||
                        (store.cart.groupProductList && store.cart.groupProductList.length) ||
                        (store.cart.packageProductList && store.cart.packageProductList.length)
                    ) {
                        indexFlag++;
                        store.toggleFlag = indexFlag === 1;
                    }
                    store.cartNums = 0;// 店铺选中的商品数量，计算全选状态的改变
                    store.allProductSize = 0;// 店铺可以选中的商品数量，计算全选状态的改变
                    store.surplusCount = 0; // 使用岳麓论坛专项款，剩余添加商品品种数量
                    store.cart.generalProductList.forEach((generalProduct) => {
                        allLen++;
                        generalProduct.isUnScope = this.isUnScope(store.userSid, generalProduct.businessScope);
                        if (!(store.isGSPExpired === false || generalProduct.stock <= 0 || generalProduct.isUnScope)) {
                            this.allProductSize++;
                            store.allProductSize++;
                        }
                        generalProduct.productType = 'general';
                        generalProduct.oldReplaceRadio = '';
                        generalProduct.selectGiftOption = 0// 选赠商品数量
                        generalProduct.checked = generalProduct.checked || false
                        const specialObj = this.calSpecialCount(store.userSid, generalProduct.productSid);
                        store.restrict = specialObj.restrict;
                        store.specialSid = specialObj.specialSid;
                        store.specialUrl = specialObj.url;
                        store.minProductQuantity = specialObj.minProductQuantity;
                        generalProduct.isSpecial = specialObj.isSpecial;

                        if (generalProduct.promotionLadderList && generalProduct.promotionLadderList.length) {
                            // 删除接口返回的错误数据
                            for (let i = 0; i < generalProduct.promotionLadderList.length; i++) {
                                if (!generalProduct.promotionLadderList[i]){
                                    generalProduct.promotionLadderList.splice(i, 1);
                                    i--;
                                }
                            }
                            // 没满足活动条件，提示下一级活动凑单
                            if (generalProduct.promotionLadderList.length && generalProduct.promotionLadderList[0].giftList === null){
                                generalProduct.nextPromotionActivityTips = generalProduct.promotionLadderList[0].nextPromotionActivityTips;
                                generalProduct.isShow = generalProduct.promotionLadderList[0].isShow;
                                generalProduct.promotionLadderList.splice(0, 1);
                            }
                        }
                        if (generalProduct.promotionLadderList && generalProduct.promotionLadderList.length) {
                            generalProduct.nextPromotionActivityTips = generalProduct.promotionLadderList[0].nextPromotionActivityTips;
                            generalProduct.isShow = generalProduct.promotionLadderList[0].isShow;
                            generalProduct.ladderTips = generalProduct.promotionLadderList[0].promotionTips;
                            generalProduct.promotionLadderList.forEach((v, i) => {
                                v.selectGiftOption = 0;
                                v.giftList && v.giftList.forEach((gift) => {
                                    gift.isUnScope = this.isUnScope(store.userSid, gift.businessScope);
                                    if (gift.optionType !== 2 && gift.stock >= gift.quantity && gift.isUnScope === false)v.selectGiftOption++;
                                    this.$set(gift, 'checked', false);
                                })
                                if (i === 0) {
                                    generalProduct.giftList = v.giftList || [];
                                    generalProduct.giftOption = v.giftOption || 0;
                                    generalProduct.level = v.level;
                                    generalProduct.selectGiftOption = v.selectGiftOption;
                                }
                            })
                            // 添加不使用优惠阶梯
                            const flag = generalProduct.promotionLadderList.filter(item => item.level === -1)[0];
                            if (!flag) {
                                generalProduct.promotionLadderList.push({
                                    promotionTips: '不参与活动、不需要赠品',
                                    nextPromotionActivityTips: '不参与活动、不需要赠品',
                                    isShow: false,
                                    promotionId: '0',
                                    giftList: [],
                                    level: -1
                                })
                            }
                        } else {
                            generalProduct.giftList = [];
                            generalProduct.giftOption = 0;
                            generalProduct.promotionLadderList = [];
                            generalProduct.level = '';
                        }
                    })
                    store.cart.groupProductList.forEach((groupProduct) => {
                        groupProduct.productType = 'group';
                        groupProduct.checked = groupProduct.checked || false
                        groupProduct.productList.forEach(product => {
                            allLen++;
                            if (!(store.isGSPExpired === false || product.stock <= 0)) {
                                this.allProductSize++;
                                store.allProductSize++;
                            }
                            product.checked = product.checked || false
                        })
                    })
                    store.cart.packageProductList.forEach((packageProduct) => {
                        allLen++;
                        if (!(store.isGSPExpired === false || packageProduct.stock <= 0)) {
                            this.allProductSize++;
                            store.allProductSize++;
                        }
                        packageProduct.productType = "package";
                        packageProduct.oldReplaceRadio = '';
                        packageProduct.checked = packageProduct.checked || false
                        packageProduct.selectGiftOption = 0
                        if (packageProduct.promotionLadderList && packageProduct.promotionLadderList.length && packageProduct.promotionLadderList[0]) {
                            packageProduct.nextPromotionActivityTips = packageProduct.promotionLadderList[0].nextPromotionActivityTips;
                            packageProduct.isShow = packageProduct.promotionLadderList[0].isShow;
                            packageProduct.ladderTips = packageProduct.promotionLadderList[0].promotionTips;
                            packageProduct.promotionLadderList.forEach((v, i) => {
                                v.selectGiftOption = 0;
                                v.giftList && v.giftList.forEach((gift) => {
                                    gift.isUnScope = this.isUnScope(store.userSid, gift.businessScope);
                                    if (gift.optionType !== 2 && gift.stock >= gift.quantity && gift.isUnScope === false)v.selectGiftOption++;
                                    this.$set(gift, 'checked', false);
                                })
                                if (i === 0) {
                                    packageProduct.giftList = v.giftList || [];
                                    packageProduct.giftOption = v.giftOption || 0;
                                    packageProduct.level = v.level;
                                    packageProduct.selectGiftOption = v.selectGiftOption
                                }
                            })
                            // 添加不使用优惠阶梯
                            const flag = packageProduct.promotionLadderList.filter(item => item.level === -1)[0];
                            if (!flag) {
                                packageProduct.promotionLadderList.push({
                                    promotionTips: '不参与活动、不需要赠品',
                                    promotionId: '0',
                                    giftList: [],
                                    level: -1
                                })
                            }
                        } else {
                            packageProduct.giftList = [];
                            packageProduct.giftOption = 0;
                            packageProduct.promotionLadderList = [];
                            packageProduct.level = '';
                        }
                    })
                });
                if (allLen > 0) this.winHeight = this.$store.getters.winHeight - 135
                this.storeList = data;
                this.isloading = false;
                this.firstLoading = false;
                Toast.clear()
            }).catch(() => {
                Toast.clear()
                this.isloading = false;
                this.refreshFlag = true;
            })
        },
        /**
         * 更新商品数量
         */
        updateNum(item, index) {
            if (this.timer) {
                clearTimeout(this.timer)
            }
            this.timer = setTimeout(() => {
                Toast.loading({
                    message: '加载中...',
                    forbidClick: true,
                    duration: 0
                })
                
                Api.upDateCartNum({ sid: item.sid, quantity: item.quantity || item.packageQuantity }).then(({ data: { data }}) => {
                    Toast.clear()
                    if (!data){
                        item.giftList = []
                        item.promotionTips = "";
                        item.nextPromotionActivityTips = "";
                        item.isShow = "";
                        item.promotionLadderList = [];
                        item.activityTypeDesc = "";
                        item.activityType = '';
                    } else if (data[0] && data[0].giftList === null){
                        item.giftList = [];
                        item.promotionLadderList = [];
                        item.nextPromotionActivityTips = data[0].nextPromotionActivityTips;
                        item.isShow = data[0].isShow;
                        item.promotionTips = data[0].promotionTips;
                        item.activityType = data[0].activityType;
                        item.activityTypeDesc = data[0].activityTypeDesc;
                    } else {
                        item.promotionLadderList = data;
                        item.oldReplaceRadio = "";
                        item.checked = item.checked || false;
                        item.selectGiftOption = 0;
                        if (item.promotionLadderList && item.promotionLadderList.length) {
                            item.nextPromotionActivityTips = data[0].nextPromotionActivityTips;
                            item.isShow = data[0].isShow;
                            item.promotionTips = data[0].promotionTips;
                            item.activityType = data[0].activityType;
                            item.activityTypeDesc = data[0].activityTypeDesc;
                            item.promotionLadderList.forEach((v, i) => {
                                v.selectGiftOption = 0;
                                v.giftList && v.giftList.forEach(gift => {
                                    gift.isUnScope = this.isUnScope(this.storeList[index].userSid, gift.businessScope);
                                    if (gift.optionType !== 2 && gift.stock >= gift.quantity && gift.isUnScope === false)v.selectGiftOption++;
                                    this.$set(gift, 'checked', false);
                                })
                                if (i === 0) {
                                    item.giftList = v.giftList || [];
                                    item.giftOption = v.giftOption || 0;
                                    item.level = v.level;
                                    item.selectGiftOption = v.selectGiftOption;
                                }
                            })
                            // 添加不使用优惠阶梯
                            const flag = item.promotionLadderList.filter(v => v.level === -1)[0];
                            if (!flag) {
                                item.promotionLadderList.push({
                                    promotionTips: '不参与活动、不需要赠品',
                                    promotionId: '0',
                                    giftList: [],
                                    level: -1
                                })
                            }
                        } else {
                            item.giftList = [];
                            item.giftOption = 0;
                            item.promotionLadderList = [];
                            item.level = '';
                            item.nextPromotionActivityTips = "";
                            item.isShow = "";
                            item.promotionTips = "";
                            item.activityTypeDesc = "";
                            item.activityType = '';
                        }
                        if (item.checked) {
                            let n = 0;
                            item.giftList && item.giftList.forEach(gift => {
                                if (gift.stock < gift.quantity || gift.isUnScope) {
                                    gift.checked = false;
                                } else {
                                    if (gift.optionType === 2) {
                                        // 固定赠送
                                        gift.checked = item.checked;
                                    } else {
                                        // 选择赠送
                                        if (n < item.giftOption){
                                            gift.checked = item.checked;
                                            n++
                                        } else {
                                            gift.checked = false;
                                        }
                                    }
                                }
                            })
                        }
                    }
                })
                
                const computeAmount = item.finalAmount - (item.quantity || item.packageQuantity) * item.price
                // const computeAmount = item.finalAmount
                // 被选中时，计算
                if (item.checked) {
                    if (item.huddle) {
                        this.storeList[index].huddleAmount = this.storeList[index].huddleAmount - computeAmount
                        this.huddleAmount = this.huddleAmount - computeAmount
                    }
                    if (item.herb) {
                        this.storeList[index].herbAmount = this.storeList[index].herbAmount - computeAmount
                        this.herbAmount = this.herbAmount - computeAmount
                    }
                    if (item.notMedicine) {
                        this.storeList[index].notMedicineAmount = this.storeList[index].notMedicineAmount - computeAmount
                        this.notMedicineAmount = this.notMedicineAmount - computeAmount
                    }
                    this.totalAmount = this.totalAmount - computeAmount
                }
                item.finalAmount = (item.quantity || item.packageQuantity) * item.price
            }, 1000)
        },
        /**
         * 选中、更新组合商品数量
         */
        updateGroupNum(data, group){
            if (this.timer) {
                clearTimeout(this.timer)
            }
            this.timer = setTimeout(() => {
                Toast.loading({
                    message: '加载中...',
                    forbidClick: true,
                    duration: 0
                })
                Api.updateNum(data).then(({ data: { data }}) => {
                    Toast.clear()
                    if (data.groupPromotion){
                        group.promotionTips = data.groupPromotion.promotionTips
                        group.preferentialAmount = data.groupPromotion.preferentialAmount
                        group.differenceAmount = data.groupPromotion.differenceAmount
                    }
                })
            }, 500)
        },
        /**
         * 单店全选
         */
        selectStore(store) {
            const e = store.checked;
            store.cart.generalProductList && store.cart.generalProductList.forEach((generalProduct) => {
                if ((generalProduct.stock > 0 && !generalProduct.isUnScope) || this.showCancel){
                    generalProduct.checked = e
                }
            })
            store.cart.groupProductList && store.cart.groupProductList.forEach((groupProduct) => {
                groupProduct.checked = e
                groupProduct.productList && groupProduct.productList.forEach(product => {
                    if (product.stock > 0){
                        product.checked = e
                    }
                })
            })
            store.cart.packageProductList && store.cart.packageProductList.forEach((packageProduct) => {
                packageProduct.checked = e
            })
        },
        /**
         * 满减商品全选
         */
        selectGroupProduct(e, item) {
            item.productList && item.productList.forEach(product => {
                if (product.stock > 0){
                    product.checked = e
                }
            })
        },
        /**
         * 商品选中（普通）
         */
        selectNormal(e, item, index, group) {
            if (item.stock > 0 || this.showCancel){
                item.checked = e
                let n = 0
                if (e){
                    if (item.isSpecial) this.storeList[index].surplusCount++;
                    // 选中商品时勾选默认赠品
                    item.giftList && item.giftList.forEach((gift) => {
                        if (gift.stock < gift.quantity || gift.isUnScope) {
                            gift.checked = false;
                        } else {
                            if (gift.optionType === 2) {
                                // 固定赠送
                                gift.checked = e;
                            } else {
                                // 选择赠送
                                if (n < item.giftOption){
                                    gift.checked = e;
                                    n++
                                } else {
                                    gift.checked = false;
                                }
                            }
                        }
                    })
                    // 控制全选按钮和店铺全选按钮状态
                    this.cartNums++
                    this.storeList[index].cartNums++
                } else {
                    if (item.isSpecial) this.storeList[index].surplusCount--;
                    // 取消选中商品将所有赠品取消勾选
                    item.giftList && item.giftList.forEach((gift, index) => {
                        gift.checked = false
                    })
                    // 控制全选按钮和店铺全选按钮状态【管理时初始数据store.cartNums=0,store.checked=false会触发方法所以为0则不减】
                    this.cartNums > 0 ? this.cartNums-- : '';
                    this.storeList[index].cartNums > 0 ? this.storeList[index].cartNums-- : ''
                }
                this.storeList[index].checked = !!(this.storeList[index].cartNums === this.storeList[index].allProductSize && this.storeList[index].cartNums !== 0);
                this.checked = !!(this.cartNums === this.allProductSize && this.cartNums !== 0);
                this.computeAction(item, index, group)
            } else {
                item.checked = false
            }
        },
        /**
         * 商品选中（套餐）
         */
        selectPackage(e, item, idx, group){
            let n = 0
            item.checked = e
            if (e){
                // 选中套餐时勾选默认赠品
                item.giftList && item.giftList.forEach((gift) => {
                    if (gift.stock < gift.quantity || gift.isUnScope) {
                        gift.checked = false;
                    } else {
                        if (gift.optionType === 2) {
                            // 固定赠送
                            gift.checked = e;
                        } else {
                            // 选择赠送
                            if (n < item.giftOption){
                                gift.checked = e;
                                n++
                            } else {
                                gift.checked = false;
                            }
                        }
                    }
                })
                // 控制全选按钮和店铺全选按钮状态
                this.cartNums++
                this.storeList[idx].cartNums++
            } else {
                // 取消选中将所有赠品取消勾选
                item.giftList && item.giftList.forEach((gift, index) => {
                    gift.checked = e
                })
                // 控制全选按钮和店铺全选按钮状态【管理时初始数据store.cartNums=0,store.checked=false会触发方法所以为0则不减】
                this.cartNums > 0 ? this.cartNums-- : '';
                this.storeList[idx].cartNums > 0 ? this.storeList[idx].cartNums-- : ''
            }
            this.storeList[idx].checked = !!(this.storeList[idx].cartNums === this.storeList[idx].allProductSize && this.storeList[idx].cartNums !== 0);
            this.checked = !!(this.cartNums === this.allProductSize && this.cartNums !== 0);
            this.computeAction(item, idx, group)
        },
        /**
         * 赠品选中
         */
        selectGift(e, item, gift) {
            gift.checked = e
            let checkedNum = 0
            item.giftList.forEach(gift => {
                if (gift.checked && gift.optionType !== 2 && gift.stock >= gift.quantity && gift.isUnScope === false) {
                    checkedNum++
                }
            })
            if (checkedNum > item.giftOption) {
                Toast(`您只能选择${item.giftOption}种选赠赠品`)
                gift.checked = false
            }
        },
        // 点击赠品
        giftClick(gift) {
            if (gift.optionType === 2 && gift.stock >= gift.quantity && gift.isUnScope === false) {
                Toast.clear();
                Toast('该赠品固定赠送');
            }
        },
        /**
         * 全选
         */
        onChangeAll(){
            const e = this.checked;
            this.storeList.forEach((store) => {
                if (!store.isGSPExpired && !this.showCancel){
                    return false
                } else {
                    store.checked = e
                    store.cart.generalProductList && store.cart.generalProductList.forEach((generalProduct) => {
                        if ((generalProduct.stock > 0 && !generalProduct.isUnScope) || this.showCancel){
                            generalProduct.checked = e
                        }
                    })
                    store.cart.groupProductList && store.cart.groupProductList.forEach((groupProduct) => {
                        groupProduct.checked = e
                        groupProduct.productList && groupProduct.productList.forEach(product => {
                            if (product.stock > 0){
                                product.checked = e
                            }
                        })
                    })
                    store.cart.packageProductList && store.cart.packageProductList.forEach((packageProduct) => {
                        packageProduct.checked = e
                    })
                }
            })
            // this.checked = !!(this.cartNums === this.allProductSize && this.cartNums !== 0);
        },
        /**
         * 选择时计算
         */
        computeAction(item, index, group) {
            if (item.checked) {
                if (item.huddle) {
                    this.storeList[index].huddleAmount += item.finalAmount
                    this.huddleAmount += item.finalAmount
                }
                if (item.herb) {
                    this.storeList[index].herbAmount += item.finalAmount
                    this.herbAmount += item.finalAmount
                }
                if (item.notMedicine) {
                    this.storeList[index].notMedicineAmount += item.finalAmount
                    this.notMedicineAmount += item.finalAmount
                }
                this.totalAmount += item.finalAmount
                if (group){
                    const groupItem = {
                        productSid: item.productSid,
                        quantity: item.quantity
                    }
                    this.selectGroupList.push(groupItem)
                    const cartItem = {
                        userSid: this.$store.getters.userInfo.stores[index].sid,
                        club: this.$store.getters.userInfo.currentType,
                        groupProductList: this.selectGroupList
                    }
                    localStorage.setItem("groupList", JSON.stringify(this.selectGroupList))
                    this.updateGroupNum(cartItem, group)
                }
            } else {
                if (item.huddle) {
                    this.storeList[index].huddleAmount -= item.finalAmount
                    this.huddleAmount -= item.finalAmount
                }
                if (item.herb) {
                    this.storeList[index].herbAmount -= item.finalAmount
                    this.herbAmount -= item.finalAmount
                }
                if (item.notMedicine) {
                    this.storeList[index].notMedicineAmount -= item.finalAmount
                    this.notMedicineAmount -= item.finalAmount
                }
                this.totalAmount -= item.finalAmount
                if (group){
                    for (let i = this.selectGroupList.length - 1; i >= 0; i--){
                        if (item.productSid === this.selectGroupList[i].productSid){
                            this.selectGroupList.splice(i, 1)
                        }
                    }
                    const cartItem = {
                        userSid: this.$store.getters.userInfo.stores[index].sid,
                        club: this.$store.getters.userInfo.currentType,
                        groupProductList: this.selectGroupList
                    }
                    localStorage.setItem("groupList", JSON.stringify(this.selectGroupList))
                    this.updateGroupNum(cartItem, group)
                }
            }
        },
        // 初始化选中-解决管理后可以勾选的商品不同，用于计算全选和店铺全选状态
        initChecked() { // 这里会触发选择商品的事件
            this.checked = false
            this.allProductSize = 0;
            this.cartNums = 0;
            this.storeList.forEach((store, index) => {
                store.checked = false
                store.cartNums = 0;// 店铺选中的商品数量，计算全选状态的改变
                store.allProductSize = 0;// 店铺可以选中的商品数量，计算全选状态的改变
                store.cart.generalProductList.forEach((generalProduct) => {
                    generalProduct.checked = false
                    this.allProductSize++;
                    store.allProductSize++;
                    generalProduct.giftList.forEach(gift => {
                        gift.checked = false;
                    })
                })
                store.cart.groupProductList.forEach((groupProduct) => {
                    groupProduct.checked = false
                    groupProduct.productList.forEach(product => {
                        this.allProductSize++;
                        store.allProductSize++;
                        product.checked = false
                        product.giftList.forEach(gift => {
                            gift.checked = false;
                        })
                    })
                })
                store.cart.packageProductList.forEach((packageProduct) => {
                    packageProduct.checked = false
                    this.allProductSize++;
                    store.allProductSize++;
                    packageProduct.giftList.forEach(gift => {
                        gift.checked = false;
                    })
                })
            });
        },
        /**
         * 显示移除购物车按钮
         */
        showCancelAction() {
            this.initChecked();
            this.showCancel = !this.showCancel
            if (!this.showCancel) this.getCartList()
        },
        /**
         * 删除商品(单个)
         */
        remove(item, type, i, j, k) {
            // type = 1 普通商品  2 套餐商品  3 满减商品
            Dialog.confirm({
                message: '您确定要删除此商品吗？',
                cancelButtonText: "删除",
                cancelButtonColor: '#999999',
                confirmButtonText: '先保留',
                confirmButtonColor: '#ED3129'
            }).then(() => {// 保留
                
            }).catch(() => {
                // 取消按钮是删除
                const arr = []
                arr.push(item.sid)
                if (type === 1) {
                    if (!(this.storeList[i].isGSPExpired === false || this.storeList[i].cart.generalProductList[j].stock <= 0 || this.storeList[i].cart.generalProductList[j].isUnScope)){
                        this.allProductSize--;
                        this.cartNums--
                        this.storeList[i].allProductSize--;
                        this.storeList[i].cartNums--;
                    }
                    this.storeList[i].cart.generalProductList.splice(j, 1)
                }
                if (type === 2) {
                    if (!(this.storeList[i].isGSPExpired === false || this.storeList[i].cart.packageProductList[j].stock <= 0)){
                        this.allProductSize--;
                        this.cartNums--
                        this.storeList[i].allProductSize--;
                        this.storeList[i].cartNums--;
                    }
                    this.storeList[i].cart.packageProductList.splice(j, 1)
                }
                if (type === 3) {
                    if (!(this.storeList[i].isGSPExpired === false || this.storeList[i].cart.groupProductList[j].stock <= 0)){
                        this.allProductSize--;
                        this.cartNums--
                        this.storeList[i].allProductSize--;
                        this.storeList[i].cartNums--;
                    }
                    this.storeList[i].cart.groupProductList[j].productList.splice(k, 1)
                }
                
                this.removeAction(arr)
                this.computeRemove(item, i)
            });
        },
        /**
         * 删除时计算
         */
        computeRemove(item, index){
            if (item.checked) {
                if (item.huddle) {
                    this.storeList[index].huddleAmount -= item.finalAmount
                    this.huddleAmount -= item.finalAmount
                }
                if (item.herb) {
                    this.storeList[index].herbAmount -= item.finalAmount
                    this.herbAmount -= item.finalAmount
                }
                if (item.notMedicine) {
                    this.storeList[index].notMedicineAmount -= item.finalAmount
                    this.notMedicineAmount -= item.finalAmount
                }
                this.totalAmount -= item.finalAmount
            }
        },
        /**
         * 移除动作
         */
        removeAction(arr, type) {
            Api.deleteGoods(arr).then(data => {
                Toast.success('删除成功')
                this.$store.commit('setCartNum')
                this.storeList.forEach(store => {
                    if (store.cart.generalProductList.length === 0 && store.cart.groupProductList.length === 0 && store.cart.packageProductList.length === 0){
                        this.emptyCart = true
                    } else {
                        this.emptyCart = false
                    }
                })
                // 多选删除
                if (type) this.getCartList();
            }).catch(() => {
                this.isloading = false
                Toast.clear();
            })
        },
        /**
         * 检查是否有额外赠品
         */
        getExtraGift(obj, array){
            localStorage.removeItem('extraGift')
            Api.getExtraGift(obj).then(({ data: { data }}) => {
                this.isloading = false
                if (data.length){
                    Toast.clear();
                    localStorage.setItem('extraGift', JSON.stringify(data))
                    localStorage.setItem('cartList', JSON.stringify(array))// 额外的赠品结算时的参数
                    this.$router.push('/extraGift/index')
                } else {
                    Api.comfirmCart(array).then(({ data: { data }}) => {
                        Toast.clear();
                        localStorage.setItem('cartInfo', JSON.stringify(data))
                        this.$router.push('/order/comfirmOrder')
                    }).catch(() => {
                        this.isloading = false
                        Toast.clear();
                    })
                }
            }).catch(() => {
                this.isloading = false
                Toast.clear();
            })
        },
        /**
         * 跳转商品详情
         */
        goDetail(sid){
            this.$router.push(`/product/detail/${sid}`)
        },
        /**
         * 去凑单
         */
        goTogether(id){
            this.$router.push({ path: "/product/collectOrders", query: { type: 1, sid: id }});
        },
        /**
         * 去结算、移除选中商品
         */
        operateCart(){
            if (this.showCancel){
                if (this.cartNums === 0){
                    Toast('请选择需要移除的商品')
                    this.isloading = false
                    return
                }
                const arr = []
                Dialog.confirm({
                    message: '您确定要删除选中的商品吗？',
                    cancelButtonText: "删除",
                    cancelButtonColor: '#999999',
                    confirmButtonText: '先保留',
                    confirmButtonColor: '#ED3129'
                }).then(() => {
                    this.isloading = false
                }).catch(() => {
                    for (let i = 0; i < this.storeList.length; i++){
                        const store = this.storeList[i].cart
                        for (let i = store.generalProductList.length - 1; i >= 0; i--){
                            const generalProduct = store.generalProductList[i]
                            if (generalProduct.checked){
                                arr.push(generalProduct.sid)
                            }
                        }
                        for (let i = 0; i < store.groupProductList.length; i++){
                            const groupProduct = store.groupProductList[i]
                            for (let j = groupProduct.productList.length - 1; j >= 0; j--){
                                const product = groupProduct.productList[j]
                                if (product.checked){
                                    arr.push(product.sid)
                                }
                            }
                        }
                        for (let i = store.packageProductList.length - 1; i >= 0; i--){
                            const packageProduct = store.packageProductList[i]
                            if (packageProduct.checked){
                                arr.push(packageProduct.sid)
                            }
                        }
                    }
                    this.removeAction(arr, 1)
                })
            } else {
                this.isloading = true
                if (this.cartNums === 0){
                    Toast('请选择需要结算的商品')
                    this.isloading = false
                    return
                }
                Toast.loading({
                    message: '加载中...',
                    forbidClick: true,
                    duration: 0
                })
                const arr = [] // 额外赠品的参数
                const goodsList = []
                const huddleAmountList = []
                const herbAmountList = []
                const notMedicineAmountList = []
                const totalAmountList = []

                const userCartParams = [];// 订单确认接口参数
                setTimeout(() => {
                    const storeListObj = JSON.parse(JSON.stringify(this.storeList));
                    // const fixedGift = [];
                    // const unScopeGift = '';
                    storeListObj.forEach(store => {
                        const item = {
                            userSid: store.userSid,
                            generalProductList: [],
                            groupProductList: [],
                            packageProductList: [],
                            huddleAmount: store.huddleAmount,
                            herbAmount: store.herbAmount,
                            notMedicineAmount: store.notMedicineAmount
                        }
                        const storeTotal = 0
                        if (store.huddleAmount !== 0 || store.herbAmount !== 0 || store.notMedicineAmount !== 0){
                            huddleAmountList.push(store.huddleAmount)
                            herbAmountList.push(store.herbAmount)
                            notMedicineAmountList.push(store.notMedicineAmount)
                        }
                        const storeCartObj = {
                            userSid: store.userSid,
                            generalProductList: [],
                            packageProductList: [],
                            groupProductList: [],
                            giftList: []
                        }
                        let paramsFlag = false;
                        store.cart.generalProductList && store.cart.generalProductList.forEach((generalProduct, i) => {
                            if (generalProduct.checked){
                                paramsFlag = true;
                                // 组装额外赠品接口参数
                                arr.push({
                                    userSid: store.userSid,
                                    id: generalProduct.productSid,
                                    quantity: generalProduct.quantity,
                                    businessScope: generalProduct.businessScope,
                                    commodityName: generalProduct.commodityName
                                })
                                // 组装商品的赠品参数
                                const giftList = []
                                // 解决点击去支付后会把未选中赠品删掉，所以下面存储商品清单的信息时会返回未选中赠品，注意在商品清单页面添加选中判断
                                for (let ind = 0; ind < generalProduct.giftList.length; ind++) {
                                    const gift = generalProduct.giftList[ind];
                                    if (gift.checked) {
                                        giftList.push(gift);
                                    } else {
                                        generalProduct.giftList.splice(ind, 1);
                                        ind--;
                                    }
                                    // if (gift.checked && gift.optionType === 2 && gift.isUnScope && !unScopeGift){
                                    //     unScopeGift = `${store.name}固定赠品${gift.giftName}无经营范围`;
                                    // } else if (gift.checked && gift.stock >= gift.quantity){
                                    //     giftList.push(gift)
                                    // } else if (gift.optionType === 2 && gift.stock < gift.quantity && gift.isUnScope === false) {
                                    //     fixedGift.push(gift.giftName);
                                    // } else {
                                    //     generalProduct.giftList.splice(ind, 1);
                                    //     ind--;
                                    // }
                                }
                                // 组装店铺商品-单品
                                storeCartObj.generalProductList.push({
                                    id: generalProduct.productSid,
                                    price: generalProduct.price,
                                    quantity: generalProduct.quantity,
                                    giftList: giftList,
                                    businessScope: generalProduct.businessScope,
                                    commodityName: generalProduct.commodityName
                                })
                                item.generalProductList.push(generalProduct)
                            }
                        })
                        store.cart.groupProductList && store.cart.groupProductList.forEach((groupProduct, i) => {
                            groupProduct.productList && groupProduct.productList.forEach((product, j) => {
                                if (product.checked){
                                    paramsFlag = true;
                                    // 组装额外赠品接口参数
                                    arr.push({
                                        userSid: store.userSid,
                                        id: product.productSid,
                                        quantity: product.quantity
                                    })
                                    // 组装商品的赠品参数
                                    const giftList = []
                                    for (let ind = 0; ind < product.giftList.length; ind++) {
                                        const gift = product.giftList[ind];
                                        if (gift.checked) {
                                            giftList.push(gift);
                                        } else {
                                            product.giftList.splice(ind, 1);
                                            ind--;
                                        }
                                        // if (gift.checked && gift.optionType === 2 && gift.isUnScope && !unScopeGift){
                                        //     unScopeGift = `${store.name}固定赠品${gift.giftName}无经营范围`;
                                        // } else if (gift.checked && gift.stock >= gift.quantity){
                                        //     giftList.push(gift)
                                        // } else if (gift.optionType === 2 && gift.stock < gift.quantity && gift.isUnScope === false) {
                                        //     fixedGift.push(gift.giftName);
                                        // }  else {
                                        //     product.giftList.splice(ind, 1);
                                        //     ind--;
                                        // }
                                    }
                                    // 组装店铺商品-满减
                                    storeCartObj.groupProductList.push({
                                        id: product.productSid,
                                        price: product.price,
                                        quantity: product.quantity,
                                        giftList: giftList
                                    })
                                    item.groupProductList.push(groupProduct)
                                }
                            })
                        })
                        store.cart.packageProductList && store.cart.packageProductList.forEach((packageProduct, i) => {
                            if (packageProduct.checked){
                                paramsFlag = true;
                                // 组装额外赠品接口参数
                                arr.push({
                                    userSid: store.userSid,
                                    id: packageProduct.packageId,
                                    quantity: packageProduct.packageQuantity
                                })
                                // 组装商品的赠品参数
                                const giftList = []
                                for (let ind = 0; ind < packageProduct.giftList.length; ind++) {
                                    const gift = packageProduct.giftList[ind];
                                    if (gift.checked) {
                                        giftList.push(gift);
                                    } else {
                                        packageProduct.giftList.splice(ind, 1);
                                        ind--;
                                    }
                                    // if (gift.checked && gift.optionType === 2 && gift.isUnScope && !unScopeGift){
                                    //     unScopeGift = `${store.name}固定赠品${gift.giftName}无经营范围`;
                                    // } else if (gift.checked && gift.stock >= gift.quantity){
                                    //     giftList.push(gift)
                                    // } else if (gift.optionType === 2 && gift.stock < gift.quantity && gift.isUnScope === false) {
                                    //     fixedGift.push(gift.giftName);
                                    // }  else {
                                    //     packageProduct.giftList.splice(ind, 1);
                                    //     ind--;
                                    // }
                                }
                                // 组装店铺商品-套餐
                                storeCartObj.packageProductList.push({
                                    id: packageProduct.packageId,
                                    price: packageProduct.discountPrice,
                                    quantity: packageProduct.packageQuantity,
                                    giftList: giftList
                                })
                                item.packageProductList.push(packageProduct)
                            }
                        })
                        if (paramsFlag) userCartParams.push(storeCartObj);
                        // 组成商品清单购物车商品信息
                        if (item.generalProductList.length !== 0 || item.packageProductList.length !== 0 || item.groupProductList.length !== 0){
                            goodsList.push(item)
                        }
                        totalAmountList.push(storeTotal)
                    })
                    // if (unScopeGift) {
                    //     Toast.clear();
                    //     this.isloading = false;
                    //     Toast(unScopeGift);
                    //     return;
                    // }
                    // if (fixedGift.length > 0) {
                    //     Toast.clear();
                    //     this.isloading = false;
                    //     Toast(`固定赠品${fixedGift.join(',')}库存不足`);
                    //     return;
                    // }
                    // 存储商品清单购物车商品
                    localStorage.setItem('goodsList', JSON.stringify(goodsList))
                    this.getExtraGift(arr, userCartParams)
                }, 500)
            }
        },
        /**
         * 去购物
         */
        goShopping(){
            this.$router.push('/menu/index')
        },
        // 点击更换赠品
        changeGift(item, index, ind, type) {
            this.replaceType = type;
            this.currentObj = { promotionLadderList: item.promotionLadderList, index, ind };
            this.replaceRadio = item.oldReplaceRadio !== '' ? item.oldReplaceRadio : item.promotionLadderList[0].level;
            this.replaceDialog = true;
        },
        // 选择活动阶梯
        changePromotionLadder(item) {
            this.promotionLadder = item;
        },
        // 确定活动阶梯
        savePromotionLadder() {
            const currentProductObj = this.storeList[this.currentObj.index].cart[this.replaceType][this.currentObj.ind];
            let n = 0
            this.promotionLadder.giftList && this.promotionLadder.giftList.forEach((gift, index) => {
                if (gift.stock < gift.quantity || gift.isUnScope) {
                    gift.checked = false;
                } else {
                    if (gift.optionType === 2) {
                        // 固定赠送
                        gift.checked = currentProductObj.checked;
                    } else {
                        // 选择赠送
                        if (n < this.promotionLadder.giftOption) {
                            gift.checked = currentProductObj.checked;
                            n++
                        } else {
                            gift.checked = false;
                        }
                    }
                }
            })
            currentProductObj.selectGiftOption = this.promotionLadder.selectGiftOption;
            currentProductObj.oldReplaceRadio = this.promotionLadder.level;
            currentProductObj.ladderTips = this.promotionLadder.promotionTips;
            currentProductObj.nextPromotionActivityTips = this.promotionLadder.nextPromotionActivityTips;
            currentProductObj.isShow = this.promotionLadder.isShow;
            currentProductObj.level = this.promotionLadder.level;
            currentProductObj.giftList = this.promotionLadder.giftList || [];
            currentProductObj.giftOption = this.promotionLadder.giftOption;
            this.storeList[this.currentObj.index].cart[this.replaceType][this.currentObj.ind] = currentProductObj;
            this.storeList = [...this.storeList]
            this.replaceDialog = false;
        },
        // 获取整件差数
        getMissNum(item) {
            const subPackNum = item.quantity % item.packageNum;// 已加购+当前加购数量，除整件(含多件)外单个发货剩余的数量
            const missMum = item.packageNum - subPackNum;// 满足整件还要加多少数量
            // 当前数量是否大于等于整件的95% && 库存是否大于整件购买后的数量
            const packageNumFlag = (subPackNum / item.packageNum) >= 0.95 && item.stock >= missMum + item.quantity;
            return packageNumFlag ? missMum : packageNumFlag;
        }
    }
}
</script>
