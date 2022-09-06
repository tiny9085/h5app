import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取活动报名记录列表
     */
    fetchList(status,params) {
        return request({
            baseURL,
            url: `/member/admin/activity/signUpDetailsPage/${status}`,
            method: 'get',
            params
        })
    },
     /**
     * 修改报名状态
     */
      editStatus(sid,status) {
        return request({
            baseURL,
            url: `/member/admin/activity/editSignUpStatus/${sid}/${status}`,
            method: 'put'
        })
    },
    /**
     * 删除记录
     */
     delStatus(sid) {
        return request({
            baseURL,
            url: `/member/admin/activity/delSignUp/${sid}`,
            method: 'delete'
        })
    },
}
