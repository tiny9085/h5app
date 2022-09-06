<template>
    <div class="collect-new">
        <div class="top-wraning">
            <img src="@/assets/images/icon_reminder.png">
            <span>若您需要的品种，平台暂未提供，您可通过该渠道进行反馈，本平台将酌情采纳，感谢您的反馈与支持。</span>
        </div>
        <ul class="select-item">
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">商品名称</p>
                <win-input ref="productName" placeholder="请输入商品名称" :max-length="30" :input-event="productInputEvent" />
            </li>
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">商品规格</p>
                <win-input ref="spec" placeholder="请输入商品规格" :max-length="30" :input-event="descInputEvent" />
            </li>
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">生产厂家</p>
                <win-input ref="manufacturer" placeholder="请输入生产厂家" :max-length="30" :input-event="manufacturerInputEvent" />
            </li>
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">零售价</p>
                <win-input ref="price" placeholder="请输入零售价,例：12.20" :max-length="8" :input-event="priceInputEvent" />
            </li>
            <li>
                <p>月销量</p>
                <win-input ref="salesNum" placeholder="请输入月销量" :max-length="6" :input-event="salesNumInputEvent" />
            </li>
            <li>
                <p><img src="@/assets/images/icon_required.png" class="required">商品图片</p>
                <div class="content-info">
                    <div class="gsp-bg">
                        <van-uploader
                            v-model="fileList"
                            :before-read="asyncBeforeRead"
                            :after-read="uploadQua"
                            @delete="deleteFile"
                        >
                            <img v-if="!form.imgUrl" src="@/assets/images/icon_upload.png" class="upload-icon" alt="">
                        </van-uploader>
                    </div>
                </div>
                <div v-if="imageError" :class="{ 'error-image': imageError }">请上传商品图片</div>
            </li>
        </ul>
        
        <div class="update-bar">
            <p :class="['continue', { 'is-disable-paint': isDisable }]" @click="submitFn(2)">继续添加</p>
            <p :class="['submit', { 'is-disable': isDisable }]" @click="submitFn(1)">提交并完成</p>
        </div>
    </div>
