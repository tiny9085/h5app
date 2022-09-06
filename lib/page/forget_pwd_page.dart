import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_assistant/app.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/helper_data.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/widget/confirm_btn.dart';

import 'login_page.dart';

class ForgetPwdPage extends StatefulWidget {
  static final String sName = "forget_pwd";

  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _oldController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _cPwdController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Timer? _timer;
  int remaining = 90;
  bool _isInRemaining = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 组件销毁时判断Timer是否仍然处于激活状态，是则取消
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void _initTimer() {
    _isInRemaining = true;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (t) {
        setState(() {
          if (remaining > 0) {
            remaining--;
          } else {
            _isInRemaining = false;
          }
        });
        if (_timer != null && remaining == 0) {
          _timer?.cancel();
          _timer = null;
          _isInRemaining = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(onInit: (store) {
      _unameController.text = store.state.userInfo?.userInfo?.username ?? '';
    }, builder: (context, store) {
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
                            '忘记密码',
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
                        Positioned(
                            top: 46,
                            left: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                NavigatorUtils.pop(context);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/ic_top_back.png',
                                  width: 18.0,
                                  height: 18.0,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Card(
                        elevation: 0.0,
                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Form(
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text('*', style: TextStyle(color: Color(0xffFF6565), fontSize: HCYYConstant.smallTextSize)),
                                      Container(
                                        child: Text(
                                          '手机号码',
                                          style: HCYYConstant.labelText,
                                        ),
                                        width: 66.0,
                                        margin: EdgeInsets.only(right: 16.0),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                            style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                            controller: _unameController,
                                            cursorColor: HCYYColor.primaryColor,
                                            decoration: InputDecoration(
                                              hintText: '请输入手机号码',
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
                                      )
                                    ],
                                  ),
                                  height: 58.0,
                                ),
                                Divider(height: 1.0, color: Color(0xfff6f6f6)),
                                Container(
                                  child: Row(
                                    children: [
                                      Text('*', style: TextStyle(color: Color(0xffFF6565), fontSize: HCYYConstant.smallTextSize)),
                                      Container(
                                        child: Text(
                                          '原密码',
                                          style: HCYYConstant.labelText,
                                        ),
                                        width: 66.0,
                                        margin: EdgeInsets.only(right: 16.0),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                            style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                            controller: _oldController,
                                            cursorColor: HCYYColor.primaryColor,
                                            decoration: InputDecoration(
                                              hintText: '请输入原密码',
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
                                              return v!.trim().length > 0 ? null : '请输入原密码';
                                            }),
                                      ),
                                    ],
                                  ),
                                  height: 58.0,
                                ),
                                Divider(height: 1.0, color: Color(0xfff6f6f6)),
                                Container(
                                  child: Row(
                                    children: [
                                      Text('*', style: TextStyle(color: Color(0xffFF6565), fontSize: HCYYConstant.smallTextSize)),
                                      Container(
                                        child: Text(
                                          '新密码',
                                          style: HCYYConstant.labelText,
                                        ),
                                        width: 66.0,
                                        margin: EdgeInsets.only(right: 16.0),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                            style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                            obscureText: true,
                                            controller: _pwdController,
                                            cursorColor: HCYYColor.primaryColor,
                                            decoration: InputDecoration(
                                              hintText: '请输入新密码',
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
                                              return v!.trim().length > 0 ? null : '请输入新密码';
                                            }),
                                      )
                                    ],
                                  ),
                                  height: 58.0,
                                ),
                                Divider(height: 1.0, color: Color(0xfff6f6f6)),
                                Container(
                                  child: Row(
                                    children: [
                                      Text('*', style: TextStyle(color: Color(0xffFF6565), fontSize: HCYYConstant.smallTextSize)),
                                      Container(
                                        child: Text(
                                          '确认密码',
                                          style: HCYYConstant.labelText,
                                        ),
                                        width: 66.0,
                                        margin: EdgeInsets.only(right: 16.0),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                            style: TextStyle(color: Color(0xff333333), fontSize: 14.0),
                                            obscureText: true,
                                            controller: _cPwdController,
                                            cursorColor: HCYYColor.primaryColor,
                                            decoration: InputDecoration(
                                              hintText: '请确认输入密码',
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
                                              return v!.trim().length > 0 ? null : '请确认输入密码';
                                            }),
                                      )
                                    ],
                                  ),
                                  height: 58.0,
                                ),
                              ],
                            ),
                            key: _formKey,
                          ),
                        )),
                  ),
                  ConfirmBtn('重置密码', () {
                    if (_formKey.currentState!.validate()) {
                      if (_pwdController.text != _cPwdController.text) {
                        Fluttertoast.showToast(msg: '两次输入密码不一致', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      RepositoryDao.modifyPwd(_unameController.text, _oldController.text, _pwdController.text, _cPwdController.text).then((res) {
                        if (res != null && res.result) {
                          Fluttertoast.showToast(msg: '重置密码成功', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                          //发送监听
                          FlutterReduxApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(LoginPage.sName, ModalRoute.withName("/"));
                        }
                      });
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
