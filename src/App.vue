<template>
    <div id="app" :class="userInfo ? 'theme-'+ userInfo.currentType : ''">
        <router-view />
    </div>
</template>

<script>
import '@/utils/pxtorem'
import { GetQueryString } from '@/utils/util'
export default {
    name: 'App',
    data() {
        return {

        }
    },
    computed: {
        userInfo: function(){
            return this.$store.getters.userInfo
        }
    },
    destroyed() {
        if (window.removeEventListener) {
            window.removeEventListener('resize', this.setHeight);
        } else if (window.detachEvent) {
            window.detachEvent('resize', this.setHeight);
        }
    },
    mounted() {
        this.$store.commit('setWinHeight', document.body.clientHeight)
        window.addEventListener('resize', this.setHeight)
        var isFromJYGW = GetQueryString("isFromJYGW");
        if (this.$store.getters.token && (isFromJYGW === 'wx')){
            this.$router.push('/bi/signUpYLLT?source=h5&&isFromJYGW=wx');
        } 
        // wx.config({
        //     debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        //     appId: 'wx4696e4b4b8ae570d', // 必填，公众号的唯一标识
        //     timestamp: new Date().getTime(), // 必填，生成签名的时间戳
        //     nonceStr: '', // 必填，生成签名的随机串
        //     signature: '', // 必填，签名
        //     jsApiList: [] // 必填，需要使用的JS接口列表
        // });
    },
    methods: {
        /**
         * 设置高度自适应
         */
        setHeight() {
            this.$store.commit('setWinHeight', document.body.clientHeight)
        }
    }
}
</script>

<style lang="scss">
@import "./assets/style/common.scss";
@import "./assets/style/theme/theme-2.scss";
@import "./assets/style/theme/theme-3.scss";
@import "./assets/style/theme/theme-4.scss";
@import "./assets/style/theme/theme-6.scss";
@import "./assets/style/theme/theme-7.scss";
</style>
