import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    fetchGoods(params) {
        return request({
            baseURL,
            url: `/marketing/api/marketing/product/package`,
            method: 'get',
            params
        })
    }
}
