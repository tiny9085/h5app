<template>
    <div class="order-box" :style="[{'height': winHeight + 'px'}]">
        <div class="order-title">
            <van-tabs :active="active" sticky @click="onChange">
                <!-- <van-tab title="多门店订单" :title-style="$store.getters.userInfo.stores.length === 1 ? 'flex-basis: 0' : ''" /> -->
                <van-tab :title-style="$store.getters.userInfo.stores.length === 1 ? 'flex-basis: 0;' : 'flex-basis: 28%;'">
                    <div v-if="$store.getters.userInfo.stores.length !== 1" slot="title">多门店订单</div>
                </van-tab>
                <van-tab title="全部订单" />
                <van-tab title="待付款" />
                <van-tab title="待发货" />
                <van-tab title="已发货" />
                <van-tab title="已收货" />
            </van-tabs>
        </div>
        <div class="order-list">
            <div class="search-order">
                <img src="@/assets/images/icon-search-order.png" alt="">
                <input
                    v-model="keyWord"
                    placeholder="请输入商品名称/订单编号"
                    @keyup.enter="searchOrder"
                >
                <van-icon
                    v-show="keyWord"
                    name="close"
                    color="#bbbbbb"
                    size=".3rem"
                    @click="emptySearch"
                />
                <template v-if=" $store.getters.userInfo.stores.length !== 1">
                    <div v-if="indexActive !== 0" class="filter-box" @click="filterStore">
                        <img src="https://imga.hnhcyy.com/fed/b2b-wechat/filter-icon.png" alt="">
                        <span>筛选</span>
                    </div>
                </template>
            </div>
            <div v-if="orderLists.length > 0 || manyStoreOrderList.length > 0" class="have-data">
                <div v-if="orderLists.length > 0">
                    <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦!'" :offset="50" @load="onLoad">
                        <template v-for="(item,index) in orderLists">
                            <div :key="index" class="order-li clearfix" :style="index===0?'margin-top:0':''">
                                <h6 v-if="$store.getters.userInfo.stores.length > 1" class="title border-bottom">{{ item.userName }}</h6>
                                <div class="title">
                                    <div class="l">
                                        <span><i>订单编号：</i><em>{{ item.orderId }}</em></span>
                                        <span class="btn-copy" style="display:inline-block" @click="copy(item.orderId)">复制</span>
                                    </div>
                                    <div class="r">
                                        <span :class="item.orderStatus!== 6 ? 'orange' : ''">{{ item.orderStatusDesc }}</span>
                                    </div>
                                </div>
                                <div v-if="item.orderType === 4 && item.orderGeneralDetailList.length !== 0" class="preSaleTime">
                                    <img src="@/assets/images/icon_presale.png">
                                    <span v-if="item.predictShippingDate">此订单包含预售商品，预计{{ item.predictShippingDate }}前发货</span>
                                    <span v-else>此订单包含预售商品，发货时间待定</span>
                                </div>
                                <div class="item-list" @click="showOrderDetail(item, 'order')">
                                    <div style="display:flex;">
                                        <div v-for="(img,index1) in item.imgLists" :key="index1" class="img-box">
                                            <div v-if="index1<5" class="item-li">
                                                <img v-if="img.saleType === 2" class="preSaleImg" src="https://imga.hnhcyy.com/fed/b2b-wechat/icon-yushou.png" alt="">
                                                <van-image :src="'https://imga.hnhcyy.com/'+img.productImg+'?x-oss-process=image/resize,m_fill,h_300,w_300/watermark,image_ZmVkL2IyYi1jb21tb24vc3lfMjAweDIwMC5wbmc=,t_100'">
                                                    <template v-slot:error>
                                                        <img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" alt="">
                                                    </template>
                                                </van-image>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- <div class="btn-all">
                                        <span>共{{ item.speciesNum }}件</span>
                                    </div> -->
                                </div>
                                
                                <div class="state-info">
                                    共<span class="total-count">{{ item.speciesNum }}</span>件商品 合计:
                                    <span>￥{{ (item.totalAmount || 0).toFixed(2) }}</span>
                                </div>
                                <!-- <van-button data-item="{{item}}" data-index="{{index}}" round wx:if="{{item.orderStatus == 4}}" bind:click="applyRefund">申请退款</van-button>
                                    <van-button data-item="{{item}}" data-index="{{index}}" round plain color="#ED3129" wx:if="{{item.orderStatus == 7}}">取消退款</van-button> -->
                                <div class="order-btns">
                                    <van-icon
                                        v-if="item.otherBtns && item.otherBtns.length"
                                        name="ellipsis"
                                        color="#cccccc"
                                        size=".36rem"
                                        @click="showMoreBtn(index)"
                                    >
                                        <div v-if="item.isShowMoreBtn" :class="['more-btn-box', item.otherBtns.length>1?'more-btn-box-2':'more-btn-box-1']">
                                            <div
                                                v-if="item.otherBtns.indexOf('取消订单') > -1"
                                                @click="cancelOrder(item,6)"
                                            >取消订单</div>
                                            <div
                                                v-if="item.otherBtns.indexOf('删除订单') > -1"
                                                @click="cancelOrder(item, 8)"
                                            >删除订单</div>
                                            <div
                                                v-if="item.otherBtns.indexOf('查看发票') > -1"
                                                @click="gotoInvoice(item.orderId)"
                                            >查看发票</div>
                                            <div
                                                v-if="item.otherBtns.indexOf('查看物流') > -1"
                                                @click="getLogic(item)"
                                            >查看物流</div>
                                        </div>
                                    </van-icon>
                                    <div v-if="item.btns" class="btn-box">
                                        
                                        <van-button
                                            v-if="item.btns.indexOf('取消订单') > -1"
                                            round
                                            @click="cancelOrder(item,6)"
                                        >取消订单</van-button>
                                        
                                        <van-button
                                            v-if="item.btns.indexOf('删除订单') > -1"
                                            round
                                            @click="cancelOrder(item,8)"
                                        >删除订单</van-button>

                                        <van-button
                                            v-if="item.btns.indexOf('查看发票') > -1"
                                            round
                                            @click="gotoInvoice(item.orderId)"
                                        >查看发票</van-button>

                                        <van-button
                                            v-if="item.btns.indexOf('查看物流') > -1"
                                            round
                                            @click="getLogic(item)"
                                        >查看物流</van-button>

                                        <!-- <van-button color="#ED3129" plain round @click="payAgin(item)">再来一单</van-button> -->
                                        <copy-order-btn
                                            v-if="item.btns.indexOf('再来一单') > -1"
                                            :item="item"
                                        />
                                        <van-button
                                            v-if="item.btns.indexOf('确认收货') > -1"
                                            color="#ED3129"
                                            round
                                            @click="cancelOrder(item,4)"
                                        >确认收货</van-button>

                                        <van-button
                                            v-if="item.btns.indexOf('支付订单') > -1"
                                            color="#ED3129"
                                            round
                                            @click="payOrder(item)"
                                        >支付订单</van-button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </van-list>
                </div>
                <div v-if="manyStoreOrderList.length > 0">
                    <van-list v-model="manyStoreLoading" :finished="manyStoreFinished" :finished-text="'我是有底线的'" :offset="50" @load="onLoadManyStore">
                        <template v-for="(item,index) in manyStoreOrderList">
                            <div :key="index" class="order-li" :style="index===0?'margin-top:0':''">
                                <div class="many-store-title border-bottom">
                                    <van-checkbox v-model="item.checked" icon-size="18" class="is-checked" @change="selectMainOrder($event ,item)" />
                                    <div class="dv">
                                        <span class="span" @click="goMergeDetail(item.mergeOrderId)">
                                            <i class="sub-title">多店订单编号：</i>
                                            <em>{{ item.mergeOrderId }}</em>
                                        </span>
                                        <span class="btn-copy" @click="copy(item.mergeOrderId)">复制</span>
                                    </div>
                                </div>
                                <div v-for="(store, idx) in item.userOrderList" :key="idx" class="many-store-list">
                                    <van-checkbox v-model="store.checked" icon-size="18" class="is-checked" @change="selectOrder($event, store, item)" />
                                    <div class="order-info-box" @click="showOrderDetail(store, 'mergOrder')">
                                        <div class="row row-1">
                                            <van-icon slot="icon" color="#ED3129" class-prefix="iconfont icon-yaodian" />
                                            <span class="store-name" :style="store.isMainShop?'max-width:4.1rem':''">{{ store.userName }}</span>
                                            <span v-if="store.isMainShop" class="main-store">主店</span>
                                            <span class="order-status" :style="store.orderStatus!== 6? 'color:#FF7005': ''">{{ store.orderStatusDesc }}</span>
                                        </div>
                                        <div class="row row-2">
                                            <span>订单编号：</span>
                                            <span>{{ store.orderId }}</span>
                                        </div>
                                        <div class="row row-3">
                                            <span>发票类型：</span>
                                            <span>{{ store.invoiceTypeDesc }}</span>
                                        </div>
                                        <div class="store-price-box">
                                            <p v-if="store.preferentialAmount" style="margin-bottom:.08rem;">优惠：
                                                <font style="font-size:.26rem">￥{{ (store.preferentialAmount||0).toFixed(2) }}</font>
                                            </p>
                                            <p class="price-info">
                                                <span>合计：<font>￥{{ (store.totalAmount || 0).toFixed(2) }}</font></span>
                                                <span>共<font class="margin-side">{{ store.speciesNum }}</font>件商品</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="many-store-bottom">
                                    <p v-if="item.totalPreferentialAmount" class="row row-preferential">优惠：
                                        <font>￥{{ (item.totalPreferentialAmount||0).toFixed(2) }}</font>
                                    </p>
                                    <div class="row row-1">
                                        <span>共<font class="margin-side">{{ item.totalSpeciesNum }}</font>件商品 合计：</span>
                                        <span>￥</span>
                                        <span>{{ (item.totalAmount || 0).toFixed(2) }}</span>
                                    </div>
                                    <div class="order-btns">
                                        <van-icon
                                            v-if="item.otherBtns && item.otherBtns.length"
                                            name="ellipsis"
                                            color="#cccccc"
                                            size=".36rem"
                                            style="margin-left:-.24rem;line-height:.6rem"
                                            @click="showMoreBtn(index)"
                                        >
                                            <div v-if="item.isShowMoreBtn" :class="['more-btn-box', item.otherBtns.length>1?'more-btn-box-2':'more-btn-box-1']">
                                                <div
                                                    v-if="item.otherBtns.indexOf('取消订单') > -1"
                                                    @click="cancelMergOrder(item, 6)"
                                                >取消订单</div>
                                                <div
                                                    v-if="item.otherBtns.indexOf('删除订单') > -1"
                                                    @click="cancelMergOrder(item, 8)"
                                                >删除订单</div>
                                                <!-- <div
                                                    v-if="item.otherBtns.indexOf('查看发票') > -1"
                                                    @click="gotoInvoice(item.orderId)"
                                                >查看发票</div> -->
                                            </div>
                                        </van-icon>
                                        <div v-if="item.btns" class="btn-box" style="padding:0">
                                            <van-button
                                                v-if="item.btns.indexOf('取消订单') > -1"
                                                round
                                                @click="cancelMergOrder(item, 6)"
                                            >取消订单</van-button>
                                            
                                            <van-button
                                                v-if="item.btns.indexOf('删除订单') > -1"
                                                round
                                                @click="cancelMergOrder(item, 8)"
                                            >删除订单</van-button>

                                            <!-- <van-button
                                                v-if="item.btns.indexOf('查看发票') > -1"
                                                round
                                                @click="gotoInvoice(item.orderId)"
                                            >查看发票</van-button> -->

                                            <!-- <van-button
                                                v-if="item.btns.indexOf('查看物流') > -1"
                                                round
                                                @click="getLogic(item)"
                                            >查看物流</van-button> -->

                                            <copy-order-btn
                                                v-if="item.btns.indexOf('再来一单') > -1"
                                                :item="item"
                                                :is-merge-order="true"
                                            />

                                            <van-button
                                                v-if="item.btns.indexOf('确认收货') > -1"
                                                color="#ED3129"
                                                round
                                                @click="cancelMergOrder(item, 4)"
                                            >确认收货</van-button>

                                            <van-button
                                                v-if="item.btns.indexOf('支付订单') > -1"
                                                color="#ED3129"
                                                round
                                                @click="payMergOrder(item)"
                                            >支付订单</van-button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </van-list>
                </div>
            </div>
            <template v-else>
                <div v-if="refreshFlag && !loading && !manyStoreLoading" class="no-data">
                    <img src="@/assets/images/refresh.png">
                    <span>数据获取失败，请尝试刷新!</span>
                    <div @click="onChange(indexActive)">重新刷新</div>     
                </div>
                <div v-if="!refreshFlag && !loading && !manyStoreLoading" class="no-data">
                    <img src="@/assets/images/emptyCart.png">
                    <span>暂无任何订单</span>       
                </div>
            </template>
            <van-popup
                v-model="show"
                :overlay="true"
                z-index="10000"
                get-container="body"
                position="bottom"
                @click-overlay="close"
            >
                <div class="popup-select-shop">
                    <div class="popup-title-box">
                        <div class="popup-title">
                            <span class="name">请选择门店</span>
                            <span class="multiple-choices">(不可多选)</span>
                            <span class="close-store" @click="close">&times;</span>
                        </div>
                    </div>
                    <div class="scroll-box">
                        <div class="store-box" :class="selectStoreIndex === '' ? 'store-box-active' : ''" @click="selectStore()">
                            全部
                        </div>
                        <div v-for="(item, index) in stores" :key="item" class="store-box" :class="selectStoreIndex === index ? 'store-box-active' : ''" @click="selectStore(item,index)">
                            {{ item.name }}
                        </div>
                    </div>
                    <div class="btn">
                        <van-button :loading="loading" type="danger" size="large" round @click="onSubmit">确定</van-button>
                    </div>
                </div>
            </van-popup>
        </div>
    </div>
