<template>
    <div class="Page-personal-feedback theme-lsx personal-box">
        <div id="feedback">
            <div class="feed-type-box">
                <div class="feed-title"><span>*</span>反馈类型</div>
                <div class="feed-type">
                    <van-row gutter="20">
                        <template v-for="(item,index) in typeList">
                            <van-col :key="index" span="8">  
                                <span :class="item.type == type ? 'active' : ''" @click="changeType(item.type)">{{ item.name }}</span>
                            </van-col>
                        </template>
                    </van-row>
                </div>
            </div>
            <div class="feedback-info-box">
                <div class="feed-title"><span>*</span>反馈内容</div>
                <textarea
                    id="feedback-info"
                    ref="info"
                    style="resize:none;"
                    name=""
                    maxlength="100"
                    placeholder="请输入您要说的话！"
                    placeholder-class="feedback-info"
                    @input="inputText"
                />
                <div class="font-num r">
                    <span id="font-num">{{ textNum }}</span><span>/100</span>
                </div>
            </div>
            <div class="upload-img">
                <div class="feed-title"><span>*</span>上传图片</div>
                <div class="uploader-bd">
                    <p>请上传图片（选填，提供问题截图，最多9张）</p>
                    <van-uploader v-model="imagesList" :before-read="beforeRead" :max-count="9" :after-read="onRead" upload-icon="plus" multiple @delete="deleteimg" />
                </div>
            </div>
            <div class="submit-btn">
                <van-button type="primary" :loading="loading" @click="submitFeed">提交</van-button>
            </div>
            <van-dialog id="van-dialog" />
        </div>
    </div>
</template>

