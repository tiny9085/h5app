import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    login(params) {
        return request({
            baseURL,
            url: `/auth/authen/member`,
            method: 'get',
            headers: {
                "contentType": "application/x-www-form-urlencoded",
                TENANT_ID: "1",
                Authorization: "Basic d3hhcHA6d3hhcHA=",
                isToken: false
            },
            params
        })
    },
    logout() {
        return request({
            baseURL,
            url: `/auth/token/logout`,
            method: "DELETE"
        })
    },
    accountOpenStauts(params) {
        return request({
            baseURL,
            url: `/bi/process/api/account`,
            method: "get",
            params
        })
    }
}
