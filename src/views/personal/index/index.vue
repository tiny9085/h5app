<template>
    <div class="Page-personal-index">
        <div :class="scrollHeight <= 1 ? 'top' : 'top top-1'">
            <div v-if="scrollHeight <= 1" class="top-bar">
                <div class="user-avatar">
                    <i class="van-image" />
                </div>
                <div v-if="userInfo" class="user-info">
                    <div class="text-1">{{ name }}</div>
                    <div class="text-2">
                        <span>{{ userInfo.clubName }}</span>
                        <span v-if="userInfo.clubs.length > 1" class="changeUser" @click="changeClub">切换</span>
                    </div>
                    <div class="useAgreement">
                        <!-- <router-link to="/account/service">用户协议</router-link> -->
                        <router-link to="/personal/setting">
                            <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/setting-o.png" size=".48rem" />
                        </router-link>
                    </div>
                </div>
            </div>
            <div v-else class="topBar">
                个人中心
                <div class="useAgreement">
                    <!-- <router-link to="/account/service">用户协议</router-link> -->
                    <router-link to="/personal/setting">
                        <van-icon name="https://imga.hnhcyy.com/fed/b2b-wechat/setting-o.png" size=".48rem" />
                    </router-link>
                </div>
            </div>
        </div>
        <div :class="scrollHeight <= 1 ? 'contant-box' : 'contant-box contant-box-1'">
            <div class="wallet box">
                <van-cell title="我的账户" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-wallet.png" is-link @click="$router.push({path:'/personal/balance',query:{active:0}})" />
                <van-grid column-num="3" clickable :border="false">
                    <van-grid-item @click="$router.push({path:'/personal/balance',query:{active:0}})">
                        <p>￥<span>{{ accountListAmount.balance || '0.00' }}</span></p>
                        <p class="textInfo">普通余额</p>
                    </van-grid-item>
                    <van-grid-item @click="$router.push({path:'/personal/balance',query:{active:2}})">
                        <p>￥<span>{{ specialListAmount.balance || '0.00' }}</span></p>
                        <p class="textInfo">专项款</p>
                    </van-grid-item>
                    <van-grid-item @click="$router.push({path:'/personal/balance',query:{active:1}})">
                        <p>￥<span>{{ rebateListAmount.balance || '0.00' }}</span></p>
                        <p class="textInfo">返利额</p>
                    </van-grid-item>
                </van-grid>
                <div class="empty" />
                <van-cell class="coupon" is-link>
                    <p>优惠券 <span>{{ myCouponCount }}</span> <span>张</span></p>
                    <p @click="$router.push('/personal/coupon')">去查看</p>
                </van-cell>
            </div>
            <div class="order-box box">
                <van-cell title="我的订单" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-order.png" is-link url="/#/personal/orderlist" value="查看全部订单" />
                <van-grid clickable :border="false">
                    <van-grid-item text="待付款" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-payment.png" :info="orderCount.status_1_count" @click="$router.push({path:'/personal/orderlist',query:{type:1}})" />
                    <van-grid-item text="待发货" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-ship.png" :info="orderCount.status_2_count" @click="$router.push({path:'/personal/orderlist',query:{type:2}})" />
                    <van-grid-item text="已发货" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-shipped.png" :info="orderCount.status_3_count" @click="$router.push({path:'/personal/orderlist',query:{type:3}})" />
                    <van-grid-item text="已收货" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-received.png" :info="orderCount.status_4_count" @click="$router.push({path:'/personal/orderlist',query:{type:4}})" />
                </van-grid>
                <div v-if="orderTrack != null" class="logistics-box" @click="showLogistics(orderTrack)">
                    <van-cell title="最新物流" url="" :value="orderTrack.shippingUpdateTime" />
                    <p class="order-info"><span>快递单号：</span>{{ orderTrack.shippingCode }}</p>
                    <div class="logistics-info-box">
                        <div class="logistics-icon">
                            <img src="https://imga.hnhcyy.com/fed/b2b-wechat/icon_shipped.png" alt="">
                            <!-- <p>{{ orderTrack.detail }}</p> -->
                            <p>{{ orderTrack.shippingStateDesc }}</p>
                        </div>
                        <div class="logistics-info">
                            <p>{{ orderTrack.detail }}</p>
                            <!-- <p>{{ orderTrack.shippingStateDesc }}</p> -->
                        </div>
                    </div>
                </div>
            </div>
            <div :class="orderTrack != null ? 'tools-box box' : 'tools-box-1 box'">
                <van-cell title="工具与服务" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-tools.png" url="" />
                <van-grid column-num="3" clickable :border="false">
                    <van-grid-item text="我的资质" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon_zizhi.png" @click="$router.push('/personal/qualification')" />
                    <van-grid-item text="经营范围" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon-zhangdan.png" @click="$router.push('/personal/range')" />
                    <van-grid-item text="领券中心" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon_lingquan.png" @click="$router.push('/couponList')" />
                    <van-grid-item text="意见反馈" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon_yijian.png" @click="$router.push('/personal/feedback')" />
                    <van-grid-item text="客户服务" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon_kefu.png" @click="$router.push('/personal/server')" />
                    <!-- <van-grid-item text="关于我们" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon_women.png" @click="$router.push({path: '/personal/about',query:{source:'h5',title: '关于我们'}})" /> -->
                    <van-grid-item
                        text="新品收集"
                        icon="https://imga.hnhcyy.com/fed/b2b-wechat/collect-new.png"
                        @click="$router.push({path: '/personal/collectNew',query:{source:'h5',title: '新品收集'}})"
                    />
                    <!-- <van-grid-item text="当前版本" icon="https://imga.hnhcyy.com/fed/b2b-wechat/icon_banben.png" /> -->
                </van-grid>
            </div>
            <div class="logout-box">
                <div class="btn-logout">
                    <van-button size="large" @click="logout">退出登录</van-button>
                </div>
            </div>
        </div>
        <div class="bottom" />

        <win-select-club ref="refSelectClub" />
    </div>
