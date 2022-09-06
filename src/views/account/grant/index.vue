<template>
    <div class="grant-box">
        <div>
            <h2 style="text-align: center;margin-top: 60px;">数据授权书</h2>
        </div>
        <div class="box">
            <p class="op">本人根据企业经营需要，自愿通过湖南恒昌医药集团股份有限公司、恒昌（上海）信息技术有限公司（以下统称“恒昌”）向平安银行股份有限公司（以下称“平安银行”）申请融资服务，同意按平安银行的有关要求，向恒昌做出以下授权。</p>
            <p class="op">本人对恒昌的授权事项具体如下：</p>
            <p class="op b">第一条&nbsp;&nbsp;本人授权<span class="sign">恒昌</span>获取本人经营的企业的相关信息及经营数据，包括企业名称、法人代表人身份证信息/统一社会信用代码、关联手机号、药品经营许可证、企业在平台的注册时间、近24个月采购或交易金额等，用于<span class="sign">通过平安银行</span>贷款申请时的身份验证、授信审批、贷款出账、贷后管理等有关用途。</p>
            <p class="op b">第二条&nbsp;&nbsp;本人授权<span class="sign">平安银行</span>有权将本人在平安银行贷款审批结果、授信额度具体信息、贷款使用信息等信息回传<span class="sign">恒昌</span>，用于双方共同监测公司经营情况及贷款使用情况。</p>
            <p class="op b">第三条&nbsp;&nbsp;<span class="sign">恒昌</span>对按照本授权书所获取的本人的信息、业务系统有关的任何资料及其它各类数据、信息等负有保密义务。在未征得本人书面同意之前，不得向本授权书所描述的相关路径涉及相关方之外的任何第三方泄露（法律法规另有规定、有权机关另有要求的除外）。</p>
            <p class="op b">第四条&nbsp;&nbsp;本人授权<span class="sign">恒昌</span>享有知晓、使用、存储与贷款申请相关的原始数据，及在原始数据基础上通过第三方或平安银行计算获得的数据结果的权利；并可根据其内部管理的要求，享有对上述各项数据信息进行收集、复制、使用、分析、转移、加工、存储等权利。</p>
            <p class="op b">第五条&nbsp;&nbsp;本授权书自本人提交平安银行贷款申请当日起生效，直至本人/本单位与平安银行融资服务合作存续期结束内及本人/本单位与平安银行贷款全部清偿完毕后有效。</p>
            <p class="op b">本人已知悉本授权书所有内容的意义及其由此产生的法律效力，自愿作出上述授权，本授权书是本人/本单位真实意愿，本人同意承担由此带来的一切法律后果。</p>
            <p class="op r">授权人姓名：</p>
            <p class="op r">身份证号码：</p>
            <p class="op r">授权日期：{{ dayDate }}</p>
        </div>
    </div>
</template>

<script>
export default {
    name: 'AccountGrant',
    data() {
        return {
            isApp: this.$route.query.source === 'h5',
            dayDate: ''
        }
    },
    mounted(){
        var nowDate = new Date();
        var date = {
            year: nowDate.getFullYear(),
            month: nowDate.getMonth() + 1,
            day: nowDate.getDate()
        }
        var dayDate = date.year + '-' + (date.month >= 10 ? date.month : '0' + date.month) + '-' + (date.day >= 10 ? date.day : '0' + date.day)
        this.dayDate = dayDate
    },
    created(){
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    }
}
</script>

<style lang="scss">
.grant-box{
    word-break: break-all;
    .box{
        padding: 0.4rem 0.4rem;
        font-family:"微软雅黑";
    }
    .op{
        padding: 0.2rem 0;
        font-size: 16px;
        color: #000;
        line-height: 0.48rem;
    }
    .b {
        font-weight: 600;
    }
    .r{
        text-align: right;
    }
    .sign {
        border-bottom: 0.02rem solid;
    }
}
</style>
