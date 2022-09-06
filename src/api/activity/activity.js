import request from '@/utils/request'
import { baseURL } from "@/utils/urls"

export default {
    /**
     * 获取限时促销
     */
    fetchGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/promotion`,
            method: 'get',
            params
        })
    },
    /**
     * 获取满赠套餐
     */
    fetchPackage(params) {
        return request({
            baseURL,
            url: `/marketing/api/marketing/product/package`,
            method: 'get',
            params
        })
    },
    /**
     * 获取优惠券列表
     */
    fetchCouponList(query) {
        return request({
            baseURL,
            url: `/marketing/api/coupons/couponsPromotionArea`,
            method: "get",
            params: query
        });
    },
    /**
     * 获取专题列表
     */
    fetchSubjectList() {
        return request({
            baseURL,
            url: `/marketing/api/activity/topic/page`,
            method: "get"
        });
    },
    /**
     * 获取过滤的未采列表
     */
    fetchQuickFilterList(query) {
        return request({
            baseURL,
            url: `/product/api/product/quickBuy/filter`,
            method: "get",
            params: query
        });
    }
}
