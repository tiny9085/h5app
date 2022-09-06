<template>
    <div class="app-register-second">
        <div class="top-div" />
        <div class="tips">
            <span>!</span>
            <p>不同的会员类型会对应不同的资质要求，不同会员类型需必备的资质标准不同，我们会根据您所属的会员类型来提供您查看对应的资质要求，请根据您的所属的类型来进行资质信息上传。</p>
        </div>
        <van-cell-group class="tableview-style">
            <div class="feed-title"><img src="@/assets/images/icon_register.png" class="left" alt="">资质信息填写</div>
            <van-field
                label="会员类型"
                placeholder="请选择会员类型"
                disabled
                right-icon="arrow"
                input-align="right"
                required
                @click="clubBtnPressed"
            />
            <van-action-sheet v-model="show" title="标题">
                <div class="content">内容</div>
            </van-action-sheet>
            <div class="cell-title"><span>*</span>资质要求</div>
            <van-cell-group class="zizhi-tableview-style">
                <van-cell
                    title="123"
                    label="456"
                />
                <van-cell
                    title="123"
                    label="456"
                />
                <van-cell
                    title="123"
                    label="456"
                />
                <van-cell
                    title="123"
                    label="456"
                />
            </van-cell-group>
            <div class="upload-img">
                <div class="feed-title"><span>*</span>上传图片</div>
                <div> 
                    <van-uploader v-model="imagesList" :before-read="beforeRead" :max-count="9" :after-read="onRead" upload-icon="plus" multiple @delete="deleteimg" />
                </div>
            </div>  
        </van-cell-group>
        <div class="footer">
            <p :class="isOk ? '':'is-ok'" @click="updatePwd">提 交</p>
        </div>
    </div>
</template>

<script>
export default {
    data(){
        return {
            show: false,
            imagesList: [],
            imgurl: []
        }
    },
    methods: {
        clubBtnPressed(){
            console.log(this.show)
            this.show = true
            console.log(this.show)
        },
        /** 
         * 上传图片
         */
        onRead(file) {
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
                // Api.imgPost(fd).then(res => {
                //     this.imgurl.push({ 'content': item.content, 'img': (res.data.data)[0] });
                // })
            })
        }
    }
}
</script>

<style lang="scss">
.feedback-index{
    background: #f1f1f1;
}
.app-register-second{
  .tableview-style{
    margin: 0.20rem;
    border-radius:0.16rem;
    background-color: #fff;
    .zizhi-tableview-style{
      margin: 0.20rem;
      border-radius: 0.16rem;
      background: #213b6e;
      van-cell{
        background-color: #213b6e !important;
      }
    }
    .cell-title{
      color: #333333;
        font-size: .14rem;
        margin-bottom: 0.16rem;  
        margin-top: 0.24rem;  
        font-weight: 500;
        margin-left: 0.2rem;
        span{
            color: #ED3129;
            font-size: 0.28rem;
            font-weight: 500;
            margin-right:0.05rem;
            vertical-align: middle; 
        }
    }
  }
  .footer{
        padding: .28rem;
        border-top: .02rem solid #EEEEEE;
        background: #FFFFFF;
        p{
            height: .8rem;
            text-align: center;
            line-height: .8rem;
            color: #FFFFFF;
            font-weight: 600;
            background: #DDDDDD;
            border-radius: 20px;
            font-size: .28rem;
        }
        .is-ok{
            background: #FF4646;
        }
    }
  .tips{
        display: flex;
        align-items: top;
        padding: .1rem .28rem;
        background: #FFF5E4;
        color: #FF6E00;
        span{
          margin-top: 0.10rem;
            width: .28rem;
            height: .28rem;
            text-align: center;
            line-height: .28rem;
            border-radius: 50%;
            border: .02rem solid #FF6E00;
        }
        p{
            flex: 1;
            margin-left: .2rem;
            line-height: .44rem;
        }
    }
  .upload-img{
        padding: 0 .20rem;
        color: #333333;
        font-size: .30rem;
        border-radius: 0.12rem;
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
        img{
          width: 0.32rem;
          height: 0.32rem;
          margin-right:0.15rem;
          margin-left:0.28rem;
          margin-top:0.3rem;
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
