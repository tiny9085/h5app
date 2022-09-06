import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取发函客户列表
     */
    fetchConfirmations(params) {
        return request({
            baseURL,
            url: `/k3cloud/confirmations/${params.type}`,
            method: 'get',
            headers: {
                CTR_VERSION: 'cc'
            },
            params
        })
    },
    /**
     * 获取发函物流详情
     */
    fetchConfirmationsDetail(data) {
        return request({
            baseURL,
            url: `/k3cloud/confirmations/logistics/${data.billCode}/${data.billName}`,
            method: 'get',
            headers: {
                CTR_VERSION: 'cc'
            }
        })
    }
}
