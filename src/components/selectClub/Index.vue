<template>
    <van-popup v-model="show" overlay class="select-club-95">
        <div class="popup-select-club">
            <div class="popup-title">
                请选择
                <img src="@/assets/images/close-1.png" alt="" @click="closePopup">
            </div>
            <div class="user-box">
                <div
                    v-for="(item, index) in clubs"
                    :key="index"
                    class="list"
                    :class="currentIndex === index ?'active':''"
                    @click="selectClub(item, index)"
                >
                    <van-image class="user-icon" :src="item.imgUrl" />
                    <span class="user-describe">{{ item.describe }}</span>
                </div>
            </div>
            <van-button type="danger" size="large" round @click="onSubmit">确定</van-button>
        </div>
    </van-popup>
</template>

<script>
export default {
    props: {
        loginType: {
            type: Number,
            default: 0
        },
        formData: {
            type: Object,
            default() {
                return {}
            }
        }
    },
    data() {
        return {
            show: false,
            clubs: [],
            currentId: '',
            currentIndex: 0
        }
    },
    computed: {
        currentClub: function(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.currentType : null
        }
    },
    methods: {
        /**
         * 打开弹窗
         */
        open(clubs, callback) {
            const clubData = [];
            clubs.forEach(club => {
                clubData.push({
                    code: club.code,
                    name: club.name,
                    describe: club.desc,
                    imgUrl: club.icon,
                    checked: this.currentClub - 0 === club.code - 0
                })
            })
            if (!this.currentClub){
                clubData[0].checked = true;
                this.currentId = clubData[0].code
                this.currentIndex = 0
            } else {
                this.currentId = this.currentClub
                this.currentIndex = this.currentClub - 1
            }
            this.$set(this, 'clubs', clubData)
            this.callback = callback
            this.show = true
        },
        /**
         * 选择业务线
         */
        selectClub(item, index) {
            for (let i = 0; i < this.clubs.length; i++) {
                if (this.clubs[i].code === item.code){
                    this.clubs[i].checked = true
                    this.currentId = item.code
                } else {
                    this.clubs[i].checked = false
                }
            }
            this.currentIndex = index
        },
        /**
         * 确认登录
         */
        onSubmit() {
            this.callback && this.callback(this.currentId)
            this.show = false;
        },
        /**
         * 关闭弹窗
         */
        closePopup(){
            this.show = false
        }
    }
}
</script>

<style lang="scss">
.select-club-95 {
    border-radius: .20rem;
}
.popup-select-club {
    .popup-title {
        font-size: 0.32rem;
        height: .56rem;
        line-height: .56rem;
        position: relative;
        text-indent: .4rem;
        padding-top: .4rem;
        color: #333;
        img{
            position: absolute;
            right: .4rem;
            top: .52rem;
            width: .24rem;
            height: .24rem;
        }
    }
    .user-box {
        padding: 0.28rem 0rem;
        .list:first-child{
            border-top: 1px solid #eee;
        }
        .list {
            background: #fff;
            line-height: 1;
            display: flex;
            border-bottom: 1px solid #eee;
            padding: .28rem .28rem .28rem .4rem;
            .user-icon{
                width: 1.08rem;
                height: .48rem;
                margin-right: .16rem;
            }
            .user-describe{
                padding: .06rem 0;
                line-height: .38rem;
                color: #999999;
                font-size: .26rem;
            }
        }
        .active{       
            background: #FFFAFA;
            box-shadow: inset 0px -1px 0px #FFC2C2, inset 0px 1px 0px #FFC2C2;;
            border: none;
            .user-describe{
                color: #ED3129;
            }
        }
    }
    .van-button {
        width: 2.78rem;
        height: 0.84rem;
        color: #fff;
        font-size: 0.32rem;
        font-weight: 600;
        border-radius: 0.42rem;
        line-height: 0.84rem;
        margin: 0 2.04rem 0.28rem 2.04rem;
        &.van-button--danger {
            background-color: #FF4646;
        }
    }
}
</style>

