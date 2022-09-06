<template>
    <div class="app-page-box clearfix">
        <template v-if="isApp">
            <template v-if="init">
                <slot :is-app="isApp" />
            </template>
            <template v-else>
                <div v-if="loadEnd" class="app-tips">
                    <van-icon name="warning-o" />您的APP版本过低，请先升级！
                </div>
            </template>
        </template>
        <template v-else>
            <slot :is-app="isApp" />
        </template>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
export default {
    props: {
        system: {
            type: String,
            default: 'b2b'
        }
    },
    data(){
        return {
            init: false,
            loadEnd: false,
            isApp: this.$route.query.source !== 'h5'
        }
    },
    computed: {
        isIos: function(){
            return !!navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)
        }
    },
    watch: {
        '$route': function(val, oldVal){
            this.isApp = this.$route.query.source !== 'h5'
        }
    },
    created(){
        this.getToken()
        
        setTimeout(() => {
            this.loadEnd = true
        }, 500)
    },
    methods: {
        getToken(){
            if (this.isApp){
                // 不需要token的页面
                const notNeedToken = this.$route.query.notNeedToken;
                if (notNeedToken) {
                    this.init = true;
                    this.$emit('init', this.isIos)
                    return;
                }
                this.$store.commit("setToken", '')
                VMnative.callHandler(this.system === "b2b" ? "getToken" : "getBiToken", {}, (params) => {
                    if (params) {
                        try {
                            const data = JSON.parse(params);
                            if (typeof data === 'object') {
                                this.$store.commit("setToken", data.token)
                                if (this.system === "b2b"){
                                    this.$store.commit("setUserInfo", { oss: data.appOssUrl, currentType: data.club })
                                    this.ossUrl = data.appOssUrl
                                    this.$store.commit("setCartAdded", data.cartAdded);
                                    this.$store.commit('setBusinessScope', data.businessScope)
                                }
                                if (data.token){
                                    this.init = true;
                                    this.$emit('init', this.isIos)
                                }
                            } else {
                                this.$store.commit("setToken", data)
                                this.$store.commit("setUserInfo", { oss: 'https://imga.hnhcyy.com/' })
                                this.init = true;
                                this.$emit('init', this.isIos)
                            }
                        } catch (e){
                            this.$store.commit("setToken", params)
                            this.$store.commit("setUserInfo", { oss: 'https://imga.hnhcyy.com/' })
                            this.init = true;
                            this.$emit('init', this.isIos)
                        }
                    }
                });
                VMnative.callHandler("finishRefresh")
            } else {
                this.init = true;
                this.$emit('init', this.isIos)
            }
        }
    }
}
</script>

<style lang="scss" scoped>
.app-page-box {
    .app-tips {
        font-size: 16px;
        text-align: center;
        color: #666;
        padding: 50px;
        .van-icon {
            position: relative;
            font-size: 18px;
            bottom: -3px;
            margin-right: 3px;
        }
    }
    .page-box-loading {
        text-align: center;
    }
}

</style>
