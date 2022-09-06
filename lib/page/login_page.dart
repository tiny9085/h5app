import 'dart:io';

import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/event/index.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/helper_data.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/AppVersionEntity.dart';
import 'package:smart_assistant/model/CommonDataEvent.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/redux/login_redux.dart';
import 'package:smart_assistant/widget/confirm_btn.dart';

//页面加载器，作为主页面
class LoginPage extends StatefulWidget {
  static final String sName = "login";

  //生命周期函数
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  //是否展示loading
  bool isShowLoading = false;
  bool isCheckedPolicy = false;

  String _userNameText = '';
  bool _passwordVisible = false;
  bool _codeVisible = false;
  String _randomStr = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Future.delayed(Duration(seconds: 2), (){
        var firstLogin = SPUtil.getString(Config.FIRST_LOGIN);
        if (firstLogin == null || firstLogin.isEmpty || firstLogin == 'false') {
          CommonUtils.showPrivacyPolicyDialog(context);
        }

        //判断是否检查版本更新
        DateTime today = DateTime.now();
        DateTime disableDate = DateTime.parse(UserDao.getDisableUpdateDate() ?? '1970-01-01 00:00:00');
        print('disableDate==>year:${disableDate.year} month:${disableDate.month} day:${disableDate.day}');
        if (!(today.year==disableDate.year && today.month==disableDate.month && today.day==disableDate.day)) {
          RepositoryDao.checkVersion().then((res) {
            if (res != null && res.result) {
              AppVersionEntity appVersionEntity = res.data;
              CommonUtils.showVersionUpdateDialog(context, appVersionEntity.description!, appVersionEntity.forceUpdate==1, appVersionEntity.downloadUrl!);
            }
          });
        }
      });
    //注册监听
    eventBus.on<CommonDataEvent>().listen((event) {
      print('event.content==>${event.content}');
      getCodeStr();//登录失败，刷新验证码
    });
    getCodeStr();//生成9位随机数
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  Widget? hidingIcon() {
    if (_userNameText.length > 0) {
      return IconButton(
          icon: Icon(Icons.cancel, color: Colors.grey),
          splashColor: Colors.blueGrey,
          onPressed: () {
            setState(() {
              _unameController.clear();
              _userNameText = "";
            });
          });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Container(
          color: Color(0xffF4F4F4),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: (CommonData.screenW - 40) / 2.4 + 95,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/bg_login_top.png'),
                          fit: BoxFit.fill,
                        )),
                        height: 190,
                      ),
                      Positioned(
                        top: 56,
                        child: Text(
                          '登录',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Positioned(
                          top: 95,
                          left: 0,
                          right: 0,
                          child: Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Image.asset('assets/images/bg_login_banner.png', height: (CommonData.screenW - 40) / 2.4, fit: BoxFit.fill))),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Card(
                      elevation: 0.0,
                      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      '手机号码',
                                      style: HCYYConstant.labelText,
                                    ),
                                    width: 66.0,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(right: 16.0),
                                  ),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: 40),
                                      child: TextFormField(
                                          style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                          controller: _unameController,
                                          cursorColor: HCYYColor.primaryColor,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],//只允许输入数字
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            setState(() {
                                              _userNameText = text;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: '请输入手机号码',
                                            suffixIcon: hidingIcon(),
                                            hintStyle: TextStyle(fontSize: 14.0, color: Color(0xffcccccc)),
                                            // 未获得焦点下划线设为灰色
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            //获得焦点下划线设为蓝色
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent),
                                            ),
                                          ),
                                          // 校验用户名
                                          validator: (v) {
                                            return v!.trim().length > 0 ? null : '请输入手机号码';
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              height: 58.0,
                            ),
                            Divider(height: 1.0, color: Color(0xfff6f6f6)),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      '密码',
                                      style: HCYYConstant.labelText,
                                    ),
                                    width: 66.0,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(right: 16.0),
                                  ),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: 40),
                                      child: TextFormField(
                                          style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                          obscureText: !_passwordVisible,
                                          controller: _pwdController,
                                          cursorColor: HCYYColor.primaryColor,
                                          onChanged: (text) {
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            hintText: '请输入密码',
                                            suffixIcon: _pwdController.text.length > 0
                                                ? IconButton(
                                                    //如果文本长度不为空则显示清除按钮
                                                    onPressed: () {
                                                      setState(() {
                                                        _passwordVisible = !_passwordVisible;
                                                      });
                                                    },
                                                    icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey))
                                                : null,
                                            hintStyle: TextStyle(fontSize: 14.0, color: Color(0xffcccccc)),
                                            // 未获得焦点下划线设为灰色
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            //获得焦点下划线设为蓝色
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent),
                                            ),
                                          ),
                                          // 校验用户名
                                          validator: (v) {
                                            return v!.trim().length > 0 ? null : '请输入密码';
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              height: 58.0,
                            ),
                            Divider(height: 1.0, color: Color(0xfff6f6f6)),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      '验证码',
                                      style: HCYYConstant.labelText,
                                    ),
                                    width: 66.0,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(right: 16.0),
                                  ),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: 40),
                                      child: TextFormField(
                                          style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                          obscureText: false,
                                          controller: _codeController,
                                          cursorColor: HCYYColor.primaryColor,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],//只允许输入数字
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            hintText: '请输入验证码',
                                            hintStyle: TextStyle(fontSize: 14.0, color: Color(0xffcccccc)),
                                            // 未获得焦点下划线设为灰色
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            //获得焦点下划线设为蓝色
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent),
                                            ),
                                          ),
                                          // 校验用户名
                                          validator: (v) {
                                            return v!.trim().length > 0 ? null : '请输入密码';
                                          }),
                                    ),
                                  ),
                                  Container(
                                    width: 66.0,
                                    height: 38.0,
                                    margin: EdgeInsets.only(right: 8.0),
                                    child: Image.network('${Address.APP_DOMAIN_PRODUCT}code?randomStr=$_randomStr',fit: BoxFit.fill,)
                                  ),
                                  InkWell(
                                    onTap: () {
                                      getCodeStr();
                                    },
                                    child: Container(
                                      width: 32.0,
                                      height: 32.0,
                                      padding: EdgeInsets.all(6),
                                      child: Image.asset('assets/images/ic_login_refresh.png', fit: BoxFit.fill,)
                                    ),
                                  )
                                ],
                              ),
                              height: 58.0,
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 44.0, left: 16.0, right: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Image.asset(
                              isCheckedPolicy ? 'assets/images/ic_checked.png' : 'assets/images/ic_unchecked.png',
                              width: 14.0,
                              height: 14.0,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              isCheckedPolicy = !isCheckedPolicy;
                            });
                          },
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '登录即表示同意药店管家的'),
                                  TextSpan(
                                      text: '《用户协议》',
                                      recognizer: TapGestureRecognizer()..onTap = () => NavigatorUtils.goAgreement(context),
                                      style: TextStyle(
                                        color: Color(0xFF5585FF),
                                        fontSize: 12.0,
                                      )),
                                  TextSpan(text: '和'),
                                  TextSpan(
                                      text: '《隐私政策》',
                                      recognizer: TapGestureRecognizer()..onTap = () => NavigatorUtils.goPolicy(context),
                                      style: TextStyle(
                                        color: Color(0xFF5585FF),
                                        fontSize: 12.0,
                                      ))
                                ])),
                      ],
                    )),
                ConfirmBtn('登录', () {
                  if(!isCheckedPolicy) {
                    Fluttertoast.showToast(msg: '请先阅读勾选协议', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                    return;
                  }
                  EasyLoading.show(status: '登录中...');
                  Future.delayed(const Duration(seconds: 3), () {
                    login();
                  });
                }),
                // GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     child: Text(
                //       '忘记密码',
                //       style: TextStyle(fontSize: 14.0, color: Color(0xff888888)),
                //     ),
                //     onTap: () {
                //       NavigatorUtils.goForgetPwd(context);
                //     })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCodeStr() {
    setState(() {
      _randomStr = '';
      for (int i=0;i<10;i++) {
        _randomStr = _randomStr + Random().nextInt(9).toString();
      }
    });
  }

  void login() async {
    String name = _unameController.text.trim();
    String pwd = _pwdController.text.trim();
    String code = _codeController.text.trim();

    ///通过 redux 去执行登录流程
    StoreProvider.of<GSYState>(context).dispatch(LoginAction(context, name, pwd, code, _randomStr));

    ///for test
    // NavigatorUtils.goMain(context);
    // NavigatorUtils.pop(context);
  }
}
