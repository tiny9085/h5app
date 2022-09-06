import Layout from '@/layout'

export default {
    path: '/extraGift',
    component: Layout,
    redirect: '/extraGift/index',
    children: [
        {
            path: '/extraGift/index',
            component: () => import('@/views/extraGift/index'),
            name: 'extraGift',
            meta: {
                title: '赠品选择',
                hasNavbar: true,
                hasToolBar: false,
                keepAlive: false
            }
        }
    ]
}
