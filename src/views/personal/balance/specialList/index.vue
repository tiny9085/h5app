<template>
    <div class="special-box">
        <div 
            v-for="(item, ind) in specialList"
            :key="ind"
            class="special-box-item"
        >
            <div class="row-1">
                <span>{{ item.name }}(元)</span>
            </div>
            <div class="row-2">
                <span><img src="@/assets/images/icon-money.png" alt="">{{ item.balance }}</span>
                <span>冻洁金额(元)&nbsp;<span class="money">￥{{ item.amount }}</span></span>
            </div>
            <div class="row-3">
                <span>有效期至&nbsp;<span class="time">{{ item.endTime ? item.endTime.split(' ')[0] : '' }}</span></span>
            </div>
        </div>
    </div>
</template>
<script>
import Api from '@/api/personal/index'
export default {
    data(){
        return {
            specialList: []
        }
    },
    mounted(){
        this.getUserSpecialList();
        document.getElementsByTagName("body")[0].className = "special-index";
    },
    beforeDestroy(){
        document.body.removeAttribute("class", "special-index");
    },
    methods: {
        getUserSpecialList() {
            Api.getSpe({
                userInfoSid: this.$route.query.userInfoSid || ''
            }).then(res => {
                this.specialList = res.data.data || [];
            })
        }
    }
}
</script>
<style lang="scss">
.special-index{
    background: #F1F1F1;
    .app-main{
        padding-top: 0.2rem;
    }
}
.special-box{ 
    margin: 0.9rem 0 0 0;

    .special-box-item{
        background: #ffffff;
        margin: 0.24rem 0.16rem;
        border-radius: 0.12rem;
        padding: 0.28rem 0.4rem 0.34rem 0.4rem;
        .row-1{
            font-size: 0.32rem;
            font-weight: 600;
            color: #333;
        }
        .row-2{
            display: flex;
            justify-content: space-between;
            background: #F8F8F8;
            border-radius: 0.12rem;
            padding: 0 0.18rem 0 0.16rem;
            line-height: 0.74rem;
            height: 0.74rem;
            margin: 0.24rem 0;
            span:nth-child(1){
                display: flex;
                align-items: center;
                font-size: 0.36rem; 
                color: #ED3129;
                font-weight: 600;
                img{
                    height: 0.36rem;
                    width: 0.34rem;
                    margin-right: 0.16rem;
                }
            }
            span:nth-child(2){
                display: flex;
                font-size: 0.28rem; 
                align-items: center;  
                color: #999999;
                .money{
                    color: #333333;
                    font-weight: 400;
                }
            }
        }
        .row-3{
            font-size: 0.26rem;
            color: #999999;
            .time{
                color: #333333;
                font-size: 0.28rem;
            }
        }
    }
}
</style>
