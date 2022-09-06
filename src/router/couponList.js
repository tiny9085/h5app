import Layout from '@/layout'

export default {
    path: '/couponList',
    component: Layout,
    redirect: '/couponList/index',
    children: [
        {
            path: '/couponList/index',
            component: () => import('@/views/couponList/index'),
            name: 'CouponList',
            meta: { 
                title: '领券中心', 
                rightText: '我的优惠券',
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        }
    ]
}
