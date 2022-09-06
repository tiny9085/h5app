<template>
    <ul class="app-goods-box">
        <li>
            <template v-for="(item, index) in goodsList">
                <product-card
                    v-if="index%2===0"
                    :key="index"
                    :item="pageName === 'promotion' ? item.promotionProduct[0]: item"
                    theme="newStyle"
                    :page-name="pageName"
                    :source="source"
                />
            </template>
        </li>
        <li>
            <template v-for="(item, index) in goodsList">
                <product-card
                    v-if="index%2===1"
                    :key="index"
                    :item="pageName === 'promotion' ? item.promotionProduct[0]: item"
                    theme="newStyle"
                    :page-name="pageName"
                    :source="source"
                />
            </template>
        </li>
    </ul>
</template>
<script>
import productCard from '@/components/productCard/index'
export default ({
    components: {
        productCard
    },
    props: {
        source: {
            type: String,
            default: 'h5'
        },
        goodsList: {
            type: Array,
            default: () => {
                return [];
            }
        }
    },
    data() {
        return {
            pageName: this.$route.name
        }
    }
})
</script>

<style lang="scss">
.app-goods-box{
    display: flex;
    li{
        flex: 1;
        &:nth-child(1){
            .new-product-card{
                margin-left: .2rem;
            }
        }
        &:nth-child(2){
            .new-product-card{
                margin-left: .1rem;
            }
        }
        
    }
}
</style>
