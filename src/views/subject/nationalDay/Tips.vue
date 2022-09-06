<template>
    <div class="box">
        <img class="top-banner" src="https://imga.hnhcyy.com/fed/b2b-h5/subject/nationalDay/tips-banner.png" alt="">
        <div class="text">
            <p class="text-title">套餐抢购活动规则</p>
            <p>一.活动时间:2019年9月17日-2019年9月28日</p>
            <p>二.本次抢购活动为乐赛仙会员用户专享。</p>
            <p>三.活动期间使用任何舞弊行为的用户一经发现，即刻取消抢购活动资格。</p>
            <p>四.抢购的产品数量有限，抢完即止。抢购产品库存数量在抢购过程中实时变化，抢购成功与否以实际结果为准。</p>
            <p>五.限时抢购活动时间：每三个套餐进行维持48小时的抢购活动。</p>
            <p>六.抢购价格：299、399、499元。</p>
            <p>七.在成功抢购后，用户需提供真实信息。如因用户资料不全导致活动奖品无法正确发放的情况，主办方不对由此产生的任何后果负责。</p>
            <p>八.所有的订单需要满足免运费的最低采购额才能派送。</p>
            <p>九.本活动最终解释权归湖南恒昌医药集团股份有限公司所有。</p>
            <p class="text-title">全场买赠活动规则</p>
            <p>一.活动时间:2019年9月17日-2019年9月28日</p>
            <p>二.活动范围:所购买商品为国庆活动产品。</p>
            <p>三.如何判断我购买的产品是否参加此活动?</p>
            <p>答:商品页面标示详情有“活动产品下单满2888元送价值260元的补钙产品(6盒阿胶强骨口服液(草本至尊)或者4盒赖氨酸磷酸氢钙颗粒),活动产品下单满4988元,送价值538元的补钙产品(12盒阿胶强骨口服液(状元娃)或者8盒赖氨酸磷酸氢钙颗粒)”字样即为参加。</p>
            <p>四.参与步骤:选择参与活动的产品→加入购物车→去结算→订单支付完成→获得赠品→点击选择赠品→输入收货地址。</p>
            <p>五.支付方式:支持在线支付、支付宝支付、微信支付、余额支付和专项款支付的订单，不支持货到付款、门店付款订单，下单及支付完成时间需在活动时间范围内。</p>
            <p>六.本次活动只针对乐赛仙线上会员用户、如您需要加入会员参与购买，需要联系当地经营顾问注册会员。</p>
            <p>七.满赠规则：</p>
            <p>1、活动产品下单满2888元,送价值260元的补钙产品 (6盒阿胶强骨口服液(草本至尊)或者4盒赖氨酸磷酸氢钙颗粒)。</p>
            <p>2、活动产品下单满4988元,送价值538元的补钙产品(12盒阿胶强骨口服液(状元娃)或者8盒赖氨酸磷酸氢钙颗粒）订单最终满赠规则由最终支付订单为准。</p>
            <p>八.所有的订单需要满足免运费的配送线才能派送。</p>
            <p>九.本活动最终解释权归湖南恒昌医药集团股份有限公司所有。</p>
        </div>
    </div>
</template>

<script>
import VMnative from '@/utils/VMnative'
import '@/utils/pxtorem'
export default {
    mounted() {
        VMnative.callHandler("setTitle", "活动攻略")

        VMnative.registerHandler('goBack', (data, responseCallback) => {
            this.$router.push('/subject/nationalDay')
        });
    }
}
</script>

<style lang="scss">
    .box{
        width: 100%;
        display: flex;
        flex-direction: column;
        .top-banner{
            width: 100%;
            height: 3.92rem;
            margin-bottom: .2rem;
        }
        .tips-text{
            padding: .4rem 0 .2rem .42rem;
            width: 2.4rem;
            height: .28rem;
        }
        .text{
            font-size: .28rem;
            color: #333333;
            padding: 0 .22rem .4rem;
            p{
                line-height: .5rem;
                text-indent: .2rem;
            }
            .text-title {
                font-size: .32rem;
                font-weight: bold;
                color: #333333;
                padding: .15rem;
            }
        }
    }
</style>
