<template>
    <van-dialog
        v-model="show"
        :show-confirm-button="false"
        :class="['account-not-open-dialog', status === 1 ? 'not-open-bg-1':'']"
    >
        <div v-if="status === 1">
            <h6 class="title">温馨提示</h6>
            <div class="tips-content">{{ msg }}</div>
            <div class="btn-box">
                <van-button round @click="close">取 消</van-button>
                <van-button :loading="loading" loading-type="spinner" round color="#FF4646" @click="save">申请重开</van-button>
            </div>
        </div>
        <div v-else-if="status === 2">
            <div class="tips-box">
                <img class="icon-tips" src="@/assets/images/submit_success.png" alt="">
                <h6 class="title">提交成功</h6>
            </div>
            <div class="tips-content-box">
                <div class="tips-content">{{ msg }}</div>
                <ul class="manager-list">
                    <ul class="manager-list">
                        <li v-for="item in managerList" :key="item.sid">
                            <p>{{ `${item.processHandleUserName}${item.phone}` }}</p>
                            <img src="@/assets/images/call-phone.png">
                        </li>
                    </ul>
                </ul>
                <div class="btn-box">
                    <van-button round color="#FF4646" @click="save">好的，我知道了</van-button>
                </div>
            </div>
        </div>
        <div v-else-if="status === 3">
            <div class="tips-box">
                <img class="icon-tips" src="@/assets/images/submit_success.png" alt="">
                <h6 class="title">温馨提示</h6>
            </div>
            <div class="tips-content-box">
                <div class="tips-content">{{ msg }}</div>
                <ul class="manager-list">
                    <li v-for="item in managerList" :key="item.sid">
                        <p>{{ `${item.processHandleUserName}${item.phone}` }}</p>
                        <img src="@/assets/images/call-phone.png">
                    </li>
                </ul>
                <div class="btn-box">
                    <van-button round color="#FF4646" @click="close">好的，我知道了</van-button>
                </div>
            </div>
        </div>
    </van-dialog>
</template>

<script>
export default {
    data() {
        return {
            loading: false,
            show: false, // 账号是否是关闭状态
            status: 1,
            msg: '',
            managerList: []
        }
    },
    methods: {
        open(data, fn) {
            this.status = data.status;
            this.msg = data.msg;
            this.callback = fn;
            this.show = true;
        },
        refreshStatus(data, fn) {
            this.status = data.status;
            this.msg = data.msg;
            this.callback = fn;
            this.managerList = data.managerList;
        },
        close() {
            this.show = false;
            this.managerList = [];
            this.status = '';
            this.msg = '';
            this.loading = false;
        },
        save() {
            this.callback();
        }
    }
}
</script>

<style lang="scss">
.account-not-open-dialog{
    box-sizing: border-box;
    width: 6.54rem;
    &.not-open-bg-1{
        padding: 2.36rem .4rem .4rem .4rem;
        height: 6.32rem;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/not_open_account_bg.png') no-repeat;
        background-size: auto 100%;
    }
    .tips-box{
        width: 6.54rem;
        height: 2rem;
        padding-top: .4rem;
        background: url('https://imga.hnhcyy.com/fed/b2b-wechat/not_open_account_bg_audit.png') no-repeat;
        background-size: auto 100%;
        .icon-tips{
            display: block;
            width: .88rem;
            margin: 0 auto;
        }
    }
    .tips-content-box{
        padding: 0 .28rem .4rem .28rem;
        .manager-list{
            margin-top: .28rem;
            li{
                margin-top: .2rem;
                padding: 0 .2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                height: .84rem;
                background: #FFFBF7;
                border-radius: 4px;
                img{
                    width: .44rem;
                }
            }
        }
    }
    .title{
        text-align: center;
        padding: .2rem 0 .36rem 0;
        font-size: .32rem;
        line-height: .44rem;
    }
    .tips-content{
        font-size: .28rem;
        text-align: center;
        line-height: .48rem;
    }
    .btn-box{
        margin-top: .4rem;
        display: flex;
        justify-content: center;
        .van-button{
            padding: 0;
            width: 2.68rem;
            height: .8rem;
            text-align: center;
            line-height: .8rem;
            &:nth-child(1){
                border: .02rem solid #E8E8E8;
            }
            &:nth-child(2){
                margin-left: .4rem;
            }
        }
        .van-button__loading{
            padding-top: .1rem;
            .van-loading__spinner{
                margin-top: .1rem;
            }
        }
    }
}
</style>
