import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取订单
     * @param {*} query 
     */
    getOrder(query) {
        if (query.keyWord) { // 搜索单门店订单
            return request({
                baseURL,
                url: `/order/api/order/search`,
                method: "get",
                params: query
            });
        } else {
            return request({
                baseURL,
                url: `/order/api/order/list`,
                method: "get",
                params: query
            });
        }
    },
    /**
     * 查询多门店订单
     */
    getMergeOrder(query) {
        return request({
            baseURL,
            url: `/order/api/order/merge/list`,
            method: "get",
            params: query
        });
    },
    /**
     * 查看物流单号列表
     * @param {*} query 
     */
    getLogi(query) {
        return request({
            baseURL,
            url: `/order/api/order/logistics/summary/${query}`,
            method: "get"
        });
    },
    /**
     * 查看物流详情
     * @param {*} query 
     */
    getLogiInfo(query) {
        return request({
            baseURL,
            url: `/order/api/order/ship-detail/${query}`,
            method: "get"
        });
    },
    /**
     * 取消订单&删除订单&确认收货 
     */
    cancelOrder(orderId, orderStatus) {
        return request({
            baseURL,
            url: `/order/api/order/${orderId}/${orderStatus}`,
            method: "put"
        });
    },
    /**
     * 取消订单&删除订单&确认收货 (多门店)
     */
    cancelMergOrder(query) {
        return request({
            baseURL,
            url: `/order/api/order/merge/${query.orderStatus}`,
            method: "put",
            data: query.orderIdList
        });
    },
    /**
     *再来一单
     * @param {*} query 
     */
    getAgin(data) {
        return request({
            baseURL,
            // url: `/order/api/order/copyOrder/${query.orderId}`,
            url: `/order/api/order/toCart`,
            method: "post",
            // data: { userSids: query.userSids }
            data: data
        });
    },
    /**
     *再来一单(多门店)
     * @param {*} query 
     */
    getMergAgin(query) {
        return request({
            baseURL,
            url: `/order/api/order/merge/copy/`,
            method: "post",
            data: query
        });
    },
    /**
     * 订单详情
     * @param {*} query 
     */
    getOrderInfo(query) {
        return request({
            baseURL,
            url: `/order/api/order/detail/${query}`,
            method: "get"
        });
    },
    /**
     * 订单详情(多门店)
     * @param {*} query 
     */
    getMergOrderInfo(query) {
        return request({
            baseURL,
            url: `/order/api/order/merge/detail/${query}`,
            method: "get"
        });
    },
    /**
     * 提交订单
     */
    submitOrder(data) {
        return request({
            baseURL,
            url: `/order/api/order/submit`,
            method: "post",
            data
        });
    },
    /**
     * 提交订单(预售)
     */
    submitPreSaleOrder(data) {
        return request({
            baseURL,
            url: `/order/api/presell/orderSubmit`,
            method: "post",
            data
        });
    },
    /**
     * 收银台
     */
    fetchOrderInfo(query) {
        return request({
            baseURL,
            url: `/order/api/order/cashier/${query}`,
            method: "POST"
        })
    },
    /**
     * 收银台(多门店)
     */
    fetchMergOrderInfo(query) {
        return request({
            baseURL,
            url: `/order/api/order/merge/cashier`,
            method: "POST",
            data: query
        })
    },
    /**
     * 获取openid
     */
    getOpenid(query) {
        return request({
            baseURL,
            url: `/mp/wxaccount/user/${query.appId}/${query.code}`,
            method: "GET"
        })
    },
    /**
     * 支付订单(h5)
     */
    pay(params) {
        return request({
            baseURL,
            url: `/order/api/order/payment/${params.orderId}/${params.paymentType}`,
            method: "POST"
            // params: {
            //     openId: params.openid
            // }
        }) 
    },
    /**
     * 支付订单(jsapi)
     */
    payOrder(params) {
        return request({
            baseURL,
            url: `/order/api/order/payment/${params.orderId}/${params.paymentType}`,
            method: "POST",
            params: {
                openId: params.openid
            }
        })
    },
    /**
     * 支付成功后获取优惠券
     */
    fetchCouponList(query) {
        return request({
            baseURL,
            url: `/order/api/order/paid/coupons/${query}`,
            method: "GET"
        })
    },
    /**
     * 获取支付验证码
     */
    getCode(query) {
        return request({
            baseURL,
            url: `/order/api/order/payment/captcha/${query}`,
            method: "GET"
        })
    },
    /**
     * 验证码支付
     */
    payWithCode(query) {
        return request({
            baseURL,
            url: `/order/api/order/payment/verify/${query.orderId}/${query.payCode}`,
            method: "POST"
        }) 
    },
    /**
     * 发送电子发票到邮箱
     */
    sentEmail(params) {
        return request({
            baseURL,
            url: `order/api/order/invoice/electric/${params.orderId}/send`,
            method: "GET",
            params: {
                email: params.email
            }
        })
    },
    /**
     * 会员批量绑定邮箱
     */
    bindEmail(data) {
        return request({
            baseURL,
            url: `/member/api/userInfo/batchBindEmail`,
            method: "POST",
            data: data
        })
    },
    /**
     * 订单确认选择优惠券
     */
    couponsChoose(data) {
        return request({
            baseURL,
            url: `/order/api/cart/couponsChoose`,
            method: "POST",
            data: data
        })
    },
    /**
     * 查找电子发票
     */
    getInvoiceList(orderId) {
        return request({
            baseURL,
            url: `/order/api/order/invoice/create/${orderId}`,
            method: "get"
        })
    }
}
