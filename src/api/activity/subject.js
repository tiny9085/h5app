import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    fetchTopicInfo(moduleId) {
        return request({
            baseURL,
            url: `/marketing/api/activity/topic/info/${moduleId}`,
            method: 'get'
        })
    },
    fetchTopicGoods(query) {
        return request({
            baseURL,
            url: `/product/api/product/getProductPageByClassOrLabel`,
            method: 'get',
            params: query
        })
    },
    getPromotionInfoByIds(query) {
        return request({
            baseURL,
            url: `/marketing/api/marketing/product/packageByIds`,
            method: 'get',
            params: query
        })
    },
    getProductPageByPromotion(query) {
        return request({
            baseURL,
            url: `/product/api/product/getProductPageByPromotion`,
            method: 'get',
            params: query
        })
    },
    getProductInfoById(query) {
        return request({
            baseURL,
            url: `/product/api/product/search/info/${query.id}`,
            method: 'get',
            params: query
        })
    }
}
