<template>
    <div class="page-tool-bar">
        <van-tabbar
            v-if="hasToolBar"
            v-model="active"
            :active-color="activeColor"
            inactive-color="#999999"
            @change="changeTabbar"
        >
            <!-- <van-tabbar v-if="hasToolBar" v-model="active" :active-color="'#ED3129'" inactive-color="#999999"> -->
            <van-tabbar-item v-for="item in tabbarData" :key="item.id" :info="item.info === 0 ? '' : item.info" :to="item.linkUrl">
                <span>{{ item.tabbarName }}</span>
                <img slot="icon" slot-scope="props" :src="props.active ? item.icon.active : item.icon.normal">
            </van-tabbar-item>
        </van-tabbar>
    </div>
</template>

<script>

var _czc = window._czc || [];
_czc.push(["_setAccount", "1278152005"]);

export default {
    name: 'ToolBar',
    data() {
        return {
            
        }
    },
    computed: {
        hasToolBar() {
            return this.$route.meta.hasToolBar
        },
        active() {
            return this.$route.meta.active
        },
        cartNum(){
            return this.$store.getters.cartNum
        },
        currentClub: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : null
        },
        activeColor: function() {
            if (this.currentClub === 1){
                return '#FF4646';
            } else if (this.currentClub === 2) {
                return '#01924D';
            } else if (this.currentClub === 3) {
                return '#DC3264';
            } else if (this.currentClub === 4) {
                return '#149FE5';
            } else if (this.currentClub === 6) {
                return '#2F5DFF';
            } else if (this.currentClub === 7) {
                return '#3760BF';
            } else {
                return '#082692';
            }
        },
        tabbarData: function() {
            return [
                {
                    tabbarName: '首页',
                    linkUrl: '/',
                    icon: {
                        // normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-home.png',
                        // active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-home.png'
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-1.png?v=1',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-home-' + (this.currentClub + 1)  + '.png'
                    },
                    info: 0
                },
                {
                    tabbarName: '抱团专卖',
                    linkUrl: '/menu',
                    icon: {
                        // normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-menu.png',
                        // active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-menu.png'
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-1.png?v=1',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-menu-' + (this.currentClub + 1) + '.png'
                    },
                    info: 0
                },
                {
                    tabbarName: '快速下单',
                    linkUrl: '/quick',
                    icon: {
                        // normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-quick.png',
                        // active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-quick.png'
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-quick-1.png?v=1',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-quick-' +  (this.currentClub + 1) + '.png'
                    },
                    info: 0
                },
                {
                    tabbarName: '购物车',
                    linkUrl: '/cart',
                    icon: {
                        // normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-cart.png',
                        // active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-cart.png'
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-cart-1.png?v=1',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-cart-' +  (this.currentClub + 1) + '.png'
                    },
                    info: this.cartNum
                },
                {
                    tabbarName: '我的',
                    linkUrl: '/personal',
                    icon: {
                        // normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-mine.png',
                        // active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-2020-mine.png'
                        normal: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-mine-1.png?v=1',
                        active: 'https://imga.hnhcyy.com/fed/b2b-h5/tabbar/icon-mine-' +  (this.currentClub + 1) + '.png'
                    },
                    info: 0
                }
            ]
        }
    },
    watch: {
        cartNum: function(val){
            this.tabbarData[3].info = val
        },
        '$store.getters.userInfo.currentType': function(val){
            this.currentClub = val
        }
    },
    methods: {
        changeTabbar(active){
            _czc.push(["_trackEvent", "点击底部菜单栏", "tabbar_click", this.tabbarData[active].tabbarName + ";club:" + this.$store.getters.userInfo.currentType])
        }
    }
}
</script>

<style lang="scss">
.page-tool-bar{
    .van-tabbar--fixed{
        z-index: 3;
    }
    .van-tabbar-item__icon img {
        height: .48rem;
    }
    .van-info{
        margin-top: .1rem !important;
    }
}
</style>
