import request from '@/utils/request'
import { baseURL } from "@/utils/urls"

export default {
    /**
     * 获取分类数据
     */
    fetchIndustry(params) {
        return request({
            baseURL,
            url: `/product/api/productClass/industryClass/all`,
            method: 'get',
            params
        })
    },
    /**
     * 获取商品数据
     */
    fetchGoodsList(params) {
        return request({
            baseURL,
            url: `/product/api/product/search`,
            method: 'get',
            params
        })
    }
}
