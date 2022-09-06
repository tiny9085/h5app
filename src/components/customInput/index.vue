<template>
    <div class="custom-input-box">
        <div :class="['custom-input', { 'error-input': showError }]">
            <input v-model="value" :type="type" :placeholder="placeholder" :maxlength="maxLength" v-on="inputEvent">
        </div>
        <div v-if="showError" :class="{ 'error-message': showError }">{{ errorMessage }}</div>
    </div>
</template>
<script>
export default {
    name: 'CustomInput',
    props: {
        type: {
            type: String,
            default: 'text'
        },
        placeholder: {
            type: String,
            default: '请输入内容'
        },
        inputEvent: {
            type: Object,
            default: () => {
                return {}
            }
        },
        maxLength: {
            type: Number,
            default: 1000
        }
    },
    data() {
        return {
            value: '',
            showError: false,
            errorMessage: this.placeholder
        }
    },
    methods: {
        verification(fn) {
            fn(this.value);
        },
        clear() {
            this.value = '';
            this.showError = '';
        }
    }
}
</script>
<style lang="scss">
.custom-input-box{
    height: 1.14rem;
    .custom-input{
        margin: 0 .2rem;
        border-radius: .16rem;
        border: .02rem solid rgba(228,228,228,1);
        input{
            width: 6.23rem;
            border: none;
            outline: none;
            height: .68rem;
            padding: 0 .2rem;
            border-radius: .16rem;
            margin: 0;
        }
        input::-webkit-input-placeholder{
            color: #CCCCCC;
        }
    }
    .error-input{
        border-color: #ED3129;
    }
    .error-message{
        color: #ED3129;
        font-size: .24rem;
    }
}
</style>
