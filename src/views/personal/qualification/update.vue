<template>
    <div class="qualification-update">
        <div class="top-wraning">
            <img src="@/assets/images/icon_reminder.png">
            <span>如资质证件有更新请及时上传并确定完成邮寄，上传证件需为盖门店公章的复印件，我们将及时为您审核。</span>
        </div>
        <ul class="select-item">
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">门店名称</p>
                <div
                    class="select-store"
                    :style="currentStore.name ? 'color:#333' : 'color:#ccc'"
                    @click="openSelect"
                >
                    {{ currentStore.name ? currentStore.name : '请选择门店名称' }}
                    <img class="open-arrow" src="@/assets/images/arrow.png">
                </div>
            </li>
            <li v-show="showSelect" class="custome-select" tabindex="0" @blur="showSelect = false">
                <i />
                <div class="option-item">
                    <p
                        v-for="item in stores"
                        :key="item"
                        :class="currentStore.userInfoSid === item.userInfoSid ? 'active-item' : ''"
                        @click="changeStore(item)"
                    >
                        {{ item.name }}
                    </p>
                </div>
            </li>
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">快递单号</p>
                <win-input ref="myExpress" placeholder="请输入快递单号" />
            </li>
        </ul>
        <p v-if="nearQualificationTitle.length" class="update-content">{{ `本次可更新${nearQualificationTitle.join('、')}` }}</p>
        <p v-if="nearQualificationTitle.length" class="p">请上传清晰的证件图片</p>
        <ol v-if="nearQualificationTitle.length" class="content-info">
            <li v-if="nearQualificationTitle.length === 1" class="only-one" />
            <li v-for="(item, index) in nearQualificationList" :key="item">
                <div class="gsp-bg">
                    <div class="gsp-content">
                        <van-uploader
                            v-model="item.images"
                            :before-read="asyncBeforeRead"
                            :after-read="uploadQua"
                            :name="index"
                            @delete="deleteFile"
                            @oversize="oversize"
                        >
                            <img v-if="!item.images.length" src="@/assets/images/icon_upload.png" class="upload-icon" alt="">
                        </van-uploader>
                        <!-- <div class="gsp-icon" :name="index" @click="deleteFile">
                            <img src="../../../assets/images/arrow.png" alt="">
                        </div> -->
                    </div>
                </div>
                <p>{{ item.name }}</p>
            </li>
            <li v-if="nearQualificationTitle.length === 1" class="only-one" />
            <!-- <p class="withdraw" @click="submitFn">提交审核</p> -->
        </ol>
        <div class="update-bar"><p class="withdraw" @click="submitFn">提交审核</p></div>
    </div>
