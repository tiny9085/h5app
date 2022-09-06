import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 查询快速下单商品
     */
    fetchQuickBuy(params) {
        return request({
            baseURL,
            url: `/product/api/product/quickBuy/page`,
            method: 'get',
            params
        })
    }
}
