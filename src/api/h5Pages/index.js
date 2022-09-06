import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取列表消息数
     */
    productDetails(qrCode) {
        return request({
            baseURL,
            url: `/product/api/product/search/qrCode/${qrCode}`,
            method: 'get'
        })
    },
}