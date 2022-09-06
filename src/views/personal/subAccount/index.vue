<template>
    <div>
        <div class="top-div" />
        <ul class="sub-account-list">
            <li 
                v-for="(user, index) in userList"
                :key="index"
                :class="['account-item', user.isOpen? '' : ' not-open']"
            >
                <div class="box">
                    <img src="@/assets/images/store_icon.png" alt="">
                    <span class="store-name">{{ user.userName }}</span>
                    <span v-if="user.isOpen" class="show-more-account">收起
                        <img src="@/assets/images/close_icon.png" @click="openAccount(false, index)">
                    </span>
                    <span v-else class="show-more-account">展开
                        <img src="@/assets/images/open_icon.png" @click="openAccount(true, index)">
                    </span>
                </div>
                <div v-if="user.isOpen" class="store-content">
                    <template v-for="(item, ind) in user.data">
                        <div v-if="item.type === 0" :key="ind" class="price-box">
                            <div class="price-info-left">
                                <p>普通余额(元)</p>
                                <p class="balance">{{ (item.balance || 0).toFixed(2) }}</p>
                            </div>
                            <div class="price-info-right">
                                <p class="amount-title">冻结金额(元）</p>
                                <p class="price">{{ (item.amount || 0).toFixed(2) }}</p>
                            </div>
                            <a @click="gotoBalance(item, user.userName)">
                                <span>交易明细</span>
                                <img src="@/assets/images/arrow_right_red.png" class="right-arrow">
                            </a>
                        </div>
                        <div v-if="item.type === 2" :key="ind" class="price-box">
                            <div class="price-info-left">
                                <p>总专项款(元）</p>
                                <p class="balance">{{ (item.balance || 0).toFixed(2) }}</p>
                            </div>
                            <div class="price-info-right">
                                <p class="amount-title">冻结金额(元）</p>
                                <p class="price">{{ (item.amount || 0).toFixed(2) }}</p>
                            </div>
                            <a @click="gotoBalance(item, user.userName)">
                                <span>交易明细</span>
                                <img src="@/assets/images/arrow_right_red.png" class="right-arrow">
                            </a>
                        </div>
                        <div v-if="item.type === 1" :key="ind" class="price-box">
                            <div class="price-info-left">
                                <p>返利余额(元)</p>
                                <p class="balance">{{ (item.balance || 0).toFixed(2) }}</p>
                            </div>
                            <div class="price-info-right">
                                <p class="amount-title">冻结金额(元）</p>
                                <p class="price">{{ (item.amount || 0).toFixed(2) }}</p>
                            </div>
                            <a @click="gotoBalance(item, user.userName)">
                                <span>交易明细</span>
                                <img src="@/assets/images/arrow_right_red.png" class="right-arrow">
                            </a>
                        </div>
                    </template>
                </div>
            </li>
        </ul>
    </div>
</template>
<script>
import Api from '@/api/personal/index'
export default {
    // name: "subAccount",
    data() {
        return {
            userList: [],
            isOpen: false
        }
    },
    mounted() {
        this.getSubAccount();
        document.getElementsByTagName("body")[0].className = "account-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "account-index");
    },
    methods: {
        openAccount(isOpen, index) {
            this.$set(this.userList[index], 'isOpen', isOpen);
        },
        getSubAccount() {
            Api.getSubAccount().then(re => {
                this.userList = [];
                (re.data.data || []).forEach((v, index) => {
                    const obj = {
                        userName: '',
                        isOpen: '',
                        data: [
                            { type: 0, userInfoSid: v[0].userInfoSid },
                            { type: 2, userInfoSid: v[0].userInfoSid },
                            { type: 1, userInfoSid: v[0].userInfoSid }
                        ]
                    };
                    if (index === 0) obj.isOpen = true;
                    v.forEach(val => {
                        obj.userName = val.userName;
                        switch (val.type - 0) {
                            case 0:
                                obj.data[0] = val;
                                break;
                            case 2:
                                obj.data[1] = val;
                                break;
                            case 1:
                                obj.data[2] = val;
                                break;
                        }
                    })
                    this.userList.push(obj);
                })
            })
        },
        gotoBalance(item, userName) {
            localStorage.setItem('personalSubUserName', userName)
            this.$router.push({
                path: '/personal/subBalance',
                query: {
                    active: item.type, 
                    userInfoSid: item.userInfoSid
                }
            })
        }
    }
}
</script>
<style lang="scss">
.account-index{
    background: #f1f1f1;
}
.sub-account-list{
    overflow: hidden;
    .account-item{
        padding: .24rem .28rem 0 0.28rem;
        margin: .24rem  .16rem;
        background: #fff;
        border-radius: 0.12rem;
        .box{
            height: 0.4rem;
            line-height: 0.4rem;
            margin-bottom: 0.24rem;
            img{
            height: 0.32rem;
            width: 0.32rem;
            margin-bottom: -0.05rem;
        }
        .store-name{
            color: #333333;
            font-size: .28rem;      
            font-weight: 600;
            display: inline-block;
        }
        .show-more-account{
            font-size: .24rem;
            float: right;
            color: #bbbbbb;
            img{
                width: .32rem;
                height: .32rem;
                // margin-left: .08rem;
                margin-bottom: -0.06rem;
            }
        }
        }
    }
    .store-content{
        width: 6.62rem;
        background: #f6f6f6;

            .price-info-left{
                width: 50%;
                height: 1.48rem;
                float: left;
                text-align: center;
                border-top-left-radius: 0.12rem;
                border-bottom-left-radius: 0.12rem;

                p:nth-child(1){
                    color: #999;
                    font-size: 0.28rem;
                    margin: 0.2rem 0 0.16rem 0;
                }
                p:nth-child(2){
                    color: #333;
                    font-size: 0.4rem;
                    font-weight: 500;
                }
            }
            .price-info-right{
                text-align: center;
                position: relative;
                width: 50%;
                height: 1.48rem;
                float: right;
                border-top-right-radius: 0.12rem;
                border-bottom-right-radius: 0.12rem;
                p:nth-child(1){
                    color: #999;
                    font-size: 0.28rem;
                    margin:  0.2rem 0 0.16rem 0;
                }
                p:nth-child(2){
                    color: #333;
                    font-size: 0.4rem;
                    font-weight: 500;
                }
            }
            .price-info-right::before {
                position: absolute;
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
                content: ' ';
                pointer-events: none;
                right: 0.16rem;
                bottom: -0.16rem;
                left: 0rem;
                border-left: 1px solid #DDDDDD;
                -webkit-transform: scaleY(0.5);
                transform: scaleY(0.5);
                top: -0.12rem;
            }
            a{
                height: 0.88rem;
                width: 6.62rem;
                display: inline-block;
                background: #fff;
                color: #ED3129;
                font-size: 0.28rem;
                text-align: right;
                line-height: 0.88rem;
                span{
                    display: inline-block;
                    margin-right: -0.12rem;
                }
                .right-arrow{
                    width: 0.4rem;
                    height: 0.4rem;
                    position: relative;
                    top: .1rem;
                    right: -0.08rem;
                 }
            }
        // display: flex;
        // >div{
        //     // flex: 1;
        //     text-align: center;
        //     h6{
        //         font-size: .28rem;
        //         margin: .2rem 0;
        //     }
        //     .price-info{
        //         border-right: 1px solid #E4E4E4;
        //     }
        //     p{
        //        font-size: .24rem;
        //         margin-top: .12rem; 
        //     }
        //     .balance{
        //         font-weight: bold;
        //     }
        //     .amount-title{
        //         color: #666666;
        //     }
        //     .price{
        //         font-size: .28rem;
        //         margin-bottom: .2rem;
        //         color: #333333;
        //     }
        //     a{
        //         color: #ED3129;
        //     }
        //     .right-arrow{
        //         width: .32rem;
        //         position: relative;
        //         top: .07rem;
        //     }
        // }
        // >div:last-of-type .price-info{
        //     border: none;
        // }
        // div:nth-child(1){
        //     width: 6.62rem;
        //     height: 1.48rem;
        //     background: #f6f6f6;
        //     .pricr-info-left{
        //         width: 50%;
        //         height: 1.48rem;
        //         float: left;
        //         background: red;
        //     }
        //     .pricr-info-right{
        //         width: 50%;
        //         height: 1.48rem;
        //         float: right;
        //         background: yellow;
        //     }
        // }
    }
    .not-open{
        padding-bottom: 0.024rem;
    }
}
</style>
