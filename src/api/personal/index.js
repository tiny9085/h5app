import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 反馈列表
     * @data 
     */
    feedlist(query) {
        return request({
            baseURL,
            url: `/cms/api/userFeedback/page`,
            method: "get",
            params: query
        });
    },
    /**
     * 提交反馈
     * @data 
     */
    feedbackPost(data) {
        return request({
            baseURL,
            url: `/cms/api/userFeedback`,
            method: "post",
            data: data
        });
    },
    /**
     * 上传图片
     * @data 
     */
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
    /**
     * 查询会员余额、返利、专项款
     *
     */
    getInfo(query) {
        return request({
            baseURL,
            url: `/member/api/userAccount`,
            method: "get",
            params: query
        });
    },
    /**
     * 用户交易充值明细
     */
    getSpe(params) {
        return request({
            baseURL,
            url: `/member/api/userAccount/specialList`,
            method: "get",
            params
        });
    },
    /**
     * 用户交易充值明细
     */
    getUserInfo(query) {
        return request({
            baseURL,
            url: `/member/api/userAccount/pageUserAccountDetail`,
            method: "get",
            params: query
        });
    },
    /**
     * 查询用户余额、返利及其明细
     */
    getAccount(query) {
        return request({
            baseURL,
            url: `/member/api/userAccount/${query}`,
            method: "get"
        });
    },
    /**
     * 会员资质
     */
    getNatural() {
        return request({
            baseURL,
            url: `/member/api/userQualification/info`,
            method: "get"
        });
    },
    /**
     * 顾问信息
     */
    getConsult() {
        return request({
            baseURL,
            url: `/member/api/userInfo/consultant`,
            method: "get"
        });
    },
    /**
     * 获取冻结明细
     */
    getFreeze(changeType) {
        return request({
            baseURL,
            url: `/member/api/userAccount/freeAccount/${changeType}`,
            method: "get"
        });
    },
    /**
     * 获取订单数量及最新物流
     */
    getOrderCount() {
        return request({
            baseURL,
            url: `/order/api/order/status/count`,
            method: "get"
        });
    },
    /**
     * 切换俱乐部
     */
    changeClub(query) {
        return request({
            baseURL,
            url: `/member/api/userInfo/changeClubs`,
            method: "put",
            params: query
        });
    },
    /**
     * 获取客户信息
     */
    fetchUserInfo() {
        return request({
            baseURL,
            url: '/member/api/userInfo',
            method: 'get'
        })
    },
    /**
     * 获取我的优惠券列表
     */
    fetchCoupon(params) {
        // return request({
        //     baseURL,
        //     url: `/marketing/api/coupons/myCoupons`,
        //     method: "get",
        //     params: query
        // });
        return request({
            baseURL,
            url: `/marketing/api/coupons/manyStoresCoupons`,
            method: "get",
            params
        });
    },
    /**
     * 获取优惠券列表
     */
    fetchCouponList(query) {
        return request({
            baseURL,
            url: `/marketing/api/coupons/couponsPromotionArea`,
            method: "get",
            params: query
        });
    },
    /**
     * 查询我的优惠券总数
     */
    fetchCouponCount() {
        return request({
            baseURL,
            url: `/marketing/api/coupons/myCouponsCount`,
            method: "get"
        });
    },
    /**
     * 领取优惠券
     */
    receiveCoupon(query) {
        return request({
            baseURL,
            url: `/marketing/api/coupons/gainCouponsById/${query}`,
            method: "get"
        });
    },
    /**
     * 选择优惠券
     */
    selectCoupon(data) {
        return request({
            baseURL,
            url: `/order/api/order/couponsChoose`,
            method: "post",
            data: data
        });
    },
    /**
     * 获取门店数据（邮箱电话企业名称）
     */
    fetchStoreInfo() {
        return request({
            baseURL,
            url: `/member/api/userInfo/allUserInfoMap`,
            method: "get"
        });
    },
    /**
     * 修改邮箱
     */
    upDatedEmail(params) {
        return request({
            baseURL,
            url: `/member/api/userInfo/bindEmail/${params.sid}`,
            method: "post",
            params: {
                email: params.email
            }
        });
    },
    /**
     * 多体店-获取多店对应的优惠券状态
     */
    manyStoresCouponsInfo(couponsId) {
        return request({
            baseURL,
            url: `/marketing/api/coupons/manyStoresCouponsInfo/${couponsId}`,
            method: "get"
        });
    },
    /**
     * 多体店-多店领取优惠券
     */
    gainManyStoresCoupons(data) {
        return request({
            baseURL,
            url: `/marketing/api/coupons/gainManyStoresCoupons/${data.couponsId}`,
            method: "get",
            params: {
                userIds: data.userIds
            }
        });
    },
    /**
     * 获取子店账户
     */
    getSubAccount() {
        return request({
            baseURL,
            url: `/member/api/userAccount/child`,
            method: "get"
        });
    }
}
