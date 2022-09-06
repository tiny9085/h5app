<template>
    <app-template style="background:#F2F2F2" system="bi" @init="init">
        <div v-if="!isApp" class="personal-box" />
        <div class="sign-up-yllt">
            <div class="area-info">
                <template v-if="!$route.query.sid">
                    <p class="select-area" @click="showArea=true">
                        <span>{{ specialObj.name }}</span>
                        <img class="down-arrow" src="@/assets/images/down-arrow.png" alt="">
                    </p>
                </template>
                <template v-else>
                    <p class="select-area">
                        <span>{{ specialObj.name }}</span>
                    </p>
                </template>           
                <p class="adress-detail">
                    <img class="gps-icon" src="@/assets/images/gps-icon.png" alt="">
                    {{ specialObj.meetingAddress }}
                </p>
                <p class="join-date">
                    <img class="date-icon" src="@/assets/images/date-icon.png" alt="">
                    {{ specialObj.meetingStartTime }} 至 {{ specialObj.meetingEndTime }}
                </p>
            </div>
            <div class="join-info">
                <van-form ref="myForm" :show-error-message="false" @submit="submit" @failed="failed">
                    <div class="select-user">
                        <p class="sign-up-time">报名时间：{{ specialObj.signUpStartTime }} 至 {{ specialObj.signUpEndTime }}</p>
                        <van-field
                            v-model="userName"
                            required
                            :rules="[{ required: true, message: '请选择报名客户' }]"
                            label="报名客户"
                            class="input-radio"
                        >
                            <template #input>
                                <div @click="openMemberDialog">
                                    {{ userName || '请选择' }}
                                    <van-icon name="arrow" />
                                </div>
                            </template>
                        </van-field>
                        <van-field
                            required
                            label="是否到现场参会"
                            class="input-radio"
                            style="border:none;"
                        >
                            <template #input>
                                <van-radio-group
                                    v-model="form.isMeeting"
                                    direction="horizontal"
                                    checked-color="#FF8947"
                                    :disabled="edit"
                                >
                                    <van-radio :name="1">是</van-radio>
                                    <van-radio :name="-1">否</van-radio>
                                </van-radio-group>
                            </template>
                        </van-field>
                        <van-field
                            v-if="form.isMeeting === 1"
                            required
                            label="是否到过公司"
                            class="input-radio"
                            style="border:none;"
                        >
                            <template #input>
                                <van-radio-group
                                    v-model="form.isFirst"
                                    direction="horizontal"
                                    checked-color="#FF8947"
                                    :disabled="edit"
                                >
                                    <van-radio :name="1">是</van-radio>
                                    <van-radio :name="-1">否</van-radio>
                                </van-radio-group>
                            </template>
                        </van-field>
                    </div>
                    <div v-for="(item, ind) in form.contactList" :key="ind" class="user-info">
                        <p class="sub-title">
                            <img class="join-user-icon" src="@/assets/images/join-user-icon.png" alt="">
                            <span class="flex">{{ ind === 0 ? '参会嘉宾信息一' : '参会嘉宾信息二' }}</span>
                            <img
                                v-if="ind === 1"
                                class="delete-join-user"
                                src="@/assets/images/delete-join-user.png"
                                alt=""
                                @click="removeUser"
                            >
                        </p>
                        <van-field
                            v-model="item.name"
                            required
                            :rules="[{ required: true, message: '请输入参会嘉宾姓名' }]"
                            label="姓名"
                            placeholder="请输入参会嘉宾姓名"
                            :disabled="edit"
                        />
                        <van-field
                            required
                            label="性别"
                            class="input-radio row"
                            :rules="[{ required: true, message: '请选择嘉宾性别' }]"
                        >
                            <template #input>
                                <van-radio-group
                                    v-model="item.sex"
                                    direction="horizontal"
                                    checked-color="#FF8947"
                                    :disabled="edit"
                                    @change="item.isErrorSex=false"
                                >
                                    <van-radio :name="1">男</van-radio>
                                    <van-radio :name="2">女</van-radio>
                                </van-radio-group>
                                <div v-if="item.isErrorSex" class="error-message">请选择嘉宾性别</div>
                            </template>
                        </van-field>
                        <van-field
                            v-model="item.levelName"
                            required
                            :rules="[{ required: true, message: '请选择对接人职务' }]"
                            label="职务"
                            class="select-user input-radio"
                        >
                            <template #input>
                                <div @click="openRoleDialog(ind)">
                                    {{ item.levelName || '请选择对接人职务' }}
                                    <van-icon name="arrow" />
                                </div>
                            </template>
                        </van-field>
                        <van-field
                            v-if="item.level - 0===4"
                            v-model="item.otherLevelName"
                            required
                            :rules="[{ required: true, message: '请输入其他职务信息' }]"
                            label="其他职务信息"
                            class="select-user input-radio"
                            placeholder="请输入其他职务信息"
                            :disabled="edit"
                        />
                        <van-field
                            v-model="item.phone"
                            required
                            :rules="[{ validator: validatorMobile, message: '请输入11位手机号' }]"
                            label="手机号"
                            style="border:none;"
                            placeholder="请输入11位手机号"
                            :disabled="edit"
                        />
                        <van-field
                            v-if="isChina === 0"
                            v-model="item.chinaSize"
                            required
                            :rules="[{ required: true, message: '请选择汉服尺码' }]"
                            label="汉服尺码"
                            class="select-user input-radio"
                        >
                            <template #input>
                                <div @click="openSizeDialog(ind)">
                                    {{ item.chinaSize || '请选择汉服尺码' }}
                                    <van-icon name="arrow" />
                                </div>
                            </template>
                        </van-field>
                    </div>
                    <div
                        v-if="form.contactList.length < 2 && !edit"
                        class="add-user-btn"
                        @click="addUser"
                    >添加参会嘉宾(最多添加一位)</div>

                    <template v-if="form.isMeeting === 1">
                        <div v-for="(item, ind) in form.vehicleList" :key="ind" class="user-info">
                            <p class="sub-title">
                                <img class="join-user-icon" src="@/assets/images/icon-aircraft.png" alt="">
                                {{ ind === 0 ? '参会交通信息' : '返程交通信息' }}
                            </p>
                            <van-field
                                v-model="item.vehicleLabel"
                                required
                                :rules="[{ required: true, message: '请选择交通工具' }]"
                                label="交通工具"
                                class="select-user input-radio"
                            >
                                <template #input>
                                    <div @click="openVehicleDialog(ind)">
                                        {{ item.vehicleLabel || '请选择' }}
                                        <van-icon name="arrow" />
                                    </div>
                                </template>
                            </van-field>
                            <van-field
                                v-if="item.vehicleType - 0 === 1"
                                v-model="item.info"
                                required
                                :rules="[{ required: true, message: '请输入车次信息' }]"
                                label="火车车次"
                                placeholder="请输入车次信息"
                                :disabled="edit"
                            />
                            <van-field
                                v-if="item.vehicleType-0 === 2"
                                v-model="item.info"
                                required
                                :rules="[{ required: true, message: '请输入大巴信息' }]"
                                label="汽车/大巴信息"
                                placeholder="请输入大巴信息"
                                :disabled="edit"
                            />
                            <van-field
                                v-if="item.vehicleType-0 === 3"
                                v-model="item.info"
                                required
                                :rules="[{ validator: validatorLicense, message: '请输入正确的车牌号码' }]"
                                label="车牌号码"
                                placeholder="请输入车牌号码"
                                :disabled="edit"
                            >
                                <template #right-icon>
                                    <LicenseKeyboard
                                        v-model="item.info"
                                        title="快捷键盘"
                                        :is-mobile="true"
                                        font-size=".28rem"
                                    />
                                </template>
                            </van-field>

                            <van-field
                                v-if="item.vehicleType-0 === 4"
                                v-model="item.info"
                                required
                                :rules="[{ required: true, message: '请输入航班信息' }]"
                                label="航班信息"
                                placeholder="请输入航班信息"
                                :disabled="edit"
                            />
                            <van-field
                                v-if="item.vehicleType-0 === 4"
                                v-model="item.address"
                                required
                                :rules="[{ required: true, message: '请输入抵达航站楼' }]"
                                label="抵达航站楼"
                                placeholder="请输入抵达航站楼"
                                :disabled="edit"
                            />
                            <van-field
                                v-if="item.vehicleType-0 === 5"
                                v-model="item.info"
                                required
                                :rules="[{ required: true, message: '请输入车次信息' }]"
                                label="高铁车次"
                                placeholder="请输入车次信息"
                                :disabled="edit"
                            />
                            <van-field
                                v-if="[5, 1].indexOf(item.vehicleType-0)>-1"
                                v-model="item.address"
                                required
                                :rules="[{ required: true, message: '请输入抵达车站' }]"
                                label="抵达车站"
                                placeholder="请输入抵达车站"
                                :disabled="edit"
                            />
                            <van-field
                                v-model="item.detailedDate"
                                required
                                :rules="[{ required: true, message: '请选择时间' }]"
                                :label="ind === 0 ? '到达时间' : '返程时间'"
                                class="select-user input-radio"
                            >
                                <template #input>
                                    <div @click="openDateDialog(ind)">
                                        {{ item.detailedDate || '请选择' }}
                                        <van-icon name="arrow" />
                                    </div>
                                </template>
                            </van-field>
                            <van-field
                                v-if="ind === 0"
                                required
                                :rules="[{ required: true, message: '请选择是否住宿' }]"
                                label="是否住宿"
                                class="input-radio row"
                                style="border:none;"
                            >
                                <template #input>
                                    <van-radio-group
                                        v-model="item.isNeedStay"
                                        direction="horizontal"
                                        checked-color="#FF8947"
                                        :disabled="edit"
                                        @change="item.isErrorNeedStay=false"
                                    >
                                        <van-radio :name="1">是</van-radio>
                                        <van-radio :name="-1">否</van-radio>
                                    </van-radio-group>
                                    <div v-if="item.isErrorNeedStay" class="error-message">请选择是否住宿</div>
                                </template>
                            </van-field>
                        </div>
                    </template>
                    <div class="user-info" :style="{'margin-bottom':edit?'0.24rem':''}">
                        <p class="sub-title">
                            <img class="join-user-icon" src="@/assets/images/user-remark.png" alt="">
                            备注信息
                        </p>
                        <div class="remark" style="border:none;">
                            <van-field
                                v-model="form.remark"
                                rows="3"
                                autosize
                                type="textarea"
                                maxlength="500"
                                placeholder="请输入备注信息"
                                :disabled="edit"
                            />
                        </div>
                    </div>
                </van-form>
            </div>
            <div v-if="!edit" class="bottom-bar">
                <!-- <van-button :disabled="loading" class="draft" @click="save(-1)">存草稿</van-button> -->
                <van-button :disabled="loading" class="submit" @click="save(0)">提 交</van-button>
            </div>
            <div v-if="edit && !$route.query.sid" class="fixedBtn">
                <van-button class="btn" @click="edit=false">修 改</van-button>
            </div>
        </div>
        <!-- 选择报名客户 -->
        <van-action-sheet
            v-model="showMember"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <div slot="title" class="sheet-text">
                    <div class="top">
                        <span>请选择报名客户</span>
                        <img src="@/assets/images/close-sheet.png" alt="" @click="showMember = false">
                    </div>
                    <div class="bottom">
                        <input v-model="businessName" type="text" placeholder="搜索客户名称" @input="emptySearch">
                        <span class="search-btn" @click="getAllUser">搜索</span>
                    </div>
                </div>
                <van-radio-group
                    v-model="form.userInfoSid"
                    class="member-list"
                    style="height:6.14rem"
                    checked-color="#FF8947"
                >
                    <van-radio
                        v-for="(item, ind) in memberList"
                        :key="ind"
                        :name="item.userInfoSid"
                        :class="{'checked-member': form.userInfoSid === item.userInfoSid}"
                    >{{ item.name }}
                        <span style="color: #ff8947;">
                            ({{ item.userCode }})
                        </span>
                    </van-radio>
                </van-radio-group>
                <div class="comfirm-btn" @click="submitMember">确定</div>
            </div>
        </van-action-sheet>
        <!-- 选择职业 -->
        <van-action-sheet
            v-model="showOccupation"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <div slot="title" class="sheet-text">
                    <div class="top">
                        <span>请选择职务</span>
                        <img src="@/assets/images/close-sheet.png" alt="" @click="showOccupation = false">
                    </div>
                </div>
                <div class="select-content">
                    <ul class="select-list">
                        <div
                            v-for="(item, ind) in roleLevelList"
                            :key="ind"
                            class="dv"
                            :style="{'padding-right': ind%3 === 2 ? 0 : ''}"
                        >
                            <li
                                :class="{'active': form.contactList[contactIndex].level-0===item.value-0}"
                                @click="selectRoleLevel(item)"
                            >{{ item.label }}
                            </li>
                        </div>
                    </ul>
                    <div class="comfirm-btn" @click="submitOccupation">确定</div>
                </div>
            </div>
        </van-action-sheet>
        <!-- 选择交通工具 -->
        <van-action-sheet
            v-model="showVehicle"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <div slot="title" class="sheet-text">
                    <div class="top">
                        <span>请选择交通工具</span>
                        <img src="@/assets/images/close-sheet.png" alt="" @click="showVehicle = false">
                    </div>
                </div>
                <div class="select-content">
                    <ul class="select-list">
                        <div
                            v-for="(item, ind) in vehicleList"
                            :key="ind"
                            class="dv"
                            :style="{'padding-right': ind%3 === 2 ? 0 : ''}"
                        >
                            <li
                                :class="{'active': form.vehicleList[vehicleIndex].vehicleType-0===item.value-0}"
                                @click="selectVeicle(item)"
                            >{{ item.label }}</li>
                        </div>
                    </ul>
                    <div class="comfirm-btn" @click="submitVehicle">确定</div>
                </div>
            </div>
        </van-action-sheet>
        <!-- 地点 -->
        <van-action-sheet
            v-model="showArea"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <div slot="title" class="sheet-text">
                    <div class="top">
                        <span>请选择报名地点</span>
                        <img src="@/assets/images/close-sheet.png" alt="" @click="showArea = false">
                    </div>
                    <!-- <div class="bottom">
                        <input v-model="areaName" type="text" placeholder="搜索报名地点">
                        <img src="@/assets/images/icon-search-user.png" alt="">
                    </div> -->
                </div>
                <van-radio-group v-model="form.activitySid" class="member-list" checked-color="#FF8947">
                    <van-radio
                        v-for="(item, ind) in specialList"
                        :key="ind"
                        :name="item.sid"
                        :class="{'checked-member': form.activitySid === item.sid}"
                    >{{ item.name }}</van-radio>
                </van-radio-group>
                <div class="comfirm-btn" @click="submitArea">确定</div>
            </div>
        </van-action-sheet>

        <!-- 选择时间 -->
        <van-action-sheet
            v-model="showDate"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <van-datetime-picker
                    v-model="dateTime"
                    type="datetime"
                    :min-date="minDate"
                    :max-date="maxDate"
                    title="选择时间"
                    @confirm="submitDate"
                    @cancel="showDate=false"
                />
            </div>
        </van-action-sheet>
        <!-- 选择尺码 -->
        <van-action-sheet
            v-model="showSize"
            :round="false"
            :close-on-click-overlay="false"
            class="select-member-sheet"
            close-on-click-action
        >
            <div slot="default">
                <div slot="title" class="sheet-text">
                    <div class="top">
                        <span>请选择汉服尺码</span>
                        <img src="@/assets/images/close-sheet.png" alt="" @click="showSize = false">
                    </div>
                </div>
                <div class="select-content">
                    <ul class="select-list">
                        <div
                            v-for="(item, ind) in dressSizeList"
                            :key="ind"
                            class="dv"
                            :style="{'padding-right': ind%3 === 2 ? 0 : ''}"
                        >
                            <li
                                :class="{'active': form.contactList[sizeIndex].chinaSizeId-0===item.value-0}"
                                @click="selectDressSize(item)"
                            >{{ item.label }}
                            </li>
                        </div>
                    </ul>
                    <div class="comfirm-btn" @click="submitSize">确定</div>
                </div>
            </div>
        </van-action-sheet>
    </app-template>
