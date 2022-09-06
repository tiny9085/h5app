<template>
    <div class="pagination-box" @click="backToTop">
        <transition name="fade">
            <div v-if="isScroll" class="pages">
                <img src="@/assets/images/backtotop-1.png" alt="">
                <span>{{ current }}</span>
            </div>
        </transition>
        <div v-if="!isScroll">
            <div class="backToTop">
                <img src="@/assets/images/backtotop.png" alt="">
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Pagination',
    props: {
        current: {
            type: Number,
            default: 1
        },
        domDiv: {
            type: String,
            default: 'app-main'
        }
    },
    data() {
        return {
            isScroll: false,
            interval: null,
            isMoving: false,
            backPosition: 0,
            oldScrollTop: 0,
            scrollHeight: 0
        }
    },
    watch: {
        scrollHeight: function(newValue, oldValue) {
            setTimeout(() => {
                if (newValue === this.scrollHeight) { // 延时执行后当newValue等于window.scrollY，代表滚动结束
                    this.isScroll = false
                    this.oldScrollTop = newValue; // 每次滚动结束后都要给oldScrollTop赋值
                }
            }, 1000); // 必须使用延时器，否则每次newValue和window.scrollY都相等，无法判断，20ms刚好大于watch的侦听周期，故延时20ms
            if (this.oldScrollTop === oldValue) { // 每次滚动开始时oldScrollTop与oldValue相等
                this.isScroll = true
            }
        }
    },
    mounted() {
    },
    beforeDestroy() {
        if (this.interval) {
            clearInterval(this.interval)
        }
    },
    methods: {
        backToTop() {
            const DivDom = document.getElementsByClassName(this.domDiv)[0]
            if (!DivDom || this.isMoving) return
            const start = this.scrollHeight
            let i = 0
            this.isMoving = true
            this.interval = setInterval(() => {
                const next = Math.floor(this.easeInOutQuad(10 * i, start, -start, 500))
                if (next <= this.backPosition) {
                    DivDom.scrollTo(0, this.backPosition)
                    clearInterval(this.interval)
                    this.isMoving = false
                } else {
                    DivDom.scrollTo(0, next)
                }
                i++
            }, 16.7)
        },
        easeInOutQuad(t, b, c, d) {
            if ((t /= d / 2) < 1) return c / 2 * t * t + b
            return -c / 2 * (--t * (t - 2) - 1) + b
        }
    }

}
</script>

<style lang="scss">
.pagination-box {
    position: fixed;
    bottom: 1.48rem;
    right: 0.42rem;
    z-index: 2;
    width: 0.72rem;
    height: 0.72rem;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0px 0px 0.2rem #e4e4e4;
    overflow: hidden;
    .fade-enter-active,
    .fade-leave-active {
        transition: opacity 0.5s;
    }
    .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
        opacity: 0;
    }
    img {
        width: 0.24rem;
        height: 0.28rem;
    }
    .backToTop{
        width: 0.72rem;
        height: 0.72rem;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .pages {
        width: 0.72rem;
        height: 0.72rem;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        font-size: 0.28rem;
        line-height: 0.4rem;
        color: #666;
        img {
            width: 0.24rem;
            height: 0.21rem;
            margin-bottom: 0.04rem;
        }
    }
}
</style>
