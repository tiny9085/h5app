import Layout from '@/layout'

export default {
    path: '/activity',
    component: Layout,
    name: 'Activity',
    children: [
        {
            path: '/activity/index',
            component: () => import('@/views/activity/index'),
            name: 'activity',
            meta: {
                hasNavbar: true,
                title: '活动专区',
                keepAlive: true
            }
        },
        {
            path: '/activity/sale',
            component: () => import('@/views/activity/sale/Index'),
            name: 'AcitvitySale',
            meta: {
                hasNavbar: true,
                title: '',
                keepAlive: false
            }
        },
        {
            path: '/activity/special',
            component: () => import('@/views/activity/special/Index'),
            name: 'AcitvitySpecial',
            meta: {
                hasNavbar: true,
                title: '抗击疫情，我们在行动！',
                keepAlive: false
            }
        },
        {
            path: '/activity/package',
            component: () => import('@/views/activity/package/index'),
            name: 'AcitvityPackage',
            meta: {
                hasNavbar: true,
                title: '套餐专区',
                keepAlive: false
            }
        },
        {
            path: '/activity/activity-theme',
            component: () => import('@/views/product/list'),
            name: 'AcitvityTheme',
            meta: {
                hasNavbar: true,
                title: '商品列表',
                keepAlive: false
            }
        },
        {
            path: '/activity/subject',
            component: () => import('@/views/activity/subject/index'),
            name: 'AcitvitySubject',
            meta: {
                hasNavbar: true,
                title: '',
                keepAlive: false
            }
        },
        {
            path: '/activity/searchProduct',
            component: () => import('@/views/activity/searchProduct/index'),
            name: 'SearchProduct',
            meta: {
                hasNavbar: true,
                title: '',
                keepAlive: false
            }
        },
        {
            path: '/activity/quickFilter',
            component: () => import('@/views/activity/quickFilter'),
            name: 'QuickFilter',
            meta: {
                hasNavbar: true,
                title: '',
                keepAlive: false,
                rightText: '去购物车'
            }
        },
        {
            path: '/activity/YLLT',
            component: () => import('@/views/activity/specialActivitiesYLLT'),
            name: 'SpecialYLLT',
            meta: {
                hasNavbar: true,
                title: '专项活动',
                keepAlive: false
            }
        },
        {
            path: '/activity/YLLTPay',
            component: () => import('@/views/activity/specialActivitiesYLLT/payInfo'),
            name: 'SpecialYLLTPay',
            meta: {
                hasNavbar: true,
                title: '专项活动',
                keepAlive: false
            }
        },
        {
            path: '/activity/YLLTPaySuccess',
            component: () => import('@/views/activity/specialActivitiesYLLT/paySuccess'),
            name: 'SpecialYLLTPaySuccess',
            meta: {
                hasNavbar: true,
                title: '专项活动',
                keepAlive: false
            }
        }
    ]
}
