import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取凑单列表
     */
    fetchGoods(query) {
        return request({
            baseURL,
            url: `/product/api/product/getProduct/${query.type}/${query.sid}`,
            method: 'get',
            params: {
                keyword: query.keyword,
                current: query.current,
                type: query.type,
                sid: query.sid
            }
        })
    }
}
