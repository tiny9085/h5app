<template>
    <div>
        <van-nav-bar
            v-if="hasNavbar"
            :title="title"
            :left-text="leftText"
            :right-text="$store.getters.cartRightText"
            fixed
            :left-arrow="hasArrow"
            :class="[$store.getters.cartRightText==='反馈记录'?'feedtext':'']"
            @click-left="onClickLeft"
            @click-right="onClickRight"
        >
            <template #title>
                <template v-if="pageName === 'collectOrders'">
                    <input v-model="keyword" placeholder="在结果中搜索" class="search-collect-orders-goods" type="text" @input="searchFn">
                </template>
                <template v-else>
                    {{ title }}
                </template>
            </template>
        </van-nav-bar>
        <win-select-club ref="refSelectClub" />
    </div>
</template>

<script>
import WinSelectClub from '@/components/selectClub/Index'
import Api from '@/api/personal/index'
import { GetQueryString } from '@/utils/util'
export default {
    name: 'NavBar',
    components: {
        WinSelectClub
    },
    data() {
        return {
            pageName: this.$route.name,
            hasArrow: true,
            keyword: '',
            timer: null
        }
    },
    computed: {
        hasNavbar: function() {
            return this.$route.meta.hasNavbar
        },
        title: function() {
            let title = ''
            if (this.$route.meta.title === 'messageItem') {
                switch (this.$route.params.type) {
                    case 'systemQty':
                        title = '系统消息';
                        break;
                    case 'promotionQty':
                        title = '优惠促销';
                        break;
                    case 'orderQty':
                        title = '订单消息';
                        break;
                    case 'arrivalQty':
                        title = '到货通知';
                        break;
                    case 'newProductQty':
                        title = '新品消息';
                        break;
                    case 'markUpQty':
                        title = '上涨通知';
                        break;
                }
                return title;
            } else if (this.$route.meta.title  === 'generaltitle') {
                switch (this.$route.query.changeType) {
                    case 0:
                        title = '普通余额';
                        break;
                    case 1:
                        title = '返利';
                        break;
                    case 2:
                        title = '专项款';
                        break;
                }
                return title;
            } else if (this.$route.query.title){
                return this.$route.query.title
            } else {
                return this.$route.meta.title
            }
        },
        leftText: function() {
            return this.$route.meta.leftText
        },
        specialYLLTObj() {
            return this.$store.getters.specialYLLTObj
        },
        userInfo: function(){
            return this.$store.getters.userInfo
        }
    },
    watch: {
        '$route.name': function(val, oldVal){
            this.pageName = val;
            if (['Home', 'menu', 'quick', 'promotion', 'newGoods', 'GoodsDetail', 'materials', 'preSale', 'getTogether', 'search', 'recom-goods'].indexOf(val) > -1) {
                this.$store.commit("setCartAdded");
            }
            switch (val) {
                case 'cart':
                    this.$store.commit('setCartRightText', '管理')
                    break;
                case 'CouponList':
                    this.$store.commit('setCartRightText', '我的优惠券')
                    break;
                case 'Feedback':
                    this.$store.commit('setCartRightText', '反馈记录')
                    break;
                case 'qualification':
                    this.$store.commit('setCartRightText', '更新记录')
                    break;
                case 'balance':
                    this.$store.commit('setCartRightText', '分店账户')
                    break;
                case 'QuickFilter':
                    this.$store.commit('setCartRightText', '去购物车')
                    break;
                case 'collectNew':
                    this.$store.commit('setCartRightText', '填报记录')
                    break;
                default :
                    this.$store.commit('setCartRightText', '')
                    break;
            }
        }
    },
    mounted() {

    },
    methods: {
        onClickLeft() {
            if (this.$route.name === 'orderlist'){
                this.$router.push('/personal/index')
            } else if (this.$route.name === 'mergeDetail'){
                localStorage.setItem("gobackMergOrder", true)
                this.$router.go(-1)
            } else if (this.$route.name === 'AcitvitySubject' && !this.$route.query.comefrom){
                this.$router.push('/activity/index?activeTabs=2&source=h5')
            } else if (this.$route.name === 'qualificationNote') {
                this.$router.push('/personal/qualification')
            } else if (this.$route.name === 'qualification') {
                this.$router.push('/personal/index')
            } else if (['SpecialYLLT', 'productQrCodeDetail', 'QuickFilter', 'activity', 'preSale'].indexOf(this.$route.name) > -1) {
                this.$router.push('/')
            } else if (this.$route.name === 'SpecialYLLTPaySuccess') {
                this.$store.commit('setQrCodeParams', {});
                if (this.$store.getters.notPayMember.length === 0) {
                    this.$router.push('/')
                } else {
                    this.$router.go(-1)
                }
            } else if (this.$route.name === 'SpecialYLLTPay') {
                if (this.specialYLLTObj.isApp) {
                    this.$router.push('/activity/YLLT')
                } else {
                    this.$router.push('/activity/YLLT?source=h5&erpCode=' + this.specialYLLTObj.erpCode)
                }
            } else if (this.$route.name === 'collectOrders') {
                if (this.$route.query.type - 0 === 2) {
                    this.$router.push('/personal/coupon');
                } else {
                    this.$router.push('/cart/index');
                }
            } else if (this.$route.name === 'coupon') {
                this.$router.push('/personal/index');
            } else if (this.$route.name === 'BiSignUpYLLT' && GetQueryString("isFromJYGW") === 'wx'){
                this.$router.push('/account/login?isFromJYGW=wx')
            }
            else {
                this.$router.go(-1)
            }
        },
        onClickRight() {
            switch (this.$route.name){
                case 'Feedback':
                    this.$router.push('/personal/feedlist')
                    break;
                case 'balance':
                    this.$router.push('/personal/subAccount')
                    break;
                case 'qualification':
                    this.$router.push('/personal/qualification/note')
                    break;
                case 'collectNew':
                    this.$router.push('/personal/newRecord')
                    break;
                case 'BiSignUpYLLT':
                    this.changeClub()
                    break;
                default : 
                    this.$store.commit('setNavbarRightClick')
                    break
            }
        },
        // 活动凑单搜索
        searchFn() {
            if (this.timer) clearTimeout(this.timer);
            this.timer = setTimeout(() => {
                this.$store.commit('setNavBarKeyword', this.keyword);
            }, 1000)
        },
        // 切换俱乐部
        changeClub() {
            this.$refs['refSelectClub'].open(this.userInfo.clubs || [], club => {
                Api.changeClub({ club: club }).then(res => {
                    const userInfo = this.$store.getters.userInfo
                    userInfo.currentType = club
                    this.$store.commit('setUserInfo', userInfo)
                })
            })
        }
    }
}
</script>

<style lang="scss">
.app-wrapper{
    .van-nav-bar {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 8888 !important;
        transform: translateZ(0);
        // border-bottom:1px solid #eee ;
    }
    .van-icon-arrow-left:before {
        color: #666666;
        font-size: 0.48rem;
    }
    .van-nav-bar__title {
        font-size: 0.36rem;
        color: #333333;
        font-weight: 600;
    }
    .van-nav-bar__text {
        font-size: 0.28rem;
        color: #666;
        font-weight: 400;
    }
    [class*="van-hairline"]::after {
        border: 1px solid #e4e4e4;
        opacity: 0;
    }
    .feedtext .van-nav-bar__right{
      .van-nav-bar__text{
          color:#666666;
          font-size:0.28rem;  
        }
    }
    .search-collect-orders-goods{
        font-weight: normal;
        outline: none;
        border: none;
        height: .68rem;
        line-height: .68rem;
        background: #F3F4F6;
        border-radius: .08rem;
        padding-left: .16rem;
    }
}
</style>