</template>
<script>
import Api from '@/api/personal/qualification'
import WinInput from '@/components/customInput/index';
import { Toast, Dialog } from 'vant';
import lrz from 'lrz'
export default {
    components: {
        WinInput
    },
    data() {
        return {
            showSelect: false,
            currentStore: {},
            imgUrls: {},
            nearQualificationTitle: [],
            nearQualificationList: [],
            stores: localStorage.qualificationStores ? JSON.parse(localStorage.qualificationStores) : []
        }
    },
    mounted() {
        if (this.stores.length === 1) {
            this.currentStore = this.stores[0];
            this.getGsp();
        } else {
            if (this.$route.query.userInfoSid){
                this.currentStore = this.$route.query;
                this.getGsp();
            }
        }
    },
    methods: {
        // 提交资质申请
        submitFn() {
            if (!this.currentStore.userInfoSid) {
                Toast('门店名称不能为空');
            } else if (!this.$refs['myExpress'].value){
                Toast('快递单号不能为空');
            } else {
                const params = [];
                this.nearQualificationList.forEach(v => {
                    if (v.fileUrl) {
                        params.push({
                            userInfoSid: this.currentStore.userInfoSid,
                            fileUrl: v.fileUrl,
                            issuingNo: v.issuingNo,
                            name: v.name
                        })
                    }
                })
                if (!params.length) {
                    Toast('请上传资质图片');
                    return;
                }
                Api.qualificationCheck({
                    userInfoSid: this.currentStore.userInfoSid,
                    expressNumber: this.$refs['myExpress'].value,
                    nearQualificationList: params
                }).then((re) => {
                    if (re.data.code === 1){
                        Dialog.alert({
                            title: '温馨提示',
                            message: re.data.msg,
                            confirmButtonColor: '#ED3129',
                            className: 'update-dialog'
                        }).then(() => { }).catch(() => {});
                    }
                    if (re.data.code === 0) {
                        Toast('提交成功');
                        // this.getGsp();
                        this.$router.push('/personal/qualification');
                    }
                })
            }
        },
        openSelect() {
            if (!this.showSelect) this.showSelect = true;
            this.$nextTick(() => {  
                document.querySelector('.custome-select').focus();
            })
        },
        // 选择店铺
        changeStore(store) {
            this.currentStore = store;
            this.showSelect = false;
            this.getGsp();
        },
        // 获取即将过期的资质
        getGsp() {
            Api.nearQualification(this.currentStore.userInfoSid).then(re => {
                const nearQualificationList = re.data.data || [];
                this.nearQualificationTitle = [];
                nearQualificationList.forEach(v => {
                    this.nearQualificationTitle.push(v.name);
                    v.images = [];
                })
                this.nearQualificationList = nearQualificationList;
            }).catch(() => {
                this.nearQualificationTitle = [];
                this.nearQualificationList = [];
            })
        },
        // 压缩图片后大小判断
        asyncBeforeRead(file) {
            return new Promise((resolve, reject) => {
                lrz(file, {
                    quality: 0.5        // 自定义使用压缩方式
                }).then((newFile) => {
                    // 成功时执行
                    if (newFile.file.size > 1024 * 1024 * 2) {
                        Toast('图片不能大于2M!');
                        reject();
                    } else {
                        resolve();
                    }
                })
            });
        },
        // 上传资质图片
        uploadQua(file, detail) {
            lrz(file.file, {
                quality: 0.5    // 自定义使用压缩方式
            }).then((newFile) => {
                // 成功时执行
                if (newFile.file.size < 1024 * 1024 * 2) {
                    const fd = new FormData()
                    fd.append("file", newFile.file)
                    Api.uploadQualification(fd).then((re) => {
                        this.nearQualificationList[detail.name].fileUrl = re.data.data[0];
                    })
                } else {
                    Toast('图片不能大于2M!');
                    return false;
                }
            }).catch((error) => {
                // 失败时执行
                console.log(error)
            }).always((rst) => {
                // 不管成功或失败，都会执行
                console.log(rst)
            })
        },
        // 删除图片
        deleteFile(file, detail) {
            this.nearQualificationList[detail.name].fileUrl = '';
        },
        oversize() {
            Toast('图片不能大于2M!');
        }
    }
}
</script>
<style lang="scss">
%imgWidth{
    width: .32rem;
    height: .32rem;
}
// body{
//     background: #FFFFFF!important;
// }
.qualification-update{
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
    .select-item{
        // padding: 0 .4rem;
        padding: 0.36rem 0.4rem 0 0.4rem;
        position: relative;
        li:not(.custome-select){
            // margin-top: .36rem;
            .select-store{
                height: .8rem;
                width: 6.41rem;
                line-height: .8rem;
                border-radius: 0.08rem;
                border: .02rem solid rgba(228,228,228,1);
                // margin: 0 .2rem;
                position: relative;
                padding-left: .29rem;
                color: #333333;
                margin-bottom: 0.24rem;
                font-size: 0.28rem;
                .open-arrow{
                    width: .48rem;
                    height: .48rem;
                    position: absolute;
                    right: .06rem;
                    top: .18rem;
                }
            }
            p{
                margin-bottom: .18rem;
                color: #333;
                font-size: .29rem;
                font-weight: 600;
                .required{
                    width: 0.32rem;
                    height: 0.32rem;
                    margin: -2px 0;
                }
            }
        }
        .custom-input{
            margin: 0;
            font-size: 0.28rem;
            color: #333333;
        }
        
        .custome-select{
            outline: none;
            position: absolute;
            width: 6.94rem;
            transform-origin: left center;
            top: 1.96rem;
            left: .28rem;
            background: #fff;
            border-radius: .08rem;
            border: .02rem solid #ebeef5;
            z-index: 2000;
            color: #606266;
            box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
            word-break: break-all;
            i{
                display: block;
                width: 0;
                height: 0;
                border-color: transparent;
                border-style: solid;
                position: absolute;
                top: -.24rem;
                left: .6rem;
                border-top-width: 0;
                border-bottom-color: #ebeef5;
                border-width: .12rem;
                filter: drop-shadow(0 .04rem .24rem rgba(0,0,0,.03));
            }
            i::after{
                content: " ";
                position: absolute;
                display: block;
                width: 0;
                height: 0;
                border: .12rem solid transparent;
                top: .02rem;
                margin-left: -.12rem;
                border-top-width: 0;
                border-bottom-color: #fff;
            }
            .option-item{
                max-height: 3.92rem;
                overflow-y: auto;
                line-height: .6rem;
                padding: .1rem 0;
                color: #666;
                font-size: 0.29rem;
                >p{
                    padding: 0.2rem 0 .2rem 0.38rem;
                }
                >p:hover{
                    background: #F6F6F6;
                }
                .active-item{
                    background: #F6F6F6;
                }
            }
        }
    }
    .update-content{
        padding: 0 .4rem;
        margin-top: .29rem;
        margin-bottom: .08rem;
        font-size: .28rem;
        color: #3A7BEF;
        font-weight: 600;
    }
    .p{
        color: #999999;
        font-size: .24rem;
        padding: 0 .4rem;
        margin-bottom: .54rem;
    }
    .content-info{
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        padding-left: .4rem;
        padding-right: .4rem;
        overflow: hidden;
        li .gsp-bg{
            position: relative;
            width: 2.8rem;
            height: 1.97rem;
            overflow: hidden;
            flex: 1;
            text-align: center;
            background:rgba(255,255,255,1);
            box-shadow: .04rem .04rem .08rem .04rem rgba(244,244,244,1);
            border-radius: .08rem;
            // .gsp-icon{
            //     position: absolute;
            //     height: 0.48rem;
            //     width: 0.48rem;
            //     background: chocolate;
            //     right: 4px;
            //     top: 7px;
            //     img{
            //         height: 100%;
            //         width: 100%;
            //     }
            // }
            
        }
        li:not(.only-one){
            p{
                padding-top: 0.46rem;
                padding-bottom: 0.42rem;
                font-size: .29rem;
                color: #333;
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
            // background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon_gsp_bg.png') no-repeat;
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
    .update-bar{
        height: 1.21rem;
        width: 100%;
        background: #f1f1f1;
        position: fixed;
        bottom: 0rem;
         .withdraw{
            width: 6.86rem;
            height: .72rem;
            background: #ED3129;
            color: #ffffff;
            font-size: .32rem;
            line-height: .72rem;
            text-align: center;
            border-radius: .44rem;
            margin-top: 0.24rem;
            margin-left: 0.32rem;
        }
    }
}
.update-dialog{
    height: 3.14rem;
    width: 5.9rem;
    border-radius: 6px;
    .van-dialog__header{
        color:#333;
        font-size: .32rem;
        font-weight:600;
        padding-top: 0.4rem;
    }
    .van-dialog__message{
        text-align: left;
        font-weight:500;
        color:#333;
        line-height: .44rem;
        font-size: .28rem;
        margin-bottom: -0.32rem;
    }
    .van-button__text{
        font-size: .36rem;
        font-weight: 500;
    }
}
.van-toast{
    top: 46%;
}
.van-toast--text{
    border-radius: 0.16rem;
    background: rgba(0, 0, 0, 0.5);
 }
.van-toast__text{
    color: #fff;   
    font-size: 0.32rem;
    font-weight: 500;
}
</style>
