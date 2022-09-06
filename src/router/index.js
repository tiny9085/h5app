import Vue from 'vue'
import Router from 'vue-router'
import personal from './personal'
import mobile from './mobile'
import product from './product'
import news from './news'
import couponList from './couponList'
import smartMall from './smartMall'
import account from './account'
import message from './message'
import order from './order'
import extraGift from './extraGift'
import h5Pages from './h5Pages'
import bi from './bi'
Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/* Router Modules */
// import componentsRouter from './modules/components'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'             the icon show in the sidebar
    noCache: true                if set true, the page will no be cached(default is false)
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
    hasNavbar:true               navbar show (must set!!!) 
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
    {
        path: '/redirect',
        component: Layout,
        hidden: true,
        children: [
            {
                path: '/redirect/:path*',
                component: () => import('@/views/redirect/index')
            }
        ]
    },
    {
        path: '/',
        component: Layout,
        redirect: '/home',
        children: [
            {
                path: '/home',
                component: () => import('@/views/home/index'),
                name: 'Home',
                meta: { 
                    title: '首页',
                    hasNavbar: false,
                    hasToolBar: true,
                    active: 0,
                    keepAlive: true
                }
            }
        ]
    },
    account,
    personal,
    mobile,
    product,
    news,
    smartMall,
    message,
    order,
    extraGift,
    couponList,
    h5Pages,
    bi,
    {
        path: '/menu',
        component: Layout,
        redirect: '/menu/index',
        children: [
            {
                path: '/menu/index',
                component: () => import('@/views/menu/index'),
                name: 'menu',
                meta: { 
                    title: '抱团',
                    hasNavbar: false,
                    hasToolBar: true,
                    active: 1,
                    keepAlive: true
                }
            }
        ]
    },
    {
        path: '/quick',
        component: Layout,
        redirect: '/quick/index',
        children: [
            {
                path: '/quick/index',
                component: () => import('@/views/quick/index'),
                name: 'quick',
                meta: { 
                    title: '快速下单',
                    hasNavbar: false,
                    hasToolBar: true,
                    active: 2,
                    keepAlive: true
                }
            }
        ]
    },
    {
        path: '/cart',
        component: Layout,
        redirect: '/cart/index',
        children: [
            {
                path: '/cart/index',
                component: () => import('@/views/cart/index'),
                name: 'cart',
                meta: { 
                    title: '购物车', 
                    rightText: '管理',
                    hasNavbar: true,
                    hasToolBar: true,
                    active: 3,
                    keepAlive: false
                }
            }
        ]
    },
    {
        path: '/404',
        component: () => import('@/views/error-page/404'),
        hidden: true
    },
    {
        path: '/401',
        component: () => import('@/views/error-page/401'),
        hidden: true
    }
]

/**
 * asyncRoutes
 * the routes that need to be dynamically loaded based on user roles
 */
// export const asyncRoutes = [

//     // 404 page must be placed at the end !!!
//     { path: '*', redirect: '/404', hidden: true }
// ]

const createRouter = () => new Router({
    // mode: 'history', // require service support
    scrollBehavior: () => ({ y: 0 }),
    routes: constantRoutes
})

const router = createRouter()

export function resetRouter() {
    const newRouter = createRouter()
    router.matcher = newRouter.matcher // reset router
}
export default router
