<template>
    <div class="step-three">
        <div class="top-div" />
        <div class="tips">
            <span>!</span>
            <p>不同的会员类型会对应不同的资质要求，不同会员类型需必备的资质标准不同，我们会根据您所属的会员类型来提供您查看对应的资质要求，请根据您的所属的类型来进行资质信息上传。</p>
        </div>
        <div class="content-bg">
            <div class="content-title"><img src="@/assets/images/icon_register.png" class="left" alt="">资质信息填写</div>
            <van-cell-group class="cell-style">
                <van-field
                    label="会员类型"
                    placeholder="请选择会员类型"
                    disabled
                    right-icon="arrow"
                    input-align="right"
                    required
                    @click="newClubBtnPressed"
                />
                <van-popup
                    v-model="showPickerView"
                    position="bottom"
                    :style="{ height: '40%' }"
                    bind:close="onClose"
                >
                    <div class="popup-bg">
                        <img src="@/assets/images/popup_bg.png" alt="">
                        <div class="popup-title">选择会员类型</div>
                        <van-radio-group v-model="radio">
                            <van-radio name="1">
                                单选框 1
                                <template #icon="props">
                                    <img class="img-icon" :src="props.checked ? activeIcon : inactiveIcon">
                                </template>
                            </van-radio>
                            <van-radio name="2">
                                单选框 2
                                <template #icon="props">
                                    <img class="img-icon" :src="props.checked ? activeIcon : inactiveIcon">
                                </template>
                            </van-radio>
                        </van-radio-group>
                    </div>
                    
                </van-popup>
            </van-cell-group>
        </div>  
    </div>
</template>

<script>
export default {
    data() {
        return {
            showPickerView: false,
            radio: '1',
            activeIcon: '/assets/images/popup_select_yes.png',
            inactiveIcon: '/assets/images/popup_select_no.png'
        }
    },
    methods: {
        newClubBtnPressed(){
            this.showPickerView = true
        }
    }
}
</script>

<style lang="scss" scoped>
.step-three{
  background-color: #f3f4f6;
  padding-bottom: 0.10rem;
  .tips{
        display: flex;
        align-items: top;
        padding: .1rem .28rem;
        background: #FFF5E4;
        color: #FF6E00;
        span{
          margin-top: 0.10rem;
            width: .28rem;
            height: .28rem;
            text-align: center;
            line-height: .28rem;
            border-radius: 50%;
            border: .02rem solid #FF6E00;
        }
        p{
            flex: 1;
            margin-left: .2rem;
            line-height: .44rem;
        }
    }
    .popup-bg{
      img{
        height: 3rem;
        width: 100%;
      }
    }
    .popup-title{
      position: absolute;
      left: 0.28rem;
      top: 0.40rem;
    }
    .img-icon {
      height: 20px;
      }
    .content-bg{
      margin: 0.20rem;
      background-color: #ffffff;
      .content-title{
        color: #333333;
        font-size: .32rem;
        font-weight: 600;
        span{
            color: #ED3129;
            font-size: 0.42rem;
            margin-right:0.05rem;
            vertical-align: middle;   
        }
        .left{
          width: 0.32rem;
          height: 0.32rem;
          vertical-align:sub;
          margin-right:0.15rem;
          margin-left:0.28rem;
          margin-top:0.4rem;
        }
    }
    .cell-style{
      margin-top:0.52rem;
    }
    }
}
</style>
