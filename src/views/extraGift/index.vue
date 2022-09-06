<template>
    <div class="box Page-index-extra" :style="{height: winHeight+'px'}">
        <van-tabs v-model="active">
            <van-tab title="全部优惠" />
            <van-tab title="已享优惠" />
            <van-tab title="凑单可享优惠" />
        </van-tabs>
        <div class="content-box">
            <div v-for="(item, aindex) in giftList" :key="aindex" class="list">
                <div class="head-row">
                    <div class="user-name">{{ item.userName }}</div>
                    <div class="toggle-btn" @click="toggleStore(item)">
                        {{ item.toggleFlag ? '收起' : '展开' }}<van-icon :name="item.toggleFlag ? 'arrow-up' : 'arrow-down'" />
                    </div>
                </div>
                <template v-for="(promotion, bindex) in item.promotionInfoGroupList">
                    <div
                        v-show="item.toggleFlag"
                        v-if="active===0||(active===1 && promotion.promotionLadderList[0].giftList)||(active===2 && !promotion.promotionLadderList[0].giftList)"
                        :key="bindex"
                        class="promotion-box"
                    >
                        <div class="promotion-tips" :style="!promotion.promotionLadderList[0].giftList?'borderBottom:0':''">
                            <h6>{{ promotion.currentLadder.level === -1 ? promotion.promotionLadderList[0].activityTypeDesc : promotion.currentLadder.activityTypeDesc }}</h6>
                            <div class="row-1">
                                <img src="@/assets/images/icon-gift.png" alt="">   
                                <div>{{ promotion.currentLadder.nextPromotionActivityTips||promotion.currentLadder.promotionTips }}</div>
                                <p
                                    v-show="promotion.currentLadder.isShow"
                                    class="goTogether"
                                    @click="goTogether(promotion.currentLadder.promotionId)"
                                >去凑单<img src="@/assets/images/go-together.png" alt=""></p>
                            </div>
                        </div>
                        <div v-if="promotion.currentLadder.giftList && active !==2" class="promotion-list">
                            <div class="tips">
                                <span v-if="promotion.currentLadder.level === -1">不参与活动、不需要赠品</span>
                                <span v-else-if="promotion.currentLadder.giftOption != null && promotion.currentLadder.giftOption > 0 && promotion.currentLadder.selectGiftOption > 0">请选择下列{{ promotion.currentLadder.giftOption }}种商品</span>
                                <span v-else>您可以选择下列赠品</span>
                                <p
                                    class="replace-gift-btn"
                                    @click="showLadderList(promotion, aindex, bindex)"
                                >换赠品
                                    <img src="@/assets/images/icon_red_down_arrow.png">
                                </p>
                            </div>
                            <div v-if="promotion.currentLadder.giftList.length" style="padding-bottom: .1rem">
                                <div v-for="(gift,cindex) in promotion.currentLadder.giftList" :key="cindex" class="gift-list">
                                    <van-checkbox
                                        v-model="gift.checked"
                                        :disabled="gift.stock < gift.quantity || promotion.currentLadder.level === -1 || gift.optionType === 2 || gift.isUnScope"
                                        @change="giftChecked($event, gift, aindex, bindex)"
                                    />
                                    <div style="position:relative">
                                        <img v-if="gift.presell" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" class="gift-presell" alt="">
                                        <image-load
                                            :is-product-img="true"
                                            class="img-box"
                                            default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png"
                                            :original-image="gift.giftImg"
                                            :item="gift"
                                        />
                                    </div>
                                    <div class="gift-info">
                                        <div class="floor-1">
                                            <font v-if="gift.expireStatus === 1" color="#FF4646">近效期-</font>
                                            <span>{{ gift.giftName }}</span>
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
                        </div>
                    </div>
                </template>
            </div>
        </div>
        <div class="btn-box">
            <van-button class="comfirmBtn" :loading="isloading" :loading-text="'正在加载中'" @click="comfirmGift"> 确定 </van-button>
        </div>
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
                        v-for="item in promotionLadderList"
                        :key="item"
                        :name="item.level"
                    >{{ item.promotionTips }}</van-radio>
                </van-radio-group>
            </div>
            <div class="submit-gift" @click="comfirmLadder">确 定</div>
        </van-popup>
    </div>
</template>

