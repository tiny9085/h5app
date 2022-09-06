<template>
    <div class="Page-quick-index">
        <div class="quick-top-div" />
        <div class="quick-top">
            <div class="search-input">
                <van-field :value="value" :clearable="true" :left-icon="'https://imga.hnhcyy.com/fed/b2b-wechat/icon-search.png'" placeholder="商品名/首字母/商品ID/厂家/标签/商标" :border="false" @focus="goSearch" />
            </div>
            <van-tabs :active="active" sticky @change="onChange($event)">
                <van-tab :title="'近期已采购(' + (totalA ? totalA : 0) +')'" />
                <van-tab :title="'近期未采购(' + (totalB ? totalB : 0) +')'" />
            </van-tabs>
        </div>
        <div class="label">
            <div :class="{actived:shows===1}" @click="checkedBox(1)">
                <p>综合</p>
            </div>
            <div :class="{'actived showArr':shows===2}" @click="checkedBox(2)">
                <p class="words">销量
                    <img v-if="shows!==2" src="@/assets/images/icon-grey.png">
                </p>
            </div>
            <div :class="{actived:shows===3}" @click="checkedBox(3)">
                <p class="words">首字母</p>
                <p class="triangle-box">
                    <span :class="isAsc===1? 'triangle triangle-top  triangle-top-red': 'triangle triangle-top'" />
                    <span :class="isAsc===0 ? 'triangle triangle-bottom  triangle-bottom-red': 'triangle triangle-bottom'" />
                </p>
            </div>
            <div :class="{actived:shows===4}" @click="checkedBox(4)">
                <p class="words">筛选</p>
                <p class="triangle-box">
                    <span class="triangle triangle-left" />
                </p>
            </div>
        </div>
        <div :class="currentType == 1 ? 'theme-lsx' : currentType == 2 ? 'theme-zat' : 'theme-chx'">
            <div v-if="goodsList.length != 0" ref="refGoodsBox" class="ref-goods-box" :style="[{'height': winHeight +'px'}]" @scroll="handleScroll($event)">
                <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :offset="50" @load="onLoad">
                    <product-list :goods-list="goodsList" />
                </van-list>
            </div>
            <template v-else-if="goodsList.length === 0 && !loading">
                <div v-if="refreshFlag" class="no-data" :style="[{'height': winHeight + 'px'}]">
                    <img src="@/assets/images/refresh.png">
                    <span>数据获取失败，请尝试刷新!</span>
                    <van-button @click="resh">
                        <p>重新刷新</p>
                    </van-button>
                </div>
                <div v-if="!refreshFlag" class="no-data" :style="[{'height': winHeight + 'px'}]">
                    <img src="@/assets/images/emptyCart.png">
                    <span>暂无商品，快去选购吧！</span>
                    <van-button @click="goMenu">
                        <p>前往</p>
                    </van-button>
                </div>
            </template>
            <pagination ref="refPagination" :current="current" dom-div="ref-goods-box" />
        </div>
        <win-screen ref="refScreen" :popup="popup" :label-list-facet="labelListFacet" @closePopup="closePopup" @save="saveValue" />
    </div>