<script>
import {   Toast } from 'vant';
import Api from '@/api/personal/index'
export default {
    data(){
        return {
            imagesList: [],
            imgurl: [],
            content: '',
            textNum: 0,
            type: 1,
            loading: false,
            typeList: [
                {
                    name: "物流反馈",
                    type: 1
                },
                {
                    name: "商品期望",
                    type: 2
                },
                {
                    name: "服务协助",
                    type: 4
                },
                {
                    name: "功能优化",
                    type: 5
                },
                {
                    name: "其他建议",
                    type: 3
                }
            ],
            selectImgList: []
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "feedback-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "feedback-index");
    },
    methods: {
        /** 
         * 上传图片
         */
        onRead(file) {
            this.upload(file);
        },
        deleteimg(file){
            if (this.imgurl.length){
                this.imgurl.forEach((item, index) => {
                    if (file.content === item.content){
                        this.imgurl.splice(index, 1)
                    }
                })
            }
        },
        upload(file){
            file = [].concat(file)
            file.forEach(item => {
                const fd = new FormData()
                fd.append("file", item.file)
                Api.imgPost(fd).then(res => {
                    this.imgurl.push({ 'content': item.content, 'img': (res.data.data)[0] });
                })
            })
        },
        /**
         * 输入框内容
         */
        inputText() {
            this.content = this.$refs.info.value
            this.textNum = this.content.length;
        },
        /**
         * 切换反馈类型
         */
        changeType(type) {
            this.type = type;
        },
        /**
         * 点击提交按钮
         */
        submitFeed(){
            let imagesUrl = '';
            this.imgurl.forEach(item => {
                imagesUrl += item.img + ',';
            })
            const content = this.content.trim()
            const type = this.type
            this.loading = true;
            if (!type){
                Toast('请选择反馈类型')
                this.loading = false;
                return;
            }
            if (!content){
                Toast('请填写反馈内容')
                this.loading = false;
                return;
            }
            Api.feedbackPost({ type: type, content: content, imagesUrl: imagesUrl.substring(0, imagesUrl.length - 1) }).then(res => {
                if (res.data.code === 0){
                    Toast('提交成功')
                    this.$router.push({ path: '/personal/feedlist', query: { isactive: 1 }})
                }
                this.loading = false;
            });
        }
    }
}
</script>

<style lang="scss">
.feedback-index{
    background: #f1f1f1;
}
.Page-personal-feedback{
    .feed-type-box{
        padding: 0rem 0.2rem;
        border-top: .02rem solid #EAEAEA;
        .feed-type{
            border-radius: 0.12rem;
            height: 1.36rem;
            width: 6.54rem;
            background: #ffffff;
            padding: 0.4rem 0.32rem 0.4rem 0.24rem;
            span{
                display: inline-block;
                width: 2rem;
                height: 0.56rem;
                background: #eee;
                border-radius: 0.28rem;
                color: #666;
                line-height: .56rem;
                text-align: center;
                margin-bottom: 0.24rem;
            }
            .active{
                background: #ED3129;
                color: #ffffff;
            }
        }
    }
    .upload-img{
        padding: 0 .20rem;
        color: #333333;
        font-size: .30rem;
        .uploader-bd{
            display: flex;
            flex-wrap: wrap;
            margin-top: 0.3rem;
            width: 7.1rem;
            height: 100%;
            background: #fff;
            border-radius: 0.12rem;
            p{
                color: #999;
                font-size: 0.28rem;
                padding: 0.28rem 1.04rem 0.28rem 0.28rem;
            }
            .van-uploader{
                margin-left: 0.28rem;
                margin-bottom: 0.28rem;
            }
            .uploader-file{
                display: flex;
                padding-top: .30rem;
                .uploader-img{
                    width: 1.46rem;
                    height: 1.46rem;
                    margin-right: .30rem;
                    border-radius: .10rem;
                }
            }
            .uploader-input{
                width: 1.46rem;
                height: 1.46rem;
                font-size: 1.12rem;
                font-weight: 700;
                color: #BFBFBF;
                background: #F4F4F4;
                text-align: center;
                border-radius: .10rem;
                margin-top: .30rem;
                border: none;
                outline: none;
            }
            .van-uploader__preview-image{
                background: #f1f1f1;
            }
        }
    }
    .feedback-info-box{
        position: relative;
        margin: 0 .20rem;
        #feedback-info{
            padding: .28rem 0.28rem 0 0.28rem;
            background: #fff;
            border-radius: .12rem;
            font-size: .26rem;
            color: #BCBCBC;
            width: 6.54rem;
            height: 2.52rem;
            display: block;
            border: none;
        }
        .feedback-info{
            font-size: .3rem;
            color: #777777;
        }
        .font-num{
            font-size: .28rem;
            color: #bbb;
            letter-spacing: .02rem;
            position: absolute;
            top: 2.8rem;
            right: 0.32rem;
        }
        textarea::-webkit-input-placeholder {
            color: #bbb;
        }
    }
    .submit-btn{
        width: 100%;
        display: flex;
        justify-content: center;
        .van-loading__spinner{
            width: 1.1rem !important;
            height: 0.6rem !important;
        }
        button{
            margin-top: 0.28rem;
            height: 0.8rem;
            width: 7.1rem;
            background: #ED3129;
            color: #ffffff;
            border-radius: .50rem;
            letter-spacing: .15rem;
            border: none;
            outline: none;
            font-size: .40rem;
        }
    }
    .feed-title{
        color: #333333;
        font-size: .32rem;
        margin-bottom: 0.16rem;  
        margin-top: 0.24rem;  
        font-weight: 600;
        margin-left: 0.2rem;
        span{
            color: #ED3129;
            font-size: 0.42rem;
            margin-right:0.05rem;
            vertical-align: middle; 
        }
    }
    #feedback-info{
        color: #333333 !important;
    }
    #van-dialog{
        button{
            color: #ED3129 !important;
            font-size: .30rem;
            padding-right: 1.32rem;
            text-align: right;
        }
    }
    .van-popup{
        top: 40%;
    }
    
}
</style>
