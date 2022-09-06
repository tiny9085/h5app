<template>
    <div class="qualification-note">
        <van-list
            v-model="loading"
            :finished="finished"
            finished-text="人家是有底线的哦!"
            @load="geNote"
        >
            <ul class="user-list">
                <li
                    v-for="(store, index) in qualificationNotes"
                    :key="store"
                    class="store-item"
                    @click="goToDetail(store)"
                >
                    <div class="store-name" :style="store.isOpen? 'margin-bottom: .24rem':''">
                        <p>{{ store.name }}</p>
                        <span v-if="store.isOpen" @click.stop="openStore(false, index)">收起
                            <img src="@/assets/images/close_icon.png">
                        </span>
                        <span v-else @click.stop="openStore(true, index)">展开
                            <img src="@/assets/images/open_icon.png">
                        </span>
                    </div>
                    <!-- <p class="p">申请时间：{{ store.createTime }}<span class="gsp-status">{{ store.statusCn }}</span></p> -->
                    <div v-if="store.isOpen">
                        <p class="p">快递单号：{{ store.expressNumber }}</p>
                        <p v-if="store.title" class="update-content">本次更新{{ store.title }}</p>
                        <van-swipe :loop="false" :width="200">
                            <van-swipe-item v-for="item in store.nearQualificationList" :key="item">
                                <div class="gsp-content">
                                    <van-image :src="ossUrl + item.fileUrl">
                                        <template v-slot:error>
                                            <img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-picture.png" alt="">
                                        </template>
                                    </van-image>
                                </div>
                                <p class="list-name">{{ item.name }}</p>
                            </van-swipe-item>
                        </van-swipe>
                    </div>
                    <p class="applay-time">申请时间：
                        <span class="gsp-time">{{ store.createTime }}</span>
                        <span class="gsp-status">{{ store.statusCn }}</span>
                    </p>
                    <div v-if="store.isOpen" class="qualification-bottom" :style="store.status===-3 || store.status===0?'height: 0rem':'height:0.84rem'">
                        <van-button
                            v-if="store.status === 1"
                            round
                            size="small"
                            class="right-btn"
                            @click.stop="withdrawFn(store)"
                        >
                            撤回申请
                        </van-button>
                        <p v-if="store.status === -2">原因：{{ store.explainMsg }}</p>
                    </div>
                </li>
            </ul>
        </van-list>
    </div>
</template>
<script>
import Api from '@/api/personal/qualification'
import { Dialog, Toast } from 'vant';
export default {
    // name: 'qualificationNote',
    data(){
        return {
            current: 1,
            size: 20,
            qualificationNotes: [],
            loading: false,
            finished: false
        }
    },
    computed: {
        ossUrl(){
            return this.$store.getters.userInfo ? this.$store.getters.userInfo.oss : 'https://imga.hnhcyy.com/'
        }
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "qualification-note-body";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "qualification-note-body");
    },
    methods: {
        goToDetail(item) {
            localStorage.setItem('qualificationDetail', JSON.stringify(item))
            this.$router.push({
                path: '/personal/qualification/detaill',
                query: { sid: item.sid }
            })
        },
        openStore(isOpen, index) {
            this.qualificationNotes[index].isOpen = isOpen;
        },
        // 获取资质审核记录
        geNote(flag) {
            Api.qualificationNotes({
                current: this.current,
                size: this.size
            }).then(re => {
                if (flag) this.qualificationNotes = [];
                if (this.current >= re.data.data.pages) {
                    this.finished = true;
                } else {
                    this.current++;
                }
                const qualificationNotes = re.data.data.records || []
                qualificationNotes.forEach((val, ind) => {
                    val.isOpen = ind === 0;
                    const title = [];
                    (val.nearQualificationList || []).forEach(v => {
                        title.push(v.name)
                    })
                    val.title = title.join('、');
                    if (val.statusCn === '已通过'){
                        val.statusCn = "审核通过"
                    } else if (val.statusCn === '驳回'){
                        val.statusCn = "审核不通过"
                    } else if (val.statusCn === '已撤销'){
                        val.statusCn = "已取消"
                    } 
                })
                this.qualificationNotes = this.qualificationNotes.concat(qualificationNotes);
            })
        },
        // 撤销申请
        withdrawFn(store) {
            Dialog.confirm({
                title: '温馨提示',
                message: '确认要撤回资质证件的更新申请吗？',
                confirmButtonText: '确定',
                confirmButtonColor: '#ED3129',
                cancelButtonColor: '#999999',
                className: 'my-dialog'
            }).then(() => {
                Api.cancleQualificationCheck(store.sid).then(re => {
                    Toast(re.data.msg);
                    this.geNote(true);
                })
            }).catch(() => {});
        }
    }
}
</script>
<style lang="scss">
%imgWidth{
    width: .32rem;
    height: .32rem;
}

