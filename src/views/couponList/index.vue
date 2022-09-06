<template>
    <div class="couponList" :style="{minHeight: winHeight+'px'}">
        <div class="top-div" />
        <template v-if="conponList.length === 0 && !loading">
            <div v-if="!refreshFlag" class="no-data">
                <img src="@/assets/images/emptyCart.png">
                <span>暂无数据</span>
            </div>
            <div v-if="refreshFlag" class="no-data">
                <img src="@/assets/images/refresh.png">
                <span>数据获取失败，请尝试刷新!</span>
                <van-button @click="resh"><p>重新刷新</p></van-button>
            </div>
        </template>
        <template v-else>
            <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦!'" :immediate-check="false" :offset="50" @load="onLoad">
                <coupon-box v-for="(item, index) in conponList" :key="index" :coupon="item" @fetchList="fetchList" />
            </van-list>
        </template>
    </div>
</template>

<script>
import couponBox from '@/components/couponDetail/index'
import Api from '@/api/personal/index'
import { Toast } from 'vant'
export default {
    name: "CouponList",
    components: {
        couponBox
    },
    data(){
        return {
            conponList: [],
            loading: false,
            finished: false,
            current: 1,
            refreshFlag: false
        }
    },
    computed: {
        winHeight(){
            return this.$store.getters.winHeight
        }
    },
    watch: {
        '$store.getters.navbarRightClick': function(val){
            this.$router.push('/personal/coupon')
        }
    },
    mounted(){
        this.loading = true
        Toast.loading({
            message: '加载中...',
            duration: 0,
            forbidClick: true
        });
        this.$store.commit('setCartRightText', '我的优惠券')
        this.fetchList()
    },
    methods: {
        resh(){
            this.fetchList()
        },
        // 查询列表
        fetchList(){
            Api.fetchCouponList({ current: this.current, size: 10 }).then(({ data: { data }}) => {
                Toast.clear()
                this.conponList = data.records || []
                this.loading = false
                this.refreshFlag = false
            }).catch(() => {
                Toast.clear()
                this.loading = false
                this.refreshFlag = true
            })
        },
        onLoad() {
            Api.fetchCouponList({ current: this.current + 1, size: 10 }).then(({ data: { data }}) => {
                Toast.clear()
                this.conponList = this.conponList.concat(data ? data.records || [] : [])
                this.loading = false;
                if (this.current + 1 >= data.pages){
                    this.finished = true
                } else {
                    this.current++
                }
            })
        }
    }
}
</script>

<style lang="scss">
.couponList{
        background: #f1f1f1;
        .couponDetail-box{
            .right{
                .row-2{
                    .receiveBtn{
                    margin-left: 1.62rem !important;
                }
                    .useBtn{
                        margin-left: 1.62rem !important;
                    }
                }
            }
        }
        .no-data {
            display: flex;
            flex-direction: column;
            align-items: center;

            img {
                width: 4.96rem;
                height: 4.96rem;
                margin-top: 1.44rem;
            }

            span {
                color: #bbbbbb;
                font-size: .36rem;
                padding-top: .54rem;
            }
            .van-button{
                width: 2.2rem;
                height: 0.68rem;
                background: #FF4646;
                border-radius: 0.47rem;
                margin-top: 0.4rem;
            p{
                color: #ffffff;
                font-size: 0.32rem;
                text-align: center;
                line-height: 0.68rem;
            }
        }
        }
    }
</style>
