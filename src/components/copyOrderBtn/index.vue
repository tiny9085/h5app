<template>
    <span v-if="isShowTop" class="plain-btn" @click="payAgin({orderId: item.orderId})">再来一单</span>
    <van-button
        v-else
        color="#ED3129"
        plain
        round
        @click="payAgin({orderId: item.orderId})"
    >再来一单</van-button>
</template>
<script>
import Api from '@/api/order/index'
import {  Dialog, Toast } from 'vant';
export default {
    props: {
        item: {
            type: Object,
            default: () => {
                
            }
        },
        // 是否是多门店按钮
        isMergeOrder: {
            type: Boolean,
            default: false
        },
        // 是否是多店订单详情顶部展示按钮
        isShowTop: {
            type: Boolean,
            default: false
        }
    },
    data() {
        return {
            supplyNameArr: ['', '长沙', '天津', '上海优福思乐', '重庆']
        }
    },
    methods: {
        payAgin(params) {
            // 多店
            if (this.isMergeOrder) {
                if (this.item.selectList.length === 0){
                    Toast("未勾选订单")
                    return
                }
                Dialog.confirm({
                    message: '确认将这' + this.item.selectList.length + '个多门店订单复制到购物车吗？',
                    asyncClose: true,
                    cancelButtonText: "取消",
                    confirmButtonText: '确定',
                    cancelButtonColor: '#999999',
                    confirmButtonColor: '#ED3129',
                    className: 'mergBtn'
                }).then(() => {
                    Api.getMergAgin(this.item.selectList).then(res => {
                        if (res.data.code === 0){
                            this.$store.commit('setCartNum')
                            Toast("加入成功")
                        // this.$router.push('/cart/index')
                        }
                    })
                }).catch(() => {
                    Dialog.close();
                });
            } else {
                // 单店
                Api.getAgin(params).then(({ data }) => {
                    if (data.code === 101005) {// 多门店选择店铺
                        // 默认选中当前订单
                        localStorage.setItem("checkedStore", JSON.stringify([this.item.userSid]));
                        const userInfo = this.$store.getters.userInfo
                        userInfo.stores = data.data
                        const currentType = this.$store.getters.userInfo.currentType
                        const supplySid = this.$store.getters.userInfo.supplySid
                        userInfo.stores.forEach(store => {
                            store.clubList = store.clubList || []
                            if (store.clubList.indexOf(currentType) === -1){
                                store.disabled = true
                                if (currentType === 1){
                                    store.storeName = '无乐赛仙俱乐部'
                                } else if (currentType === 2){
                                    store.storeName = '无佐安堂俱乐部'
                                } else if (currentType === 3){
                                    store.storeName = '无初心俱乐部'
                                } else if (currentType === 4){
                                    store.storeName = '无六谷俱乐部'
                                } else if (currentType === 5){
                                    store.storeName = '无国通俱乐部'
                                }
                            }
                            if (store.supplySid !== supplySid){
                                store.disabled = true
                                store.supply = this.supplyNameArr[supplySid - 0];
                            }
                        })
                        this.$store.commit("setUserInfo", userInfo)
                        this.$store.commit("setSelectStore", {
                            isPackage: false,
                            show: true,
                            isCopy: true,
                            callback: (userSids) => {
                                this.payAgin(Object.assign({}, { orderId: this.item.orderId, userSids: userSids }))
                            }
                        })
                    } else if (data.code === 0){
                        this.$store.commit('setCartNum')
                        Toast("加入成功")
                        this.$store.commit('setSelectStore', { show: false })
                        // this.$router.push('/cart/index')
                    }
                })
            }
        }
    }
}
</script>
<style lang="scss" scoped>
.mergBtn{
    border-radius: .16rem;
    .van-dialog__message{
        font-size: .32rem;
    }
}
.plain-btn{
    background: transparent;
    border: .02rem solid #FFFFFF;
    color: #ffffff;
}
</style>
