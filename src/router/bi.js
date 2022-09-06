import Layout from '@/layout'

export default {
    path: '/bi',
    component: Layout,
    name: 'Bi',
    children: [
        {
            path: '/bi/service',
            component: () => import('@/views/bi/service/Index'),
            name: 'BiService',
            meta: { 
                title: '用户协议',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/bi/privacy',
            component: () => import('@/views/bi/privacy/index'),
            name: 'BiPrivacy',
            meta: { 
                title: '隐私政策',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/bi/customer',
            component: () => import('@/views/bi/customer/list'),
            name: 'BiCustomerList',
            meta: { 
                title: '客户列表',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/bi/logistics',
            component: () => import('@/views/bi/customer/logistics'),
            name: 'BiCustomerLogistics',
            meta: { 
                title: '客户列表',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/bi/record',
            component: () => import('@/views/bi/record/index'),
            name: 'BiRecordList',
            meta: { 
                title: '活动报名记录',
                hasNavbar: false,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/bi/signUpYLLT',
            component: () => import('@/views/bi/signUpYLLT/index'),
            name: 'BiSignUpYLLT',
            meta: { 
                title: '活动报名',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            } 
        }
    ]
}
