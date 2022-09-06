import Layout from '@/layout'

export default {
    path: '/news',
    component: Layout,
    redirect: '/news/index',
    children: [
        {
            path: '/news/index',
            component: () => import('@/views/news/index'),
            name: 'News',
            meta: { 
                title: '恒昌资讯', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        },
        {
            path: '/news/detail',
            component: () => import('@/views/news/detail'),
            name: 'NewsDetail',
            meta: { 
                title: '恒昌资讯', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: false
            }
        }
    ]
}
