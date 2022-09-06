import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_assistant/common/utils/helper_data.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';

// MARK 自定义导航栏
// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.opacity = 1.0,
    this.brightness = SystemUiOverlayStyle.dark,
    this.sapce = 5.0,
    this.titleText = '',
    this.title,
    this.backgroundColor,
    this.background,
    this.actionsMaxW,
    this.leftActions,
    this.rightActions,
  })  : assert(height == null || height > CommonData.navAndStatusH, '导航栏高度最小为${CommonData.navAndStatusH}'),
        super(key: key);

  //状态栏文字样式
  SystemUiOverlayStyle brightness;

  //高度
  double? height;

  //屏幕两边空隙
  double sapce;

  //透明度
  double opacity;

  //中间视图
  Widget? title;

  //中间标题
  String titleText;

  //背景视图
  Widget? background;

  //背景颜色
  Color? backgroundColor;

  //默认 _actionW * count 如果超过需要设置
  double? actionsMaxW;

  //按钮集合
  List<Widget>? leftActions;
  List<Widget>? rightActions;

  @override
  Widget build(BuildContext context) {
    //配置视图
    return _handleWidget(context);
  }

  /// MARK:处理组件
  //  @LastEditors:
  //  @Version: 版本号, YYYY-MM-DD
  //  @param {type}
  //  @return:
  //  @Deprecated: 否
  //  备注
  Widget _handleWidget(BuildContext context) {
    double _actionW = 48.0;

    //数据处理
    //背景视图
    // Widget _background = this.background;
    Widget _background;
    if (background == null) {
      _background = Container(
        color: (this.backgroundColor != null) ? this.backgroundColor : Colors.white,
        child: null,
      );
    } else {
      _background = this.background!;
    }

    //透明度（0 ～ 1）
    double _opacity = max(min(this.opacity, 1), 0);

    //事件宽度
    double _actionsMaxW;
    //左侧组件集合
    List<Widget>? _leftActions = this.leftActions;
    //默认左侧返回按钮
    if (_leftActions == null && NavigatorUtils.canPop(context)) {
      _leftActions = [_getNavBack(context)];
    }

    int count = 0;
    if (_leftActions != null) {
      //取出有多少个按钮
      count = max(_leftActions.length, (this.rightActions != null) ? this.rightActions!.length : 0);
    }
    if (null == actionsMaxW) {
      //默认
      _actionsMaxW = count * _actionW;
    } else {
      _actionsMaxW = actionsMaxW!;
    }

    //中间组件
    Widget _title;
    if (null == title) {
      _title = Container(
        alignment: Alignment.center,
        child: Text(
          titleText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff333333),
            fontSize: 18,
          ),
        ),
      );
    } else {
      _title = this.title!;
    }

    // 返回组件
    return Opacity(
      opacity: _opacity,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        child: Stack(
          children: <Widget>[
            //底部背景
            Container(
              height: this.preferredSize.height,
              child: _background,
            ),
            //上方内容
            Container(
              height: CommonData.navH,
              margin: EdgeInsets.only(
                top: this.preferredSize.height - CommonData.navH,
                left: this.sapce,
                right: this.sapce,
              ),
              child: Row(
                children: <Widget>[
                  //左边
                  Container(
                    width: _actionsMaxW,
                    child: _leftActions == null ? null : Row(children: _leftActions),
                  ),

                  //中间视图
                  Expanded(
                    child: _title,
                  ),

                  //右边
                  Container(
                    width: _actionsMaxW,
                    child: (null == rightActions) ? null : Row(children: rightActions!),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Divider(height: 1.0, color: Color(0xFFEEEEEE)),
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
            ),
          ],
        ),
        value: this.brightness,
      ),
    );
  }

  /// MARK:导航栏按钮
  //  @LastEditors:
  //  @Version: 版本号, YYYY-MM-DD
  //  @param {type}
  //  @return:
  //  @Deprecated: 否
  //  备注
  Widget _getNavBack(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 48.0,
        height: 48.0,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10.0),
        child: Image.asset(
          'assets/images/ic_top_back_grey.png',
          width: 18.0,
          height: 18.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(max(CommonData.navAndStatusH, ((this.height == null) ? 0 : this.height!)));
}
