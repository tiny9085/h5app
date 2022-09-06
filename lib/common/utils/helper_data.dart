import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CommonData {
  // 数据
  static MediaQueryData queryData = (MediaQueryData.fromWindow(window));

  // 获取屏幕size
  static final Size size = (queryData.size);

  // 屏幕高
  static double screenH = (size.height);

  // 屏幕宽
  static double screenW = (size.width);

  // 像素密度
  static double devicePixelRatio = (queryData.devicePixelRatio);

  // 状态栏高度
  static final double statusH = (queryData.padding.top);

  // 底部安全高度
  static final double bottomH = (queryData.padding.bottom);

  // 导航栏与状态栏高度
  static double navAndStatusH = (navH + statusH);

  // 视图安全高度
  static final double viewSafeH = (size.height - bottomH - navAndStatusH);

  // 视图高度
  static final double viewH = (size.height - navAndStatusH);

  // 导航栏高度
  static final double navH = 44.0;

  // 获取真实宽度
  static double getRealViewW(double width) {
    // 根据设计图 iphone6的尺寸 750
    return (width * screenW) / 750;
  }

  // 获取size的宽
  static double getRealSizeW(Size size, double height) {
    return (height * size.width) / size.height;
  }

  // 获取size的高
  static double getRealSizeH(Size size, double width) {
    return (width * size.height) / size.width;
  }
}
