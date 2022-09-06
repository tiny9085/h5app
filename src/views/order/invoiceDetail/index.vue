<template>
    <div class="order-invoice-detail">
       <table align='center' width='100%' border="1px" cellspacing="0px" bordercolor="#f3f3f3">
            <tr class="title">
                <th>发票编号</th>
                <th>操作</th>
            </tr>
            <tr v-for="(item,index) in invoiceData" :key="index">
                <td>{{item.invoiceNum}}</td>
                <td style="color:#ED3129;">
                    <a :href="item.previewUrl">查看发票</a>
                </td>
            </tr>
      </table>
    </div>
</template>
<script>
import Api from '@/api/order'
export default {
    data(){
        return {
            invoiceData:[]
        }
    },
    created(){
        this.gotoInvoice()
    },
    methods:{
        /**
         * 查看电子发票
         */
        gotoInvoice() {
            Api.getInvoiceList(this.$route.query.orderId).then(({ data: { data }})=>{
                this.invoiceData=data||[]
            })  
        },
    }
}
</script>
<style lang="scss">
.order-invoice-detail{
    padding: 46px 8px 0 8px;
    font-size: .26rem;
    text-align: center;
    color: #666;
    table{
        margin-top: 0.2rem;
        tr{
            height: 0.6rem;
            th:first-child{
                width: 75%;
            }
            
        }
        tr.title{
            background: #f3f3f3;
        }
    }
    
}
</style>