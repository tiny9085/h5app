<template>
    <div class="Page-personal-server theme-lsx personal-box">
        <div class="server-box">
            <div class="top-title">
                <p>订单有疑问?</p>
                <p>可按需求致电以下负责人员!</p>
            </div>
            <div class="consult-list clearfix">
                <div v-if="consultantList.length !== 0">
                    <template v-for="(item,index) in consultantList">
                        <div v-if="item.phone !== null" :key="index" class="consult-li">
                            <div class="l">
                                <!-- 1-区总,2-省总,3-地总,4-商务专员 -->
                                <span v-if="item.specType == 1"><img src="@/assets/images/icon_area_1.png" class="user-icon"><span class="group">大区区经营顾问</span></span>
                                <span v-if="item.specType == 2"><img src="@/assets/images/icon_area_2.png" class="user-icon"><span class="group">省区经营顾问</span></span>
                                <span v-if="item.specType == 3"><img src="@/assets/images/icon_area_3.png" class="user-icon"><span class="group">地区经营顾问</span></span>
                                <span v-if="item.specType == 4"><img src="@/assets/images/icon_area_1.png" class="user-icon"><span class="group">服务顾问</span></span>
                            </div>
                            <div class="r">
                                <span>{{ item.username }}</span>
                                <span><a :data-phone="item.phone" :href="'tel:' + item.phone">{{ item.phone }}</a></span>
                                <img src="@/assets/images/phone-circle-o.png" alt="">
                            </div>
                        </div>
                    </template>
                </div>
                <div v-else>
                    <div class="consult-li">
                        <div class="l">
                            <span class="group">服务顾问</span>
                        </div>
                        <div class="r">
                            <span><a data-phone="400-662-4000" href="tel:400-662-4000">400-662-4000</a></span>
                            <img src="@/assets/images/phone-circle-o.png" alt="">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- <div class="image-tips">
            <div class="icon-2x icon-server">
                <img src="https://imga.hnhcyy.com/fed/b2b-wechat/server_bottom_icon.png">
            </div>
        </div> -->

    </div>
</template>
<script>
import Api from '@/api/personal/index'
export default {
    data(){
        return {
            consultantList: []
        }
    },
    created(){
        this.getConsult();
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "serve-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "serve-index");
    },
    methods: {
        // 获取顾问信息
        getConsult(){
            Api.getConsult().then((res) => {
                this.consultantList = res.data.data || [];
            })
        }
    }
}
</script>
<style lang="scss">
.serve-index{
    background: #f1f1f1;
}
.Page-personal-server {
    background: #f1f1f1;
   .server-box{
        width: 7.1rem;
        margin: 0.24rem 0.2rem 0rem 0.2rem;
        background: #fff;
        background: url('../../../assets/server_top_bg.png') no-repeat;
        background-size:100%;
        height: 100%;
        .top-title {
            height: 2.86rem;
            // width: 7.1rem;
            color: #fff;
            p:first-child{
                font-size: 0.32rem;
                font-weight: 500;
                margin-left: 2.66rem;
                padding-top: 0.82rem;
            }
            p:last-child{
                font-size: 0.28rem;
                margin-left: 1.94rem;
                margin-top: 0.08rem;
            }
        }
        .consult-list {
            .consult-li {
                height: 0.48rem;
                width: 6.14rem;
                background: #f1f1f1;
                position: relative;
                margin-left: 0.24rem;
                margin-bottom: 0.24rem;
                line-height: 0.48rem;
                padding: 0.2rem 0.28rem 0.2rem 0.2rem;
                border-radius:0.12rem ;
                .l {
                    font-size: .26rem;
                    color: #333;
                    float: left;
                    font-weight: 600;
                    .user-icon{
                        height: 0.48rem;
                        width: 0.48rem;
                        margin-bottom: -0.1rem;
                        margin-right: 0.16rem;
                        float: left;
                    }
                    .group{
                        display: inline-block;
                        margin-top: 0.02rem;
                    }
                }
                .r {
                    float: right;
                    display: flex;
                    align-items: center;
                    margin-top: 0.02rem;
                     span:nth-child(1){
                        color: #666;
                        font-size: 0.26rem;
                    }
                    span:nth-child(2){
                        margin: 0 0.18rem 0 0.12rem;
                        color: #0584FF;
                        font-size: 0.26rem;
                    }
                    img{
                        height: 0.32rem;
                        width: 0.32rem;
                        margin-bottom: 0.04rem;
                    }
                }
            }
        }
        // .image-tips {
        //     text-align: center;
        //     position: fixed;
        //     width: 100%;
        //     bottom: 1.42rem;
        //     transform: translateZ(0);
        //     .icon-server {
        //         width: 2.46rem;
        //         height: 1.69rem;
        //         display: inline-block;
        //         img{
        //             width: 100%;
        //         }
        //     }
        // }
   }
}
</style>
