<template>
    <app-template system="bi" @init="init">
        <div class="app-record-box" :style="[{'min-height':winHeight+'px'}]">
            <div class="search-bar-box">
                <form action="/">
                    <van-search v-model.trim="searchParams.keyWord" type="search" placeholder="请输入客户名称或编码" @search="search" @clear="search" />
                </form>
                <van-tabs v-model="active" @click="tabClick">
                    <van-tab>
                        <template slot="title">
                            <p>已提交</p>
                        </template>
                    </van-tab>
                    <!-- <van-tab>
                        <template slot="title"><p>草稿</p></template>
                    </van-tab> -->
                    <van-tab>
                        <template slot="title">
                            <p>已取消</p>
                        </template>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="record-list">
                <van-list v-model="loading" :finished="finished" finished-text="没有更多了" :immediate-check="false" @load="fetchList">
                    <div v-for="item in recordData" :key="item" class="record-li">
                        <div class="record-info-top">
                            <div class="record-info">
                                <div class="record-info-1">
                                    <img src="@/assets/images/bi/canhui-icon.png" style="width:20px;">
                                    <h3>{{ item.businessName }}</h3>
                                </div>
                                <div class="record-info-2">
                                    <p>{{ item.userCode }}</p>
                                    <span />
                                    <!-- <p>单体店</p>
                                    <span /> -->
                                    <p>{{ item.isNew===-1?'老':'新' }}金牌会员</p>
                                </div>
                            </div>
                        </div>
                        <div class="record-info-bottom">
                            <p><span />{{ item.name }}</p>
                            <p><span />参会嘉宾：{{ item.contactName }}</p>
                        </div>
                        <div v-if="active===0" class="record-btns">
                            <div @click="cancel(item)">
                                <van-icon name="close" />取消参会
                            </div>
                            <div @click="detail(item)">
                                <van-icon name="manager-o" />查看详情
                            </div>
                            <div @click="edit(item)">
                                <van-icon name="records" />修改信息
                            </div>
                        </div>
                        <!-- <div v-if="active===1" class="record-btns">
                            <div @click="del(item)"><van-icon name="delete" />删除</div>
                            <div @click="edit(item)"><van-icon name="records" />编辑</div>
                        </div> -->
                        <div v-if="active===1" class="record-btns record-btns-1">
                            <div @click="edit(item)">
                                <van-icon name="replay" />重新提交
                            </div>
                        </div>
                    </div>
                </van-list>
            </div>
        </div>
    </app-template>