.qualification-note-body{
    background: #f1f1f1;
    .qualification-note{
        background: #f1f1f1;
        padding-top: 45px;
    .user-list{
        margin-top: 0.28rem;
        .store-item{
            background: #ffffff;
            margin-top: 0.24rem;
            .store-name{
                padding: .4rem 0.4rem 0 0.4rem;
                color: #333333;
                font-size: .29rem;
                font-weight: 600;
                display: flex;
                // margin-bottom: .24rem;
                p{
                    flex: 1;
                }
                span{
                    color: #bbbbbb;
                    font-size: .24rem;
                    line-height: .24rem;
                    font-weight: normal;
                    img{
                        @extend %imgWidth;
                        vertical-align: sub;
                        // margin-left: .06rem;
                    }
                }
            }
            .p{
                padding-left: 0.4rem;
                font-size: .29rem;
                color: #999999;
                margin-bottom: .16rem;
            }
            .update-content{
                padding-left: 0.4rem;
                margin-bottom: .42rem;
                font-size: .29rem;
                color: #3A7BEF;
            }
            .van-swipe{
                padding-bottom: .28rem;
                padding-left: 0.4rem;
                border-bottom: 0.02rem solid #eeeeee;
            }
            .van-swipe-item{
                width: 2.7rem!important;
                height: 2rem; 
                background:rgba(255,255,255,1);
                box-shadow: .04rem .04rem .08rem .04rem rgba(244,244,244,1);
                border-radius: .12rem;
                margin-right: .4rem;
                margin-bottom: 0.8rem;
            }
            .van-swipe__indicators{
                display: none;
            }
            .gsp-content{
                width: 2.3rem;
                height: 1.6rem;
                margin: .2rem;
                background: url('https://imga.hnhcyy.com/fed/b2b-wechat/icon_gsp_bg.png') no-repeat;
                background-size: 100%;
                .van-image, .van-image__error, .van-image__error img{
                    width: 100%;
                    height: 100%;
                }
            }
            .list-name{
                padding-top: 0.28rem;
                padding-bottom: 0.38rem;
                font-size: .29rem;
                color: #333333;
                text-align: center;
            }
            .applay-time{
                position: relative;
                // border-top: 0.02rem solid #eeeeee;
                color: #999999;
                font-size: 0.29rem;
                padding: 0.28rem 0 0.28rem 0.4rem;
                .gsp-time{
                    color: #333333;
                }
                .gsp-status{
                    color: #ED3129;
                    font-size: .24rem;
                    position: absolute;
                    right: 0.4rem;
                }
            }
            .qualification-bottom{
                // height: 0.84rem;
                width: 100%;
                // padding-top: 0.28rem;
                p{
                    color: #ED3129;
                    height: 0.59rem;
                    width: 6.41rem;
                    background: #FFF5F5;
                    border-radius: 0.29rem;
                    margin-left: 0.4rem;
                    line-height: 0.59rem;
                    padding-left: 0.29rem;
                    font-size: 0.24rem;
                }
                .right-btn{
                    width: 1.44rem;
                    height: 0.52rem;
                    float: right;
                    margin-right: 0.16rem;
                    border: 0.02rem solid #E4E4E4;
                    border-radius: 0.32rem;
                    color: #999999;
                    font-size: 0.24rem;
                    text-align: center;
                    line-height: 0.52rem;
                    margin-top: 0.03rem;
                }
            }
        }
    }
}
}
.my-dialog{
    .van-dialog__header{
        color:#333;
        font-size: .32rem;
        font-weight:600;
    }
    .van-dialog__message{
        font-weight:500;
        color:#333;
        font-size: .28rem;
    }
}
</style>
