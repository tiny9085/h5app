import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/widget/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  static final String sName = "about_us";

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String? _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        this._version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '关于药店管家',
      ),
      body: Container(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 40.0), child: Image.asset('assets/images/ic_logo_about_us.png', width: 120.0, height: 120.0)),
            Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Card(
                    elevation: 0.0,
                    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        children: [
                          // GestureDetector(
                          //     behavior: HitTestBehavior.opaque,
                          //     child: Container(
                          //       child: Row(
                          //         children: [
                          //           Image.asset(
                          //             'assets/images/ic_website.png',
                          //             width: 16.0,
                          //             height: 16.0,
                          //           ),
                          //           Expanded(
                          //               child: Padding(
                          //             padding: EdgeInsets.only(left: 10.0),
                          //             child: Text('官方网站', style: HCYYConstant.labelText),
                          //           )),
                          //           Image.asset(
                          //             'assets/images/ic_right_arrow.png',
                          //             width: 5.0,
                          //             height: 10.0,
                          //           )
                          //         ],
                          //       ),
                          //       height: 58.0,
                          //     ),
                          //     onTap: () async {
                          //       String url = 'https://www.yyhelper.com';
                          //       if (await canLaunch(url)) {
                          //         await launch(url, forceSafariVC: false);
                          //       } else {
                          //         Fluttertoast.showToast(msg: '不能访问网站', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                          //       }
                          //     }),
                          // Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              String url = 'tel:400-168-4568';
                              //判断是否可以拨打电话
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                Fluttertoast.showToast(msg: '手机号异常，不能拨打电话', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                              }
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_service_hotline.png',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text('客服热线', style: HCYYConstant.labelText),
                                  )),
                                  Image.asset(
                                    'assets/images/ic_right_arrow.png',
                                    width: 5.0,
                                    height: 10.0,
                                  )
                                ],
                              ),
                              height: 58.0,
                            ),
                          ),
                          Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_user_agreement.png',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('用户协议', style: HCYYConstant.labelText),
                                      )),
                                  Image.asset(
                                    'assets/images/ic_right_arrow.png',
                                    width: 5.0,
                                    height: 10.0,
                                  )
                                ],
                              ),
                              height: 58.0,
                            ),
                            onTap: () {
                              NavigatorUtils.goAgreement(context);
                            },
                          ),
                          Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_privacy_policy.png',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('隐私政策', style: HCYYConstant.labelText),
                                      )),
                                  Image.asset(
                                    'assets/images/ic_right_arrow.png',
                                    width: 5.0,
                                    height: 10.0,
                                  )
                                ],
                              ),
                              height: 58.0,
                            ),
                            onTap: () {
                              NavigatorUtils.goPolicy(context);
                            },
                          ),
                          Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_version_update.png',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text('版本更新', style: HCYYConstant.labelText),
                                  )),
                                  Text(
                                    _version == null ? '' : 'V$_version',
                                    style: TextStyle(fontSize: 14.0, color: Color(0xffbbbbbb)),
                                  ),
                                ],
                              ),
                              height: 58.0,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    )))
          ],
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x249664FF),
              Color(0x2464C7FF),
            ],
          ),
        ),
      ),
    );
  }
}