</template>

<script>
import WinSelectClub from '@/components/selectClub/Index'
import AccountApi from '@/api/account/login'
import Api from '@/api/personal/index'

export default {
    name: '',
    components: {
        WinSelectClub
    },
    data(){
        return {
            orderTrack: null,
            orderCount: {
                status_1_count: '',
                status_2_count: '',
                status_3_count: '',
                status_4_count: ''
            },
            name: '',
            specialListAmount: { balance: '0.00' },
            rebateListAmount: { balance: '0.00' },
            accountListAmount: { balance: '0.00' },
            myCouponCount: 0,
            scrollHeight: 0
        }
    },
    computed: {
        userInfo: function(){
            return this.$store.getters.userInfo
        }
    },
    created() {
        window.addEventListener('scroll', this.scroll)
        this.$store.commit("setHasToolbar", true)
    },
    mounted(){
        /**
         * 获取用户信息
         */
        Api.fetchUserInfo().then(({ data: { data }}) => {
            this.name = data.name
        })
        this.getOrderCount()
        this.getUserBalance()
        this.getMycouponNum()
    },
    methods: {
        scroll: function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            this.scrollHeight = scrollTop
        },
        /**
         * 切换俱乐部
         */
        changeClub() {
            this.$refs['refSelectClub'].open(this.userInfo.clubs || [], club => {
                Api.changeClub({ club: club }).then(res => {
                    const userInfo = this.$store.getters.userInfo
                    userInfo.currentType = club
                    this.$store.commit('setUserInfo', userInfo)
                    this.$store.commit('setCartNum')
                    this.getOrderCount()
                    this.getUserBalance()
                    this.getMycouponNum()
                })
            })
        },
        /**
         * 获取订单数量及最新物流信息
         */
        getOrderCount(){
            this.orderCount.status_1_count = ''
            this.orderCount.status_2_count = ''
            this.orderCount.status_3_count = ''
            this.orderCount.status_4_count = ''
            Api.getOrderCount({}).then(({ data: { data }}) => {
                this.orderTrack = data.orderTrack
                data.statusCount.forEach(element => {
                    this.orderCount['status_' + element.order_status + '_count'] = element.count > 99 ? '99+' : element.count
                });
            })
        },
        /**
         * 查询会员余额、返利、专项款
         */
        getUserBalance() {
            this.accountListAmount = { balance: '0.00' };
            this.rebateListAmount = { balance: '0.00' };
            this.specialListAmount = { balance: '0.00' };
            Api.getInfo().then(res => {
                const data = res.data.data;
                data.forEach(v => {
                    switch (v.type - 0) {
                        case 0:
                            this.accountListAmount = v || {};
                            break;
                        case 2:
                            this.specialListAmount = v || {};
                            break;
                        case 1:
                            this.rebateListAmount = v || {};
                            break;
                    }
                })
            })
        },
        /**
         * 获取我的优惠券总数
         */
        getMycouponNum(){
            Api.fetchCouponCount().then(({ data: { data }}) => {
                this.myCouponCount = data
            })
        },
        /**
         * 跳转最新物流
         */
        showLogistics(item){
            this.$router.push({ path: `/order/newLogistics?logisticsId=${item.shippingCode}&expressNum=${item.expressNum}` })
        },
        /**
         * 退出登录
         */
        logout(){
            AccountApi.logout({}).then(({ data }) => {
                localStorage.removeItem('checkedStore');
                localStorage.removeItem('cartList');
                localStorage.removeItem('extraGift');
                localStorage.removeItem('gobackMergOrder');
                localStorage.removeItem('goodsLists');
                localStorage.removeItem('goodsList');
                localStorage.removeItem('cartInfo');
                localStorage.removeItem('giftList');
                localStorage.removeItem('qualificationStores');
                localStorage.removeItem('qualificationDetail');
                localStorage.removeItem('qftFlag');
                this.$store.commit('setUserInfo', null)
                this.$store.commit('setToken', null)
                this.$router.push('/account/login')  
            })
        }
    }
}
</script>

