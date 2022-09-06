<template>
    <div v-if="reload" :class="['app-wrapper', pathName]">
        <nav-bar v-if="hasNavbar" />
        <app-main v-if="reload" />
        <tool-bar v-if="hasToolbar" />
        <select-shop v-if="!this.$store.getters.userInfo || (this.$store.getters.userInfo.stores && this.$store.getters.userInfo.stores.length > 1)" ref="selectShop" />
    </div>
</template>

<script>
import AppMain from "./components/AppMain";
import ToolBar from "./components/ToolBar";
import NavBar from "./components/NavBar";
import selectShop from "@/components/selectShop/index"

export default {
    name: "Layout",
    components: {
        AppMain,
        ToolBar,
        NavBar,
        selectShop
    },
    data() {
        return {
            pathName: this.$route.name,
            reload: true
        }
    },
    computed: {
        hasNavbar(){
            return this.$store.getters.hasNavbar
        },
        hasToolbar(){
            return this.$store.getters.hasToolbar
        }
    },
    watch: {
        '$store.getters.userInfo.currentType': function(val){
            // 切换俱乐部后要刷新所有数据
            this.reload = false;
            this.$nextTick(() => {
                this.reload = true;
            })
        },
        '$route.name': function(val){
            this.pathName = val;
        }
    },
    mounted(){
        if (this.$store.getters.token){
            // this.$store.commit('setCartNum')
        }
    }
};
</script>
