import request from '@/utils/request'
import { baseURL } from "@/utils/urls"

export default {
    /**
     * 获取首页商品
     */
    fetchGoods(params) {
        return request({
            baseURL,
            url: '/product/api/product/search',
            method: 'get',
            params
        })
    },
    /**
     * 获取快速入口
     */
    fetchIcon(params) {
        return request({
            baseURL,
            url: '/cms/api/index/icon/page',
            method: 'get',
            params
        })
    },
    /**
     * 获取banner
     */
    fetchBanner(params) {
        return request({
            baseURL,
            url: '/cms/api/banner/page',
            method: 'get',
            params
        })
    },
    /**
     * 获取首页弹窗
     */
    fetchWinPop(params) {
        return request({
            baseURL,
            url: '/cms/api/windowInfo/info',
            method: 'get',
            params
        })
    },
    /**
     * 获取首页楼层数据
     */
    fetchFloorList(query) {
        return request({
            baseURL,
            url: '/cms/api/home/module/info',
            method: 'get',
            params: query
        })
    }
}
