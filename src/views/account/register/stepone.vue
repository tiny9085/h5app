<template>
    <div class="app-register-first">
        <div class="top-div" />
        <div class="top-view">
            <van-cell-group title="基础信息填写">
                <van-field 
                    v-model="companyName"
                    label="公司名称"
                    placeholder="请输入公司名称"
                    input-align="right"
                    required
                />
                <van-field
                    v-model="legalPersonName"
                    label="法定代表人"
                    placeholder="请输入法人真实姓名"
                    input-align="right"
                    required
                />
                <van-field
                    v-model="phoneNumber"
                    label="手机号"
                    placeholder="请输入手机号"
                    input-align="right"
                    type="number"
                    required
                />
                <van-field
                    v-model="clubType"
                    label="销售部门"
                    placeholder="请选择销售部门"
                    disabled
                    right-icon="arrow"
                    input-align="right"
                    required
                    @click="clubBtnPressed"
                />
                <van-field
                    v-model="clubType"
                    label="所在地区"
                    placeholder="请选择省市区县、乡镇等"
                    disabled
                    right-icon="arrow"
                    input-align="right"
                    required
                    @click="addressBtnPressed"
                />
                <van-field
                    v-model="address"
                    label="详细地址"
                    type="textarea"
                    rows="1"
                    placeholder="请输入街道、楼牌号等"
                    input-align="right"
                    autosize
                    required
                />
                <van-popup v-model="showAreaPicker" position="bottom" :style="{ height: '40%' }">
                    <van-area
                        :area-list="areaList"
                        value="110101"
                        :columns-placeholder="['请选择', '请选择', '请选择']"
                        title="选择所在省市区"
                        @cancel="cancelFn"
                        @confirm="confirmFn"
                    />
                </van-popup>
                <van-popup
                    v-model="showClubPicker"
                    position="bottom"
                    custom-style="height: 20%;"
                    bind:close="onClose"
                ><van-picker show-toolbar :columns="clubTypeColumns" @change="onChange" /></van-popup>
            </van-cell-group>
        </div>
        <div class="top-view">
            <van-cell-group title="开票信息填写" />
            <div class="radio-style">
                <van-field
                    label="客户开票类别"
                    disabled
                    required
                ><van-radio-group slot="input" v-model="ticketType" bind:change="ticketChange" direction="horizontal">
                    <van-radio name="1">男</van-radio>
                    <van-radio name="2">女</van-radio>
                </van-radio-group></van-field>
            </div>
            <van-field
                v-model="tradeNo"
                label="纳税人识别号"
                placeholder="请输入纳税人识别号"
                input-align="right"
                required
            /> 
            <van-field
                v-model="invoiceName"
                label="发票抬头"
                placeholder="请输入会员名称"
                input-align="right"
                required
            /> 
            <van-field
                v-model="invoiceBankName"
                label="开户银行"
                placeholder="请输入开户银行"
                input-align="right"
                required
            /> 
            <van-field
                v-model="invoiceBankNo"
                label="账号"
                placeholder="请选择开户银行账号"
                input-align="right"
                required
            /> 
            <van-field
                v-model="invoiceBankNo"
                label="地址"
                disabled
                placeholder="请选择地址"
                input-align="right"
                required
            /> 
            <van-field
                v-model="invoicePhoneNumber"
                label="电话"
                placeholder="请输入电话号"
                input-align="right"
                required
            />
        </div>
        <div class="footer">
            <p :class="isOk ? '':'is-ok'" @click="updatePwd">确 定</p>
        </div>
    </div>
</template>

<script>
import { areaList } from '@vant/area-data';
export default {
    data() {
        return {
            areaList,
            clubTypeColumns: ['乐赛仙', '佐安堂', '初心', '国通'],
            showClubPicker: false,
            showAreaPicker: false,
            companyName: '',
            legalPersonName: '',
            phoneNumber: '',
            clubType: '',
            areaString: '',
            address: '',
            ticketType: '',
            tradeNo: '',
            invoiceName: '',
            invoiceBankName: '',
            invoiceBankNo: '',
            invoiceAddress: '',
            invoicePhoneNumber: ''
        }
    },
    methods: {
        clubBtnPressed(){
            this.showClubPicker = true
            console.log('1112233444')
        },
        addressBtnPressed(){
            this.showAreaPicker = true
        },
        ticketChange(event){
            this.ticketType = event.detail
        },
        updatePwd(){
            this.$router.push({
                path: "/account/stepthree"
            })
        }
    }
}
</script>

<style scoped lang="scss">
  .app-register-first{
    display: flex;
    background-color: #f1f1f1;
    flex-direction: column;
    width: 100%;
    height: 100vh;
    .top-view{
      margin: 14px;
      background-color: #ffffff;
      border-radius:8px;
      .radio-style{
        height: 50px; 
      }
    }
    .footer{
        padding: .28rem;
        border-top: .02rem solid #EEEEEE;
        background: #FFFFFF;
        p{
            height: .8rem;
            text-align: center;
            line-height: .8rem;
            color: #FFFFFF;
            font-weight: 600;
            background: #DDDDDD;
            border-radius: 20px;
            font-size: .28rem;
        }
        .is-ok{
            background: #FF4646;
        }
    }
    }
</style>
