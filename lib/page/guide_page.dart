import 'package:flutter/material.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/widget/confirm_btn.dart';
import 'package:smart_assistant/widget/swiper.dart';

class GuidePage extends StatefulWidget {
  static final String sName = "guide";

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Swiper(
            ['assets/images/pic_guide_1.png', 'assets/images/pic_guide_2.png', 'assets/images/pic_guide_3.png', 'assets/images/pic_guide_4.png', 'assets/images/pic_guide_5.png'],
            showIndicator: true,
            autoplay: false,
            activeColor: Color(0xFF6DB9FF),
            defaultColor: Color(0x336DB9FF),
            indicatorSize: Size(10, 10),
            onTap: (value) {
              print(value);
            },
            height: double.infinity,
          ),
          Positioned(
            child: ElevatedButton(child: Text('立即体验'),onPressed: (){
              NavigatorUtils.goLogin(context);
            },),
            bottom: 30.0,
          )
        ],
      ),
      constraints: new BoxConstraints.expand(),
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg_welcome.png'), fit: BoxFit.fill)),
    ));
  }
}
