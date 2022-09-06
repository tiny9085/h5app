<template>
    <div class="qualification-details">
        <div v-if="qualificationDetails.status === 1" class="top-wraning">
            <img src="@/assets/images/icon_reminder.png">
            <span>您的申请已提交，我们将尽快为您审核，如您需重新上传，请先撤回申请。</span>
        </div>
        <ul class="user-store-list">
            <li class="store-item">
                <span class="qualification-status">{{ qualificationDetails.statusCn }}</span>
                <img v-if="qualificationDetails.status === 0" class="qualification-status-img" src="@/assets/images/icon_adopt.png">
                <img v-if="qualificationDetails.status === -2" class="qualification-status-img" src="@/assets/images/icon_no_adopt.png">
                <img v-if="qualificationDetails.status === -3" class="qualification-status-img" src="@/assets/images/icon_cancel.png">
                <img v-if="qualificationDetails.status === 1" class="qualification-status-img" src="@/assets/images/icon_adopting.png">
                <p class="store-name">{{ qualificationDetails.name }}</p>
                <p class="courier-number">申请时间：<span>{{ qualificationDetails.createTime }}</span></p>
                <p class="courier-number">快递单号：{{ qualificationDetails.expressNumber }}</p>
                <p class="update-content">本次更新{{ qualificationDetails.title }}</p>
                <ol class="content-info">
                    <li v-if="qualificationDetails.nearQualificationList.length === 1" class="only-one" />
                    <li v-for="(item, index) in qualificationDetails.nearQualificationList" :key="item">
                        <div class="gsp-bg">
                            <!-- <div class="gsp-content">
                                <van-image :src="ossUrl + item.fileUrl" @click="showImg(index)">
                                    <template v-slot:error>
                                        <img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" alt="">
                                    </template>
                                </van-image>
                            </div> -->
                            <van-image :src="ossUrl + item.fileUrl" @click="showImg(index)">
                                <template v-slot:error>
                                    <img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" alt="">
                                </template>
                            </van-image>
                        </div>
                        <p>{{ item.name }}</p>
                    </li>
                    <li v-if="qualificationDetails.nearQualificationList.length === 1" class="only-one" />
                </ol>
            </li>
        </ul>
        <p v-if="qualificationDetails.status === 1" class="withdraw" @click="withdrawFn">撤回申请</p>
    </div>
