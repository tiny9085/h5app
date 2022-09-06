<template>
    <div class="feed-info-box" :style="{minHeight:winHeight+'px'}">
        <div class="top-div" />
        <div>
            <div class="timebox">{{ feedlist.createTime }}</div>
            <div class="sendper">
                <div class="content">{{ feedlist.content }}</div>
                <div class="imgbox">
                    <img src="@/assets/images/img1.png">
                </div>
            </div>
            <div v-if="feedlist.imagesUrl&&feedlist.imagesUrl.length">
                <div v-for="(item,index) in feedlist.imagesUrl.split(',')" :key="index" class="sendper sendimgbox" @click="preViewImg(feedlist.imagesUrl.split(','))">
                    <div class="content">
                        <img :src="$store.getters.userInfo.oss+item" class="sendimg">
                    </div>
                    <div class="imgbox">
                        <img src="@/assets/images/img1.png">
                    </div>
                </div>
            </div>
            <div v-if="feedlist.remark">
                <div class="timebox rendtime">{{ feedlist.updateTime }}</div>
                <div class="sendper rendper">
                    <div class="imgbox">
                        <img src="@/assets/images/img2.png">
                    </div>
                    <div class="content">{{ feedlist.remark }}</div>
                </div>
            </div>
        </div>
        <div v-if="feedlist.remark" class="bottom-note">
            <div class="tip"><img src="@/assets/images/icon-messge.png" alt=""><span>温馨提示</span></div>
            <div class="text">
                若您的疑问未通过客户回复得到解决，可直接联系您的经营顾问，感谢您的反馈，我们将继续努力争取为您带来更优质的服务！
            </div>
        </div>
    </div>
</template>
<script>
import { ImagePreview } from 'vant';
export default {
    data(){
        return {
            feedlist: JSON.parse(localStorage.getItem('feedrow'))
        }
    },
    computed: {
        winHeight: function(){
            return this.$store.getters.winHeight
        }
    },
    methods: {
        /**
         * 预览图片
         */
        preViewImg(item){
            const imgArr = []
            item.forEach(img => {
                imgArr.push(this.$store.getters.userInfo.oss + img)
            })
            ImagePreview(imgArr)
        }
    }
}
</script>
<style lang="scss">
.feed-info-box{
    background: #F4F4F4;
    padding-bottom: 1.5rem;
    box-sizing: border-box;
   .timebox{
        margin: 0.4rem auto 0 auto;
        padding: 0 0.1rem;
        height: 0.45rem;
        line-height: 0.45rem;
        color: #FFFFFF;
        background: #000000;
        opacity:0.2;
        border-radius:10px;
        width: 2.6rem;
        text-align: center;
    }
    .rendtime{
        margin-top: 0.4rem;
    }
    .sendper{
        display: flex;
        align-items: center;
        justify-content: flex-end;
        margin-top: 0.4rem;
        padding: 0 0.2rem;
        .content{
            padding: 0.2rem;
            margin-right: 0.16rem;
            border-radius:.20rem;
            background: #1D98FF;
            color: #fff;
            .sendimg{
                width: 2.15rem;
            }
        }
        img{
            width: .64rem;
        }
    }
    .rendper{
        margin-top: 0.4rem;
        justify-content: flex-start;
        .content{
            margin-right: 0;
            margin-left: 0.2rem;
            background: #FFFFFF;
            color: #000000;
        }
    }
    .bottom-note{
        position: fixed;
        bottom: 0;
        left: 0;
        height:2.16rem;
        background: #ffffff;
        padding: 0.32rem 0.38rem 0.2rem 0.4rem;
        .tip{
            display: flex;
            align-items: center;
            img{
                height: 0.48rem;
                width: 0.48rem;
                margin-right: 0.08rem;
            }
        }
      .text{
            margin-top: 0.12rem;
            font-size: 0.26rem;
            color: #888888;
      }
    }
}
</style>
