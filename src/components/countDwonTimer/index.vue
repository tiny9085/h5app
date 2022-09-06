<template>
    <span>
        <slot :time="timerStr" :init="init">{{ timerStr }}</slot>
    </span>
</template>
<script>
export default {
    props: {
        timestamp: {
            type: Number,
            default: 0
        },
        duration: {
            type: Number,
            default: 60
        },
        from: {
            type: String,
            default: 'retrievePwdTimestamp'
        },
        onload: {
            type: Boolean,
            default: true
        }
    },
    data() {
        return {
            timerStr: '',
            timer: null,
            endTime: '' // 倒计时结束时间
        }
    },
    beforeDestroy() {
        clearInterval(this.timer);
    },
    mounted() {
        this.onload && this.init();
    },
    methods: {
        init(timestamp) {
            if (timestamp) this.timestamp = timestamp;
            localStorage.setItem(this.from, this.timestamp);
            this.endTime = (this.timestamp - 0) + (this.duration * 1000);
            this.timerFn();
            this.timer = setInterval(() => {
                this.timerFn();
            }, 1000)
        },
        timerFn() {
            if (!this.timestamp) {
                this.timerStr = 0;
                return;
            }
            const timer = this.endTime - new Date().getTime();
            if (timer > 0)  {
                this.timerStr = Math.floor(timer / 1000);
            } else {
                clearInterval(this.timer);
            }
        }
    }
}
</script>