</template>
<script>
import Api from '@/api/personal/qualification'
import { Dialog, ImagePreview  } from 'vant';
export default {
    // name: 'qualificationDetail',
    data() {
        return {
            qualificationDetails: localStorage.getItem('qualificationDetail') ? JSON.parse(localStorage.getItem('qualificationDetail')) : {},
            imgs: []
        }
    },
    computed: {
        ossUrl(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.oss : 'https://imga.hnhcyy.com/'
        }
    },
    mounted() {
        (this.qualificationDetails.nearQualificationList || []).forEach(v => {
            this.imgs.push(this.ossUrl + v.fileUrl)
        })
    },
    methods: {
        withdrawFn() {
            Dialog.confirm({
                title: '温馨提示',
                message: '确认要撤回资质证件的更新申请吗？',
                confirmButtonText: '确定',
                confirmButtonColor: '#ED3129',
                cancelButtonColor: '#999999',
                className: 'detail-dialog'
            }).then(() => {
                Api.cancleQualificationCheck(this.qualificationDetails.sid).then(re => {
                    // Toast(re.data.msg);
                    this.$router.push('/personal/qualification/note');
                })
            }).catch(() => {});
        },
        // 预览图片
        showImg(index) {
            ImagePreview({
                images: this.imgs,
                startPosition: index,
                showIndex: true
            })
        }
    }
}
</script>
<style lang="scss">
 %imgWidth{
    width: .32rem;
    height: .32rem;
}
.van-image-preview{
    z-index: 8890!important;
}
.van-image-preview__overlay{
    z-index: 8889!important;
}
.qualification-details{
    background: #FFFFFF;
    padding-top: 45px;
    .top-wraning{
        height: 0.68rem;
        background: #FFF6EE;
        color: #FF7800;
        padding: .2rem 0.18rem 0.2rem 0.22rem;
        font-size: .24rem;
        display: flex;
        line-height: 0.34rem;
        img{
            @extend %imgWidth;
            margin-right: .2rem;
            margin-top: .08rem;
        }
        span{
            flex: 1;
            
        }
    }
    .user-store-list{
        overflow: hidden;
        padding: 0.4rem 0.2rem 0 0.4rem;
        .store-item{
            position: relative;
            .qualification-status{
                color: #ED3129;
                display: inline-block;
                font-size: .29rem;
                margin-bottom: 0.4rem;
            }
            .qualification-status-img{
                width: 1.44rem;
                position: absolute;
                right: 0;
                top: 0;
            }
            .store-name{
                color: #333333;
                font-size: .29rem;
                line-height: .4rem;
                padding-right: 1.64rem;
                width: 5.24rem;
                height: 100%;
                font-weight: 600;
            }
            .courier-number{
                font-size: .28rem;
                color: #666666;
                margin-top: .2rem;
                span{
                    letter-spacing: 1px;
                    margin-left: 0.02rem;
                }
            }
            .update-content{
                margin-top: .42rem;
                margin-bottom: .61rem;
                font-size: .28rem;
                color: #3A7BEF;
                font-weight: 600;
            }
            .content-info{
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                padding-left: .24rem;
                padding-right: .46rem;
                overflow: hidden;
                float: left;
        li .gsp-bg{
            position: relative;
            width: 2.7rem;
            height: 2rem;
            overflow: hidden;
            flex: 1;
            text-align: center;
            background:rgba(255,255,255,1);
            box-shadow: .04rem .04rem .08rem .04rem rgba(244,244,244,1);
            border-radius: .08rem;
            .van-image{
                width: 100%;
                height: 100%;
            }
        }
        li:not(.only-one){
            p{
                padding-top: 0.46rem;
                padding-bottom: 0.42rem;
                font-size: .29rem;
                color: #333333;
                text-align: center;
            }
        }
        li:last-child{
            p{
                padding-bottom: 1.4rem;
            }
        }

        .gsp-content{
            width: 2.16rem;
            height: 1.6rem;
            margin: 0.18rem 0.36rem ;
            background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon_gsp_bg.png') no-repeat;
            background-size: 100%;
            overflow: hidden;
            .upload-icon{
                width: .64rem;
                height: .64rem;
                margin-top: .5rem;
            }
            .van-uploader__wrapper, .van-uploader{
                overflow: hidden;
                height: 2.1rem;
            }
            .van-uploader__preview{
                margin: 0;
            }
            .van-uploader__preview-image{
                display: block;
                width: 2.16rem;
                height: 1.6rem;
                margin-bottom: .24rem;
            }
            .van-uploader__preview-delete{
                top: 0rem;
                right: 0rem;
                color: #ED3129;
            }
        }
        .only-one{
            flex: 1;
            height: 1.96rem;
            background: transparent;
        }
    }
        }
    }
    .withdraw{
        width: 6.86rem;
        height: .72rem;
        background: #ED3129;
        color: #ffffff;
        font-size: .32rem;
        line-height: .72rem;
        text-align: center;
        border-radius: .44rem;
        position: fixed;
        left: 50%;
        bottom: .2rem;
        margin-left: -3.43rem;
    }
}
.detail-dialog{
    height: 2.74rem;
    width: 5.9rem;
    border-radius: 6px;
    .van-dialog__header{
        color:#333;
        font-size: .32rem;
        font-weight:600;
        padding-top: 0.4rem;
    }
    .van-dialog__message{
        text-align: center;
        font-weight:500;
        color:#333;
        line-height: .44rem;
        font-size: .29rem;
        margin-bottom: -0.2rem;
    }
    .van-button__text{
        font-size: .36rem;
        font-weight: 500;
    }
}
</style>
