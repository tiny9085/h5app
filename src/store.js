import Vue from 'vue'
import Vuex from 'vuex'
import Cookies from 'js-cookie';
import Api from '@/api/product/cart'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        /**
		 * 窗口高度 在layout组件中通过resize更新
		 */
        winHeight: 0,
        /* 
        * 窗口原始高度 
        */
        originHeight: 0,
        /**
		 * 登录用户信息
		 */
        userInfo: null,
        /**
		 * 登录token信息
		 */
        token: null,
        /**
		 * 数据字典
		 */
        dictionary: [],
        /**
		 * 用户唯一标识
		 */
        imei: Math.floor(Math.random() * 1000000000).toString(),
        /**
         * 是否展示门店选择
         */
        selectStore: {},
        /**
         * 是否点击navbar右侧按钮
         */
        navbarRightClick: 0,
        /**
         * 购物车右侧按钮文案
         */
        cartRightText: '',
        /**
         * 购物车品种数
         */
        cartNum: '',
        /**
         * 查询分类sid
         */
        firstSid: '',
        /**
         * 是否显示标题栏
         */
        hasNavbar: true,
        /**
         * 是否显示底部tabbar
         */
        hasToolbar: true,
        /**
         * 购物车已加购商品数量
         */
        cartAdded: localStorage.cartAddedObj ? JSON.parse(localStorage.cartAddedObj) : {},
        /*
         * 用户经营范围
         */
        businessScope: localStorage.getItem('businessScope') ? JSON.parse(localStorage.getItem('businessScope')) : [],
        specialYLLTObj: localStorage.getItem('specialYLLTObj') ? JSON.parse(localStorage.getItem('specialYLLTObj')) : {},
        showSpecialAgreement: localStorage.getItem('showSpecialAgreement') || '',
        notPayMember: localStorage.getItem('notPayMember') ? JSON.parse(localStorage.getItem('notPayMember')) : [],
        qrCodeParams: localStorage.getItem('qrCodeParams') ? JSON.parse(localStorage.getItem('qrCodeParams')) : {},
        navBarKeyword: ''
    },
    getters: {
        winHeight: state => {
            return state.winHeight
        },
        originHeight: state => {
            return state.originHeight
        },
        userInfo: state => {
            return state.userInfo
        },
        token: state => {
            return state.token
        },
        dictionary: state => {
            return state.dictionary
        },
        imei: state => {
            return state.imei
        },
        selectStore: state => {
            return state.selectStore
        },
        userAccount: state => {
            return state.userAccount
        },
        navbarRightClick: state => {
            return state.navbarRightClick
        },
        cartRightText: state => {
            return state.cartRightText
        },
        cartNum: state => {
            return state.cartNum
        },
        firstSid: state => {
            return state.firstSid
        },
        hasNavbar: state => {
            return state.hasNavbar
        },
        hasToolbar: state => {
            return state.hasToolbar
        },
        cartAdded: state => {
            return state.cartAdded;
        },
        businessScope: state => {
            return state.businessScope
        },
        specialYLLTObj: state => {
            return state.specialYLLTObj
        },
        showSpecialAgreement: state => {
            return state.showSpecialAgreement
        },
        notPayMember: state => {
            return state.notPayMember;
        },
        qrCodeParams: state => {
            return state.qrCodeParams;
        },
        navBarKeyword: state => {
            return state.navBarKeyword;
        }
    },
    mutations: {
        setWinHeight(state, height) {
            state.originHeight = state.winHeight;
            state.winHeight = height;
        },
        setUserInfo(state, userInfo) {
            state.userInfo = userInfo;
            if (userInfo) {
                if (userInfo.clubs) {
                    const club = userInfo.clubs.filter(item => item.code === userInfo.currentType)[0] || {}
                    userInfo.clubName = club.name;
                    userInfo.shortClubName = club.shortName;
                }
                localStorage.setItem('userInfo', JSON.stringify(userInfo))
            } else {
                localStorage.removeItem('userInfo')
            }
        },
        setToken(state, token) {
            state.token = token;
            if (token) {
                Cookies.set('token', token)
            } else {
                Cookies.remove('token')
            }
        },
        setUserAccount(state, userAccount) {
            state.userAccount = userAccount;
            if (userAccount) {
                localStorage.setItem('userAccount', userAccount)
            } else {
                localStorage.removeItem('userAccount')
            }
        },
        setDictionary(state, data) {
            state.dictionary = data;
        },
        setSelectStore(state, data) {
            state.selectStore = data;
        },
        setNavbarRightClick(state) {
            state.navbarRightClick++;
        },
        setCartRightText(state, data) {
            state.cartRightText = data
        },
        setCartNum(state) {
            Api.getCartNum().then((res) => {
                if (!res) return
                state.cartNum = res.data.data
            })
        },
        setFirstSid(state, data) {
            state.firstSid = data
        },
        setHasNavbar(state, data) {
            state.hasNavbar = data
        },
        setHasToolbar(state, data) {
            state.hasToolbar = data
        },
        setCartAdded(state, data) {
            if (data) {
                state.cartAdded = JSON.parse(JSON.stringify(data || {}));
                localStorage.setItem('cartAddedObj', JSON.stringify(data || {}));
            } else {
                Api.addedCount().then(({ data: data }) => {
                    state.cartAdded = data.data || {};
                    localStorage.setItem('cartAddedObj', JSON.stringify(data.data || {}));
                })
            }
        },
        setBusinessScope(state, data) {
            if (data) {
                state.businessScope = data;
                localStorage.setItem('businessScope', JSON.stringify(data));
            } else {
                Api.businessScope().then(re => {
                    const data = re.data.data || [];
                    state.businessScope = data;
                    localStorage.setItem('businessScope', JSON.stringify(data));
                })
            }
        },
        setSpecialYLLTObj(state, data) {
            state.specialYLLTObj = data;
            localStorage.setItem('specialYLLTObj', JSON.stringify(data));
        },
        setShowSpecialAgreement(state, data) {
            state.showSpecialAgreement = data;
            localStorage.setItem('showSpecialAgreement', data);
        },
        setNotPayMember(state, data) {
            state.notPayMember = data;
            localStorage.setItem('notPayMember', JSON.stringify(data));
        },
        setQrCodeParams(state, data) {
            state.qrCodeParams = data;
            localStorage.setItem('qrCodeParams', JSON.stringify(data));
        },
        setNavBarKeyword(state, data) {
            state.navBarKeyword = data;
        }
    },
    actions: {
		
    }
})
