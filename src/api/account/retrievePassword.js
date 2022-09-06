import request from '@/utils/request'
import { baseURL } from "@/utils/urls"

export default {
    // 根据关联账号验证客户
    verification(account) {
        return request({
            baseURL,
            url: `/member/api/userInfo/verification/${account}`,
            method: "get",
            headers: {
                isToken: false
            }
        })
    },
    // 获取验证码
    forgetPwdCode(phone) {
        return request({
            baseURL,
            url: `/member/api/userInfo/forgetPwdCode/${phone}`,
            method: "get",
            headers: {
                isToken: false
            }
        })
    },
    // 修改密码
    forgetEditPwd(data) {
        return request({
            baseURL,
            url: `/member/api/userInfo/forgetEditPwd`,
            method: "put",
            headers: {
                isToken: false
            },
            params: data
        })
    },
    // 获取审核状态
    progressQuery(phone) {
        return request({
            baseURL,
            url: `/member/api/userInfo/progressQuery/${phone}`,
            method: "get",
            headers: {
                isToken: false
            }
        })
    },
    // 通过新手机号码获取验证码
    getNphoneCode(phone) {
        return request({
            baseURL,
            url: `/member/api/userInfo/forgetPhone/${phone}`,
            method: "get",
            headers: {
                isToken: false
            }
        })
    },
    // 手机变更校验验证码是否通过
    checkUserInfo(code, phone) {
        return request({
            baseURL,
            url: `/member/api/userInfo/check/${code}/${phone}`,
            method: "get",
            headers: {
                isToken: false
            }
        })
    },
    // 上传身份证
    imgPost(data) {
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
    // 提交申诉
    uploadUserInfo(data) {
        return request({
            baseURL,
            url: `/member/api/userInfo/phone/upload`,
            method: "post",
            data
        });
    }
}
