import 'package:smart_assistant/common/dao/user_dao.dart';

/// 地址数据
class Address {
  // static const String APP_DOMAIN_PRODUCT = 'http://192.168.15.132:29999/'; //新测试
  // static const String APP_DOMAIN_PRODUCT = 'http://192.168.69.207:20007/'; //新测试
  static const String APP_DOMAIN_PRODUCT = 'http://pharmacy-boss.hnhcyy.com/'; //线上
  // static const String APP_DOMAIN_PRODUCT = 'https://yg-api.hcjk.com/'; //线上
  static const String APP_HTML_DOMAIN = 'http://pharmacy-h5.hnhcyy.com/#/';
  // static const String APP_HTML_DOMAIN = 'https://yg-api.hcjk.com/';
  // static const String APP_HTML_DOMAIN = 'http://192.168.15.55:8089/#/';

  ///门店销售详情
  static organSaleDetails() {
    return '${APP_HTML_DOMAIN}member/saleDetail?token=${UserDao.getAccessToken()}';
  }

  ///门店排行
  static storeRank(){
    return '${APP_HTML_DOMAIN}member/store?token=${UserDao.getAccessToken()}';
  }

  ///品种销售榜
  static productRank() {
    return '${APP_HTML_DOMAIN}member/saleList?token=${UserDao.getAccessToken()}';
  }

  ///断货榜
  static outStockList() {
    return '${APP_HTML_DOMAIN}product/outofstockList?token=${UserDao.getAccessToken()}';
  }

  ///不动销榜
  static fixedPinRank() {
    return '${APP_HTML_DOMAIN}product/fixedPin?token=${UserDao.getAccessToken()}';
  }

  ///查库存
  static checkStock() {
    return '${APP_HTML_DOMAIN}product/checkStock?token=${UserDao.getAccessToken()}';
  }

  ///库存成本金额
  static stockInventoryAmount() {
    return '${APP_HTML_DOMAIN}home?token=${UserDao.getAccessToken()}';
  }

  ///断货品种
  static outBreed() {
    return '${APP_HTML_DOMAIN}product/outofstock?token=${UserDao.getAccessToken()}';
  }

  ///新品品种
  static newBreeds() {
    return '${APP_HTML_DOMAIN}product/new?token=${UserDao.getAccessToken()}';
  }

  ///60天-90天不动销
  static sixtyNoSale() {
    return '${APP_HTML_DOMAIN}product/fixedPin?type=1&token=${UserDao.getAccessToken()}';
  }

  ///90天不动销
  static ninetyNoSale() {
    return '${APP_HTML_DOMAIN}product/fixedPin?type=2&token=${UserDao.getAccessToken()}';
  }

  ///效期品种查看
  static expiredDetailsCheck() {
    return '${APP_HTML_DOMAIN}product/expiryDate?token=${UserDao.getAccessToken()}';
  }

  ///近1个月效期明细查看
  static oneMonthExpiredDetailsCheck() {
    return '${APP_HTML_DOMAIN}product/expiryDate?type=1';
  }

  ///近1-3个月效期明细查看
  static threeMonthExpiredDetailsCheck() {
    return '${APP_HTML_DOMAIN}product/expiryDate?type=2';
  }

  ///1个月效期明细查看
  static sixMonthExpiredDetailsCheck() {
    return '${APP_HTML_DOMAIN}product/expiryDate?type=3';
  }

  ///远程审方列表
  static reviewerList() {
    return '${APP_HTML_DOMAIN}reviewer/list?token=${UserDao.getAccessToken()}';
  }

  ///手机盘点
  static mobileCheck() {
    return '${APP_HTML_DOMAIN}member/check?token=${UserDao.getAccessToken()}';
  }

  ///远程审方详情
  static reviewerDetail(int tab) {
    return '${APP_HTML_DOMAIN}reviewer/detail?tab=$tab&source=h5';
  }

  static login() {
    // return '${APP_DOMAIN_PRODUCT}auth/oauth/token';
    return '${APP_DOMAIN_PRODUCT}auth/mobile/token/sms';
  }

  static fetchIndex() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/index';
  }

  static fetchSalesReport() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/report';
  }

  static fetchCommodityMana() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/goods';
  }

  static modifyPwd() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/user/pwd';
  }

  static feedback() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/opinion';
  }

  static memberManage() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/member';
  }

  static sendCode(String phoneNum) {
    return '${APP_DOMAIN_PRODUCT}pharmacy/checkcode/upw/$phoneNum';
  }

  static fetchOrganList() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/organ/user';
  }

  //检查手机盘点权限
  static checkPermission() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/checkreg/index';
  }

  //检查远程审方权限
  static reviewerPermission() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/retailrecipe/index';
  }

  //登录日志
  static userLoginLog() {
    return '${APP_DOMAIN_PRODUCT}pharmacy/userlog';
  }

  //检查版本
  static checkVersion(String clientType, String version) {
    return '${APP_DOMAIN_PRODUCT}pharmacy/version/info/$clientType?versionCode=$version';
  }

}