</template>
<script>
import AppTemplate from '@/components/appTemplate/Index'
import VMnative from '@/utils/VMnative'
import Api from '@/api/bi/signUpYLLT'
import { Dialog, Toast } from 'vant'
import moment from 'moment'
import regex from '@/utils/regex';
import LicenseKeyboard from './licenseKeyboard';
import { GetQueryString } from '@/utils/util'

export default {
    name: 'AccountService',
    components: {
        AppTemplate,
        LicenseKeyboard
    },
    data() {
        return {
            isApp: this.$route.query.source !== 'h5',
            regex: regex,
            loading: false,
            userName: '',
            showMember: false,
            showDate: false,
            showVehicle: false,
            showOccupation: false,
            showArea: false,
            showSize: false,
            dateTime: new Date(),
            minDate: new Date(),
            maxDate: new Date(2100, 0, 0),
            form: {
                isMeeting: 1,
                isFirst: 1,
                sid: '',
                activitySid: '',
                userInfoSid: '',
                status: '',
                remark: '',
                vehicleList: [{
                    type: 1,
                    vehicleType: '',
                    vehicleLabel: '',
                    info: '',
                    address: '',
                    isNeedStay: '',
                    isErrorNeedStay: false,
                    detailedDate: ''
                }, {
                    type: -1,
                    vehicleType: '',
                    vehicleLabel: '',
                    info: '',
                    address: '',
                    isNeedStay: '',
                    isErrorNeedStay: false,
                    detailedDate: ''
                }],
                contactList: [{
                    sex: '',
                    isErrorSex: false,
                    name: '',
                    phone: '',
                    level: '',
                    levelName: '',
                    otherLevelName: '',
                    chinaSizeId: '',
                    chinaSize: ''
                }]
            },
            contactIndex: 0,
            vehicleIndex: 0,
            sizeIndex: 0,
            specialList: [],
            specialObj: {},
            memberList: [],
            vehicleList: [],
            roleLevelList: [],
            dressSizeList: [],
            businessName: '',
            userCode: '',
            isChina: '',
            edit: false,
            clubId: ''
        }
    },
    created() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "活动报名")
            this.goback()
            this.getYLLTApply()
        } else {
            this.$store.commit("setHasNavbar", true)
        }
        if (GetQueryString("isFromJYGW") === 'wx'){
            this.$store.commit('setCartRightText', '切换俱乐部');
        }
    },
    activated() {
        if (this.isApp) {
            this.$store.commit("setHasNavbar", false)
            VMnative.callHandler("setTitle", "活动报名")
            this.goback()
            this.getYLLTApply()
        } else {
            this.$store.commit("setHasNavbar", true)
        }
        if (GetQueryString("isFromJYGW") === 'wx'){
            this.$store.commit('setCartRightText', '切换俱乐部');
        }
    },
    methods: {
        goback() {
            VMnative.registerHandler('goBack', (data, responseCallback) => {
                if (this.$route.query.comefrom || !this.$route.query.sid) {
                    responseCallback('0')
                } else {
                    responseCallback('1')
                    this.$router.push({
                        path: '/bi/record',
                        query: {
                            isSign: localStorage.getItem('isSign') * 1 === 1 ? 1 : 0
                        }
                    })
                }
            });
        },
        getYLLTApply(){
            VMnative.registerHandler('getYLLTApply', (data, responseCallback) => {
                const item = {
                    // addressUrl: 'http://m-dev.b2b.hcyy.top/#/account/login?isFromJYGW=wx'
                    // addressUrl: 'http://m-qa.b2b.hcyy.top/#/account/login?isFromJYGW=wx'
                    // addressUrl: 'http://192.168.15.21:8088/#/account/login?isFromJYGW=wx'
                    addressUrl: 'https://m.hnhcyy.com/#/account/login?isFromJYGW=wx'
                }
                responseCallback(item)
            });
        },
        // 车牌校验
        validatorLicense(val) {
            val = val.trim().toUpperCase(); // 字母转换为大写
            // if (val !== '') return this.regex.licensePlate.test(val);
            return this.regex.licensePlate.test(val);
        },
        // 手机号码校验
        validatorMobile(val) {
            val = val.replace(/\s+/g, ''); // 去除所有空格
            return this.regex.mobile.test(val);
        },
        async init() {
            await this.getDictVehicle();
            await this.getDictRoleLevel();
            await this.getDictDressSize();
            var isFromJYGW = GetQueryString("isFromJYGW");
            if (isFromJYGW === 'wx'){
                await this.getMemberSpecialList();
                await this.getMemberDetail();
                this.userName = JSON.parse(localStorage.getItem('userInfo')).name;
                this.form.userInfoSid = JSON.parse(localStorage.getItem('userInfo')).sid;
            } else {
                if (this.$route.query.sid) await this.getDetail();
                await this.getSpecialList();
            }
        },
        getMemberDetail(){
            Api.viewMemberDetail({
                sid: this.form.activitySid
            }).then(res => {
                if (res.data.code === 1){
                    Dialog.confirm({
                        title: '提示',
                        message: res.data.msg,
                        asyncClose: true,
                        cancelButtonText: "再想想",
                        confirmButtonText: "我知道了",
                        cancelButtonColor: '#999999',
                        confirmButtonColor: '#FFF',
                        className: 'mergBtn',
                        showCancelButton: false
                    }).then(() => {
                        this.$router.push('/account/login?isFromJYGW=wx')
                    }).catch(() => {
                        Dialog.close();
                    });
                } else {
                    Dialog.close();
                    const data = res.data.data
                    if (!data){
                        this.contactIndex = 0;
                        this.sizeIndex = 0;
                        this.form.contactList.splice(1, 1);
                        for (const key in this.form) {
                            if (key === 'contactList') {
                                this.form[key] = [{
                                    sex: '',
                                    isErrorSex: false,
                                    name: '',
                                    phone: '',
                                    level: '',
                                    levelName: '',
                                    otherLevelName: '',
                                    chinaSizeId: '',
                                    chinaSize: ''
                                }];
                            } else if (key === 'vehicleList') {
                                this.form[key] = [{
                                    type: 1,
                                    vehicleType: '',
                                    vehicleLabel: '',
                                    info: '',
                                    address: '',
                                    isNeedStay: '',
                                    isErrorNeedStay: false,
                                    detailedDate: ''
                                }, {
                                    type: -1,
                                    vehicleType: '',
                                    vehicleLabel: '',
                                    info: '',
                                    address: '',
                                    isNeedStay: '',
                                    isErrorNeedStay: false,
                                    detailedDate: ''
                                }];
                            }
                        }
                        this.form.remark = ''
                        this.edit = false;
                    } else {
                        for (const key in this.form) {
                            if (key === 'contactList') {
                                this.form[key] = data[key] || [{
                                    sex: '',
                                    isErrorSex: false,
                                    name: '',
                                    phone: '',
                                    level: '',
                                    levelName: '',
                                    otherLevelName: '',
                                    chinaSizeId: '',
                                    chinaSize: ''
                                }];
                            } else if (key === 'vehicleList') {
                                this.form[key] = data[key] || [{
                                    type: 1,
                                    vehicleType: '',
                                    vehicleLabel: '',
                                    info: '',
                                    address: '',
                                    isNeedStay: '',
                                    isErrorNeedStay: false,
                                    detailedDate: ''
                                }, {
                                    type: -1,
                                    vehicleType: '',
                                    vehicleLabel: '',
                                    info: '',
                                    address: '',
                                    isNeedStay: '',
                                    isErrorNeedStay: false,
                                    detailedDate: ''
                                }];
                            } else {
                                this.form[key] = data[key];
                            }
                        }
                        this.form.contactList.forEach(v => {
                            if (v.level - 0 === 4) v.otherLevelName = v.levelName;
                        })
                        this.form.vehicleList.forEach(v => {
                            const obj = this.vehicleList.filter(item => item.value - 0 === v.vehicleType - 0)[0] || {};
                            v.vehicleLabel = obj.label;
                        })
                        this.edit = true;
                    }
                }
            }).catch(() => {

            })
        },
        // 获取报名详情
        getDetail() {
            return new Promise((resolve, reject) => {
                this.form.sid = this.$route.query.sid;
                this.edit = this.$route.query.edit;
                Api.viewSignUpDetails(this.$route.query.sid).then(({ data: { data }}) => {
                    for (const key in this.form) {
                        if (key === 'contactList') {
                            this.form[key] = data[key] || [{
                                sex: '',
                                isErrorSex: false,
                                name: '',
                                phone: '',
                                level: '',
                                levelName: '',
                                otherLevelName: '',
                                chinaSizeId: '',
                                chinaSize: ''
                            }];
                        } else if (key === 'vehicleList') {
                            this.form[key] = data[key] || [{
                                type: 1,
                                vehicleType: '',
                                vehicleLabel: '',
                                info: '',
                                address: '',
                                isNeedStay: '',
                                isErrorNeedStay: false,
                                detailedDate: ''
                            }, {
                                type: -1,
                                vehicleType: '',
                                vehicleLabel: '',
                                info: '',
                                address: '',
                                isNeedStay: '',
                                isErrorNeedStay: false,
                                detailedDate: ''
                            }];
                        } else {
                            this.form[key] = data[key];
                        }
                    }
                    this.form.contactList.forEach(v => {
                        if (v.level - 0 === 4) v.otherLevelName = v.levelName;
                    })
                    this.form.vehicleList.forEach(v => {
                        const obj = this.vehicleList.filter(item => item.value - 0 === v.vehicleType - 0)[0] || {};
                        v.vehicleLabel = obj.label;
                    })
                    this.userName = data.businessName || '';
                    resolve();
                // this.businessName = data.businessName;
                }).catch(() => {
                    reject();
                })
            })
        },
        // 确定会员
        submitMember() {
            const userObj = this.memberList.filter(item => item.userInfoSid === this.form.userInfoSid)[0] || {};
            if (userObj.userInfoSid) {
                this.userName = userObj.name;
                this.showMember = false;
            }
        },
        // 确定地点
        submitArea() {
            this.specialObj = this.specialList.filter(item => item.sid === this.form.activitySid)[0] || {}
            this.isChina = this.specialObj.isChina
            this.showArea = false;
            this.clubId = this.specialObj.club;
            if (GetQueryString("isFromJYGW") === 'wx'){    
                this.getMemberDetail()
            } else {
                this.businessName = ''
                this.userName = ''
                this.form.userInfoSid = ''
                this.memberList = []
                this.getAllUser()
            }
        },
        // 删除嘉宾
        removeUser() {
            Dialog.confirm({
                title: '是否删除该参会嘉宾？',
                message: '删除后无法找回，请谨慎操作',
                asyncClose: true,
                cancelButtonText: "再想想",
                confirmButtonText: "确定删除",
                cancelButtonColor: '#999999',
                confirmButtonColor: '#FFF',
                className: 'mergBtn'
            }).then(() => {
                this.contactIndex = 0;
                this.sizeIndex = 0;
                this.form.contactList.splice(1, 1);
            }).catch(() => {
                Dialog.close();
            });
        },
        // 获取专项活动
        getSpecialList() {
            Api.signUpActivity().then(({ data: { data }}) => {
                this.specialList = data || [];
                if (this.form.activitySid) {// 编辑回显
                    this.specialObj = data.filter(item => item.sid === this.form.activitySid)[0] || {};
                    this.isChina = this.specialObj.isChina
                    this.clubId = this.specialObj.club
                } else {
                    this.specialObj = data[0] || {};
                    this.form.activitySid = this.specialObj.sid;
                    this.isChina = this.specialList[0].isChina
                    this.clubId = this.specialList[0].club
                }
                this.getAllUser()
            })
        },
        getMemberSpecialList() {
            return new Promise((resolve, reject) => {
                Api.signUpActivity().then(({ data: { data }}) => {
                    this.specialList = data || [];
                    if (this.form.activitySid) {// 编辑回显
                        this.specialObj = data.filter(item => item.sid === this.form.activitySid)[0] || {};
                        this.isChina = this.specialObj.isChina
                    } else {
                        this.specialObj = data[0] || {};
                        this.form.activitySid = this.specialObj.sid;
                        this.isChina = this.specialList[0].isChina
                    }
                    resolve();
                }).catch(() => {
                    this.loading = true
                    reject();
                })
            })
        },
        // 获取会员
        getAllUser() {
            Api.getMemberPage({
                status: 0,
                current: 1,
                size: 20,
                businessName: this.businessName.trim(),
                club: this.clubId
            }).then(({ data: { data }}) => {
                this.memberList = data.records || [];
            })
        },
        // 添加嘉宾
        addUser() {
            this.form.contactList.push({
                sex: '',
                isErrorSex: false,
                name: '',
                phone: '',
                level: '',
                levelName: '',
                otherLevelName: '',
                chinaSizeId: '',
                chinaSize: ''
            })
        },
        // 获取交通工具列表
        getDictVehicle() {
            Api.getDict('vehicle_type').then(({ data: { data }}) => {
                this.vehicleList = data;
            })
        },
        // 打开交通工具弹窗
        openVehicleDialog(index) {
            this.vehicleIndex = index
            !this.edit ? this.showVehicle = true : '';
        },
        // 选择参会交通工具
        selectVeicle(item) {
            this.form.vehicleList[this.vehicleIndex].vehicleType = item.value;
        },
        // 确定交通工具
        submitVehicle() {
            const vehicle = this.form.vehicleList[this.vehicleIndex].vehicleType;
            const vehicleObj = this.vehicleList.filter(item => item.value === vehicle)[0] || {};
            if (vehicleObj.hasOwnProperty('value')) {
                if (this.form.vehicleList[this.vehicleIndex].vehicleLabel !== vehicleObj.label) {
                    this.form.vehicleList[this.vehicleIndex].info = '';
                    this.form.vehicleList[this.vehicleIndex].address = '';
                }
                this.form.vehicleList[this.vehicleIndex].vehicleType = vehicleObj.value;
                this.form.vehicleList[this.vehicleIndex].vehicleLabel = vehicleObj.label;
                this.showVehicle = false;
            }
        },
        // 获取职务
        getDictRoleLevel() {
            Api.getDict('role_level').then(({ data: { data }}) => {
                this.roleLevelList = data;
            })
        },
        // 打开选择职位弹窗
        openRoleDialog(index) {
            this.contactIndex = index;
            !this.edit ? this.showOccupation = true : '';
        },
        // 选择职务
        selectRoleLevel(item) {
            this.form.contactList[this.contactIndex].level = item.value;
        },
        // 确定职务
        submitOccupation() {
            const level = this.form.contactList[this.contactIndex].level;
            const roleLevelObj = this.roleLevelList.filter(item => item.value === level)[0] || {};
            if (roleLevelObj.hasOwnProperty('value')) {
                this.form.contactList[this.contactIndex].level = roleLevelObj.value;
                this.form.contactList[this.contactIndex].levelName = roleLevelObj.label;
                this.showOccupation = false;
            }
        },
        // 打开时间弹窗
        openDateDialog(ind) {
            this.vehicleIndex = ind;
            const detailedDate = this.form.vehicleList[ind].detailedDate;
            this.dateTime = detailedDate ? new Date(detailedDate.split('-').join('/')) : new Date();
            !this.edit ? this.showDate = true : "";
            if (!this.form.vehicleList[0].detailedDate || !this.form.vehicleList[1].detailedDate){
                this.minDate = new Date();
                this.maxDate = new Date(2100, 0, 0);
            }
            // if (ind === 1) {
            //     if (this.form.vehicleList[0].detailedDate) {
            //         const date = this.form.vehicleList[0].detailedDate.split('-').join('/');
            //         this.minDate = new Date(date);
            //         this.maxDate = new Date(2100, 0, 0);
            //     } else {
            //         this.minDate = new Date();
            //         this.maxDate = new Date(2100, 0, 0);
            //     }
            // } else {
            //     if (this.form.vehicleList[1].detailedDate) {
            //         const date = this.form.vehicleList[1].detailedDate.split('-').join('/');
            //         this.maxDate = new Date(date);
            //         this.minDate = new Date();
            //     } else {
            //         this.minDate = new Date();
            //         this.maxDate = new Date(2100, 0, 0);
            //     }
            // }
        },
        // 确定时间
        submitDate() {
            this.form.vehicleList[this.vehicleIndex].detailedDate = moment(this.dateTime).format('YYYY-MM-DD HH:mm:ss');
            this.showDate = false;
        },
        // 保存并添加报名记录
        submit() {
            var isFromJYGW = GetQueryString("isFromJYGW");
            const obj = JSON.parse(JSON.stringify(Object.assign({}, this.form)));
            obj.contactList.forEach(v => {
                if (v.level - 0 === 4) v.levelName = v.otherLevelName;
                v.phone = v.phone.replace(/\s+/g, '');
                delete v.isErrorSex;
                delete v.otherLevelName;
            });
            obj.vehicleList.forEach(v => {
                delete v.vehicleLabel;
                delete v.isErrorNeedStay;
                if (!v.address) v.address = '无'
                if (v.type === -1 || this.form.isMeeting !== 1) v.isNeedStay = -1
                if (this.form.isMeeting !== 1){
                    v.address = '无'
                    v.info = '无'
                    v.vehicleType = 9
                    v.detailedDate = ''
                    obj.isFirst = -1
                }
            });
            if (isFromJYGW === 'wx'){
                obj.registerType = 1;
                Api.activityImplementationDetails(obj).then(res => {
                    if (res.data.code === 0){
                        this.edit = true
                        this.loading = false;
                        Toast.clear();
                        Toast('提交成功!')
                    }
                }).catch(() => {
                    this.loading = false;
                    this.edit = false;
                })
            } else {
                if (this.form.sid) {
                    obj.registerType = 2;
                    obj.club = this.clubId
                    Api.editActivityImplementationDetails(obj).then(res =>  {
                        if (res.data.code === 0){
                            this.loading = false;
                            Toast.clear();
                            Toast('修改成功!')
                            this.$router.push({
                                path: '/bi/record',
                                query: {
                                    isSign: localStorage.getItem('isSign') * 1 === 1 ? 1 : 0
                                }
                            })
                        } else {
                            this.loading = false;
                            Toast(res.data.msg)
                        }
                    }).catch(() => {
                        this.loading = false;
                    })
                } else {
                    obj.registerType = 2;
                    Api.activityImplementationDetails(obj).then(res =>  {
                        if (res.data.code === 0){
                            this.loading = false;
                            Toast.clear();
                            Toast('提交成功!')
                            if (this.isApp) {
                                this.$router.push({
                                    path: '/bi/record',
                                    query: {
                                        isSign: 1
                                    }
                                });
                            } else {
                                this.$router.push('/bi/record?source=h5');
                            }
                        } else {
                            this.loading = false;
                            Toast(res.data.msg)
                        }
                    }).catch(() => {
                        this.loading = false;
                    })
                }
            }
        },
        // 校验失败
        failed() {
            if (!this.form.isNeedStay) this.isErrorNeedStay = true;
            this.form.contactList.forEach(v => {
                if (!v.sex) v.isErrorSex = true;
            })
            this.form.vehicleList.forEach(v => {
                if (!v.isNeedStay) v.isErrorNeedStay = true;
            })
            this.loading = false;
            Toast.clear();
            Toast('请先完善报名信息!')
        },
        // 提交表单
        save(status) {
            this.loading = true;
            this.form.status = status;
            this.$refs['myForm'].submit();
        },
        // 清空搜索
        emptySearch() {
            if (this.businessName.trim() === '') this.getAllUser();
        },
        // 打开选择报名客户弹窗
        openMemberDialog() {
            var isFromJYGW = GetQueryString("isFromJYGW");
            !this.form.sid && isFromJYGW !== 'wx' ? this.showMember = true : '';
        },
        // 获取衣服尺码
        getDictDressSize() {
            Api.getDict('dress_size').then(({ data: { data }}) => {
                this.dressSizeList = data
            })
        },
        // 衣服尺寸弹窗
        openSizeDialog(index){
            this.sizeIndex = index;
            !this.edit ? this.showSize = true : '';
        },
        // 选择衣服尺寸
        selectDressSize(item) {
            this.form.contactList[this.sizeIndex].chinaSizeId = item.value;
        },
        // 确定衣服尺寸
        submitSize(){
            const chinaSizeId = this.form.contactList[this.sizeIndex].chinaSizeId;
            const ressSizeObj = this.dressSizeList.filter(item => item.value === chinaSizeId)[0] || {};
            if (ressSizeObj.hasOwnProperty('value')) {
                this.form.contactList[this.sizeIndex].chinaSizeId = ressSizeObj.value;
                this.form.contactList[this.sizeIndex].chinaSize = ressSizeObj.label;
                this.showSize = false;
            }
        }
    }
}
</script>
<style lang="scss">
.sign-up-yllt {
    min-height: 3.1rem;
    overflow-y: auto;
    .area-info {
        height: 3.1rem;
        background: url("~@/assets/images/YLLT_bm.png") no-repeat;
        color: #fff;
        padding: 0.48rem 0.2rem;
        box-sizing: border-box;
        > p {
            display: flex;
            align-items: center;
        }
        .select-area {
            font-size: 0.4rem;
            line-height: 0.36rem;
            .down-arrow {
                width: 0.36rem;
                height: 0.16rem;
                margin-left: 0.36rem;
            }
        }
        .adress-detail {
            font-size: 0.28rem;
            margin-top: 0.44rem;
            margin-bottom: 0.24rem;
            .gps-icon {
                width: 0.24rem;
                height: 0.28rem;
                margin-right: 0.16rem;
            }
        }
        .join-date {
            .date-icon {
                width: 0.24rem;
                height: 0.24rem;
                margin-right: 0.14rem;
            }
        }
    }
    .join-info {
        background: transparent;
        margin: -0.54rem 0.2rem 0 0.2rem;
        border-radius: 0.08rem;
        .select-user {
            background: #fff;
            border-radius: 0.08rem;
            .van-cell {
                background: transparent;
            }
            .sign-up-time {
                padding: 0.12rem 0.2rem;
                color: #ff8947;
                background: #fffcf7;
                border-top-left-radius: 0.08rem;
                border-top-right-radius: 0.08rem;
            }
        }
        .van-cell__title {
            width: 2.8rem;
            flex: none;
        }
        .van-radio-group--horizontal{
            flex-wrap: nowrap;
        }
        .van-field--error .van-field__control,
        .van-field--error .van-field__control::placeholder,
        .error-message {
            color: #ff8947;
        }
        .input-radio {
            justify-content: space-between;
        }
        .row{
            .van-cell__title {
                width: 1.4rem;
                flex: none;
            }
        }
        .van-field__control--custom {
            display: flex;
            justify-content: flex-end;
            > div {
                display: flex;
                justify-content: flex-end;
                align-items: center;
            }
        }
        .van-cell--required::before {
            color: #ff8947;
        }
        .user-info {
            margin-top: 0.2rem;
            background: #ffffff;
            box-shadow: 0px 0.06rem 0.24rem rgba(50, 53, 55, 0.06);
            border-radius: 0.08rem;
            overflow: hidden;
            .sub-title {
                display: flex;
                align-items: center;
                font-weight: 600;
                font-size: 0.32rem;
                line-height: 0.28rem;
                padding: 0.24rem 0.2rem;
                .flex {
                    flex: 1;
                }
                .delete-join-user {
                    width: 0.36rem;
                    height: 0.36rem;
                }
            }
            .join-user-icon {
                width: 0.4rem;
                height: 0.4rem;
                margin-right: 0.16rem;
            }
            .van-cell {
                padding-right: 0.2rem;
                border-bottom: 1px solid #ebedf0;
            }
            .van-field__control {
                text-align: right;
            }
            .van-cell:not(:last-child)::after {
                border: none;
            }
        }
        .add-user-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 0.8rem;
            background: #ffffff;
            color: #ff8947;
            font-size: 0.32rem;
            margin-top: 0.2rem;
            box-shadow: 0px 0.06rem 0.24rem rgba(50, 53, 55, 0.06);
            border-radius: 0.08rem;
        }
        .remark {
            border-radius: 0.08rem;
            margin: 0 0.2rem 0.2rem 0.2rem;
            .van-field__control {
                text-align: left;
            }
            .van-cell {
                background: #f9f9f9;
                border-radius: 0.08rem;
                border: none !important;
            }
        }
    }
    .bottom-bar {
        margin-bottom: constant(safe-area-inset-bottom);
        margin-bottom: env(safe-area-inset-bottom);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 0.24rem 0.06rem 0.24rem;
        background: #ffffff;
        height: 1.18rem;
        margin-top: 0.24rem;
        > .van-button {
            // width: 3.12rem;
            width: 100%;
            height: 0.8rem;
            border-radius: 0.4rem;
            text-align: center;
            line-height: 0.8rem;
            font-size: 0.32rem;
            box-sizing: border-box;
        }
        .draft {
            background: #fffcf7;
            margin-right: 0.38rem;
            color: #ffa674;
        }
        .submit {
            background: linear-gradient(90deg, #ffa16d 10.71%, #ff8947 102.11%);
            box-shadow: 0px 0.08rem 0.16rem rgba(255, 138, 72, 0.2);
            border-radius: 0.4rem;
            color: #ffffff;
        }
    }
    .fixedBtn{
        position: fixed;
        bottom: 0.2rem;
        height: 1.18rem;
        width: 100%;
        text-align: center;
        line-height: 1.18rem;
        .btn{
            width: 2.78rem;
            height: 0.84rem;
            border-radius: 0.42rem;
            background: linear-gradient(90deg, #ffa16d 10.71%, #ff8947 102.11%);
            color: #fff;
            font-size: 0.4rem;
        }
    }
}
.select-member-sheet {
    max-height: calc(9.2rem + constant(safe-area-inset-bottom));
    max-height: calc(9.2rem + env(safe-area-inset-bottom));
    .sheet-text {
        padding: 0 0.28rem;
        font-weight: 600;
        font-size: 0.32rem;
        border-bottom: 0.02rem solid #eeeeee;
        .top {
            height: 1.18rem;
            line-height: 1.18rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            img {
                width: 0.24rem;
                height: 0.24rem;
            }
        }
        .bottom {
            height: 0.68rem;
            display: flex;
            align-items: center;
            margin-bottom: 0.28rem;
            box-sizing: border-box;
            img {
                width: 0.28rem;
                height: 0.28rem;
                margin-left: 0.2rem;
            }
            input {
                height: 0.68rem;
                flex: 1;
                border: none;
                outline: none;
                background: #f3f3f3;
                padding: 0 0.2rem;
                margin-right: 0.2rem;
                border-radius: 0.12rem;
                font-size: 0.32rem;
                font-weight: 400;
            }
            .search-btn {
                width: 1.2rem;
                height: 0.68rem;
                text-align: center;
                line-height: 0.68rem;
                background: #ff8c4b;
                color: #fff;
                font-size: 0.32rem;
                font-weight: 600;
                border-radius: 0.12rem;
            }
        }
    }
    .member-list {
        padding: 0.24rem 0.28rem 0.28rem 0.28rem;
        max-height: 5.14rem;
        overflow-y: auto;
        .van-radio {
            display: flex;
            align-items: center;
            height: 0.92rem;
            padding: 0 0.28rem;
            border-radius: 0.12rem;
            margin-top: 0.16rem;
            .van-radio__label {
                margin-left: 0.32rem;
                font-size: 0.28rem;
            }
        }
        .van-radio__icon--checked {
            .van-icon-success::before {
                content: "";
                width: 0.12rem;
                height: 0.12rem;
                background: #ffffff;
                border-radius: 50%;
                position: absolute;
                top: 50%;
                left: 50%;
                margin-left: -0.06rem;
                margin-top: -0.06rem;
            }
        }
    }
    .select-content {
        padding: 0 0.28rem;
        .comfirm-btn {
            margin-bottom: 0.28rem;
        }
    }
    .select-list {
        display: flex;
        flex-wrap: wrap;
        text-align: center;
        line-height: 0.68rem;
        padding: 0.6rem 0;
        .dv {
            width: 33.3%;
            padding-right: 0.2rem;
            margin-bottom: 0.24rem;
            box-sizing: border-box;
        }
        li {
            height: 0.68rem;
            background: #f4f4f4;
            border-radius: 0.12rem;
            border: 1px solid #f4f4f4;
        }
        .active {
            background: #fff5e4;
            border: 1px solid #ffba93;
        }
    }
    .comfirm-btn {
        margin: 0.28rem;
        height: 0.8rem;
        line-height: 0.8rem;
        text-align: center;
        color: #ffffff;
        font-size: 0.32rem;
        background: linear-gradient(90deg, #ffa16d -2.42%, #ff8947 102.42%);
        box-shadow: 0px 0.08rem 0.16rem rgba(255, 138, 72, 0.2);
        border-radius: 0.4rem;
    }
}
.mergBtn {
    .van-dialog__confirm {
        background: #ff8947;
    }
}
</style>
