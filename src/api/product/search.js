import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 搜索商品
     */
    fetchGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/search`,
            method: 'get',
            params
        })
    },
    /**
     * 获取热门关键字
     */
    gethotword(params) {
        return request({
            baseURL,
            url: `/product/api/product/hotWordInDb/pageForApi`,
            method: 'get',
            params
        })
    }
}
