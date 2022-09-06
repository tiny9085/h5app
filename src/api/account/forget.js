import request from '@/utils/request'
import { baseURL } from "@/utils/urls"

export default {
    getCode(params) {
        return request({
            baseURL,
            url: `/member/api/userInfo/forgetPwdCode/${params}`,
            method: "get",
            headers: {
                isToken: false
            }
        })
    },
    changePwd(data) {
        return request({
            baseURL,
            url: `/member/api/userInfo/forgetEditPwd`,
            method: "put",
            headers: {
                isToken: false
            },
            params: data
        })
    }
}
