import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

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
    }
}
