import Layout from '@/layout'

export default {
    path: '/account',
    component: Layout,
    name: 'Account',
    children: [
        {
            path: '/account/login',
            component: () => import('@/views/account/login/Index'),
            name: 'AccountLogin',
            meta: { 
                title: '登录',
                keepAlive: false
            }
        },
        {
            path: '/account/register',
            component: () => import('@/views/account/register/index'),
            name: 'AccountRegister',
            meta: { 
                title: '会员注册',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/account/stepone',
            component: () => import('@/views/account/register/stepone'),
            name: 'AccountRegisterStepOne',
            meta: { 
                title: '信息填写',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            }
        },
        {
            path: '/account/stepthree',
            component: () => import('@/views/account/register/stepthree'),
            name: 'AccountRegisterStepThree',
            meta: { 
                title: '资质申请上传',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/account/service',
            component: () => import('@/views/account/service/Index'),
            name: 'AccountService',
            meta: { 
                title: '商城用户服务协议',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/account/privacy',
            component: () => import('@/views/account/privacy/index'),
            name: 'AccountPrivacy',
            meta: { 
                title: '商城用户隐私政策',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/account/forget',
            component: () => import('@/views/account/forget/index'),
            name: 'AccountForget',
            meta: { 
                title: '修改密码',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        },
        {
            path: '/account/reopenAccount',
            component: () => import('@/views/account/login/reopenAccount'),
            name: 'BiReopenAccount',
            meta: { 
                title: '申请重开',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: true
            } 
        },
        {
            path: '/account/retrieve-pwd',
            component: () => import('@/views/account/retrievePassword'),
            name: 'RetrievePwd',
            meta: { 
                title: '找回密码',
                hasNavbar: true,
                hasToolBar: false
            } 
        },
        {
            path: '/account/appeal',
            component: () => import('@/views/account/appeal'),
            name: 'accountAppeal',
            meta: { 
                title: '在线申诉',
                hasNavbar: true,
                hasToolBar: false
            } 
        },
        {
            path: '/account/grant',
            component: () => import('@/views/account/grant/index'),
            name: 'AccountGrant',
            meta: { 
                title: '三方授权书',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        }
    ]
}
