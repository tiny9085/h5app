import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /* 
    获取问卷调查信息列表 
    */
    fetchContent(status, params) {
        return request({
            baseURL,
            url: `/member/questionnaire/selectTempByAccount/${status}`,
            method: 'get',
            params
        })
    },
    /* 
    提交账号重开问答卷信息列表
     */
    fetchSave(params) {
        return request({
            baseURL,
            url: `/bi/process/api/member`,
            method: 'post',
            data: params
        })
    }
}
