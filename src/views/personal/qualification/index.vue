<template>
    <div class="Page-personal-qualification theme-lsx personal-box">
        <div class="top-wraning">
            <img src="@/assets/images/icon_reminder.png">
            <span>如资质证件有更新请及时上传并确定完成邮寄，上传证件需为盖门店公章的复印件，我们将及时为您审核。</span>
        </div>
        <ul class="user-store-list" :style="qualificationList.length && canSubmit? 'margin:.24rem .18rem 0rem 0.18rem':'margin:0'">
            <li
                v-for="(store, index) in qualificationList"
                :key="store"
                :class="['store-item', store.isOpen? '' : ' not-open']"
            >
                <div class="store-name">
                    <p>{{ store.name }}</p>
                    <span v-if="store.isOpen">收起
                        <img src="@/assets/images/close_icon.png" @click="openStore(false, index)">
                    </span>
                    <span v-else>展开
                        <img src="@/assets/images/open_icon.png" @click="openStore(true, index)">
                    </span>
                </div>
                <div v-if="store.nearCount || store.count" class="overdue-reminder">
                    <img src="@/assets/images/icon_horn.png">
                    <div>
                        <span v-if="store.nearCount">当前有<font>{{ store.nearCount }}个</font>资质证件即将过期</span>{{ store.nearCount && store.count ? ',' : '' }}
                        <span v-if="store.count"><font>{{ store.count }}个</font>资质证件已过期，请及时更新</span>
                        <p class="go-to-update" @click="goToUpdate(store)">去更新<span><img src="@/assets/images/go_updata.png" alt=""></span></p>
                    </div>
                </div>
                <div v-if="store.isOpen">
                    <ol class="qualification-list">
                        <li v-for="item in store.qualification" :key="item" class="qualification-item">
                            <img class="qualification-log" src="@/assets/images/icon_qualification.png">
                            <i class="substring-name">{{ item.name ? item.name.substring(0, 1) : '' }}</i>
                            <div class="qualification-content">
                                <p>{{ item.name }}</p>
                                <p>资质内容：<span>{{ item.content ? item.content : '无' }}</span></p>
                                <div class="qualification-detail">
                                    <p>授权委托人：<span>{{ item.notes ? item.notes : '无' }}</span></p>
                                    <p><span class="time">失效时间</span><span :class="item.status === 2 ? 'red-date': item.status === 1 ? 'orange-date' : ''">{{ item.endDate ? item.endDate.split(' ')[0] : '' }}</span></p>
                                </div>
                            </div>
                        </li>
                    </ol>
                    <div class="person-list">
                        <h6>详情请咨询</h6>
                        <template v-for="area in store.biResult.userList">
                            <p v-if="[1, 2, 3].indexOf(area.img) > -1" :key="area" class="person-item">
                                <img v-if="area.img === 1" src="@/assets/images/icon_area_1.png" class="user-icon">
                                <img v-if="area.img === 2" src="@/assets/images/icon_area_2.png" class="user-icon">
                                <img v-if="area.img === 3" src="@/assets/images/icon_area_3.png" class="user-icon">
                                <span class="person-type">{{ area.str }}</span>
                                <a :href="'tel:' + area.phone">
                                    <span class="person-name">{{ area.userName }}</span>
                                    <span class="person-phone">{{ area.phone }}</span>
                                    <img src="@/assets/images/icon_call_phone.png">
                                </a>
                            </p>
                        </template>
                    </div>
                </div>
            </li>
        </ul>
        <!-- <div v-if="canSubmit" class="update-qualification" @click="goToUpdate">
            更新资质
        </div> -->
        <div class="update-bar"><p class="withdraw" @click="goToUpdate"> 更新资质</p></div>
    </div>
