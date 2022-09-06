import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取列表消息数
     */
    fetchMessageCount(params) {
        return request({
            baseURL,
            url: `/message/api/message/info`,
            method: 'get',
            params
        })
    },
    /**
     * 获取消息列表
     */
    fetchMessageList(params) {
        return request({
            baseURL,
            url: `/message/api/message/page`,
            method: 'get',
            params
        })
    }
}