</template>
<script>
import Api from '@/api/personal/newCollection'
import WinInput from '@/components/customInput/index';
import { Toast } from 'vant';
import regObj from '@/utils/regex' 
import lrz from 'lrz'
export default {
    components: {
        WinInput
    },
    data() {
        return {
            fileList: [],
            productInputEvent: {
                blur: this.checkName
            },
            descInputEvent: {
                blur: this.checkDesc
            },
            manufacturerInputEvent: {
                blur: this.checkManufacturer
            },
            priceInputEvent: {
                blur: this.checkPrice,
                keyup: this.replaceText
            },
            salesNumInputEvent: {
                keyup: this.replaceTextTwo
            },
            isDisable: true,
            imageError: false,
            form: {
                productName: '',
                spec: '',
                manufacturer: '',
                price: '',
                salesNum: '',
                imgUrl: ''
            }
        }
    },
    mounted() {
        this.$store.commit('setCartRightText', '填报记录')
    },
    methods: {
        getStatus() {
            if (
                !this.$refs['productName'].value.trim() ||
                !this.$refs['spec'].value.trim() ||
                !this.$refs['manufacturer'].value.trim() ||
                !this.$refs['price'].value.trim() ||
                !this.form.imgUrl
            ) {
                this.isDisable = true;
            } else {
                this.isDisable = false;
            }
        },
        // 验证商品名称
        checkName() {
            this.$refs['productName'].verification((val) => {
                if (val.trim() === '') {
                    this.$refs['productName'].showError = true;
                    this.$refs['productName'].errorMessage = '商品名称不能为空或空格';
                } else {
                    this.$refs['productName'].showError = false;
                    this.form.productName = val.trim();
                }
                this.getStatus();
            })
        },
        // 验证商品规格
        checkDesc() {
            this.$refs['spec'].verification((val) => {
                if (val.trim() === '') {
                    this.$refs['spec'].showError = true;
                    this.$refs['spec'].errorMessage = '商品规格不能为空或空格';
                } else {
                    this.$refs['spec'].showError = false;
                    this.form.spec = val.trim();
                }
                this.getStatus();
            })
        },
        // 验证商品厂家
        checkManufacturer() {
            this.$refs['manufacturer'].verification((val) => {
                if (val.trim() === '') {
                    this.$refs['manufacturer'].showError = true;
                    this.$refs['manufacturer'].errorMessage = '商品厂家不能为空或空格';
                } else {
                    this.$refs['manufacturer'].showError = false;
                    this.form.manufacturer = val.trim();
                }
                this.getStatus();
            })
        },
        replaceText() {
            this.$refs['price'].value = this.$refs['price'].value.replace(/[^\d+(\.\d{1,2})?]/g, '');
        },
        replaceTextTwo() {
            this.$refs['salesNum'].value = this.$refs['salesNum'].value.replace(/^(0+)|[^\d]+/g, '');
        },
        // 验证商品价格
        checkPrice() {
            this.$refs['price'].verification((val) => {
                if (val.trim() === '') {
                    this.$refs['price'].showError = true;
                    this.$refs['price'].errorMessage = '商品价格不能为空或空格';
                } else {
                    if (regObj.money.test(val)) {
                        this.$refs['price'].showError = false;
                        this.form.price = val.trim();
                    } else {
                        this.$refs['price'].showError = true;
                        this.$refs['price'].errorMessage = '格式有误，只能输入两位小数';
                    }
                }
                this.getStatus();
            })
        },
        // 提交资质申请
        submitFn(type) {
            if (this.isDisable) return;
            this.checkName()
            this.checkDesc()
            this.checkManufacturer()
            this.checkPrice()
            if (!this.form.imgUrl) {
                this.imageError = true;
                return;
            }
            this.isDisable = true;
            const params = Object.assign({}, this.form, { salesNum: this.$refs['salesNum'].value })
            Api.collection(params).then(re => {
                this.isDisable = false;
                Toast('提交成功，感谢您的反馈');
                if (type === 1) {
                    this.$router.push('/personal/index');
                } else {
                    this.isDisable = true;
                    this.$refs['productName'].clear();
                    this.$refs['spec'].clear();
                    this.$refs['manufacturer'].clear();
                    this.$refs['price'].clear();
                    this.$refs['salesNum'].clear();
                    this.fileList = [];
                    this.form.imgUrl = '';
                    this.imageError = false;
                }
            }).catch(() => {
                this.isDisable = false;
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
        // 上传商品图片
        uploadQua(file, detail) {
            lrz(file.file, {
                quality: 0.5    // 自定义使用压缩方式
            }).then((newFile) => {
                // 成功时执行
                if (newFile.file.size < 1024 * 1024 * 2) {
                    const fd = new FormData()
                    fd.append("file", newFile.file, file.file.name)
                    Api.imgPost(fd).then(res => {
                        this.form.imgUrl = (res.data.data)[0];
                        this.imageError = false;
                        this.getStatus();
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
            this.form.imgUrl = '';
            this.imageError = true;
            this.getStatus();
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
.collect-new{
    background: #FFFFFF;
    padding-top: 45px;
    padding-bottom: 1.21rem;
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
        padding: 0.36rem 0.4rem .9rem 0.4rem;
        position: relative;
        li{
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
        overflow: hidden;
        margin-top: .1rem;
        .gsp-bg{
            position: relative;
            width: 2.76rem;
            height: 1.92rem;
            background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon_gsp_bg.png') no-repeat;
            background-size: contain;
            border-radius: .08rem;
            text-align: center;
        }
        .van-uploader__preview img{
            width: 2.16rem;
            height: 1.6rem;
        }
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
            margin: .16rem auto;
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
    .error-image{
        color: #ED3129;
        margin-top: 5px;
    }
    .update-bar{
        position: fixed;
        bottom: 0;
        left: 0;
        display: flex;
        justify-content: space-around;
        width: 100%;
        height: 1.21rem;
        background: #fff;
        box-shadow: 0px -2px 3px rgba(0, 0, 0, 0.06);
        >p{
            width: 2.7rem;
            height: .72rem;
            line-height: .72rem;
            text-align: center;
            font-size: .32rem;
            border-radius: .44rem;
            margin-top: 0.24rem;
        }
        .submit{
            background: #ED3129;
            color: #ffffff;
        }
        .continue{
            color: #ED3129;
            border: .02rem solid #ED3129;
        }
        .is-disable{
            background: #999999;
        }
        .is-disable-paint{
            border: 1px solid #999999;
            box-sizing: border-box;
            border-radius: 20px;
            color: #999999;
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
