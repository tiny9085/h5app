<template>
    <div class="freeze-box personal-box">
        <div :class="currentType == 1 ? 'theme-lsx' : currentType == 2 ? 'theme-zat' : 'theme-chx'">
            <div v-if="freezeList.length>0" class="balance-list clearfix">
                <div class="balance-li1 border-bottom">
                    <span style="font-size:0.32rem;">冻结明细表</span>
                </div>
                <div v-for="(item,index) in freezeList" :key="index" class="balance-li border-bottom">
                    <div class="row-1 clearfix">
                        <span>{{ item.accountTypeEnumName }}</span>
                        <span>¥{{ (item.amount) }}</span>
                    </div>
                    <div class="row-2 clearfix">
                        <span>{{ item.createTime }}</span>
                        <span>{{ item.orderCode }}</span>
                    </div>
                </div>
            </div>
            <div v-else class="no-freeze-message">
                <div><img src="https://imga.hnhcyy.com/fed/b2b-wechat/no-message.png" alt=""></div>
                <span>暂无明细</span>
            </div>
        </div>
    </div>
</template>
<script>
import Api from '@/api/personal/index'
import {   Toast } from 'vant';
export default {
    data(){
        return {
            changeType: 0,
            currentType: 0,
            freezeList: []
        }
    },
    created(){
        this.getFreeze(this.$route.query.changeType)
    },
    methods: {
        getFreeze(changeType){
            Toast.loading({
                message: '加载中...'
            });
            Api.getFreeze(changeType).then(res => {
                this.freezeList = res.data.data.records || []
                Toast.clear();
            })
        }
    }
}
</script>
<style lang="scss">
.balance-list {
    background: #FFF;
    margin-top: -0.02rem;
    .balance-li1{
        padding: .40rem  .20rem .20rem .20rem;    
    }
    .balance-li {
        padding: .15rem .20rem;
        overflow: hidden;

        .row-1 {
            span {
                font-size: .32rem;

                &:nth-child(1) {
                    float: left;
                }

                &:nth-child(2) {
                    float: right;

                    &.red {
                        color: #ED3129;
                    }

                    &.green {
                        color: #009719;
                    }
                }
            }
        }

        .row-2 {
            margin-top: .20rem;
            span {
                font-size: .24rem;
                color: #666666;

                &:nth-child(1) {
                    float: left;
                }

                &:nth-child(2) {
                    float: right;
                }
            }
        }
    }
    
}
.no-freeze-message{
    display: flex;
    flex-direction: column;
    align-items: center;
    img{
        width: 3.32rem;
        height: 3.12rem;
        margin-top: 2.64rem;
    }
    span{
        font-size: .36rem;
        color:#333333;
        padding-top: .54rem;
    }
} 
</style>
