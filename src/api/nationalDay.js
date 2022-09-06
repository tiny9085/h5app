import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    getActivityProduct(params) {
        return request({
            baseURL,
            url: `/marketing/api/marketing/promotion/activityProduct/${params.actSid}`,
            method: 'get',
            params
        })
    },
    getActivityInfo(params) {
        return request({
            baseURL,
            url: `/marketing/api/marketing/promotion/activityInfo/${params.actSid}`,
            method: 'get',
            params
        })
    }
}