</template>
<script>
import Api from '@/api/quick/quick'
import productList from '@/components/productList'
import pagination from '@/components/pagination/index'
import { comfirmPage } from '@/utils/util'
import { Toast } from 'vant'
import winScreen from '@/views/menu/dialog/index.vue'
var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'App',
    components: {
        productList,
        pagination,
        winScreen
    },
    data() {
        return {
            popup: false,
            shows: 1,
            active: this.$route.query.quickType === '2' ? 1 : 0,
            currentType: 1,
            noMoreData: false,
            goodsList: [],
            loading: false,
            finished: false,
            quickType: this.$route.query.quickType || 1,
            page: 1,
            totalA: null,
            totalB: null,
            show: false,
            refreshFlag: false,
            scrollHeight: 0,
            currentPage: [],
            positionArr: [],
            current: 1,
            pageName: this.$route.name,
            labelListFacet: [],
            minPrice: '',
            maxPrice: '',
            searchTypeList: [],
            labelVal: [],
            sortType: 0,
            sortTop: true
        }
    },
    computed: {
        winHeight: function() {
            return this.$store.getters.winHeight - 152
        }
    },
    watch: {
        totalA: function(val) {
            this.totalA = val
        },
        totalb: function(val) {
            this.totalA = val
        },
        page: function(val) {
            if (val > 1) {
                this.currentPage.push({
                    page: val - 1,
                    scrollPosition: this.scrollHeight
                })
                this.positionArr.push(this.scrollHeight)
            }
        }
    },
    created() {
        this.$store.commit("setHasToolbar", true)
    },
    mounted() {
        this.show = true
        this.loading = true
        Toast.loading({
            message: '加载中...',
            forbidClick: true,
            duration: 0
        })
        Api.fetchQuickBuy({ quickType: 1, current: this.page, size: 16 }).then(({ data: { data }}) => {
            this.totalA = data.total
        })
        Api.fetchQuickBuy({ quickType: 2, current: this.page, size: 16 }).then(({ data: { data }}) => {
            this.totalB = data.total
        })
        this.onLoad()
    },
    methods: {
        /* 
         * 点击切换查询方式 
         */
        checkedBox(flag) {
            this.shows = flag;
            this.sortTop = !this.sortTop
            if (this.shows === 4) {
                this.popup = !this.popup
                if (this.popup) this.$refs['refScreen'].action = '';
                return
            }
            Toast.loading({
                message: '加载中...',
                forbidClick: true,
                duration: 0
            })
            this.finished = false
            this.page = 1
            this.goodsList = []
            this.currentPage = []
            this.positionArr = []
            this.current = 1
            this.onLoad()
            if (this.$refs['refGoodsBox']) this.$refs['refGoodsBox'].scrollTop = 0
        },
        resh() {
            this.onLoad()
        },
        goMenu() {
            this.$router.push('/menu')
        },
        /**
         * 切换已采未采
         */
        onChange(e) {
            Toast.loading({
                message: '加载中...',
                forbidClick: true,
                duration: 0
            })
            this.finished = false
            this.page = 1
            this.goodsList = []
            this.currentPage = []
            this.positionArr = []
            this.current = 1
            e === 0 ? this.quickType = 1 : this.quickType = 2
            this.onLoad()
            if (this.$refs['refGoodsBox']) {
                this.$refs['refGoodsBox'].scrollTop = 0
            }
        },
        /**
         * 获取商品数据
         */
        // getGoodsList() {
        //     Api.fetchQuickBuy({ quickType: this.quickType, current: this.page, size: 16 }).then(({ data: { data }}) => {
        //         this.goodsList = data.records
        //         localStorage.removeItem("quickType")
        //         this.show = false
        //         Toast.clear()
        //         this.loading = false
        //         this.refreshFlag = false
        //     }).catch(() => {
        //         Toast.clear()
        //         this.loading = false
        //         this.refreshFlag = true
        //         this.show = false
        //     })
        // },
        /* 
         * 筛选商品数据 
         */
        searchParams() {
            switch (this.shows) {
                case 1:
                    this.sortType = 0;
                    break;
                case 2:
                    this.sortType = 1;
                    break;
                case 3:
                    this.sortType = 4;
                    this.isAsc = this.sortTop ? 0 : 1;
                    break;
                case 4:
                    this.sortType = '';
            }
        },
        /**
         * 加载更多
         */
        onLoad() {
            this.searchParams()
            Api.fetchQuickBuy(
                {
                    quickType: this.quickType,
                    current: this.page,
                    size: 16,
                    minPrice: this.minPrice,
                    maxPrice: this.maxPrice,
                    searchTypeList: this.searchTypeList.join(),
                    labelVal: this.labelVal.join(),
                    isAsc: this.isAsc,
                    sortType: this.sortType
                }
            ).then(({ data: { data }}) => {
                this.labelListFacet = data.facetResultMap.labelListFacet
                this.goodsList = this.goodsList.concat(data.records || [])
                localStorage.removeItem("quickType")
                this.show = false
                Toast.clear()
                this.loading = false
                this.refreshFlag = false
                if (this.page >= data.pages) {
                    this.finished = true
                } else {
                    this.page++
                }
                this.$refs['refScreen'].loading = false
            }).catch(() => {
                Toast.clear()
                this.loading = false
                this.$refs['refScreen'].loading = false
            })
        },
        // 跳转搜索
        goSearch() {
            this.$router.push(`/product/search/${'bt'}`)
            _czc.push(["_trackEvent", "点击搜索框", "search_click", "快速下单" + ";club:" + this.$store.getters.userInfo.currentType])
        },
        // 监听滚动
        handleScroll(e) {
            this.scrollHeight = e.target.scrollTop
            this.$refs['refPagination'].scrollHeight = e.target.scrollTop
            this.current = comfirmPage(this.positionArr, e.target.scrollTop)
        },
        // 弹窗显示
        showPopup() {
            this.popup = !this.popup
        },
        // 关闭弹窗
        closePopup() {
            // console.log(222)
            // console.log(this.$refs)
            this.popup = false
        },
        // 提交数据
        saveValue(val) {
            this.minPrice = val.minPrice;
            this.maxPrice = val.maxPrice;
            this.searchTypeList = val.searchTypeList;
            this.labelVal = val.labelVal;
            this.finished = false
            this.page = 1
            this.goodsList = []
            this.currentPage = []
            this.positionArr = []
            this.current = 1
            this.onLoad();
            this.closePopup();
            if (this.$refs['refGoodsBox']) this.$refs['refGoodsBox'].scrollTop = 0
        }
    }
}
</script>
<style lang="scss">
.Page-quick-index {
    .quick-top-div {
        height: 102px;
    }
    .quick-top {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 9;
        transform: translateZ(0);
    }
    .search-input {
        padding: 0.1rem 0.28rem;
        background: #ffffff;
        height: 7%;
        img {
            width: 0.48rem;
            height: 0.48rem;
        }

        .van-cell {
            background: #f4f4f4;
            border-radius: 1rem;
            color: #999999;
            padding: 0.14rem 0.2rem;

            .van-field__control {
                font-size: 0.26rem;
                color: #bbb;
                line-height: 0.56rem;
            }
        }
    }
    .van-tabs {
        z-index: 99;
        padding-top: 0;
        // border-bottom: 0.2rem solid #f4f4f4;
        [class*="van-hairline"]::after {
            content: none;
        }

        .van-tab {
            font-size: 0.32rem;
            color: #666;

            &.van-tab--active {
                color: #ed3129;
            }
        }

        .van-tabs__line {
            width: .28rem!important;
            height: .06rem;
        }
    }
    .van-tabs .van-tabs__line::after {
        position: absolute;
        box-sizing: border-box;
        content: " ";
        pointer-events: none;
        right: 0.4rem;
        bottom: -0.04rem;
        left: 0.4rem;
        border-bottom: 8px solid #ed3129;
        -webkit-transform: scaleY(0.5);
        transform: scaleY(0.5);
        border-radius: 4px;
    }

    .label {
        padding-top: 0.1rem;
        display: flex;
        justify-content: space-around;
        div {
            display: flex;
            align-items: center;
            padding-bottom: 0.15rem;
            p {
                font-weight: normal;
                font-size: 0.28rem;
            }
            img {
                width: 0.12rem;
                height: 0.16rem;
                margin-bottom: 0.02rem;
            }
            .words::before {
                content: "|";
                color: #eeeeee;
                margin-right: 0.4rem;
            }
            &.showArr {
                &:nth-child(2) {
                    p {
                        &::after {
                            content: "";
                            display: inline-block;
                            background: url("~@/assets/images/icon-arrow.png") no-repeat;
                            background-size: 100% auto;
                            width: 0.12rem;
                            height: 0.16rem;
                            margin-bottom: 0.02rem;
                        }
                    }
                }
            }
        }
        .triangle-box {
            display: flex;
            flex-direction: column;
            .triangle {
                width: 0;
                height: 0;
                border-width: 0.08rem;
                border-style: solid;
                border-color: transparent transparent transparent transparent;
                &.triangle-top {
                    border-bottom-color: #d8d8d8;
                    margin-bottom: 0.06rem;
                    margin-left: 0.1rem;
                    border-bottom-width: 0.1rem;
                }
                &.triangle-bottom {
                    border-top-color: #d8d8d8;
                    margin-left: 0.1rem;
                    border-top-width: 0.1rem;
                }
                &.triangle-left {
                    border-left-color: #d8d8d8;
                    margin-left: 0.1rem;
                    border-left-width: 0.1rem;
                }
            }
        }
        .actived {
            color: #ff4646;
            .triangle-left {
                border-left-color: #ed3129 !important;
            }
            .triangle.triangle-top-red {
                border-bottom-color: red;
            }
            .triangle.triangle-bottom-red {
                border-top-color: red;
            }
        }
    }

    .no-data {
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 9.2rem;

        img {
            width: 4.96rem;
            height: 4.96rem;
            margin-top: 1.44rem;
        }

        span {
            color: #bbbbbb;
            font-size: 0.32rem;
            padding-top: 0.54rem;
        }
        .van-button {
            width: 2.2rem;
            height: 0.68rem;
            background: #ff4646;
            border-radius: 0.47rem;
            margin-top: 0.4rem;
            p {
                color: #ffffff;
                font-size: 0.32rem;
                text-align: center;
                line-height: 0.68rem;
            }
        }
    }
    .ref-goods-box {
        background: #f1f1f1;
        overflow: auto;
    }
}
</style>
