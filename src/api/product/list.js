import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 即将到货
     */
    fetchComingGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/notice/page`,
            method: 'get',
            params
        })
    },
    /**
     * 即将上涨.新品抢购.预售专区
     */
    fetchGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/search/page`,
            method: 'get',
            params
        })
    },
    /**
     * 限时促销
     */
    fetchPromotionGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/promotion`,
            method: 'get',
            params
        })
    },
    /**
     * 宣传物料.品牌街
     */
    searchGoods(params) {
        return request({
            baseURL,
            url: '/product/api/product/search',
            method: 'GET',
            params
        })
    }
}
