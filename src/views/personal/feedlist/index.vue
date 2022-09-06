<template>
    <div class="feed-list-box" :style="[{'height': winHeight + 'px'}]">
        <van-tabs v-model="active" sticky @click="changeType">
            <van-tab v-for="(item,index) in titleData" :key="index" :title="item.title" />
        </van-tabs>
        <div v-if="feedInfoList.length>0" class="message">
            <van-list v-model="loading" :finished="finished" :finished-text="'我是有底线的哦！'" :offset="50" @load="onLoad">
                <div v-for="(item1, index1) in feedInfoList" :key="index1" class="info-box" @click="jumpInfo(item1)">
                    <div class="lefttext">
                        <span 
                            class="title" 
                            :style="item1.type ===1 ? 'background: #E9F9FF;color: #53AEFF': 
                                item1.type ===2 ? 'background: #E0F9F4;color: #47B59D': 
                                item1.type ===3 ? 'background: #E9EDFF;color: #7790FF': 
                                item1.type ===4 ? 'background: #FFF4E6;color: #E1993E': 
                                item1.type ===5 ? 'background: #FFE9E9;color: #ED3129': ''"
                        >{{ item1.typename }}</span>
                        <span class="time">{{ item1.createTime }}</span>
                    </div>
                    <div class="text">{{ item1.content }}</div>
                </div>
            </van-list>
        </div>
        <div v-if="feedInfoList.length===0 && !loading && !refreshFlag" class="no-message">
            <div><img src="@/assets/images/emptyCart.png" alt=""></div>
            <span>暂无记录</span>
        </div>
        <div v-if="feedInfoList.length===0 && !loading && refreshFlag" class="no-message">
            <img src="@/assets/images/refresh.png">
            <span>数据获取失败，请尝试刷新!</span>
            <van-button @click="resh"><p>重新刷新</p></van-button>
        </div>
    </div>
</template>
<script>
import { Toast } from 'vant';
import Api from '@/api/personal/index'
export default {
    data() {
        return {
            titleData: [
                { type: 1, title: '已回复' },
                { type: 0, title: '待回复' }
            ],
            status: 1,
            feedInfoList: [],
            current: 1,
            finished: false,
            loading: false,
            active: 0,
            refreshFlag: false
        };
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    mounted(){
        this.loading = true
        Toast.loading({
            message: '加载中...'
        });
        document.getElementsByTagName("body")[0].className = "feedlist-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "feedlist-index");
    },
    created(){
        this.active = this.$route.query.isactive ? Number(this.$route.query.isactive) : 0
        if (this.active){
            this.status = 0
            this.current = 2;
        } 
        this.feedlist(this.status, 1, 10)
    },
    methods: {
        resh(){
            this.feedlist(this.status, 1, 10)
        },
        changeType(type){
            this.feedInfoList = [];
            this.finished = false;
            this.current = 2;
            switch (type){
                case 0:
                    this.status = 1;
                    break;
                case 1:
                    this.status = 0;
                    break;
            }
            this.feedlist(this.status, 1, 10)
        },
        onLoad(){
            Toast.loading({
                message: '加载中...'
            });
            this.current = 2;
            Api.feedlist({ status: this.status, current: this.current, size: 10  }).then(({ data: { data }}) => {
                this.feedInfoList = this.feedInfoList.concat(data ? data.records || [] : [])
                this.loading = false
                if (this.feedInfoList.length){
                    this.feedInfoList.forEach(item => {
                        switch (item.type) {
                            case 1:
                                item.typename = '物流反馈'
                                break;
                            case 2:
                                item.typename = '商品期望'
                                break;
                            case 3:
                                item.typename = '其他建议'
                                break;
                            case 4:
                                item.typename = '服务协助'
                                break;
                            case 5:
                                item.typename = '功能优化'
                                break;
                            default:
                                break;
                        }
                    })
                }
                if (this.current  >= data.pages){
                    this.finished = true
                } else {
                    this.current++
                }
                Toast.clear();
            })
        },
        feedlist(status, current, size){
            Api.feedlist({ status: status, current: current, size: size  }).then(({ data: { data }}) => {
                this.feedInfoList = this.feedInfoList.concat(data ? data.records || [] : [])
                if (this.feedInfoList.length){
                    this.feedInfoList.forEach(item => {
                        switch (item.type) {
                            case 1:
                                item.typename = '物流反馈'
                                break;
                            case 2:
                                item.typename = '商品期望'
                                break;
                            case 3:
                                item.typename = '其他建议'
                                break;
                            case 4:
                                item.typename = '服务协助'
                                break;
                            case 5:
                                item.typename = '功能优化'
                                break;
                            default:
                                break;
                        }
                    })
                }
                if (this.feedInfoList.length < 10){
                    this.finished = true;
                } else {
                    this.finished = false;
                }
                Toast.clear();
                this.loading = false
                this.refreshFlag = false
            }).catch(() => {
                Toast.clear();
                this.loading = false
                this.refreshFlag = true
            })
        },
        jumpInfo(item){
            localStorage.setItem('feedrow', JSON.stringify(item));
            this.$router.push('/personal/feedinfo')
        }
    }
}
</script>
<style lang="scss">
.feedlist-index{
    background: #f1f1f1;
    .van-nav-bar{
        border-bottom: 1px solid #eee;
    }
}
.feed-list-box{
    .van-tabs__line{
        width: 50px !important;
    }
    .van-tabs__nav--line{
       color: #FFFFFF;
    }
    .van-tabs__nav--line .van-tab{
        font-size: 0.28rem;
    }
    .van-tab--active .van-tab__text{
        color: #ee0a24;
        font-size: 0.32rem;
    }
    .message{
        background: #F1F1F1;
        padding-top: 0.01rem;
        .van-list{
            background: #F1F1F1;
            .info-box{
                background: #ffffff;
                padding: 0.28rem;
                margin: 0.24rem 0.16rem;
                border-radius: 0.12rem;
                .lefttext{
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    .title{
                        height: 0.48rem;
                        width: 1.36rem;
                        font-size: 0.26rem;
                        line-height: 0.48rem;
                        border-radius: 0.08rem;
                        text-align: center;
                    }
                    .time{
                        color: #A3A3A3;
                        font-size: 0.24rem;
                    }
                }
                .text{
                    margin-top: 0.32rem;
                    color: #666666;               
                    font-size: 0.28rem;
                }
            }
        }
    }
    .no-message{
        display: flex;
        flex-direction: column;
        align-items: center;
        img{
            width: 4.96rem;
            height: 4.96rem;
            margin-top: 1.44rem;
        }
        span{
            font-size: .36rem;
            color:#bbbbbb;
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
