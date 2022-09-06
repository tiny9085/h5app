import Layout from '@/layout'

export default {
    path: '/h5Pages',
    component: Layout,
    name: 'h5Pages',
    children: [
        {
            path: '/h5Pages/productQrCodeDetail',
            component: () => import('@/views/h5Pages/productQrCodeDetail'),
            name: 'productQrCodeDetail',
            meta: { 
                title: '恒昌医药集团',
                keepAlive: false,
                hasNavbar: true,
                hasToolBar: false
            }
        }
    ]
}
