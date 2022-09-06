import Vue from 'vue'
import App from './App.vue'
import Vant from 'vant';
import store from './store';
import 'vant/lib/index.css'
import Cookies from 'js-cookie';
import router from './router'
import './assets/iconFont/iconfont.css'
Vue.config.productionTip = false
Vue.config.devtools = true
Vue.use(Vant);
// 去掉前后空格
// eslint-disable-next-line no-extend-native
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
}

// 用户信息
const userAccount = localStorage.getItem('userAccount')
const token = Cookies.get("token")
const userInfo = localStorage.getItem('userInfo')
    
if (userAccount) store.commit('setUserAccount', userAccount)
if (token) store.commit('setToken', token)
if (userInfo) store.commit('setUserInfo', JSON.parse(userInfo))

new Vue({
    el: '#app',
    store,
    router,
    render: h => h(App)
})
