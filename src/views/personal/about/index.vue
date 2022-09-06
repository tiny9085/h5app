<template>
    <app-template>
        <div :class="['Page-personal-about', 'theme-lsx', {'personal-box': !isApp}]">
            <div class="about-box" :style="!isApp ? 'border-top: .02rem solid #E4E4E4;':''">
                <div class="img-box">
                    <img class="privacy-img" src="https://imga.hnhcyy.com/fed/b2b-wechat/logo.png?v=1">
                </div>
                <div class="content-box">
                    <div class="title">
                        恒昌医药集团企业简介
                    </div>
                    <div class="row"><img src="https://imga.hnhcyy.com/fed/b2b-h5/about-us-banner.png" width="100%"></div>
                    <div class="row">
                        湖南恒昌医药集团股份有限公司（以下简称恒昌医药集团）由江琎等人于2015年6月1日创建于长沙医药健康产业园，成立之初便确立“专业创品牌、诚信立伟业”的核心价值观，以“让14亿国人不为健康产品多花1分钱”为使命，立志“做大健康产业集成服务平台领航者”，联合200余家百强及优质工业伙伴，通过互联网平台B2B模式，去掉层层加价环节，将大批优质、高效、低价的1500余个PB商品供应到全国十几万家终端会员门店。
                    </div>
                    <div class="row">
                        公司目前拥有员工1500余名，仓储面积达52000平方米。旗下有恒昌(广州)新药研究有限公司、湖南六谷大药房连锁有限公司、天津和治恒昌医药有限公司三家分、子公司和恒昌医疗器械研发生产中心，并拥有乐赛仙、佐安堂、初心、状元娃、草本至尊、善举、芽培、科大利民、尚划算等品牌。
                    </div>
                
                </div>
            </div>
        </div>
    </app-template>
</template>

<script>
import AppTemplate from '@/components/appTemplate/Index'
import VMnative from '@/utils/VMnative'
export default {
    components: {
        AppTemplate
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5'
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", '关于我们')
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                VMnative.callHandler("close", {})
            });
        } else {
            this.$route.meta.title = this.$route.query.title
        }
    },
    methods: {
        init() {
            
        }
    }
}
</script>

<style lang="scss">
.Page-personal-about{
    .about-box{
        .img-box{
            padding: .6rem 0 .4rem;
            text-align: center;
            .privacy-img{
                width: 3.81rem;
                height: .72rem;
            }
        }
        .content-box{
            padding: 0 .20rem;
            font-size: .26rem;
            .title{
                color: #333333;
                font-size: .32rem;
                text-align: center;
                padding-bottom: .20rem;
                font-weight: 700;
            }
            .row{
                color: #333333;
                padding-bottom: .40rem;
                line-height: .48rem;
            }
        }
    }
}
</style>
