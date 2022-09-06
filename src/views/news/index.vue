<template>
    <div class="list-box">
        <div class="top-div" />
        <van-list v-model="loading" :finished="finished" :finished-text="'人家是有底线的哦！'" :finished-icon="'https://imga.hnhcyy.com/fed/b2b-wechat/icon-payment.png'" :offset="10" @load="onLoad">
            
            <div v-for="(item, index) in newsLists" :key="index" class="lists">
                <div class="list" @click="goToDetail(item.sid)">
                    <div class="list-left">
                        <div class="title">{{ item.title }}</div>
                        <div class="time">{{ item.issuerTime || '' }}</div>
                    </div>
                    <div class="list-right">
                        <image-load default-image="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" :original-image="item.thumbnails" />
                    </div>
                </div>
            </div>
        </van-list>
    </div>
</template>

<script>
import Api from '@/api/news/index'
import imageLoad from '@/components/imageLoad/index'
export default {
    name: 'NewsList',
    components: {
        imageLoad
    },
    data() {
        return {
            loading: false,
            finished: false,
            current: 1,
            newsLists: []
        }
    },
    methods: {
        onLoad() {
            Api.getNews({ current: this.current, size: 10 }).then(({ data: { data }}) => {
                this.newsLists = this.newsLists.concat(data ? data.records || [] : [])
                this.loading = false;
                if (this.current >= data.pages){
                    this.finished = true
                } else {
                    this.current++
                }
            })
        },
        goToDetail(sid){
            this.$router.push({ path: "/news/detail", query: { sid: sid }});
        }
        // getNews(){
        //     Api.getNews({ current: this.current, size: 10 }).then(res => {
        //         this.newsLists = res.data.data.records || [];
        //     })
        // }
    }
}
</script>

<style lang="scss">
.list-box {
    background: #f1f1f1;

    .lists {
        padding: 0rem .16rem;
        margin-top: 0.24rem;

        // .list:nth-child(1){
        //     margin-top: 0.24rem;
        // }

        .list {
            display: flex;
            justify-content: space-between;
            background: #fff;
            padding: 0.28rem;
            border-radius: 0.12rem;

            .list-left {
                width: 4.32rem;

                .title {
                    color: #333;
                    font-size: .32rem;
                    font-weight: 600;
                    margin-bottom: .34rem;
                }

                .time {
                    color: #666666;
                    font-size: .28rem;
                    line-height: 1;
                }
            }

            .list-right {
                position: relative;
                margin-left: 0.28rem;
                img {
                    width: 2.2rem;
                    height: 1.5rem;
                }
            }
            //  .list-right::before{
            //     content: " ";
            //     border: 0.1rem solid #FF4646;
            //     border-radius:50%;
            //     position: absolute;
            //     z-index: 1000;
            //     right: -0.08rem;
            //     box-shadow: 0px 0px 8px 0px rgba(237,49,41,0.34);
            //     top: -0.08rem;
            // }
        }
    }
    .van-list__finished-text{
        color: #BBBBBB;
        font-size: 0.26rem;
    }
}
</style>
