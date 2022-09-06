import Layout from '@/layout'

export default {
    path: '/order',
    component: Layout,
    children: [
        {
            path: '/order/detail',
            component: () => import('@/views/order/detail'),
            name: 'orderDetail',
            meta: {
                title: '订单详情',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/order/mergeDetail',
            component: () => import('@/views/order/mergeDetail'),
            name: 'mergeDetail',
            meta: {
                title: '多门店订单详情',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/order/logistics',
            component: () => import('@/views/order/logistics'),
            name: 'orderLogistics',
            meta: {
                title: '物流信息',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/order/newLogistics',
            component: () => import('@/views/order/newLogistics'),
            name: 'newLogistics',
            meta: {
                title: '物流详情',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/order/goodlist',
            component: () => import('@/views/order/goodlist'),
            name: 'goodlist',
            meta: {
                title: '查看清单',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/order/comfirmOrder',
            component: () => import('@/views/order/comfirmOrder'),
            name: 'comfirmOrder',
            meta: {
                title: '订单确认',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/order/checkout',
            component: () => import('@/views/order/checkout'),
            name: 'checkout',
            meta: {
                title: '恒昌收银台',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/order/checkPay',
            component: () => import('@/views/order/checkout/checkPay'),
            name: 'checkPay',
            meta: {
                title: '检查付款',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/order/paySuccess',
            component: () => import('@/views/order/paySuccess'),
            name: 'paySuccess',
            meta: {
                title: '付款成功',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/order/invoice',
            component: () => import('@/views/order/invoiceDetail'),
            name: 'invoiceDetail',
            meta: {
                title: '发票详情',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        }
    ]
}
