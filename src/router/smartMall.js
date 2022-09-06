import Layout from '@/layout'

export default {
    path: '/smart-mall',
    component: Layout,
    redirect: '/smart-mall/index',
    children: [
        {
            path: '/smart-mall/index',
            component: () => import('@/views/smart-mall/index'),
            name: 'Smart-mall',
            meta: { 
                title: '尚划算', 
                hasToolBar: false,
                hasNavbar: false,
                keepAlive: false
            }
        },
        {
            path: '/smart-mall/menu',
            component: () => import('@/views/smart-mall/menu'),
            name: 'Smart-mall-menu',
            meta: { 
                title: '分类', 
                hasToolBar: false,
                hasNavbar: false,
                keepAlive: true
            }
        }
    ]
}
