import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 添加报名信息
     */
    activityImplementationDetails(data) {
        return request({
            baseURL,
            url: `/member/admin/activity/activityImplementationDetails`,
            method: 'post',
            data
        })
    },
    /**
     * 获取报名活动列表
     */
    signUpActivity() {
        return request({
            baseURL,
            url: `/member/admin/activity/signUpActivity`,
            method: 'get'
        })
    },
    /**
     * 获取会员列表
     */
    getMemberPage(params) {
        return request({
            baseURL,
            url: `/bi/customer/qualificationPage`,
            method: 'get',
            params
        })
    },
    /**
     * 获取字典
     */
    getDict(type) {
        return request({
            baseURL,
            url: `/admin/dict/type/${type}`,
            method: 'get'
        })
    },
    /**
     * 报名详情
     */
    viewSignUpDetails(sid) {
        return request({
            baseURL,
            url: `/member/admin/activity/viewSignUpDetails/${sid}`,
            method: 'get'
        })
    },
    /**
     * 会员报名详情
     */
    viewMemberDetail(query) {
        return request({
            baseURL,
            url: `/member/admin/activity/getDetailByMember/${query.sid}`,
            method: 'get'
        })
    },
    /**
     * 修改报名信息
     */
    editActivityImplementationDetails(data) {
        return request({
            baseURL,
            url: `/member/admin/activity/editActivityImplementationDetails`,
            method: 'put',
            data
        })
    }

}
