import Layout from '@/layout'

export default {
    path: '/product',
    component: Layout,
    children: [
        {
            path: '/product/coming-soon',
            component: () => import('@/views/product/list'),
            name: 'comingSoon',
            meta: {
                title: '即将到货',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/get-rise',
            component: () => import('@/views/product/list'),
            name: 'getRise',
            meta: {
                title: '即将上涨',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/new-goods',
            component: () => import('@/views/product/list'),
            name: 'newGoods',
            meta: {
                title: '新品抢购',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/promotion',
            component: () => import('@/views/product/list'),
            name: 'promotion',
            meta: {
                title: '限时促销',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/recom-goods',
            component: () => import('@/views/product/list'),
            name: 'recomGoods',
            meta: {
                title: '相关推荐',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/search/:type',
            component: () => import('@/views/product/search'),
            name: 'search',
            meta: {
                title: '搜索',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/detail/:sid',
            component: () => import('@/views/product/detail'),
            name: 'GoodsDetail',
            meta: {
                title: '商品详情',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/product/getTogether',
            component: () => import('@/views/product/getTogether'),
            name: 'getTogether',
            meta: {
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/materials',
            component: () => import('@/views/product/list'),
            name: 'materials',
            meta: {
                title: '宣传物料',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/preSale',
            component: () => import('@/views/product/list'),
            name: 'preSale',
            meta: {
                title: '预售专区',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/product/needToKnow',
            component: () => import('@/views/product/needToKnow'),
            name: 'needToKnow',
            meta: {
                title: '购买须知',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/product/collectOrders',
            component: () => import('@/views/product/collectOrders'),
            name: 'collectOrders',
            meta: {
                title: '活动凑单',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        }
    ]
}
