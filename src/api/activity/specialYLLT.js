import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    // 获取专项活动信息和档次
    fetchList(code) {
        return request({
            baseURL,
            url: `/member/api/activity/details/${code}`,
            method: 'get'
        })
    },
    // 获取会员参与专项活动信息
    memberDetail(sid) {
        return request({
            baseURL,
            url: `/member/api/activity/partake/${sid}`,
            method: 'get'
        })
    },
    // 立即支付
    sepecalOnlyNumber(obj) {
        return request({
            baseURL,
            url: `/member/api/activity/sepecalOnlyNumber/${obj.userInfoSid}/${obj.specialSid}/${obj.supplySid}/${obj.sn}`,
            method: 'post',
            params: {
                channelId: obj.channelId
            }
        })
    },
    // 查询订单生成状态
    checkSepecalOrderPayStatus(orderCode) {
        return request({
            baseURL,
            url: `/member/api/activity/checkSepecalOrderPayStatus/${orderCode}`,
            method: 'get'
        })
    },
    // 获取已参加活动的会员
    getAllPayMentStatus(sepecalSid) {
        return request({
            baseURL,
            url: `/member/api/activity/getAllPayMentStatus/${sepecalSid}`,
            method: 'get'
        })
    }
}
