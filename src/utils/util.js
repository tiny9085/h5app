/* eslint-disable prefer-const */
/* eslint-disable no-undef */

/**
 * 生成随机len位数字
 */
export const randomLenNum = (len, date) => {
    let random = ''
    random = Math.ceil(Math.random() * 100000000000000).toString().substr(0, len || 4)
    if (date) random = random + Date.now()
    return random
}

/**
 *加密处理
 */
export const encryption = (params) => {
    let {
        data,
        type,
        param,
        key
    } = params
    const result = JSON.parse(JSON.stringify(data))
    if (type === 'Base64') {
        param.forEach(ele => {
            result[ele] = btoa(result[ele])
        })
    } else {
        param.forEach(ele => {
            var data = result[ele]
            key = CryptoJS.enc.Latin1.parse(key)
            var iv = key
            // 加密
            var encrypted = CryptoJS.AES.encrypt(
                data,
                key, {
                    iv: iv,
                    mode: CryptoJS.mode.CBC,
                    padding: CryptoJS.pad.ZeroPadding
                })
            result[ele] = encrypted.toString()
        })
    }
    return result
}

/**
 * 获取对象类型
 */
export const getObjType = obj => {
    var toString = Object.prototype.toString
    var map = {
        '[object Boolean]': 'boolean',
        '[object Number]': 'number',
        '[object String]': 'string',
        '[object Function]': 'function',
        '[object Array]': 'array',
        '[object Date]': 'date',
        '[object RegExp]': 'regExp',
        '[object Undefined]': 'undefined',
        '[object Null]': 'null',
        '[object Object]': 'object'
    }
    if (obj instanceof Element) {
        return 'element'
    }
    return map[toString.call(obj)]
}

/**
 * 对象深拷贝
 */
export const deepClone = data => {
    var type = getObjType(data)
    var obj
    if (type === 'array') {
        obj = []
    } else if (type === 'object') {
        obj = {}
    } else {
    // 不再具有下一层次
        return data
    }
    if (type === 'array') {
        for (var i = 0, len = data.length; i < len; i++) {
            obj.push(deepClone(data[i]))
        }
    } else if (type === 'object') {
        for (var key in data) {
            obj[key] = deepClone(data[key])
        }
    }
    return obj
}

/**
 * 加密
 * @param {*} code
 */
export const compile = code => {
    var c = String.fromCharCode(code.charCodeAt(0) + code.length)
    for (var i = 1; i < code.length; i++) {
        c += String.fromCharCode(code.charCodeAt(i) + code.charCodeAt(i - 1))
    }
    return escape(c)
}
/**
 * 解密
 * @param {*} code
 */
export const uncompile = code => {
    code = unescape(code)
    var c = String.fromCharCode(code.charCodeAt(0) - code.length)
    for (var i = 1; i < code.length; i++) {
        c += String.fromCharCode(code.charCodeAt(i) - c.charCodeAt(i - 1))
    }
    return c
}
/**
 * 图片路径添加或删除/
 * @param {*} url
 */
export const replaceUrl = (ossUrl, url) => {
    if (ossUrl && url) {
        const a = url.substr(0, 1);
        const b = ossUrl.substr(ossUrl.length - 1, ossUrl.length);
        if (a === '/') {
            if (b === '/') {
                return url.substr(1, url.length - 1);
            }
            return url;
        } else {
            if (b === '/') {
                return url;
            }
            return '/' + url;
        }
    } else {
        return url;
    }
}

/**
 * 确认当前页码
 */

export const comfirmPage = (arr, num) => {
    var i = 0; var len = arr.length; var target = 1
    if (!(len > 0)){
        return;
    }
    if (num > arr[len - 1]) {
        target = len
    }
    for (i; i < len - 1; i++){
        if (num > arr[i] && num <= arr[ i + 1]) {
            target = i + 1
        }
    }
    return target
}

/**
 * 获取路径的参数值
 */
export const GetQueryString = (name) => {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    if (window.location.hash.indexOf("?") < 0){
        return null;
    }
    const r = window.location.hash.split("?")[1].match(reg);
    if (r != null) return decodeURIComponent(r[2]); 
    return null; 
}

