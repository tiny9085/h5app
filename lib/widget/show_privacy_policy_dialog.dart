


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/page/agreement_page.dart';
import 'package:smart_assistant/page/policy_page.dart';

class ShowPrivacyPolicyDialog extends StatefulWidget {


  ShowPrivacyPolicyDialog();

  @override
  _ShowPrivacyPolicyDialogState createState() => _ShowPrivacyPolicyDialogState();

}

class _ShowPrivacyPolicyDialogState extends State<ShowPrivacyPolicyDialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 36.0, right: 36.0),
          decoration: BoxDecoration(
            color: Colors.white,
            //用一个BoxDecoration装饰器提供背景图片
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
             children: [
               Container(
                 height: 40,
                 child: Stack(
                   alignment: AlignmentDirectional.topCenter,
                   children: [
                     Positioned(
                       top: 15.0,
                       child: Text("服务条款和隐私保护提示",
                           style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.none, fontSize: 16.0, color: Color(0xff333333))),
                     ),
                     Positioned(
                       top: 20.0,
                       right: 0.0,
                       child: GestureDetector(
                           behavior: HitTestBehavior.opaque,
                           child: Container(
                             width: 50.0,
                             height: 20.0,
                             alignment: Alignment.topCenter,
                             child: Image.asset(
                               "assets/images/ic_close.png",
                               width: 12.0,
                               height: 12.0,
                             ),
                           ),
                           onTap: () {
                             NavigatorUtils.pop(context);
                           }),
                     )
                   ],
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(top: 21),
                  padding: EdgeInsets.only(left: 18,right: 18),
                  child: RichText(
                      text: TextSpan(
                        text: '欢迎您使用药店管家\n\n',
                        style: TextStyle(color: Color(0xff333333),fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: '在使用我们的产品和服务之前，请您先阅读并了解完整版的'
                          ),
                          TextSpan(
                            text: '《药店管家用户协议》',
                            style: TextStyle(color: Color(0xff3A7CFD),fontSize: 14.0),
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              Navigator.pushNamed(context, AgreementPage.sName);
                            }
                          ),
                          TextSpan(
                            text: '《药店管家隐私政策》\n',
                            style: TextStyle(color: Color(0xff3A7CFD),fontSize: 14.0),
                              recognizer: TapGestureRecognizer()..onTap = () async {
                                Navigator.pushNamed(context, PolicyPage.sName);
                              }
                          ),
                          TextSpan(
                            text: '我们将严格按照，上述协议为您提供服务，保护您的信息安全，'
                                '点击“同意”即表示您已阅读并同意全部条款，可以继续使用我们的产品和服务。'
                          )
                        ]
                      ),
                  ),
               ),
               Row(

                 children: [
                   Expanded(
                       child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(top: 6, bottom: 6),
                          margin: EdgeInsets.only(
                              left: 19, right: 13, bottom: 33, top: 20),
                          child: Text(
                            '退出',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0, color: Color(0xff9466FF)),
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xffE7E7FE),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                        ),
                        onTap: () {
                          //退出
                          NavigatorUtils.pop(context);
                        })),
                   Expanded(
                       child: GestureDetector(
                         child: Container(
                           padding: EdgeInsets.only(top: 6,bottom: 6),
                           margin: EdgeInsets.only(left: 13,right: 17,bottom: 33,top: 20),
                           child: Text(
                             '同意',
                             textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 14.0, color: Color(0xffFFFFFF)),
                           ),
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               begin: Alignment.centerLeft,
                               end: Alignment.centerRight,
                               colors: [
                                 Color(0xff9566FF),
                                 Color(0xff69BEFF),
                               ],
                             ),
                             borderRadius: BorderRadius.all(Radius.circular(50.0))
                           ),
                         ),
                         onTap: (){
                           //同意
                           SPUtil.putString(Config.FIRST_LOGIN, 'true');
                           //退出
                           NavigatorUtils.pop(context);
                         },
                       )
                   ),
                 ],
               )
             ],
          ),
        ),
    );
  }

}