<script>
import imageLoad from '@/components/imageLoad/index' 
import Api from '@/api/product/cart'
import { Toast } from 'vant'
export default {
    name: 'ExtraGift',
    components: {
        imageLoad
    },
    data(){
        return {
            giftList: [],
            cartList: [],
            isloading: false,
            replaceDialog: false,
            replaceRadio: '',
            promotionLadderList: [],
            currIndex: '',
            currInd: '',
            active: 0
        }
    },
    computed: {
        winHeight(){
            return this.$store.getters.winHeight
        },
        userInfoScope: function(){
            return this.$store.getters.businessScope ? this.$store.getters.businessScope.userInfoScope : [];
        }
    },
    mounted(){
        this.giftList = JSON.parse(localStorage.getItem('extraGift'))
        this.cartList = JSON.parse(localStorage.getItem('cartList'))
        this.giftList.forEach((item) => {
            this.$set(item, 'toggleFlag', true);
            item.promotionInfoGroupList.forEach(promotion => {
                promotion.promotionLadderList.forEach((ladder, ind) => {
                    const giftOption = ladder.giftOption
                    let n = 0
                    ladder.selectGiftOption = 0;
                    ladder.giftList && ladder.giftList.forEach((gift, i) => {
                        gift.isUnScope = this.isUnScope(item.userSid, gift.businessScope);
                        if (gift.stock < gift.quantity || gift.isUnScope) {
                            this.$set(gift, 'checked', false);
                        } else {
                            if (gift.optionType === 2) {
                                this.$set(gift, 'checked', true)
                            } else {
                                ladder.selectGiftOption++;
                                if (n < giftOption){
                                    this.$set(gift, 'checked', true)
                                    n++
                                } else {
                                    this.$set(gift, 'checked', false)
                                }
                            }
                        }
                    })
                    if (ind === 0) promotion.currentLadder = ladder;
                })

                // 添加不使用优惠阶梯
                const flag = promotion.promotionLadderList.filter(item => item.level === -1)[0];
                if (promotion.promotionLadderList.length && !flag) {
                    const obj = Object.assign({}, promotion.promotionLadderList[0], {
                        promotionTips: '不参与活动、不需要赠品',
                        nextPromotionActivityTips: '不参与活动、不需要赠品',
                        isShow: false,
                        level: -1,
                        giftList: []
                    })
                    promotion.promotionLadderList.push(obj);
                }
            })
        })
    },
    methods: {
        giftChecked(e, gift, a, b){
            gift.checked = e
            let checkedNum = 0
            let giftOption = 0
            giftOption = this.giftList[a].promotionInfoGroupList[b].currentLadder.giftOption
            this.giftList[a].promotionInfoGroupList[b].currentLadder.giftList.forEach(gift => {
                if (gift.checked && gift.optionType !== 2 && gift.stock >= gift.quantity && gift.isUnScope === false) checkedNum++;
            })
            if (checkedNum > giftOption){
                Toast("您选择的赠品超过可选数量")
                gift.checked = false
            }
        },
        comfirmGift(){
            this.isloading = true
            const giftList = JSON.parse(JSON.stringify(this.giftList));
            // const fixedGift = [];
            // const unScopeGift = '';
            giftList.forEach((item, idx) => {
                const extraGift = []
                item.promotionInfoGroupList.forEach(promotion => {
                    if (promotion.currentLadder.giftList) {
                        for (let i = (promotion.currentLadder.giftList.length - 1); i >= 0; i--){
                            const gift = promotion.currentLadder.giftList[i];
                            if (gift.checked) {
                                extraGift.push(gift);
                            } else {
                                promotion.currentLadder.giftList.splice(i, 1);
                            }
                            // if (gift.checked && gift.optionType === 2 && gift.isUnScope && !unScopeGift) {
                            //     unScopeGift = `${item.userName}固定赠品${gift.giftName}无经营范围`;
                            // } else if (gift.checked && gift.stock >= gift.quantity){
                            //     extraGift.push(gift)
                            // } else if (gift.optionType === 2 && gift.stock < gift.quantity) {
                            //     fixedGift.push(gift.giftName);
                            // } else {
                            //     promotion.currentLadder.giftList.splice(i, 1)
                            // }
                        }
                    }
                })
                // 订单确认组装额外赠品参数
                this.cartList.forEach(store => {
                    if (store.userSid === item.userSid) store.giftList = extraGift;
                });
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
            // 存储选中的额外赠品
            localStorage.setItem('extraGift', JSON.stringify(giftList))
            if (this.$route.query.type === 'preSale') {
                setTimeout(() => {
                    Api.confirmBuy(this.cartList).then(({ data }) => {
                        localStorage.setItem('cartInfo', JSON.stringify(data.data))
                        this.$router.push('/order/comfirmOrder?type=preSale')
                        this.isloading = false
                    }).catch(() => {
                        this.isloading = false
                    })
                }, 500)
            } else {
                Api.comfirmCart(this.cartList).then(({ data: { data }}) => {
                    localStorage.setItem('cartInfo', JSON.stringify(data))
                    this.$router.push('/order/comfirmOrder')
                    this.isloading = false
                }).catch(() => {
                    // this.cartList.pop()
                    this.isloading = false
                })
            }
        },
        // 打开阶梯选择列表
        showLadderList(item, index, ind) {
            this.replaceDialog = true;
            this.currIndex = index;
            this.currInd = ind;
            this.replaceRadio = item.currentLadder.level;
            this.promotionLadderList = item.promotionLadderList;
        },
        // 确定阶梯
        comfirmLadder() {
            const currentPromotion = this.giftList[this.currIndex].promotionInfoGroupList[this.currInd];
            const promotionLadderList = currentPromotion.promotionLadderList;
            let n = 0
            currentPromotion.currentLadder.giftList.forEach((gift) => {
                if (gift.stock < gift.quantity || gift.isUnScope) {
                    gift.checked = false;
                } else {
                    if (gift.optionType === 2) {
                        // 固定赠送
                        gift.checked = true;
                    } else {
                        // 选择赠送
                        if (n < currentPromotion.currentLadder.giftOption) {
                            gift.checked = true;
                            n++
                        } else {
                            gift.checked = false;
                        }
                    }
                }
            })
            currentPromotion.currentLadder = promotionLadderList.filter(item => item.level === this.replaceRadio)[0];
            currentPromotion.selectGiftOption = currentPromotion.currentLadder.giftList.filter(item => item.optionType !== 2).length;
            this.giftList[this.currIndex].promotionInfoGroupList[this.currInd] = currentPromotion;
            this.giftList = [...this.giftList];
            this.replaceDialog = false;
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
         * 去凑单
         */
        goTogether(id){
            this.$router.push({ path: "/product/collectOrders", query: { type: 1, sid: id }});
        },
        // 点击展开、收缩门店
        toggleStore(item){
            item.toggleFlag = !item.toggleFlag;
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
.Page-index-extra {
    overflow: hidden;
    display: flex;
    flex-direction: column;
    background: #F1F1F1;
    box-sizing: border-box;
    &.box {
        .list:last-child {
            border: none;
        }
        .content-box{
            flex: 1;
            overflow-y: auto;
            .list {
                border-radius: .16rem;
                background: #ffffff;
                margin: .24rem .16rem;
                .head-row{
                    display: flex;
                    padding: .4rem .28rem;
                    .user-name{
                        flex: 1;
                        padding-right: .2rem;
                        font-size: .28rem;
                        line-height: .4rem;
                        font-weight: 600;
                    }
                    .toggle-btn {
                        display: flex;
                        align-items: center;
                        font-size: .24rem;
                        height: .34rem;
                        color: #BBBBBB;
                        .van-icon {
                            color: #666666;
                            margin-left: .06rem;
                        }
                    }
                }
                .promotion-box {
                    border-top: .02rem solid #EEEEEE;
                    .promotion-tips{
                        padding: .38rem .28rem;
                        border-bottom: .02rem solid #EEEEEE;
                        h6{
                            font-size: .32rem;
                            margin-bottom: .28rem;
                        }
                        .row-1 {
                            display: flex;
                            img {
                                width: .64rem;
                                height: .36rem;
                                margin-right: .2rem;
                            }
                            div {
                                flex: 1;
                                overflow: hidden;
                                font-size: .24rem;
                                color: #666666;
                            }
                            .goTogether {
                                color: #FF6E00;
                                font-size: 0.28rem;
                                margin-left: 0.16rem;
                                img{
                                    width: .12rem;
                                    height: .2rem;
                                    margin-left: .12rem;
                                }
                            }
                        }
                    }
                    .promotion-list {
                        padding: 0 .24rem 0 .28rem;
                        background: #FAFAFA;
                        border-bottom-right-radius: .16rem;
                        border-bottom-left-radius: .16rem;
                        .tips {
                            display: flex;
                            justify-content: flex-end;
                            padding: .3rem 0;
                            font-size: .24rem;
                            span{
                                flex: 1;
                                color: #666666;
                            }
                            .replace-gift-btn{
                                width: 1.44rem;
                                height: .52rem;
                                line-height: .52rem;
                                background: #FFFFFF;
                                color: #666666;
                                border-radius: .22rem;
                                padding-left: .14rem;
                                font-size: .28rem;
                                img{
                                    width: .2rem;
                                    height: .2rem;
                                    margin-left: .08rem;
                                    margin-right: .1rem;
                                }
                            }
                        }

                        .gift-list {
                            display: flex;
                            align-items: center;
                            position: relative;
                            margin-bottom: .28rem;
                            .van-checkbox {
                                .van-checkbox__icon {
                                    width: .32rem;
                                    height: .32rem;
                                    i.van-icon{
                                        font-size: .24rem;
                                        line-height: .28rem;
                                    }
                                }
                            }
                            .gift-presell{
                                width: .4rem;
                                position: absolute;
                                left: 0;
                                top: 0;
                                z-index: 2;
                            }
                            .img-box {
                                width: .60rem;
                                height: .60rem;
                                margin-right: .28rem;
                                margin-left: .32rem;
                                img {
                                    width: .60rem;
                                    height: .60rem;
                                    margin-right: .20rem;
                                }
                            }

                            .gift-info {
                                flex: 1;
                                overflow: hidden;
                                .floor-1 {
                                    @extend %textOver;
                                    padding-bottom: .08rem;                                
                                    color: #666666;
                                    font-size: .24rem;
                                }

                                .floor-2 {
                                    color: #999999;
                                    font-size: .24rem;
                                    display: flex;
                                    align-items: center;
                                    justify-content: space-between;
                                    .num {
                                        padding-left: 1rem;
                                        display: flex;
                                        align-items: center;

                                        span:nth-child(1) {
                                            color: #CCCCCC;
                                            font-size: .32rem;
                                            padding-right: .08rem;
                                        }

                                        span:nth-child(2) {
                                            color: #999999;
                                            font-size: .22rem;
                                        }
                                    }
                                    .no-stock{
                                        padding-left: 1.05rem;
                                        span:nth-child(1) {
                                            color: #EE3E36;
                                            font-size: .20rem;
                                            padding-right: 0;
                                        }
                                    }
                                }
                            }

                        }
                    }
                }
            }
        }
    }
    .btn-box{
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 1.36rem;
        text-align: center;
        background: #fff;
        .comfirmBtn {
            width: 90%;
            border-radius: .44rem;
            font-size: .40rem;
            height: .88rem;
            line-height: .88rem;
            background: #ED3129;
            color: #ffffff;
            &.van-button--loading{
                .van-button__text{
                    display: none;
                }
            }
            .van-loading{
                padding-top: .2rem;
            }
        }
    }
    .van-tabs {
        .van-tabs__line{
            width: .28rem!important;
            height: .06rem;
        }
        .van-tabs__nav--line .van-tab--active .van-tab__text{
            color: #333333;
        }
    }
}
.replace-gift-popup{
    .popup-content{
        position: relative;
        width: 100%;
        height: 100%;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/spec-bg.png') no-repeat;
        background-size: 100% auto;
        padding-bottom: 1.2rem;
        .title{
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: .4rem .28rem;
            letter-spacing: .02rem;
            color: #666666;
            font-size: .32rem;
            font-weight: 600;
        }
        .close-btn{
            width: .36rem;
            height: .36rem;
            text-align: center;
            line-height: .36rem;
            border-radius: 50%;
            background: #FFD29E;
            color: #FFFFFF;
        }
        .van-popup__close-icon--top-right{
            top: .56rem;
            font-size: .32rem;
        }
        
        .van-radio-group{
            max-height: 416rem;
            overflow: auto;
            padding: 0 .24rem 0 .32rem;
            border-bottom: .02rem solid #EEEEEE;
            .van-radio{
                height: 1rem;
                line-height: 1rem;
            }
            .van-radio__label{
                color: #999999;
                line-height: .4rem;
                font-size: .28rem;;
            }
            .van-radio[aria-checked=true]{
                .van-radio__label{
                    color: #333333;
                }
            }
            .van-icon{
                position: relative;
                width: .32rem;
                height: .32rem;
            }
            .van-icon-success::before{
                position: absolute;
                left: .06rem;
                top: .06rem;
                content: '';
                width: .16rem;
                height: .16rem;
                border-radius: 50%;
                background: #fff;
            }
        }
    }
    .submit-gift{
        position: absolute;
        bottom: .2rem;
        left: 50%;
        margin-left: -3.35rem;
        width: 6.7rem;
        height: .8rem;
        text-align: center;
        line-height: .8rem;
        font-size: .36rem;
        background: #ED3129;
        border-radius: .44rem;
        color: #fff;
    }
}
</style>
