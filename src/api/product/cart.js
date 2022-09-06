import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 商品加入购物车
     */
    addTocart(data) {
        return request({
            baseURL,
            // url: `/order/api/cart/product`,
            url: `/order/api/cart/mutil_shop`,
            method: 'post',
            data: data
        })
    },
    /**
     * 获取购物车列表
     */
    fetchCartList() {
        return request({
            baseURL,
            url: `/order/api/cart/productList`,
            method: 'get'
        })
    },
    /**
     * 更新购物车数量-单品
     */
    upDateCartNum(data) {
        return request({
            baseURL,
            url: `/order/api/cart/quantity`,
            method: 'put',
            data
        })
    },
    /**
     * 删除购物车商品
     */
    deleteGoods(data) {
        return request({
            baseURL,
            url: `/order/api/cart/product`,
            method: 'delete',
            data
        })
    },
    /**
     * 检查是否有额外赠品
     */
    getExtraGift(data) {
        return request({
            baseURL,
            url: `/order/api/cart/promotion`,
            method: "post",
            data
        })
    },
    /**
     * 结算购物车
     */
    comfirmCart(data) {
        return request({
            baseURL,
            url: `/order/api/cart/confirm`,
            method: "post",
            data
        })
    },
    /**
     * 获取购物车品种数
     */
    getCartNum() {
        return request({
            baseURL,
            url: `/order/api/cart/count`,
            method: "GET"
        })
    },
    /**
     * 选中、更新组合商品数量
     */
    updateNum(data) {
        return request({
            baseURL,
            url: `/order/api/cart/group`,
            method: "post",
            data
        })
    },
    /**
     * 预售抢购
     */
    comfirmPreSale(data) {
        return request({
            baseURL,
            // url: `/order/api/presell/product`,
            url: `/order/api/presell/mutil_shop`,
            method: "post",
            data
        }) 
    },
    /**
     * 确认预售抢购
     */
    confirmBuy(data) {
        return request({
            baseURL,
            // url: '/order/api/presell/comfirm',
            url: '/order/api/presell/orderConfirm',
            method: "post",
            data
        })
    },
    /**
     * 购物车套餐加减数量
     */
    setPackageNumber(data){
        return request({
            baseURL,
            url: `/order/api/cart/product`,
            method: "put",
            data
        })
    },
    /**
     * 购物车中商品明细（已加购）
     */
    addedCount() {
        return request({
            baseURL,
            url: `/order/api/cart/product/count`,
            method: "post"
        })
    },
    // 获取经营范围
    businessScope() {
        return request({
            baseURL,
            url: `/member/api/userInfo/allBusinessScope`,
            method: "get"
        });
    },
    // 购物车岳麓论坛专项款商品
    accountPredict() {
        return request({
            baseURL,
            url: `/order/api/cart/account/predict`,
            method: "get"
        });
    }
}
