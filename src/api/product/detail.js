import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 搜索商品
     */
    fetchGoods(sid) {
        return request({
            baseURL,
            url: `/product/api/product/search/info/${sid}`,
            method: 'get'
        })
    },
    /**
     * 预售抢购
     */
    comfirmPreSale(data) {
        return request({
            baseURL,
            // url: `/order/api/presell/product`,
            url: `/order/api/presell/mutil_shop`,
            method: "post",
            data
        }) 
    },
    /**
     * 确认预售抢购
     */
    confirmBuy(data) {
        return request({
            baseURL,
            url: '/order/api/presell/comfirm',
            method: "post",
            data
        })
    }
}
