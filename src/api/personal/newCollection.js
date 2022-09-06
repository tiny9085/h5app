import request from '@/utils/request'
import { baseURL } from "@/utils/urls";

export default {
    /**
     * 资质列表
     */
    collection(data) {
        return request({
            baseURL,
            url: `/cms/api/product/collection`,
            method: "post",
            data
        });
    },
    /**
     * 上传商品图片
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
     * 新品收集记录
     * @params 
     */
    collectionRecord(params) {
        return request({
            baseURL,
            url: `/cms/api/product/collection`,
            method: "get",
            params
        });
    }
}