</template>
<script>
import AppTemplate from '@/components/appTemplate/Index'
import Api from '@/api/bi/record'
import { Dialog, Toast } from 'vant';
import VMnative from '@/utils/VMnative'
export default {
    name: 'BiRecordList',
    components: {
        AppTemplate
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            finished: false,
            loading: false,
            active: 0,
            status: 0,
            searchParams: {
                current: 1,
                size: 10,
                keyWord: ''
            },
            recordData: []
        }
    },
    computed: {
        winHeight: function() {
            return this.$store.getters.winHeight
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "活动报名记录")
            this.goback()
        } else {
            this.$store.commit("setHasNavbar", true)
        }
    },
    activated() {
        VMnative.callHandler("setTitle", "活动报名记录")
        this.goback()
    },
    methods: {
        tabClick(v) {
            this.finished = false
            this.searchParams.current = 1
            this.recordData = []
            if (v === 0) {
                this.status = 0
                this.fetchList()
            } else if (v === 1) {
                this.status = -3
                this.fetchList()
            }
        },
        init() {
            this.fetchList()
        },
        search() {
            this.timeout = setTimeout(() => {
                this.searchParams.current = 1
                this.recordData = []
                this.finished = false
                this.fetchList()
            }, 500)
        },
        fetchList() {
            this.loading = true
            Api.fetchList(this.status, this.searchParams).then(({ data: { data }}) => {
                this.recordData = this.recordData.concat(data.records || [])
                this.loading = false
                if (this.searchParams.current >= data.pages) {
                    this.finished = true
                } else {
                    this.searchParams.current++
                }
            }).catch(() => {
                this.loading = false
                this.finished = true;
            })
        },
        cancel(item) {
            Dialog.confirm({
                title: '提示',
                className: 'edit-status',
                message: `是否取消${item.businessName}的报名信息？`,
                cancelButtonText: "再想想",
                cancelButtonColor: '#999999',
                confirmButtonText: '取消参会',
                confirmButtonColor: '#FFF'
            }).then(() => {
                Api.editStatus(item.sid, -3).then(res => {
                    if (res.data.code === 0) {
                        Toast.success({
                            message: '取消成功',
                            duration: 800,
                            onClose: () => {
                                this.searchParams.current = 1
                                this.recordData = []
                                this.finished = false
                                this.fetchList()
                            }
                        })
                    }
                })
            }).catch(() => {
                Dialog.close()
            });
        },
        del(item) {
            Dialog.confirm({
                title: '是否删除该草稿信息',
                className: 'edit-status',
                message: `删除后无法找回，请谨慎操作`,
                cancelButtonText: "再想想",
                cancelButtonColor: '#999999',
                confirmButtonText: '确定删除',
                confirmButtonColor: '#FFF'
            }).then(() => {
                Api.delStatus(item.sid).then(res => {
                    if (res.data.code === 0) {
                        Toast.success({
                            message: '删除成功',
                            duration: 800,
                            onClose: () => {
                                this.searchParams.current = 1
                                this.recordData = []
                                this.finished = false
                                this.fetchList()
                            }
                        })
                    }
                })
            }).catch(() => {
                Dialog.close()
            });
        },
        edit(item) {
            const path = this.isApp ? '/bi/signUpYLLT' : '/bi/signUpYLLT?source=h5'
            this.$router.push({
                path: path,
                query: { sid: item.sid }
            })
        },
        detail(item) {
            const path = this.isApp ? '/bi/signUpYLLT' : '/bi/signUpYLLT?source=h5'
            this.$router.push({
                path: path,
                query: { sid: item.sid,
                    edit: true
                
                }
            })
        },
        goback() {
            localStorage.setItem('isSign', this.$route.query.isSign * 1 === 1 ? 1 : 0)
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                if (localStorage.getItem('isSign') * 1 === 1) {
                    responseCallback('1')
                    this.$router.push('/bi/signUpYLLT');
                } else {
                    responseCallback('0')
                }
            });
        }
    }
}
</script>
<style lang="scss">
.app-record-box {
    position: relative;
    clear: both;
    background: #f2f2f2;
    .search-bar-box {
        position: fixed;
        z-index: 1;
        top: 0;
        width: 100%;
        .van-search {
            padding: 10px 15px;
        }
        .van-search__content {
            width: 100%;
            border-radius: 6px;
        }
        .van-tabs--line {
            padding-top: 0;
        }
        .van-tabs__line {
            width: 32px !important;
            height: 3px;
            background-color: #ff8947;
        }
        .van-tab__text {
            padding: 0px 0 9px 0;
            font-size: 16px;
            color: #999999;
        }
        .van-tabs__nav--line .van-tab--active .van-tab__text {
            color: #333333;
        }
    }
    .record-list {
        padding: 108px 10px 10px 10px;
        .record-li {
            margin-bottom: 10px;
            box-shadow: 0px 3px 12px rgba(50, 53, 55, 0.06);
            border-radius: 4px;
            background: #ffffff;
            .record-info-top {
                border-bottom: 1px solid #f2f2f2;
                .record-info {
                    padding: 20px 10px;
                    .record-info-1 {
                        display: flex;
                        align-items: center;
                        h3 {
                            font-size: 16px;
                            color: #333333;
                            margin-left: 8px;
                        }
                    }
                    .record-info-2 {
                        display: flex;
                        align-items: center;
                        margin-top: 16px;
                        p {
                            color: #666666;
                            font-size: 14px;
                            padding: 0 10px;
                            &:first-child {
                                padding: 0 10px 0 0;
                            }
                        }
                        span {
                            width: 1px;
                            height: 12px;
                            background: #e3e3e3;
                        }
                    }
                }
            }
            .record-info-bottom {
                padding: 18px 10px;
                p {
                    color: #333333;
                    font-size: 14px;
                    margin-bottom: 10px;
                    span {
                        display: inline-block;
                        width: 6px;
                        height: 6px;
                        background: #c4c4c4;
                        border-radius: 100%;
                        vertical-align: middle;
                        margin-right: 8px;
                    }
                }
            }
            .record-btns {
                width: 100%;
                background: #fafafa;
                height: 44px;
                display: flex;
                div {
                    display: inline-block;
                    width: 50%;
                    border-right: 1px solid #f2f2f2;
                    font-size: 14px;
                    color: #666666;
                    text-align: center;
                    line-height: 44px;
                    .van-icon {
                        margin-right: 8px;
                        vertical-align: middle;
                    }
                }
            }
            .record-btns-1 {
                div {
                    width: 100%;
                    border-right: none;
                }
            }
        }
    }
}
.edit-status {
    .van-dialog__confirm {
        background: #ff8947;
    }
}
</style>
