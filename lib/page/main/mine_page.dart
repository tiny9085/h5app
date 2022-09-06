
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/helper_data.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/AppVersionEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/redux/login_redux.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePage extends StatefulWidget {
  static final String sName = 'mine';

  //生命周期函数
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(builder: (context, store) {
      return Scaffold(
        body: Container(
          color: Color(0xffF4F4F4),
          height: double.infinity,
          child: Container(
            child: Stack(
              clipBehavior: Clip.none,
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
                    left: 16.0,
                    top: 56.0,
                    child: Image.asset(
                      'assets/images/ic_default_avatar.png',
                      width: 60.0,
                      height: 60.0,
                    )),
                Positioned(
                    top: 58.0,
                    left: 96.0,
                    child: Text(
                      store.state.userInfo?.userInfo?.username ?? '',
                      style: TextStyle(fontSize: HCYYConstant.normalTextSize, color: Colors.white),
                    )),
                Positioned(
                    top: 94.0,
                    left: 96.0,
                    child: Text(
                      'ID',
                      style: TextStyle(fontSize: HCYYConstant.smallTextSize, color: Color(0x66ffffff)),
                    )),
                Positioned(
                    top: 94.0,
                    left: 118.0,
                    child: Text(
                      '${store.state.userInfo?.userInfo?.id}',
                      style: TextStyle(fontSize: HCYYConstant.smallTextSize, color: Colors.white),
                    )),
                Positioned(
                    top: 136.0,
                    left: 0,
                    right: 0,
                    child: Container(
                      // elevation: 0.0,
                      // shape: new RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                      height: CommonData.screenH-136.0-40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (){
                                    //判断权限
                                    RepositoryDao.checkPermission().then((res) {
                                      if (res != null && res.result) {
                                        NavigatorUtils.goWebView(context, Address.mobileCheck());
                                      } else {
                                        Fluttertoast.showToast(msg: res.data, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 82,
                                    margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/bg_mine_check.png'),
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: (){
                                      //判断权限
                                      RepositoryDao.checkPermission().then((res) {
                                        if (res != null && res.result) {
                                          NavigatorUtils.goWebView(context, Address.reviewerList());
                                        } else {
                                          Fluttertoast.showToast(msg: res.data, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 82,
                                      margin: EdgeInsets.only(top: 30, right: 20),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/images/bg_mine_remote.png'),
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_modify_pwd.png',
                                      width: 16.0,
                                      height: 16.0,
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('修改密码', style: HCYYConstant.labelText),
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
                                NavigatorUtils.goForgetPwd(context);
                              }),
                          Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                NavigatorUtils.goFeedback(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_feedback.png',
                                      width: 16.0,
                                      height: 16.0,
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('意见反馈', style: HCYYConstant.labelText),
                                        )),
                                    Image.asset(
                                      'assets/images/ic_right_arrow.png',
                                      width: 5.0,
                                      height: 10.0,
                                    )
                                  ],
                                ),
                                height: 58.0,
                              )),
                          Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_about_us.png',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('关于我们', style: HCYYConstant.labelText),
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
                              NavigatorUtils.goAboutUs(context);
                            },
                          ),
                          Divider(height: 1.0, color: Color(0xfff6f6f6)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_check_version.png',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('版本更新', style: HCYYConstant.labelText),
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
                              //获取版本
                              RepositoryDao.checkVersion().then((res) async {
                                if (res != null) {
                                  if (res.result) {
                                    AppVersionEntity appVersionEntity = res.data;
                                    if (!await launchUrl(Uri.parse(appVersionEntity.downloadUrl!))) {
                                      throw 'Could not launch ${appVersionEntity.downloadUrl!}';
                                    }
                                  } else {
                                    Fluttertoast.showToast(msg: res.data.toString(), gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                                  }
                                }
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () async {
                              CommonUtils.showConfirmDialog(context, '确认退出吗?', () {
                                store.dispatch(LogoutAction(context));
                              });
                            },
                            child: Container(
                              width: 200,
                              height: 44,
                              margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/bg_mine_signout.png'),
                                    fit: BoxFit.fill,
                                  )
                              ),
                              child: Center(
                                child: Text(
                                  '退出登录',
                                  style: TextStyle(color: Colors.white, fontSize: HCYYConstant.middleTextWhiteSize),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
