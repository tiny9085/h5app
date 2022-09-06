import { Dialog, Toast } from 'vant';
import A from 'axios'
import store from '@/store'
import router from '../router'
import VMnative from '@/utils/VMnative'

const service = A.create({
    timeout: 15000,
    withCredentials: true,
    cancelToken: new A.CancelToken(c => (A.requestCancel = c))
});

service.interceptors.request.use(config => {
    const token = store.getters.token;
    const isToken = (config.headers || {}).isToken === false
    config.headers['source'] = config.headers.source || 5
    if (token && !isToken) {
        config.headers['Authorization'] = token  // token
    }
    return config;
}, error => {
    return Promise.reject(error)
});

service.interceptors.response.use(
    response => {
        const status = Number(response.status) || 200
        if (status === 401 || response.data.code === 181005 || response.data.code === 181006) {
            store.commit('setUserInfo', null)
            store.commit('setToken', null)
            service.timer && clearTimeout(service.timer)
            Toast.clear()
            if (router.app.$route.query.source && router.app.$route.query.source !== 'h5'){
                Dialog.alert({
                    title: '温馨提示',
                    message: '登录失效，请重新登录'
                }).then(() => {
                    VMnative.callHandler("toLogin", {})
                })
            } else {
                const linkUrl = router.app.$route.fullPath
                router.push('/account/login?linkUrl=' + linkUrl)
            }
        } else if (response.data.code === 99999) {
            Dialog.alert({
                title: '系统升级中',
                message: '\n' + response.data.msg + '\n\n',
                showConfirmButton: false
            }).then(() => {
                
            })
        } else if (
            status === 200 &&
            ([0, 111000, 101005, 101008, 102017, 181013, 2, 100032, 800004, 181014, 800008].indexOf(response.data.code) > -1 || response.data.access_token)
        ) {
            return response
        } else {
            service.timer && clearTimeout(service.timer)
            Toast.clear()
            service.timer = setTimeout(() => {
                Toast(response.data.msg)
            }, 500)
            return Promise.reject(response.data.msg)
        }
    },
    error => {
        Toast.clear()
        if (error.response.status === 400) {
            Toast(error.response.data.msg)
        } else {
            service.timer && clearTimeout(service.timer)
            service.timer = setTimeout(() => {
                Toast(error.message)
            }, 500)
        }
        return Promise.reject(error)
    }
);

export default service;

