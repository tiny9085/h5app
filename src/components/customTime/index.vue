<template>
    <div class="custom-time">
        <div :class="['custom-item', {'show-day': oldTimeData.endType === 'day'}]" @click="showSelectTime = true">
            <p>{{ currentTimeStr }}</p>
            <img class="open-arrow" src="@/assets/images/arrow.png" alt="">
        </div>
        <van-popup v-model="showSelectTime" position="bottom" :close-on-click-overlay="false" get-container="body" class="custom-time-popup">
            <ul class="select-time-type">
                <li :class="{'active-time': endType === 'month'}" @click="endType = 'month'">日期选择</li>
                <li :class="{'active-time': endType === 'day'}" @click="endType = 'day'">自定义</li>
                <span class="close-time" @click="closeTimeFn">&times;</span>
            </ul>
            <ol class="date-wrap">
                <li v-show="endType === 'month'">
                    <van-datetime-picker
                        v-model="currentTime"
                        :show-toolbar="false"
                        :min-date="minDateM"
                        :max-date="maxDateM"
                        type="year-month"
                        @change="changeMonth"
                    />
                </li>
                <li v-show="endType === 'day'">
                    <div class="selected-date-wrap">
                        <span :class="['start-time', {bg: currentTmeType === 1}]" @click="changeCurrentTimeType(1)">{{ startTime }}</span>
                        <i></i>
                        <span :class="['end-time', {bg: currentTmeType === 2}]" @click="changeCurrentTimeType(2)">{{ endTime }}</span>
                    </div>
                    <van-datetime-picker
                        v-show="currentTmeType === 1"
                        v-model="currStartTime"
                        :show-toolbar="false"
                        :min-date="sMinDate"
                        :max-date="sMaxDate"
                        type="date"
                        @change="changeDay"
                    />
                    <van-datetime-picker
                        ref="refCurrEndTime"
                        v-show="currentTmeType === 2"
                        v-model="currEndTime"
                        :show-toolbar="false"
                        :min-date="eMinDate"
                        :max-date="eMaxDate"
                        type="date"
                        @change="changeDay"
                    />
                </li>
            </ol>
            <p v-if="(endType === 'day' && startTime && endTime) || (endType === 'month' && currentTime) " class="confirm" @click="confirmTimeFn">确  认</p>
            <p v-else class="confirm disabled">确  认</p>
        </van-popup>
    </div>
