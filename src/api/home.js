import request from '@/utils/request'
import {
    baseURL
} from "@/utils/urls";
export default {
    /**
     * 获取首页banner
     */
    fetchBanner(params) {
        return request({
            baseURL,
            url: '/cms/api/banner/page',
            method: 'get',
            params
        })
    },
    /**
     * 获取首页快速入口icon
     */
    fetchIcon() {
        return request({
            baseURL,
            url: '/cms/api/index/icon/page',
            method: 'get'
        })
    },
    /**
     * 获取首页促销推荐商品
     */
    fetchPromotion(params) {
        return request({
            baseURL,
            url: '/product/api/product/promotion',
            method: "get",
            params
        })
    },
    /**
     * 获取首页新品推荐(热销推荐)
     */
    fetchNewGoods(params) {
        return request({
            baseURL,
            url: '/product/api/product/search/page',
            method: "get",
            params
        })
    },
    /**
     * 获取首页弹窗
     */
    fetchWinPop(params) {
        return request({
            baseURL,
            url: '/cms/api/windowInfo/info',
            method: 'get',
            params
        })
    },
    /**
     * 获取楼层商品
     */
    fetchGoods(params) {
        return request({
            baseURL,
            url: '/product/api/product/search',
            method: 'get',
            params
        })
    },
    /**
     * 获取优惠券
     */
    fetchCouponList(query) {
        return request({
            baseURL,
            url: '/marketing/api/coupons/gainCouponsByNode',
            method: 'get',
            params: query
        })
    },
    /**
     * 判断是否展示预售
     */
    isShowPreSale() {
        return request({
            baseURL,
            url: '/admin/external/dict/type/PRESELL_DISPLAY',
            method: 'get'
        })
    },
    /**
     * 获取首页楼层数据
     */
    fetchFloorList(query) {
        return request({
            baseURL,
            url: '/cms/api/home/module/info',
            method: 'get',
            params: query
        })
    }
}
