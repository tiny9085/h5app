import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 资质列表
     */
    allQualification() {
        return request({
            baseURL,
            url: `/member/api/userQualification/allQualification`,
            method: "get"
        });
    },
    /**
     * 更新资质
     */
    qualificationCheck(data) {
        return request({
            baseURL,
            url: `/member/api/userQualification/qualificationCheck`,
            method: "post",
            data
        });
    },
    /**
     * 上传资质
     */
    uploadQualification(data) {
        return request({
            baseURL,
            headers: { 
                'Content-Type': 'multipart/form-data'
            },
            url: `/public/api/file/upload`,
            method: "post",
            data
        });
    },
    /**
     * 获取最近过期的资质
     */
    nearQualification(sid) {
        return request({
            baseURL,
            url: `/member/api/userQualification//nearQualification/${sid}`,
            method: "get"
        });
    },
    /**
     * 获取资质记录
     */
    qualificationNotes(params) {
        return request({
            baseURL,
            url: `/member/api/userQualification/qualificationCheckDetails`,
            method: "get",
            params
        });
    },
    /**
     * 撤销资质
     */
    cancleQualificationCheck(sid) {
        return request({
            baseURL,
            url: `/member/api/userQualification/cancleQualificationCheck/${sid}`,
            method: "put"
        });
    },
    /**
     * 资质详情
     */
    qualificationDetails(sid) {
        return request({
            baseURL,
            url: `/member/admin/userInfo/qualification/${sid}`,
            method: "get"
        });
    },
}