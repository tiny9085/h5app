<template>
    <div>
        <div class="top-div" />
        <div class="news-detail">
            <div class="title">{{ newsDetail.title }}</div>
            <div class="time">{{ newsDetail.createTime }}</div>
            <div class="content" v-html="newsDetail.content" />
            <div class="bottom-box">
                <!-- <img src="https://imga.hnhcyy.com/fed/b2b-wechat/news-over.png"> -->
                <div class="news-over">END</div>
                <div class="good-news">
                    <div />
                    <p>推荐阅读</p>
                </div>
                <div v-if="upDetail && upDetail.sid" class="prev-news" @click="$router.push({path:'/news/detail',query:{sid:upDetail.sid}})">
                    上一条：{{ upDetail ? upDetail.title: '没有了' }}
                </div>
                <!-- <div v-else-if="!upDetail" class="next-news1">
                    上一条：没有了
                </div> -->
                <div v-if="downDetail && downDetail.sid" class="next-news" @click="$router.push({path:'/news/detail',query:{sid:downDetail.sid}})">
                    下一条：{{ downDetail ? downDetail.title : '没有了' }}
                </div>
                <!-- <div v-else class="next-news1">
                    下一条：没有了
                </div> -->
            </div>
        </div>
    </div>
</template>

<script>
import Api from '@/api/news/index'
export default {
    data(){
        return {
            newsDetail: {},
            downData: {},
            upData: {}
        }
    },
    created(){
        this.getDetail()
    },
    methods: {
        getDetail(){
            Api.getNewsInfo(this.$route.query.sid).then(res => {
                this.newsDetail = res.data.data.main;
                this.upDetail = res.data.data.upData;
                this.downDetail = res.data.data.downData;
            })
        }
    }
}
</script>

<style lang="scss">
.news-detail {
    // padding: .20rem;
    // width: calc(100% - .4rem);
    overflow: hidden;
    padding: 0.4rem 0.28rem 0.8rem 0.28rem;
    section{
        width: 100% !important;
        img{
            // width: 100%;
            width: 6.94rem;
            height: 4rem;
        }
    }
    p{
        width: 100% !important;
        img{
            // width: 100%;
            // height: 4rem;
            width: 6.94rem;
            height: 4rem;
        }
    }
    span{
        width: 100% !important;
    }
    .title {
        font-size: .40rem;
        color: #333333;
        padding-bottom: .20rem;
        font-weight: 600;
    }
    .time {
        color: #666666;
        font-size: .28rem;
        padding-bottom: .40rem;
    }
    // .content{
    //     p{
    //         font-size: 0.28rem;
    //         color: #666;
    //     }
    //     span{
    //         font-size: 0.28rem;
    //         color: #666;
    //     }
    // }
    .bottom-box {
        .news-over{
            height: 0.72rem;
            width: 0.72rem;
            background: rgba(153, 153, 153, 0.22);
            color: #fff;
            font-size: 0.24rem;
            font-weight: 500;
            text-align: center;
            line-height: 0.72rem;
            border-radius:50% ;
            margin: 0.8rem 3.04rem 0.8rem 3.28rem;
        }
        .good-news{
            color: #333;
            font-weight: 600;
            font-size: 0.28rem;
            height: 0.4rem;
            width: 1.4rem;
            display: flex;
            div{
                height: 0.28rem;
                background: red;
                width: 0.06rem;
                background: linear-gradient(180deg, #ED3129 0%, #FFBBB5 100%);
                // float: left;
            }
            p{
                margin-top: -0.06rem;
                margin-left: 0.16rem;
            }
        }
        .prev-news,
        .next-news {
            color: #666666;
            font-size: .28rem;
            margin-top: .2rem;
            line-height: 0.64rem;
            text-decoration: none;
            width: 6.74rem;
            height: 0.64rem;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            background: #f6f6f6;
            border-radius: 0.12rem;
            padding-left: 0.2rem;
        }
        .next-news1{
            font-size: .28rem;
            margin-top: .2rem;
            color: #666666;
            padding-left: 0.2rem;
        }
        // .next-news {
        //     padding-bottom: .62rem;
        // }
    }
}
</style>