<style lang="scss">
.Page-personal-index {
    background: #F5F5F5;
    .van-info{
        color: #FF4646;
        background: #ffffff;
        border:1px solid #FF4646 ;
        border-radius: 50%;
    }
    .top{
        position: fixed;
        width: 100%;
        transform: translateZ(0);
        &.top-1{
            z-index: 9;
        }
        .topBar{
            height: .88rem;
            background: #ED3129;
            font-size: .36rem;
            color: #ffffff;
            font-weight: 600;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            .useAgreement{
                position: absolute;
                top: .22rem;
                right: .29rem;
                font-size: .24rem;
                font-weight: 400;
                .van-icon__image {
                    width: 0.48rem;
                    height: 0.48rem;
                }
            }
        }
        .top-bar {
            height: 3.16rem;
            transition: all 1s;
            background-image: url(https://imga.hnhcyy.com/fed/b2b-wechat/personal_top_bg.png?v=1) ;
            background-size: cover;
            padding: 0 .2rem 0 .18rem;
            position: relative;
            border-radius: 0 0 1rem 1rem / .16rem;
            .user-avatar {
                float: left;
                width: 1.2rem;
                height: 1.2rem;
                border-radius: 50%;
                background: #FFF;
                overflow: hidden;
                margin-top: 0.68rem;
                margin-right: 0.24rem;
                .van-image {
                    width: 1.2rem;
                    height: 1.2rem;
                    background: url(https://imga.hnhcyy.com/fed/b2b-wechat/icon-avatar-lsx.png) 50% 50% no-repeat;
                    background-size: contain;
                }
            }
            .user-info {
                float: left;
                padding-top: 0.8rem;
                color: #FFF;
                font-weight: 500;
                .text-1 {
                    display: block;
                    font-size: .32rem;
                    width: 4.16rem;
                    text-overflow: -o-ellipsis-lastline;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    line-clamp: 2;
                    -webkit-box-orient: vertical;
                    font-weight: 500;
                    margin-bottom: 0.12rem;
                }
    
                .text-2 {
                    display: flex;
                    align-items: center;
                    font-size: .29rem;
                    font-weight: 500;
                    .changeUser {
                        width: 0.76rem;
                        height: 0.4rem;
                        line-height: 0.4rem;
                        font-size: .24rem;
                        color: #6E3900;
                        background: transparent;
                        border-radius: 20px;
                        margin-left: .16rem;
                        background: #FFF3A4;
                        text-align: center;
                        font-weight: 500;
                    }
                }
                .useAgreement{
                    position: absolute;
                    top: .66rem;
                    right: .29rem;
                    font-size: .24rem;
                    font-weight: 400;
                    .van-icon__image {
                        width: 0.48rem;
                        height: 0.48rem;
                    }
                }
            }
        }
    }
    .contant-box{
        padding-top: 2.7rem;
        .van-cell__left-icon{
            margin-left: 0.06rem;
        }
        .van-cell__right-icon{
            font-size: 0.26rem;
        }
        .van-cell__title{
            font-size: 0.32rem;
            font-weight: 500;
            color: #666;
        }
        .van-cell__value{
            font-size: 0.24rem;
            color: #666;
        }
        &.contant-box-1{
            padding-top: 2rem;
            .wallet{
                top: -.8rem;
            }
            .order-box{
                top: -.6rem;
            }
            // .logistics-box{
            //     top: -.4rem;
            // }
            .tools-box, .tools-box-1{
                padding-top: 0;
                top: -.4rem;
                &.tools-box-1{
                    top: -.4rem;
                }
            }
            .logout-box{
                top: -0.22rem;
            }
        }
    }

    .box{
        margin: 0 .2rem;
        border-radius: .2rem;
        position: relative;
        overflow: hidden;
        .van-cell{
            color: #666666;
            padding: .2rem;
            .iconfont{
                margin-right: .08rem;
            }
        }
    }
    .van-icon__image{
        height: 0.36rem;
        width: 0.36rem;
        margin-top: 0.06rem;
    }
    .wallet{
        top: -.4rem;
        .van-cell{
            .icon-wallet{
                font-size: .52rem;
                color: #ED3129;
            }
        }
        .van-grid{   
            background: #fff;  
            border-bottom: 1px solid #eeeeee; 
            .van-grid-item__content{
                padding: 6px 0px 22px 0px;
            }                           
            p:nth-child(1){
                font-size: 0.32rem;
                color: #666;
                margin-bottom: 0.06rem;
                // display: flex;
                span{
                    font-size: 0.36rem;
                    color: #333;
                    font-weight: 600;
                    // overflow: hidden;
                    // text-overflow: ellipsis;
                    // white-space: nowrap;
                    // width: 102px;
                    // display: block;
            }
            }
            p:nth-child(2){
                font-size: 0.24rem;
                color: #999;
            }
        }
        .empty{
            height: 0.22rem;
            width: 100%;      
            background:#FBFBFB;
            position: absolute;
        }

        .coupon{
            background-color: #FBFBFB;
            .van-cell{
                padding: 0;
            }
            p:nth-child(1){
                margin-left: 0.09rem;
                color: #999;
                font-size: 0.29rem;
                float: left;
                letter-spacing: 2px;
                span:nth-child(1){
                    font-size: 0.32rem;
                    font-weight: 500;
                    color: #333;
                    letter-spacing: 1px;
                }
                span:nth-child(2){
                    font-size: 0.24rem;
                    color: #666;
                }
            }
             p:nth-child(2){
                color: #666666;
                font-size: 0.24rem;
                float: right;
            }
        }
    }

    .order-box{
        background: #fff;
        // height: 5.34rem;
        top: -.2rem;
        .van-cell{
            .van-icon__image{
            height: 0.36rem;
            width: 0.36rem;
        }
        .icon-order{
                font-size: .52rem;
                color: #2BA56B;
        }
        }
        .van-grid{
            font-size: .24rem;
            background: #fff;
            .van-grid-item__content{
                padding: 6px 0px 22px 0px;
                // padding: 0;
            } 
            .van-grid-item__text{
                color: #666;
            }
            .van-icon__image{
                height: 0.56rem;
                width: 0.56rem;
            }
            .iconfont{
                font-size: .52rem;
                color: #999999;
                margin-bottom: .2rem;
            }
        }
        .logistics-box{
            background: #fff;
            padding: 0 0.16rem 0.16rem 0.16rem;
        .van-cell{
            background: #F7F7F7;
            padding: 0.12rem;
            border-top-left-radius: 0.12rem;
            border-top-right-radius: 0.12rem; 
            .van-cell__title{
                margin-left: 0.16rem;
                color: #BBB;
                font-size: 0.24rem;
            }
            .van-cell__value{
                color: #999;
                margin-right: 0.3rem;
            }
            .icon-time{
                font-size: .4rem;
                color: #ED3129;
            }
        }

        .order-info{
            font-size: .26rem;
            color: #999;
            padding: .12rem .12rem .12rem 0.01rem;
            background:#F0F0F0;
            span{
                color: #666;
                font-weight: 500;
                padding-left: .1rem;
                margin-left: 0.16rem;
            }
        }
        .logistics-info-box{
            background: #F7F7F7;
            border-bottom-left-radius: 0.12rem;
            border-bottom-right-radius: 0.12rem;
            padding: 0.3rem 0 0.3rem 0.2rem;
            .logistics-icon{
                width: 1.2rem;
                height: 0.4rem;
                text-align: center;
                line-height: 0.4rem;
                margin-left: 0.06rem;
                img{
                    height: 0.4rem;
                    width: 0.4rem;
                    float: left;
                }
                p{
                     color: #0096FF;
                     float: right;
                     font-size: 0.29rem;
                     
                }
            }
            .logistics-info{
                padding-right: 0.3rem;
                p{
                    color: #666;
                    font-size: 0.26rem;
                    margin-left: 0.1rem;
                    margin-top: 0.06rem;
                    overflow: hidden;
                    text-overflow:ellipsis;
                    white-space: nowrap;
                }
            }
        }
    }
    }

    .tools-box, .tools-box-1{
        background: #ffffff;
        // height: 4.98rem;
        padding-top: .2rem;
        &.tools-box-1{
            padding-top: 0;
        }
        .van-cell{
            .van-icon__image{
                height: 0.36rem;
                width: 0.36rem;
            }
            .icon-tools{
                font-size: .48rem;
                color: #ED3129;
            }
        }
        .van-grid{
            .van-grid-item__text{
                color: #666666;
                font-size: 0.29rem;
            }
            .van-icon__image{
                height: 0.64rem;
                width: 0.64rem;
            }
        }
    }
    
    .logout-box {
        padding-bottom: 1rem;
        position: relative;
        .btn-logout {
            padding: 0 .2rem;
            .van-button {
                border: none;
                height: 45px;
                line-height: 45px;
                border-radius: .08rem;
                .van-button__text{
                    color: #666;
                    font-size: .32rem;
                }
            }
        }
    }
    .bottom{
        background: #f5f5f5;
    }
    .van-cell::after{
        border-bottom: none;
    }
}
</style>
