import Layout from '@/layout'

export default {
    path: '/message',
    component: Layout,
    redirect: '/message/list/index',
    children: [
        {
            path: '/message/list',
            component: () => import('@/views/message/list/index'),
            name: 'MessageList',
            meta: { 
                title: '我的消息', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: true
            }
        },
        {
            path: '/message/item/:type',
            component: () => import('@/views/message/item/index'),
            name: 'MessageItem',
            meta: { 
                title: 'messageItem', 
                hasToolBar: false,
                hasNavbar: true,
                keepAlive: true
            }
        }
    ]
}