</template>
<script>
import moment from 'moment'
export default {
    name: 'customeTime',
    props:{
        minDateInit: {
            type: Array,
            default: ()=> {
                return [2015, 0, 1]
            }
        },
        maxDateInit: {
            type: Array,
            default: ()=> {
                const now = new Date();
                return [now.getFullYear(), now.getMonth(), now.getDate()]
            }
        }
    },
    data() {
        return {
            endType: 'month', // month, day控制宽度
            currentTimeStr: moment(new Date()).format('YYYY.MM'),
            currentTime: new Date(),
            currStartTime: new Date(),
            currEndTime: new Date(),
            showSelectTime: false,
            startTime: moment(new Date(2015, 0, 1)).format('YYYY.MM.DD'),
            endTime: '',
            currentTmeType: 1, // 当前自定义时间类型 1：开始时间，2结束时间
            sMinDate: new Date(),
            sMaxDate: new Date(),
            eMinDate: new Date(),
            eMaxDate: new Date(),
            minDateM: new Date(),
            maxDateM: new Date(),
            oldTimeData: {
                endType: 'month',
                currentTmeType: 1
            }
        }
    },
    watch:{

    },
    mounted() {
        this.sMinDate = new Date(this.minDateInit[0], this.minDateInit[1], this.minDateInit[2]);
        this.sMaxDate = new Date(this.maxDateInit[0], this.maxDateInit[1], this.maxDateInit[2]);
        this.eMinDate = new Date(this.minDateInit[0], this.minDateInit[1], this.minDateInit[2]);
        this.eMaxDate = new Date(this.maxDateInit[0], this.maxDateInit[1], this.maxDateInit[2]);
        this.minDateM = new Date(this.minDateInit[0], this.minDateInit[1]);
        this.maxDateM = new Date(this.maxDateInit[0], this.maxDateInit[1]);
        this.startTime = moment().startOf('month').format('YYYY.MM.DD');
        this.endTime = moment().format('YYYY.MM.DD');
        this.currStartTime = new Date(this.startTime.split('.').join('/'))
        this.currEndTime =  new Date(this.endTime.split('.').join('/'))
    },
    methods: {
        formatter(type, val) {
            if (type === 'month') {
                return `${val}月`;
            } else if (type === 'day') {
                return `${val}日`;
            }
            return val;
        },
        changeMonth() {
            // this.currentTimeStr = moment().format('YYYY.MM.DD');
        },
        // 选择自定义时间
        changeDay() {
            if (this.currentTmeType === 1) {
                this.startTime = moment(this.currStartTime).format('YYYY.MM.DD');
            } else {
                this.endTime = moment(this.currendTime).format('YYYY.MM.DD');
            }
        },
        // 点击修改自定义时间
        changeCurrentTimeType(type) {
            this.currentTmeType = type;
            const startTime = this.startTime.split('.').join('/');
            const endTime = this.endTime.split('.').join('/');
            this.$nextTick(()=>{
                this.currStartTime = startTime ? new Date(startTime) : ''
                this.currEndTime = startTime ? new Date(endTime) : ''
            })
            if (type === 1){ //修改开始时间
                if (this.endTime) {// 控制可选时间
                    this.sMinDate = new Date(this.minDateInit[0], this.minDateInit[1], this.minDateInit[2]);
                    this.sMaxDate = new Date(endTime);
                }
            }
            if (type === 2) { // 修改结束时间
                if (this.startTime) {// 控制可选时间
                    this.eMinDate = new Date(startTime);
                    this.eMaxDate = new Date(this.maxDateInit[0], this.maxDateInit[1], this.maxDateInit[2]);
                }
            }
        },
        // 取消选择
        closeTimeFn() {
            this.showSelectTime = false;
            this.currentTmeType = this.oldTimeData.currentTmeType;
            this.endType = this.oldTimeData.endType;
        },
        // 确定选择时间
        confirmTimeFn() {
            const startTime = this.startTime.split('.').join('/');
            const endTime = this.endTime.split('.').join('/');
            if (this.endType === 'month') {
                this.currentTimeStr = moment(this.currentTime).format('YYYY.MM');
            } else {
                this.currentTimeStr = [moment(startTime).format('YYYY.MM.DD'), moment(endTime).format('YYYY.MM.DD')].join('-');
            }
            this.oldTimeData.endType = this.endType;
            this.oldTimeData.currentTmeType = this.currentTmeType;
            this.showSelectTime = false;
            this.$emit('selectTime');
        }
    }
}
</script>
<style lang="scss">
.custom-time{
    .custom-item{
        position: relative;
        width: 1.92rem;
        height: .6rem;
        line-height: .56rem;
        border: .01rem solid #E4E4E4;
        border-radius: .3rem;
        box-sizing: border-box;
        margin: .2rem;
        p{
            width: 1.88rem;
            border-radius: .3rem;
            height: .56rem;
            padding: 0 .2rem;
            font-size: .28rem;
        }
        .open-arrow{
            width: .48rem;
            height: .48rem;
            position: absolute;
            right: .06rem;
            top: .08rem;
        }
    }
    .custom-item.show-day{
        width: 3.62rem;
        p{
            width: 3.62rem;
        }
    }
}
.custom-time-popup{
    .confirm{
        margin: .32rem .4rem;
        height: .72rem;
        text-align: center;
        line-height: .72rem;
        background: #ED3129;
        color: #fff;
        font-size: .32rem;
        border-radius: .36rem;
    }
    .disabled{
        background: #E4E4E4;
    }
}
// 日期选择
.select-time-type{
    margin: 0 .32rem;
    height: .88rem;
    line-height: .86rem;
    border-bottom: .04rem solid #E4E4E4;
    display: flex;
    position: relative;
    li{
        width: 1.64rem;
        text-align: center;
        font-size: .32rem;
        color: #666666;
        margin-right: .32rem;
        position: relative;
    }
    .close-time{
        font-size: .48rem;
        color: #CCCCCC;
        position: absolute;
        right: 0;
    }
    .active-time::after{
        content: ' ';
        position: absolute;
        bottom: -.02rem;
        left: 0;
        width: 100%;
        height: .04rem;
        background: #EA424D;
    }
    .active-time{
        color: #ED3129;
    }
}
//自定义时间选择
.date-wrap{
    margin: 0 .32rem;
    .van-picker__frame{
        left: 0;
    }
    .van-picker__frame::after{
        border-left: none;
        border-right: none;
    }
    .selected-date-wrap{
        display: flex;
        margin-top: .4rem;
        .start-time, .end-time{
            font-size: .28rem;
            width: 2.48rem;
            height: .68rem;
            text-align: center;
            line-height: .68rem;
            border-radius: .08rem;
            background: #F6F6F6;
            color: #666666;
            border: 1px solid transparent;
        }
        .bg{
            border-color: #EA424D;
        }
        i{
            width: .32rem;
            height: .02rem;
            margin: .33rem .16rem;
            background: #666666;
        }
    }
}
</style>