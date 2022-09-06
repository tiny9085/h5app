import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    fetchGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/productPageBySidsForMarketing`,
            method: 'get',
            params
        })
    },
    productPageByLabels(params) {
        return request({
            baseURL,
            url: `/product/api/product/productPageByLabels`,
            method: 'get',
            params
        })
    },
    getUserInfo(params) {
        return request({
            baseURL,
            url: `/member/api/userInfo`,
            method: 'get',
            params
        })
    },
    searchGoods(params) {
        return request({
            baseURL,
            url: '/product/api/product/search',
            method: 'GET',
            params
        })
    },
    fetchProduct(params) {
        return request({
            baseURL,
            url: '/product/api/product/getProductPageByClassOrLabel',
            method: 'GET',
            params
        })
    }

}
