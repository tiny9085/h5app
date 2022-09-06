<template>
    <div class="Page-personal-range personal-box" :style="[{'height':winHeight+'px'}]">
        <ul class="user-store-list">
            <li
                v-for="(item, index) in storeList"
                :key="item"
                class="store-item not-open"
            >
                <div class="store-name">
                    <p>{{ item.name }}</p>
                    <span v-if="item.isOpen" @click="openStore(false, index)">收起
                        <img src="@/assets/images/close_icon.png">
                    </span>
                    <span v-else @click="openStore(true, index)">展开
                        <img src="@/assets/images/open_icon.png">
                    </span>
                </div>
                <template v-if="item.isOpen">
                    <div class="range-item">
                        <img src="@/assets/images/opened_range_icon.png" class="left" alt="">
                        <div class="right">
                            <p>已开启经营范围</p>
                            <div class="range-content">{{ !item.scope ? '暂无已开启的经营范围' : item.scope }}</div>
                        </div>
                    </div>
                    <div class="range-item">
                        <img src="@/assets/images/close_range_icon.png" class="left" alt="">
                        <div class="right">
                            <p>未开启经营范围</p>
                            <div class="range-content">{{ !item.unHaveScopeStr ? '暂无未开启的经营范围' : item.unHaveScopeStr }}</div>
                        </div>
                    </div>
                </template>
            </li>
        </ul>
    </div>
</template>
<script>
export default {
    data(){
        return {
            
        }
    },
    computed: {
        winHeight() {
            return this.$store.getters.winHeight
        },
        storeList() {
            const data = this.$store.getters.businessScope ? this.$store.getters.businessScope.userInfoScope : [];
            data.forEach((v, i) => {
                this.$set(v, 'isOpen', false);
                if (i === 0) this.$set(v, 'isOpen', true);
            });
            return data;
        }
    },
    methods: {
        openStore(isOpen, index) {
            this.storeList[index].isOpen = isOpen;
        }
    }
}
</script>
<style lang="scss">
%imgWidth{
    width: .32rem;
    height: .32rem;
}
.Page-personal-range{
    background: #F1F1F1;
    overflow-y: auto;
    .user-store-list{
        .store-item:last-child{
            margin-bottom: 1.3rem;
            .person-list{
                margin-bottom: 40px;
            }
        }
        .store-item{
            border-radius: .1rem;
            background: #FFFFFF;
            margin: .24rem .16rem 0 .16rem;
            padding: .28rem;
            .store-name{
                color: #333333;
                font-size: .29rem;
                font-weight: 600;
                display: flex;
                p{
                    flex: 1;
                }
                span{
                    color: #bbbbbb;
                    font-size: .24rem;
                    line-height: .24rem;
                    font-weight: 400;
                    padding-left: .2rem;
                    img{
                        @extend %imgWidth;
                        vertical-align: sub;
                    }
                }
            }
            .range-item{
                margin-top: .28rem;
                display: flex;
                .left{
                    width: .56rem;
                    height: .56rem;
                    margin-right: .2rem;
                    margin-top: .28rem;
                }
                .right{
                    font-size: .28rem;
                    padding-top: .28rem;
                    line-height: .4rem;
                    border-top: .02rem solid #F4F4F4;
                    .range-content{
                        margin-top: .12rem;
                        color: #999999;
                    }
                }
            }
            .range-item:nth-child(2){
                .right{
                    border-top: none;
                    padding-top: 0;
                }
                .left{
                    margin-top: 0;
                }
            }
        }
        .not-open{
            padding: .24rem;
            margin-bottom: 0.24rem;
            .overdue-reminder{
                border-bottom: none;
            }
        }
    }
}
</style>
