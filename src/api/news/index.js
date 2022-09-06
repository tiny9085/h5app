import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 获取新闻资讯列表
     */
    getNews(params) {
        return request({
            baseURL,
            url: `/cms/api/news/page`,
            method: 'get',
            params
        })
    },
    /**
	 * 获取新闻详情
	 * @param {*} query 
	 */
    getNewsInfo(query) {
        return request({
            baseURL,
            url: `/cms/api/news/${query}`,
            method: "get"
        });
    }
}
