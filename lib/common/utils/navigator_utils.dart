import 'package:flutter/material.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/page/aboutus_page.dart';
import 'package:smart_assistant/page/agreement_page.dart';
import 'package:smart_assistant/page/feedback_page.dart';
import 'package:smart_assistant/page/forget_pwd_page.dart';
import 'package:smart_assistant/page/guide_page.dart';
import 'package:smart_assistant/page/login_page.dart';
import 'package:smart_assistant/page/main/main_page.dart';
import 'package:smart_assistant/page/policy_page.dart';
import 'package:smart_assistant/page/scan_page.dart';
import 'package:smart_assistant/page/webview_page.dart';

class NavigatorUtils {
  ///返回上一级页面
  static pop(BuildContext context, {dynamic params}) {
    Navigator.maybePop(context, params);
  }

  ///返回根页面
  static popRoot(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(MainPage.sName));
  }

  ///是否可以返回
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  ///主页
  static goMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, MainPage.sName);
  }

  ///引导页
  static goGuide(BuildContext context) {
    Navigator.pushReplacementNamed(context, GuidePage.sName);
  }

  ///忘记密码
  static goForgetPwd(BuildContext context) {
    Navigator.pushNamed(context, ForgetPwdPage.sName);
  }

  ///关于我们
  static goAboutUs(BuildContext context) {
    Navigator.pushNamed(context, AboutUsPage.sName);
  }

  ///意见反馈
  static goFeedback(BuildContext context) {
    Navigator.pushNamed(context, FeedbackPage.sName);
  }

  ///用户协议
  static goAgreement(BuildContext context) {
    Navigator.pushNamed(context, AgreementPage.sName);
  }

  ///隐私政策
  static goPolicy(BuildContext context) {
    Navigator.pushNamed(context, PolicyPage.sName);
  }

  ///webview页
  static goWebView(BuildContext context, String url) {
    Navigator.pushNamed(context, WebviewPage.sName, arguments: url);
  }

  ///扫一扫
  static goScan(BuildContext context) {
    Navigator.pushNamed(context, ScanPage.sName);
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(

        ///不受系统字体缩放影响
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: widget);
  }

  ///弹出 dialog
  static Future<T?> showCommonDialog<T>({required BuildContext context, bool barrierDismissible = false, required WidgetBuilder builder}) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: Color(0x66000000),
        builder: (context) {
          return MediaQuery(

              ///不受系统字体缩放影响
              data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window).copyWith(textScaleFactor: 1),
              child: SafeArea(child: builder(context)));
        });
  }

  static Future<T?> ShowPrivacyPolicyDialog<T>({required BuildContext context, required WidgetBuilder builder}){
    return showDialog<T>(
        context: context,
        barrierColor: Color(0x66000000),
        builder: (context) {
          return MediaQuery(

            ///不受系统字体缩放影响
              data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window).copyWith(textScaleFactor: 1),
              child: SafeArea(child: builder(context)));
        });
  }

}
