import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/widget/confirm_btn.dart';
import 'package:smart_assistant/widget/custom_appbar.dart';
import 'package:flutter/services.dart';

class FeedbackPage extends StatefulWidget {
  static final String sName = "feedback";

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _inputController = new TextEditingController();
  int? count;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            appBar: CustomAppBar(
              titleText: '意见反馈',
              // actionsMaxW: 70,
              // rightActions: [
              //   GestureDetector(
              //     child: Text('反馈列表'),
              //     onTap: () {
              //       Navigator.pushNamed(context, FeedbackListPage.sName);
              //     },
              //   )
              // ],
            ),
            body: Container(
                color: Color(0xffF4F4F4),
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/images/bg_login_banner.png',
                            width: double.infinity,
                            fit: BoxFit.fill,
                          )),
                      Card(
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '欢迎使用药店管家APP，如果您有任何的建议或在使用过程中任何的问题，烦请及时反馈，药店管家将尽快与您联系。',
                                  style: TextStyle(fontSize: 12.0, color: Color(0xff888888)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: [
                                      Text('*', style: TextStyle(color: Color(0xffFF6565), fontSize: HCYYConstant.smallTextSize)),
                                      Text(
                                        '售后QQ',
                                        style: HCYYConstant.labelText,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            '582450121',
                                            style: TextStyle(fontSize: 14.0, color: Color(0xffFF6565)),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: '582450121'));
                                          Fluttertoast.showToast(msg: 'QQ号已经复制到粘贴板', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                                        },
                                        child: Text(
                                          '+加好友',
                                          style: TextStyle(fontSize: 14.0, color: HCYYColor.blue_6d),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      Card(
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            child: TextFormField(
                                style: TextStyle(color: Color(0xff666666), fontSize: 14.0),
                                controller: _inputController,
                                maxLength: 140,
                                maxLines: 4,
                                cursorColor: HCYYColor.primaryColor,
                                decoration: InputDecoration(
                                  hintText: '快和小慧说说吧',
                                  hintStyle: TextStyle(fontSize: 14.0, color: Color(0xffbbbbbb)),
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
                                  return v!.trim().length > 0 ? null : '请输入内容';
                                }),
                          )),
                      ConfirmBtn('提交', () {
                        RepositoryDao.feedback(_inputController.text).then((res) {
                          if (res != null && res.result) {
                            Fluttertoast.showToast(msg: '感谢您提出的宝贵意见', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                            NavigatorUtils.pop(context);
                          }
                        });
                      }),
                    ],
                  ),
                ))),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        behavior: HitTestBehavior.opaque);
  }
}
