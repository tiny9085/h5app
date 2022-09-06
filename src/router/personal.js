import Layout from '@/layout'

export default {
    path: '/personal',
    component: Layout,
    redirect: '/personal/index',
    children: [
        {
            path: '/personal/index',
            component: () => import('@/views/personal/index/index'),
            name: 'Personal',
            meta: { 
                title: '个人中心', 
                hasToolBar: true,
                active: 4,
                keepAlive: true
            }
        },
        {
            path: '/personal/about',
            component: () => import('@/views/personal/about/index'),
            name: 'About',
            meta: { 
                title: '关于我们', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: true
            }
        },
        {
            path: '/personal/feedback',
            component: () => import('@/views/personal/feedback/index'),
            name: 'Feedback',
            meta: { 
                title: '客户反馈', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: true
            }
        },
        {
            path: '/personal/feedlist',
            component: () => import('@/views/personal/feedlist/index'),
            name: 'Feedlist',
            meta: { 
                title: '反馈记录', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/feedinfo',
            component: () => import('@/views/personal/feedinfo/index'),
            name: 'Feedinfo',
            meta: { 
                title: '反馈详情', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/balance',
            component: () => import('@/views/personal/balance/index/index'),
            name: 'balance',
            meta: { 
                title: '我的账户', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false,
                rightText: '分店账户'
            }
        },
        {
            path: '/personal/subBalance',
            component: () => import('@/views/personal/balance/index/index'),
            name: 'subBalance',
            meta: { 
                title: '分店账户', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false,
                rightText: ''
            }
        },
        {
            path: '/personal/subAccount',
            component: () => import('@/views/personal/subAccount/index'),
            name: 'subAccount',
            meta: { 
                title: '分店账户', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/coupon',
            component: () => import('@/views/personal/coupon/index'),
            name: 'coupon',
            meta: { 
                title: '我的优惠券', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/tips',
            component: () => import('@/views/personal/coupon/tips/index'),
            name: 'couponTips',
            meta: { 
                title: '优惠券规则说明', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: true
            }
        },
        {
            path: '/personal/selectCoupon',
            component: () => import('@/views/personal/coupon/selectCoupon/index'),
            name: 'selectCoupon',
            meta: { 
                title: '优惠券', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/freeze',
            component: () => import('@/views/personal/balance/freeze/index'),
            name: 'freeze',
            meta: { 
                title: 'generaltitle', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/specialList',
            component: () => import('@/views/personal/balance/specialList/index'),
            name: 'specialList',
            meta: { 
                title: '专项款详情', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/qualification',
            component: () => import('@/views/personal/qualification/index'),
            name: 'qualification',
            meta: { 
                title: '我的资质', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/qualification/update',
            component: () => import('@/views/personal/qualification/update'),
            name: 'qualificationUpdate',
            meta: { 
                title: '资质更新', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/qualification/note',
            component: () => import('@/views/personal/qualification/note'),
            name: 'qualificationNote',
            meta: { 
                title: '资质更新记录', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/qualification/detaill',
            component: () => import('@/views/personal/qualification/detail'),
            name: 'qualificationDetail',
            meta: { 
                title: '资质更新详情', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/server',
            component: () => import('@/views/personal/server'),
            name: 'server',
            meta: { 
                title: '客服', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/setting',
            component: () => import('@/views/personal/setting'),
            name: 'setting',
            meta: { 
                title: '设置', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/storeInfo',
            component: () => import('@/views/personal/setting/store-info'),
            name: 'storeInfo',
            meta: { 
                title: '账号信息', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/orderlist',
            component: () => import('@/views/personal/orderlist'),
            name: 'orderlist',
            meta: { 
                title: '我的订单', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/range',
            component: () => import('@/views/personal/range'),
            name: 'range',
            meta: { 
                title: '经营范围', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/personal/collectNew',
            component: () => import('@/views/personal/collectNew/index'),
            name: 'collectNew',
            meta: { 
                title: '新品收集', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false,
                rightText: '填报记录'
            }
        },
        {
            path: '/personal/newRecord',
            component: () => import('@/views/personal/collectNew/newRecord'),
            name: 'newRecord',
            meta: { 
                title: '填报记录', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        }
    ]
}
