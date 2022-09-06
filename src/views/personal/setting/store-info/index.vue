<template>
    <div class="setting-page-index">
        <div class="top-div" />
        <div v-for="(item, index) in storeInfo" :key="index" class="store-info-box">
            <van-cell class="title-cell" :title="item.name" icon="location-o">
                <template #icon>
                    <img class="store-icon" src="@/assets/images/store_icon.png">
                </template>
            </van-cell>
            <van-cell title="会员电话：" :value="item.contactorPhone" />
            <van-cell title="电子邮箱：" :value="item.email ? item.email : '去绑定'" is-link @click="editEmail(item,index)" />
            <van-cell title="所属俱乐部：" :value="item.clubCn" />
            <van-cell title="账号状态：" :value="item.statucCn" />
        </div>
        <van-dialog
            id="van-dialog"
            v-model="isShowEditEmail"
            use-slot
            title="绑定邮箱"
            async-close="true"
            confirm-button-text="确认"
            :before-close="comfirmEdit"
            close-on-click-overlay="true"
        >
            <div class="email-info-box">
                <van-cell class="title-cell" :title="storeName" icon="location-o">
                    <template #icon>
                        <img class="store-icon" src="@/assets/images/store_icon.png">
                    </template>
                </van-cell>
                <van-field v-model="email" placeholder="请输入要绑定的邮箱 如:sevice@hcyy.com" border="false" />
                <!-- <van-button :type="btnType" :disabled="disabled" size="small" @click="getPayCode">{{ buttonText }}</van-button>
                <van-icon class="close-dialog" name="https://imga.hnhcyy.com/fed/b2b-wechat/icon-oss-del.png" @click="closeDialog" /> -->
            </div>
        </van-dialog>
    </div>
</template>

<script>
import Api from '@/api/personal' 
import { isEmail } from '@/utils/validate'
import { Toast } from 'vant'
export default {
    name: 'StoreInfo',
    data(){
        return {
            storeInfo: [],
            isShowEditEmail: false,
            storeName: '',
            email: '',
            idx: ''
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "store-info-index";
        Api.fetchStoreInfo().then(({ data: { data }}) => {
            data.forEach(info => {
                if (info.email) info.email = info.email.trim()
            })
            this.storeInfo = data
        })
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "store-info-index");
    },
    methods: {
        /**
         * 编辑邮箱
         */
        editEmail(item, idx){
            this.isShowEditEmail = true
            this.storeName = item.name
            this.idx = idx
        },
        /**
         * 确认修改邮箱
         */
        comfirmEdit(action, done){
            if (action === 'confirm'){
                if (!isEmail(this.email)){
                    Toast("邮箱地址不能为空或不正确")
                    done(false)
                } else {
                    this.storeInfo[this.idx].email = this.email
                    Api.upDatedEmail({ sid: this.storeInfo[this.idx].userSid, email: this.email }).then(res => {
                        Toast(res.data.msg)
                        done()
                    })
                }
            } else {
                done()
            }
        }
    }
}
</script>

<style lang="scss">
.store-info-index{
    background: #f1f1f1;
}
    .setting-page-index{
        #van-dialog{
            .van-dialog__header{
                padding-top: .4rem;
                padding-bottom: .32rem;
                &::after{
                    position: absolute;
                    content: ' ';
                    width: 200%;
                    height: .01rem;
                    top: 1.18rem;
                    left: -50%;
                    background: #E4E4E4;
                    transform: scaleY(.5);
                }
            }
            .email-info-box{
                .van-cell{
                    &.van-field{
                        width: 90%;
                        padding: .26rem .2rem;
                        margin-left: 5%;
                        border: .01rem solid #E4E4E4;
                        border-radius: .12rem;
                        font-size: 0.28rem;
                    }
                    &::after{
                        display: none;
                    }
                    &::after:last-child{
                        display: none;
                    }
                }
                .title-cell{
                    border: none;
                    padding: .36rem .2rem .44rem;
                    .van-cell__title{
                        font-weight: 600;
                        font-size: 0.28rem;
                    }
                }
                .store-icon{
                    width: .32rem;
                    height: .32rem;
                    margin-right: .12rem;
                    margin-top: 0.08rem;
                }
            }
        }
        .store-info-box{
            margin-bottom: 0.24rem;
            margin-top: 0.24rem;
            .van-cell:not(:last-child)::after{
            left: 0.88rem;
        }
        .van-cell{
            // padding: 0.4rem;
            padding: 0.28rem 0.4rem 0.28rem 0.84rem;
            height: 0.96rem;
            &.title-cell{
                height: 100%;
                padding: 0.4rem 0.4rem 0.4rem;
                color: #333333;
                font-size: 0.28rem;
                font-weight: 600;
                span{
                    display: inline-block;
                    width: 6.27rem;
                    height: 100%;
                }
                .store-icon{
                    width: .32rem;
                    height: .32rem;
                    margin-right: .12rem;
                    margin-top: 0.04rem;
                }
            }
            .van-cell__title{
                // flex: 2;
                font-size: 0.28rem;
                font-weight: 600;
                color: #333333;
                line-height: 0.4rem;
            }
            .van-cell__value{
                // flex: 4;
                font-size: 0.28rem;
                color: #666666;
                line-height: 0.4rem;
            }
            .van-cell__right-icon{
                margin-left: 0.06rem;
                margin-right: -0.05rem;
                font-size: .28rem;
                line-height: 0.42rem;
            }
        }
        }
    }
</style>