</template>
<script>
import Api from '@/api/order'
import { Dialog, Toast } from 'vant'
import copyOrderBtn from '@/components/copyOrderBtn/index';
export default {
    components: {
        copyOrderBtn
    },
    data(){
        return {
            active: localStorage.getItem("gobackMergOrder") === 'true' ? 0 : 1,
            orderStatus: '',
            orderLists: [],
            manyStoreOrderList: [],
            current: 2,
            loading: false,
            finished: false,
            manyStoreFinished: false,
            manyStoreLoading: false,
            keyWord: '',
            refreshFlag: false,
            indexActive: 1,
            show: false,
            selectStoreIndex: '',
            selectStoreSid: ''
        }
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        },
        isMergeStore: function(){
            return this.$store.getters.userInfo.stores.length > 1
        },
        stores: function(){
            if (this.$store.getters.userInfo){
                return this.$store.getters.userInfo.stores || []
            } else {
                return []
            }
        }
    },
    created(){
        if (localStorage.getItem("gobackMergOrder") === 'true'){
            this.orderStatus = 'manyStore';
            this.getManyStoreOrderList(1, 10)
        } else {
            if (this.$route.query.type){
                this.active = Number(this.$route.query.type) + 1;
                this.getOrderList(this.$route.query.type, 1, 10); 
            } else {
                this.getOrderList(this.orderStatus, 1, 10); 
            }
        }
    },
    methods: {
        /**
         * 查看电子发票
         */
        gotoInvoice(orderId) {
            Api.getInvoiceList(orderId).then(({ data: { data }}) => {
                if (data.length === 1){
                    window.location.href = data[0].previewUrl;
                } else if (data.length > 1){
                    this.$router.push({
                        path: '/order/invoice',
                        query: {
                            orderId: orderId
                        }
                    })
                }    
            })
        },
        /**
         * 筛选门店订单
         */
        filterStore(){
            this.show = true
            // this.$store.commit("setSelectStore", {
            //     isPackage: false,
            //     show: true,
            //     filterOrder: true,
            //     callback: (userQuantityList) => {
            //         console.log(userQuantityList)
            //         // this.addToCart(Object.assign({}, this.item, { userQuantityList: userQuantityList }), 2, this.activityType)
            //     }
            // })
        },
        /**
         * 选择门店
         */
        selectStore(item, idx){
            if (!item){
                this.selectStoreIndex = ''
            } else {
                this.selectStoreIndex = idx
                this.selectStoreSid = item.sid
            }
        },
        /**
         * 确认选择门店
         */
        onSubmit(){
            this.show = false
            this.getOrderList(this.orderStatus, 1, 10)
        },
        /**
         * 关闭筛选门段弹窗
         */
        close() {
            this.show = false
        },
        /**
         * 切换订单状态
         */
        onChange(e) {
            let orderStatus = '';
            this.orderLists = [];
            this.manyStoreOrderList = [];
            this.current = 2;
            this.finished = false;
            this.manyStoreFinished = false;
            this.keyWord = "";
            this.indexActive = e;
            switch (e) {
                case 0:
                    orderStatus = 'manyStore';
                    break;
                case 1:
                    orderStatus = '';
                    break;
                case 2:
                    orderStatus = 1;
                    break;
                case 3:
                    orderStatus = 2;
                    break;
                case 4:
                    orderStatus = 3;
                    break;
                case 5:
                    orderStatus = 4;
                    break;
            }
            this.orderStatus = orderStatus;
            if (orderStatus !== 'manyStore'){
                this.getOrderList(orderStatus, 1, 10);
            } else {
                this.getManyStoreOrderList(1, 10)
            } 
        },
        /**
         * 查询订单列表
         */
        getOrderList(orderStatus, current, size){
            this.loading = true;
            this.refreshFlag = false;
            Toast.loading({
                message: '加载中...'
            });
            const obj = {
                orderStatus: orderStatus,
                current: current,
                size: size,
                keyWord: this.keyWord
            }
            if (this.selectStoreSid){
                obj.userSidList = this.selectStoreSid
            }
            console.log(this.selectStoreSid, obj)
            Api.getOrder(obj).then(({ data: { data }}) => {
                this.orderLists = data.orderList || [];
                this.orderLists.forEach(item => {
                    item.imgLists = []
                    item.orderGeneralDetailList && item.orderGeneralDetailList.forEach(general => {
                        item.imgLists.push(general)
                    })
                    item.orderPackageDetailList && item.orderPackageDetailList.forEach(packages => {
                        packages.productList.forEach(items => {
                            item.imgLists.push(items)
                        })
                    })
                    this.$set(item, 'isShowMoreBtn', false);
                    item.allBtns = [];
                    item.btns = [];
                    item.otherBtns = [];
                    if (item.orderStatus === 1){
                        item.allBtns = ['支付订单', '再来一单', '取消订单'];
                    } else if (item.orderStatus === 3){
                        item.allBtns = ['确认收货', '再来一单', '查看物流' ];
                    } else if (item.orderStatus === 6){
                        item.allBtns = ['再来一单', '删除订单'];
                    } else {
                        item.allBtns = ['再来一单'];
                    }
                    if ([3, 4, 5].indexOf(item.orderStatus) > -1 && item.invoiceType === 3) item.allBtns.push('查看发票');
                    // 平行展示和更多展示逻辑
                    if (item.allBtns.length > 3) {
                        item.otherBtns = item.allBtns.slice(3, item.allBtns.length);
                        item.btns = item.allBtns.slice(0, 3);
                    } else {
                        item.btns = item.allBtns;
                    }
                })
                if (this.orderLists.length < 10){
                    this.finished = true;
                } else {
                    this.finished = false;
                }
                this.loading = false;
                Toast.clear();
            }).catch(() => {
                this.refreshFlag = true;
                this.loading = false;
                Toast.clear();
            })
        },
        /**
         * 查询多门店订单列表
         */
        getManyStoreOrderList(current, size){
            localStorage.setItem("gobackMergOrder", '')
            this.manyStoreLoading = true;
            this.refreshFlag = false;
            Toast.loading({
                message: '加载中...'
            });
            // 	1 待支付 2 待发货 3 已发货 4 已收货 5 已完成 6 已取消
            Api.getMergeOrder({
                current: current,
                size: size,
                keyWord: this.keyWord.trim()
            }).then(({ data: { data }}) => {
                this.manyStoreOrderList = data.mergeOrderOutLineList || []
                this.manyStoreOrderList.forEach(item => {
                    this.$set(item, 'checked', false)
                    this.$set(item, 'isShowMoreBtn', false)
                    this.$set(item, 'selectList', [])
                    item.allBtns = [];
                    item.userOrderList.forEach(store => {
                        // 多个状态按钮合并
                        if (store.orderStatus === 1){
                            item.allBtns = [...['支付订单', '再来一单', '取消订单'], ...item.allBtns];
                        } else if (store.orderStatus === 3){
                            item.allBtns = [...['确认收货', '再来一单', '查看物流'], ...item.allBtns];
                        } else if (store.orderStatus === 6){
                            item.allBtns = [...['再来一单', '删除订单'], ...item.allBtns];
                        } else {
                            item.allBtns = [...['再来一单'], ...item.allBtns];
                        }
                        // if ([3,4,5].indexOf(store.orderStatus) > -1) item.allBtns = [...item.allBtns, ...['查看发票']];
                        this.$set(store, 'checked', false)
                    })
                    // 按钮合并后去重
                    item.allBtns = [...new Set(item.allBtns)];
                    item.otherBtns = [];
                    item.btns = [];
                    // 平行展示和更多展示逻辑,多门店汇总按钮没有查看发票&查看物流
                    const bIndex = item.allBtns.indexOf('查看发票');
                    if (bIndex > -1)item.allBtns.splice(bIndex, 1);
                    const aIndex = item.allBtns.indexOf('查看物流');
                    if (aIndex > -1)item.allBtns.splice(aIndex, 1);
                    // 按钮排序规则生成新数组
                    item.allBtns.sort((a, b) => {
                        const order = ["支付订单", "确认收货", "再来一单", "查看物流", "查看发票", "删除订单", "取消订单"];
                        return order.indexOf(a) - order.indexOf(b);
                    })
                    if (item.allBtns.length > 3) {
                        item.otherBtns = item.allBtns.slice(3, item.allBtns.length);
                        item.btns = item.allBtns.slice(0, 3);
                    } else {
                        item.btns = item.allBtns;
                    }
                })
                if (this.manyStoreOrderList.length < 10){
                    this.manyStoreFinished = true;
                } else {
                    this.manyStoreFinished = false;
                }
                this.manyStoreLoading = false;
                Toast.clear()
            }).catch(() => {
                this.manyStoreLoading = false;
                this.refreshFlag = true;
                Toast.clear();
            }) 
        },
        /**
         * 查询更多(非多店订单)
         */
        onLoad(){
            this.refreshFlag = false;
            Toast.loading({
                message: '加载中...'
            });
            this.loading = true;
            const obj = {
                orderStatus: this.orderStatus,
                current: this.current,
                size: 10,
                keyWord: this.keyWord
            }
            if (this.selectStoreSid){
                obj.userSidList = this.selectStoreSid
            }
            Api.getOrder(obj).then(({ data: { data }}) => {
                this.orderLists = this.orderLists.concat(data ? data.orderList || [] : [])
                this.orderLists.forEach(item => {
                    item.imgLists = []
                    item.orderGeneralDetailList && item.orderGeneralDetailList.forEach(general => {
                        item.imgLists.push(general)
                    })
                    item.orderPackageDetailList && item.orderPackageDetailList.forEach(packages => {
                        packages.productList.forEach(items => {
                            item.imgLists.push(items)
                        })
                    })
                    this.$set(item, 'isShowMoreBtn', false);
                    item.allBtns = [];
                    item.btns = [];
                    item.otherBtns = [];
                    if (item.orderStatus === 1){
                        item.allBtns = ['支付订单', '再来一单', '取消订单'];
                    } else if (item.orderStatus === 3){
                        item.allBtns = ['确认收货', '再来一单', '查看物流'];
                    } else if (item.orderStatus === 6){
                        item.allBtns = ['再来一单', '删除订单'];
                    } else {
                        item.allBtns = ['再来一单'];
                    }
                    // if ([3,4,5].indexOf(item.orderStatus) > -1) item.allBtns.push('查看发票');
                    // 平行展示和更多展示逻辑
                    if (item.allBtns.length > 3) {
                        item.otherBtns = item.allBtns.slice(3, item.allBtns.length);
                        item.btns = item.allBtns.slice(0, 3);
                    } else {
                        item.btns = item.allBtns;
                    }
                })
                this.loading = false
                if (this.current >= data.totalPage){
                    this.finished = true
                } else {
                    this.current++
                }
                Toast.clear();
            }).catch(() => {
                this.loading = false
                this.refreshFlag = true;
                Toast.clear();
            }) 
        },
        /**
         * 查询更多(多店订单)
         */
        onLoadManyStore(){
            this.refreshFlag = false;
            Toast.loading({
                message: '加载中...'
            });
            Api.getMergeOrder({ current: this.current, size: 10 }).then(({ data: { data }}) => {
                this.manyStoreOrderList = this.manyStoreOrderList.concat(data ? data.mergeOrderOutLineList || [] : [])
                this.manyStoreLoading = true
                this.manyStoreOrderList.forEach(item => {
                    this.$set(item, 'checked', false)
                    this.$set(item, 'isShowMoreBtn', false)
                    this.$set(item, 'selectList', [])
                    item.allBtns = [];
                    item.userOrderList.forEach(store => {
                        // 多个状态按钮合并
                        if (store.orderStatus === 1){
                            item.allBtns = [...['支付订单', '再来一单', '取消订单'], ...item.allBtns];
                        } else if (store.orderStatus === 3){
                            item.allBtns = [...['确认收货', '再来一单', '查看物流'], ...item.allBtns];
                        } else if (store.orderStatus === 6){
                            item.allBtns = [...['再来一单', '删除订单'], ...item.allBtns];
                        } else {
                            item.allBtns = [...['再来一单'], ...item.allBtns];
                        }
                        if ([3, 4, 5].indexOf(store.orderStatus) > -1 && store.invoiceType === 3) item.allBtns = [...item.allBtns, ...['查看发票']];
                        this.$set(store, 'checked', false)
                    })
                    // 按钮合并后去重
                    item.allBtns = [...new Set(item.allBtns)];
                    item.otherBtns = [];
                    item.btns = [];
                    // 多门店汇总按钮没有查看发票&查看物流
                    const bIndex = item.allBtns.indexOf('查看发票');
                    if (bIndex > -1)item.allBtns.splice(bIndex, 1);
                    const aIndex = item.allBtns.indexOf('查看物流');
                    if (aIndex > -1)item.allBtns.splice(aIndex, 1);

                    // 按钮排序规则生成新数组
                    item.allBtns.sort((a, b) => {
                        const order = ["支付订单", "确认收货", "再来一单", "查看物流", "查看发票", "删除订单", "取消订单"];
                        return order.indexOf(a) - order.indexOf(b);
                    })
                    
                    // 平行展示和更多展示逻辑
                    if (item.allBtns.length > 3) {
                        item.otherBtns = item.allBtns.slice(3, item.allBtns.length);
                        item.btns = item.allBtns.slice(0, 3);
                    } else {
                        item.btns = item.allBtns;
                    }
                })
                if (this.current >= data.totalPage){
                    this.manyStoreFinished = true
                } else {
                    this.current++
                }
                this.manyStoreLoading = false
                Toast.clear();
            }).catch(() => {
                this.manyStoreLoading = false
                this.refreshFlag = true;
                Toast.clear();
            })
        },
        /**
         * 弹出更多按钮选择
         */
        showMoreBtn(index){
            if (this.orderStatus === 'manyStore') {
                this.$set(this.manyStoreOrderList[index], 'isShowMoreBtn', !this.manyStoreOrderList[index].isShowMoreBtn)
            } else {
                this.orderLists[index].isShowMoreBtn = !this.orderLists[index].isShowMoreBtn
            }
        },
        /**
         * 选中主订单号
         */
        selectMainOrder(e, item){
            item.userOrderList.forEach(store => {
                store.checked = e
            })
        },
        /** 
         * 选中子店订单 
         */
        selectOrder(e, item, mainItem){
            item.checked = e
            if (e){
                mainItem.selectList.push(item.orderId)
            } else {
                for (let i = 0; i < mainItem.selectList.length; i++){
                    if (mainItem.selectList[i] === item.orderId) {
                        mainItem.selectList.splice(i, 1)
                    }
                }
            }
        },
        /**
         * 判断所选门店订单状态是否一致
         */
        isSameOrderStatus(item){
            const orderStatus = []
            item.userOrderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    orderStatus.push(store.orderStatus)
                }
            })
            if (orderStatus.length > 0) {
                return !orderStatus.some(function(value, index) {
                    return value !== orderStatus[0];
                });
            } else {
                return true;
            }
        },
        /**
         * 取消订单&删除订单&确认收货(非多门店)
         */
        cancelOrder(item, orderStatus) {
            let message;
            if (orderStatus === 6){
                message = '您确认取消此订单吗'
            } else if (orderStatus === 8){
                message = '您确认删除此订单吗'
            } else if (orderStatus === 4){
                message = '您确认收货此订单吗'
            }
            Dialog.confirm({
                message: message,
                asyncClose: true,
                cancelButtonText: "我再想想",
                cancelButtonColor: '#999999',
                confirmButtonColor: '#ED3129',
                className: 'mergBtn'
            }).then(() => {
                Api.cancelOrder(item.orderId, orderStatus).then(res => {
                    if (res.data.code === 0){
                        this.getOrderList(this.orderStatus, 1, 10)
                    }
                })
            }).catch(() => {
                Dialog.close();
            });
        },
        /**
         * 取消订单&删除订单&确认收货(多门店)
         */
        cancelMergOrder(item, orderStatus){
            const orderStatusList = []
            item.userOrderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    orderStatusList.push(store.orderStatus)
                }
            })
            let orderNum = 0
            // if (this.isSameOrderStatus(item)){
            // let message, tips;
            let tips;
            const filterList = []
            if (orderStatus === 6){
                // message = '是否取消订单？'
                tips = '取消'
                orderStatusList.forEach((val, idx) => {
                    if (val !== 1){ 
                        orderNum++
                        // item.selectList.splice(idx, 1)
                    } else {
                        filterList.push(item.selectList[idx])
                    }
                })
                if (filterList.length === 0){
                    Toast("未勾选待付款订单")
                    return
                }
            } else if (orderStatus === 8){
                // message = '是否删除订单？'
                tips = '删除'
                orderStatusList.forEach((val, idx) => {
                    if (val !== 6){ 
                        orderNum++
                        // item.selectList.splice(idx, 1)
                    } else {
                        filterList.push(item.selectList[idx])
                    }
                })
                if (filterList.length === 0){
                    Toast("未勾选已取消订单")
                    return
                }
            } else if (orderStatus === 4){
                // message = '是否确认收货？'
                tips = '确认收货'
                orderStatusList.forEach((val, idx) => {
                    if (val !== 3){ 
                        orderNum++
                        // item.selectList.splice(idx, 1)
                    } else {
                        filterList.push(item.selectList[idx])
                    }
                })
                if (filterList.length === 0){
                    Toast("未勾选已发货订单")
                    return
                }
            }
            if (orderNum === 0){
                Dialog.confirm({
                    message: '有 ' + orderStatusList.length + ' 个订单将' + tips,
                    cancelButtonText: "我再想想",
                    cancelButtonColor: '#999999',
                    confirmButtonText: '确定',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn'
                }).then(() => {
                    Api.cancelMergOrder({ orderIdList: item.selectList, orderStatus: orderStatus }).then(res => {
                        Toast.success({
                            message: '操作成功',
                            duration: 800,
                            onClose: () => {
                                this.getManyStoreOrderList(this.current - 1, 10)
                            }
                        })
                    })
                })
            } else {
                Dialog.confirm({
                    message: '因有 ' + orderNum + ' 个订单状态不一致，将不与其他订单一起' + tips,
                    cancelButtonColor: '#999999',
                    confirmButtonText: '确定',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn',
                    messageAlign: 'left'
                }).then(() => {
                    Api.cancelMergOrder({ orderIdList: filterList, orderStatus: orderStatus }).then(res => {
                        Toast.success({
                            message: '操作成功',
                            duration: 800,
                            onClose: () => {
                                this.getManyStoreOrderList(this.current - 1, 10)
                            }
                        })
                    }).catch(() => {
                        
                    })
                }).catch(() => {
                    Dialog.close();
                });
            }
        },
        /**
         * 支付订单
         */
        payOrder(item){
            localStorage.setItem('orderId', item.orderId)
            this.$router.push({ path: '/order/checkout', query: { mergOrder: false }})
        },
        /**
         * 支付订单(多门店)
         */
        payMergOrder(item){
            const orderStatusList = []
            item.userOrderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    orderStatusList.push(store.orderStatus)
                }
            })
            let orderNum = 0
            orderStatusList.forEach((val, idx) => {
                if (val === 1){ 
                    orderNum++
                } else {
                    // item.selectList.splice(idx, 1)
                }
            })
            if (orderNum === 0){
                Toast("未勾选待付款订单")
                return
            }
            orderNum = orderStatusList.length - orderNum
            if (orderNum !== 0){
                Dialog.confirm({
                    message: '因有 ' + orderNum + ' 个订单状态不一致，将不与其他订单一起支付',
                    cancelButtonColor: '#999999',
                    confirmButtonText: '去支付',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn',
                    messageAlign: 'left'
                }).then(() => {
                    if (!this.isSameInvoiceType(item)){
                        Dialog.alert({
                            message: '增值税专用发票与增值税普通发票订单不支持一同付款，请选择同类型发票订单进行付款',
                            cancelButtonColor: '#999999',
                            confirmButtonColor: '#ED3129',
                            className: 'mergBtn'
                        }).then(() => {
                            return false
                        });
                    } else {
                        localStorage.setItem('orderId', JSON.stringify(item.selectList))
                        this.$router.push({ path: '/order/checkout', query: { mergOrder: true }})
                    }
                }).catch(() => {
                    Dialog.close();
                });
            } else {
                if (!this.isSameInvoiceType(item)){
                    Dialog.alert({
                        message: '增值税专用发票与增值税普通发票订单不支持一同付款，请选择同类型发票订单进行付款',
                        cancelButtonColor: '#999999',
                        confirmButtonColor: '#ED3129',
                        className: 'mergBtn'
                    }).then(() => {
                        return false
                    });
                } else {
                    localStorage.setItem('orderId', JSON.stringify(item.selectList))
                    this.$router.push({ path: '/order/checkout', query: { mergOrder: true }})
                }
            }
        },
        /**
         * 判断是否为同种发票(1普通纸质发票 2专用发票 3电子发票)
         */
        isSameInvoiceType(item){
            const invoiceTypeList = []
            item.userOrderList.forEach(store => {
                if (item.selectList.indexOf(store.orderId) > -1) {
                    invoiceTypeList.push(store.invoiceType)
                }
            })
            if (invoiceTypeList.length > 0) {
                if (invoiceTypeList.indexOf(1) > -1 && invoiceTypeList.indexOf(2) > -1){
                    return false
                } else if (invoiceTypeList.indexOf(2) > -1 && invoiceTypeList.indexOf(3) > -1){
                    return false
                } else {
                    return true
                }
            } else {
                return true;
            }
        },
        /**
         * 复制订单号
         */
        copy(copyInner, e) {
            window.event ? window.event.cancelBubble = true : e.stopPropagation();
            var el = document.createElement('input');
            el.value = copyInner;
            el.style.opacity = '0';
            document.body.appendChild(el);
            var editable = el.contentEditable;
            var readonly = el.readonly;
            el.contentEditable = true;
            el.readonly = false;
            var range = document.createRange();
            range.selectNodeContents(el);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
            el.setSelectionRange(0, 999999);
            el.contentEditable = editable;
            el.readonly = readonly;
            el.select();
            document.execCommand('copy');

            Toast({
                message: '复制成功',
                duration: 500
            })
            // document.body.removeChild(el)
        },
        /**
         * 订单详情
         */
        showOrderDetail(val, type){
            if (val.orderType === 4){
                if (type === 'order'){
                    this.$router.push({
                        path: `/order/detail?orderId=${val.orderId}&isPreSale=true`
                    })
                } else {
                    this.$router.push({
                        path: `/order/detail?orderId=${val.orderId}&gobackMergOrder=true&isPreSale=true`
                    })
                }
            } else {
                if (type === 'order'){
                    this.$router.push({
                        path: `/order/detail?orderId=${val.orderId}`
                    })
                } else {
                    this.$router.push({
                        path: `/order/detail?orderId=${val.orderId}&gobackMergOrder=true`
                    })
                }
            }
        },
        /**
         * 订单详情
         */
        goMergeDetail(val){
            this.$router.push({
                path: `/order/mergeDetail?mergeOrderId=${val}&gobackMergOrder=true`
            })
        },
        /**
         * 查看物流
         */
        getLogic(val){
            this.$router.push({ path: `/order/logistics?orderId=${val.orderId}&expressNum=${val.expressNum}` })
        },
        // 搜索订单
        searchOrder() {
            this.current = 2;
            if (this.orderStatus === 'manyStore') {
                this.manyStoreOrderList = [];
                this.getManyStoreOrderList(1, 10)
            } else {
                this.orderLists = [];
                this.getOrderList(this.orderStatus, 1, 10)
            }
        },
        // 清空搜索
        emptySearch() {
            this.keyWord = "";
            this.searchOrder();
        }
    }
}
</script>
<style lang="scss">
.mergBtn{
    border-radius: .16rem;
    .van-dialog__message{
        font-size: .32rem;
    }
}
%textOver{
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.popup-select-shop {
    box-sizing: border-box;
    padding: 0 .28rem;
    max-height: 8rem;
    overflow: auto;
    .popup-title-box{
        background: #fff;
        height: 1.12rem;
        position: fixed;
        z-index: 9;
    }
    .popup-title {
        color: #666666;
        padding: 0 .28rem;
        height: 1.18rem;
        line-height: 1.18rem;
        width: 100%;
        position: fixed;
        top: 0;
        left: 0;
        border-bottom: .02rem solid #EEEEEE;
        background: #fff;
        z-index: 2;
        transform: translateZ(0);
        .name{
            font-size: .36rem;
            font-weight: 600;
        }
    }
    .scroll-box{
        .store-box{
            padding: .44rem .24rem;
            border-radius: .16rem;
            background: #f6f6f6;
            margin-bottom: .16rem;
            font-size: 14px;
            line-height: 20px;
            color: #666666;
            &.store-box-active{
                background: #FFFAFA;
                color: #ED3129;
            }
            &:last-child{
                margin-bottom: 0;
            }
        }
    }
    .btn{
        position: fixed;
        bottom: 0;
        left: 0;
        z-index: 2;
        background: #fff;
        width: 100%;
        transform: translateZ(0);
        text-align: center;
        .van-button {
            height: .88rem;
            line-height: .88rem;
            font-size: .40rem;
            margin: .20rem 0 .28rem;
            width: 95%;
            &.van-button--danger {
                background-color: #FF4646;
            }
        }
    }
    .close-store{
        font-size: .48rem;
        color: #CCCCCC;
        position: absolute;
        right: .1rem;
    }
}
.order-box{
    height: 100%;
    display: flex;
    flex-direction: column;
    background: #f4f4f4;
    .order-btns{
        display: flex;
        justify-content: space-between;
        padding-top: .06rem;
        align-items: center;
        .van-icon{
            position: relative;
            margin-left: .24rem;
            height: .6rem;
            .more-btn-box{
                position: absolute;
                left: -.3rem;
                width: 2.14rem;
                div{
                    color: #333;
                    font-size: .28rem;
                    text-align: center;
                    margin: 0 .1rem;
                    line-height: .6rem;
                }
                div:nth-child(1){
                    padding-top: .1rem;
                }
            }
            .more-btn-box-1{
                height: 1.08rem;
                top: -1.1rem;
                background: url('~@/assets/images/more-btn-bg-1.png') center center no-repeat;
                background-size: contain;
            }
            .more-btn-box-2{
                height: 1.68rem;
                top: -1.7rem;
                background: url('~@/assets/images/more-btn-bg-2.png') center center no-repeat;
                background-size: contain;
                div:nth-child(1){
                    border-bottom: .02rem solid #eeeeee;
                }
            }
        }
        .btn-box{
            flex: 1;
            display: flex;
            justify-content: flex-end;
            padding: 0;
            border-radius: .16rem;
            .van-button{
                font-size: .28rem;
                height: .6rem;
                line-height: .6;
            }
        }
    }
    .van-tabs--line{
        padding-top:0px;
    }
    .btn-copy {
        width: .68rem;
        height: .36rem;
        text-align: center;
        line-height: .36rem;
        border-radius: .08rem;
        background: #FFE9E8;
        margin-left: .2rem;
        color: #ED3129;
        font-size: .24rem;
        font-weight: normal;
    }
    .order-title{
        position: fixed;
        top: 46px;
        width: 100%;
        background:#fff;
        z-index: 33;
        transform: translateZ(0);
    }
    .have-data{
        background: #F4F4F4;
        flex: 1;
        overflow: auto;
    }
    .order-list {
        flex: 1;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        padding-top: 91px;
        .search-order{
            display: flex;
            border-radius: .16rem;
            background: #ffffff;
            margin: .24rem .2rem;
            img{
                width: .48rem;
                height: .48rem;
                margin: .1rem;
            }
            input::-webkit-input-placeholder { 
                color: #BBBBBB; 
            } 
            input{
                flex: 1;
                border: none;
                outline: none;
                height: .68rem;
                line-height: .68rem;
                border-radius: .16rem;
            }
            .van-icon-close{
                margin-top: .18rem;
                margin-right: .1rem;
            }
            .filter-box{
                display: flex;
                align-items: center;
                justify-content: center;
                width: 1.4rem;
                border-left: .02rem solid #eee;
                img{
                    width: .24rem;
                    height: .24rem;
                    margin: 0 .12rem 0 0;
                }
            }
        }
        .order-li {
            background: #FFF;
            margin: .24rem .16rem;
            border-radius: .16rem;
            h6.title{
                font-size: .32rem;
                padding: .26rem .24rem;
                line-height: .44rem;
            }
            .title {
                font-size: .28rem;
                padding: .3rem .24rem .24rem .24rem;
                line-height: .44rem;
                overflow: hidden;
                .l {
                    float: left;
                    i{
                        font-style: normal;
                        color: #999999;
                    }
                    em{
                        font-weight: 600;
                        font-size: .3rem;
                        font-style: normal;
                    }
                }
                .r {
                    float: right;
                    font-size: .24rem;
                    span {
                        color: #BBBBBB;
                    }
                    .orange{
                        color: #FF7914;
                    }
                }
            }

            .many-store-title{
                display: flex;
                align-items: center;
                height: .94rem;
                line-height: .94rem;
                padding: 0 .2rem .06rem .2rem;
                font-size: .28rem;
                color: #333333;
                .dv{
                    overflow: hidden;
                    flex: 1;
                    display: flex;
                    align-items: center;
                    .sub-title{
                        color: #999999;
                        font-style: normal;
                    }
                    .span{
                        flex: 1;
                        display: flex;
                        overflow: hidden;
                        em{
                            flex: 1;
                            @extend %textOver;
                            font-weight: 600;
                            font-size: .3rem;
                            font-style: normal;
                        }
                    }
                }
                .van-checkbox {
                    font-size: .32rem;
                    margin-right: .24rem;
                }
            }
            .margin-side{
                margin: 0 .1rem;
                font-weight: 600;
                color: #333333;
                font-size: .28rem;
            }

            .many-store-list{
                display: flex;
                align-items: flex-start;
                padding: .14rem .24rem .14rem .24rem;
                position: relative;
                .order-info-box{
                    padding-left: .2rem;
                    flex: 1;
                    .row{
                        display: flex;
                        align-items: center;
                        position: relative;
                    }
                    .row-1{
                        padding-bottom: .22rem;
                        .store-name{
                            display: inline-block;
                            max-width: 4.9rem;
                            overflow: hidden;
                            white-space: nowrap;
                            text-overflow: ellipsis;
                            color: #333333;
                            font-size: .32rem;
                            font-weight: 600;
                            padding: 0 .08rem;
                        }
                        .main-store{
                            display: inline-block;
                            color: #ED3129;
                            font-size: .24rem;
                            padding: .04rem .1rem;
                            border: .02rem solid #ED3129;
                            border-radius: .08rem;
                            line-height: 1;
                        }
                        .order-status{
                            display: inline-block;
                            color: #BBBBBB;
                            font-size: .24rem;
                            position: absolute;
                            right: 0;
                            top: .06rem;
                        }
                    }
                    .row-2, .row-3{
                        padding-bottom: .1rem;
                        line-height: .4rem;
                        font-size: .28rem;
                        span:nth-child(1){
                            color: #999999;
                        }
                        span:nth-child(2){
                            color: #333333;
                        }
                    }
                    .store-price-box{
                        margin-top: .18rem;
                        padding: .18rem .26rem .2rem .26rem;
                        background: #F6F6F6;
                        color: #999999;
                        border-radius: .12rem;
                        line-height: .4rem;
                        .price-info{
                            display: flex;
                            span:nth-child(1){
                                flex: 1;
                                font-size: .28rem;
                                font{
                                    font-weight:600;
                                    font-size: .32rem;
                                    color: #333333
                                }
                            }
                            span:nth-child(2){
                                width: 2rem;
                                text-align: right;
                            }
                        }
                    }
                }
            }

            .many-store-bottom{
                padding: .14rem .24rem .28rem .48rem;
                .row{
                    display: flex;
                }
                .row-preferential{
                    justify-content: flex-end;
                    padding-bottom: .06rem;
                    line-height: .34rem;
                    color: #666666;
                    font{
                        color: #ED3129;
                    }
                }
                .row-1{
                    justify-content: flex-end;
                    align-items: baseline;
                    color: #666666;
                    margin-bottom: .3rem;
                    span:nth-child(2){
                        font-size: .24rem;
                        color: #ED3129;
                    }
                    span:nth-child(3){
                        font-size: .28rem;
                        color: #ED3129;
                    }
                }
            }

            .item-list {
                padding-top: .1rem;
                overflow: hidden;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: relative;
                .img-box {
                    .item-li {
                        float: left;
                        width: 1.28rem;
                        height: 1.28rem;
                        padding-right: .02rem;
                        overflow: hidden;
                        text-align: center;
                        margin-left: .1rem;
                        position: relative;
                        img {
                            width: 100%;
                            height: 100%;
                            // margin-left: .1rem;
                            // box-shadow: 0px 2px 5px 0px rgba(46, 0, 4, 0.07);
                            border-radius: 5px;
                        }
                        .van-image__error, .van-image{
                            width: 1.28rem;
                            height: 1.28rem;
                        }
                        .preSaleImg{
                            position: absolute;
                            width: .6rem;
                            height: .36rem;
                            top: 0;
                            left: .08rem;
                            border-radius: 0;
                            z-index: 9;
                        }
                    }
                }

                .btn-all {
                    span {
                        font-size: .26rem;
                        color: #666;
                        display: block;
                        &:first-child {
                            margin-top: 16px;
                        }

                        &:last-child {
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap
                        }
                    }
                }
            }

            .state-info {
                font-size: .28rem;
                text-align: right;
                padding: .30rem .20rem;
                color: #999999;
                .total-count{
                    padding: 0 .1rem;
                    font-size: .32rem;
                }
                span {
                    color: #333333;
                    font-weight: bold;
                }
            }
            
            .preSaleTime{
                display: flex;
                height: .56rem;
                line-height: .56rem;
                margin: 0 .2rem .1rem .2rem;
                color: #FF6E00;
                font-size: .24rem;
                background: #FFF6EE;
                border-radius: .08rem;
                img{
                    width: .28rem;
                    margin: .14rem;
                }
                span{
                    flex: 1;
                }
            }

            .btn-box {
                text-align: right;
                padding: 0 .20rem .24rem .20rem;
                .van-button {
                    font-size: .30rem;
                    height: .6rem;
                    line-height: .6rem;
                    margin-left: .2rem;
                    &.van-button--default {
                        width: 1.64rem;
                        text-align: center;
                        padding: 0;
                        color: #666666;
                        border-color: #cccccc;
                    }

                    &.van-button--danger {
                        background-color: #ED3129;
                    }
                }
            }
        }

        .no-data {
            display: flex;
            flex-direction: column;
            align-items: center;

            img {
                width: 4.96rem;
                height: 4.96rem;
                margin-top: 1.62rem;
            }

            span {
                color: #BBBBBB;
                font-size: .36rem;
                padding-top: .22rem;
            }
            div {
                width: 2.2rem;
                height: .68rem;
                text-align: center;
                line-height: .68rem;
                background: #FF4646;
                font-size: .32rem;
                color: #fff;
                border-radius: .47rem;
                margin-top: .4rem;
            }
        }
    }
    .no-more-data {
        font-size: .28rem;
        text-align: center;
        padding: .60rem 0;
        position: relative;
        width: 80%;
        margin: 0 auto;

        &::before {
            position: absolute;
            content: ' ';
            left: 0;
            top: .78rem;
            width: 200%;
            z-index: 1;
            border-top: 1px solid #cccccc;
            -webkit-transform-origin: 0 0;
            transform-origin: 0 0;
            -webkit-transform: scale(.5, .5);
            transform: scale(.5, .5);
        }

        span {
            position: relative;
            z-index: 2;
            padding: 0 .20rem;
            background: #F4F4F4;
            color: #999999;
        }
    }
}
</style>
