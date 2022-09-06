<template>
    <div class="setting-page-index">
        <div class="top-div" />
        <van-cell class="agreement" title="关于我们" is-link to="/personal/about?source=h5&title=关于我们" />
        <van-cell title="用户协议" is-link to="/account/service?source=h5" />
        <van-cell title="隐私协议" is-link to="/account/privacy?source=h5" />
        <van-cell title="账号信息" is-link to="/personal/storeInfo" />
        <van-cell title="修改密码" is-link to="/account/retrieve-pwd?title=修改密码" />
        <!-- <van-cell title="清理缓存" is-link>
            <p>共 54 MB</p>
        </van-cell> -->
        <van-cell title="最新版本" value="3.1.7" />
    </div>
</template>

<script>
export default {
    
}
</script>

<style lang="scss">
    .setting-page-index{
        background-color: #F1F1F1;
        .agreement{
            margin-top: 0.24rem;
        }
        .van-cell{
            padding: 0.2rem 0.22rem 0.24rem 0.4rem;
            height: 0.88rem;
            color: #666;
            font-size: 0.32rem;
            p{
                font-size: 0.29rem;
            }
        }
        .van-cell__value{
            font-size: 0.29rem;
            color: #999;
            margin-right: 0.18rem;
        }
        .van-cell:not(:last-child)::after{
            left:0;
            border-bottom: 1px solid #f1f1f1;
        }
    }
</style>