</template>
<script>
import Api from '@/api/personal/qualification'
export default {
    data(){
        return {
            qualificationList: [],
            canSubmit: false
        }
    },
    created(){
        this.$store.commit('setCartRightText', '更新记录');
        this.getQualificationList();
    },
    mounted(){
        document.getElementsByTagName("body")[0].className = "qualification-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "qualification-index");
    },
    methods: {
        // 去更新
        goToUpdate(store) {
            let query = {};
            if (store) {
                query = {
                    userInfoSid: store.userInfoSid,
                    name: store.name
                }
            }
            this.$router.push({
                path: '/personal/qualification/update',
                query
            })
        },
        openStore(isOpen, index) {
            this.qualificationList[index].isOpen = isOpen;
        },
        // 获取会员资质
        getQualificationList(){
            const arr = []
            Api.allQualification().then(re => {
                const data = re.data.data || [];
                this.canSubmit = false;
                data.forEach((val, ind) => {
                    val.isOpen = ind === 0;
                    (val.biResult.userList || []).forEach((area, i) => {
                        switch (area.userRole) {
                            case 'DZ_ROLE':
                                area.str = '地区经营顾问';
                                area.img = 1;
                                break;
                            case 'SQ_ROLE':
                                area.str = '省区经营顾问';
                                area.img = 2;
                                break;
                            case 'SWZY_ROLE':
                                area.str = '服务顾问';
                                area.img = 3;
                                break;
                            default:
                                area.str = '其他';
                                area.img = 4;
                                break;
                        }
                    })
                    if (val.canSubmit > 0) {
                        this.canSubmit = true; 
                        const store = { ...val };
                        delete store.qualification;
                        arr.push(store);
                    }
                });
                this.qualificationList = data;
                localStorage.setItem('qualificationStores', JSON.stringify(arr));
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

.qualification-index{
    background: #f4f4f4;
    .Page-personal-qualification{
    background: #f4f4f4;
    overflow: hidden;
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
        .store-item:last-child{
            margin-bottom: 1.3rem;
            .person-list{
                margin-bottom: 40px;
            }
        }
        .store-item{
            border-radius: .1rem;
            background: #FFFFFF;
            padding: .22rem 0.28rem 0.4rem 0.28rem;
            margin-bottom: 0.24rem;
            .store-name{
                color: #333333;
                font-size: .29rem;
                font-weight: 600;
                display: flex;
                padding-bottom: .12rem;
                p{
                    flex: 1;
                }
                span{
                    color: #bbbbbb;
                    font-size: .24rem;
                    line-height: .24rem;
                    font-weight: 400;
                    padding-left: .2rem;
                    img{
                        @extend %imgWidth;
                        vertical-align: sub;
                        // margin-left: .06rem;
                    }
                }
            }
            .overdue-reminder{
                position: relative;
                height: 0.76rem;
                padding: 0.1rem 0.29rem 0.12rem 0.29rem;
                display: flex;
                border-radius: 0.12rem;
                color: #666666;
                font-size: .24rem;
                border-bottom: .01rem solid #E4E4E4;
                background: #F4F4F4;
                margin-bottom: 0.2rem;
                img{
                    @extend %imgWidth;
                    margin-right: .16rem;
                    margin-top: 0.03rem;
                }
                div{
                    flex: 1;
                    line-height: .4rem;
                    font-size: 0.24rem;
                    color: #666;
                    font{
                        color: #FF7800;
                    }
                    .go-to-update{
                        color: #ED3129;
                        display: flex;
                        position: absolute;
                        top: 0.56rem;
                        right: 0.16rem;
                        font-size: 0.24rem;
                        span{
                            display: block;
                            height: 0.28rem;
                            width: 0.28rem;
                            margin-top: -0.01rem;
                        }
                    }
                }
            }
            .qualification-list{
                .qualification-item{
                    display: flex;
                    position: relative;
                    margin-top: .28rem;
                    margin-bottom: 0.28rem;
                    padding-top: 0.28rem;
                    padding-left: 0.2rem;
                    padding-right: 0.08rem;
                    .substring-name{
                        position: absolute;
                        font-style: normal;
                        font-size: .18rem;
                        top: .52rem;
                        left: .37rem;
                        color: #F3544D;
                    }
                    .qualification-log{
                        width: .56rem;
                        height: .56rem;
                        margin: 0.06rem 0.24rem 0 0;
                    }
                    .qualification-content{
                        color: #333333;
                        font-size: .29rem;
                        flex: 1;
                        > :nth-child(1){
                            font-weight:600;
                            margin-bottom: .08rem;
                        }
                        > :nth-child(2){
                            margin-bottom: 0.14rem;
                            color: #999;
                            span{
                                color: #333333;
                                font-weight:500;
                            }
                        }
                        .qualification-detail{
                            display: flex;
                            font-size: 0.26rem;
                            justify-content: space-between;
                            p:nth-child(1){
                                color: #999999;
                                span{
                                    margin-left: 0.12rem;
                                    color: #333;
                                    font-weight: 500;
                                }
                            }
                            p:nth-child(2){
                                color: #333333;
                                .time{
                                    color: #999999;
                                    font-weight: 400;
                                }
                                span{
                                    margin-left: 0.12rem;
                                    font-weight: 500;
                                }
                                .red-date{
                                    color: #ED3129;
                                }
                                .orange-date{
                                    color: #FF7800;
                                }
                            }
                        }
                    }
                }
                .qualification-item:not(:last-child)::after {
                    position: absolute;
                    box-sizing: border-box;
                    content: ' ';
                    pointer-events: none;
                    right: -0.28rem;
                    bottom: -.28rem;
                    left: 0.8rem;
                    border-bottom: 1px solid #f4f4f4;
                    -webkit-transform: scaleY(.5);
                    transform: scaleY(.5);
                }
            }
            .person-list{
                // height: 3.32rem;
                // padding: 0.28rem 0.28rem 0.4rem 0.28rem;
                position: relative;
                padding-top: 0.28rem;
                h6{
                    font-size: .32rem;
                    color: #333;
                    font-weight: 600;
                }
                .person-item{
                    display: flex;
                    height: 0.72rem;
                    border: 0.02rem solid #EEEEEE;             
                    border-radius: 0.12rem;
                    margin: 0.24rem 0;
                    line-height: 0.72rem;

                }
                .user-icon{
                    width: .48rem;
                    height: .48rem;
                    margin: 0.12rem 0.16rem 0.12rem 0.2rem;
                }
                .person-type{
                    color: #333;
                    font-size: 0.26rem;
                    font-weight: 500;
                }
                a{
                    flex: 1;
                    color: #0584FF;
                    text-align: right;
                    margin-right: 0.28rem;
                    img{
                        @extend %imgWidth;
                        vertical-align: sub;
                    }
                    .person-name{
                        color: #666;
                        font-size: 0.26rem;
                    }
                    .person-phone{
                        margin: 0 0.18rem 0 0.12rem ;
                    }
                }
            }
            .person-list::before {
                position: absolute;
                box-sizing: border-box;
                content: ' ';
                pointer-events: none;
                right: -0.28rem;
                top: -0.01rem;
                left: -0.28rem;
                border-bottom: 1px solid #f4f4f4;
                -webkit-transform: scaleY(.5);
                transform: scaleY(.5);
            }
        }
        .not-open{
            padding-bottom: 1px;
            margin-bottom: 0.24rem;
            .overdue-reminder{
                border-bottom: none;
            }
        }
        // .store-item:last-child .not-open{
        //     margin-bottom: 1.3rem;
        // }
    }
    // .update-qualification{
    //     position: fixed;
    //     bottom: .24rem;
    //     right: .32rem;
    //     height: 0.72rem;
    //     width: 6.86rem;
    //     background: #ED3129;
    //     color: #fff;
    //     font-size: 0.32rem;
    //     font-weight: 500;
    //     border-radius:0.44rem ;
    //     text-align: center;
    //     line-height: 0.72rem;
    // }
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
}
</style>
