import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取即将到货
     */
    fetchGoods(params) {
        return request({
            baseURL,
            url: `/product/api/product/search/page`,
            method: 'get',
            params
        })
    }
}
