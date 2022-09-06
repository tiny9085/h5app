<template>
    <section class="app-main">
        <transition name="fade-transform" mode="out-in">
            <keep-alive v-if="$route.meta.keepAlive">
                <router-view :key="key" />
            </keep-alive>
            <router-view v-if="!$route.meta.keepAlive" :key="key" />
        </transition>
    </section>
</template>

<script>
export default {
    name: 'AppMain',
    computed: {
        key() {
            return this.$route.fullPath
        }
    }
}
</script>
