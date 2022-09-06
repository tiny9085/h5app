// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_assistant/widget/animation/custom_animation.dart';

import 'app.dart';
import 'env/config_wrapper.dart';
import 'env/env_config.dart';
import 'env/dev.dart';

void main() {
  runZoned(() {
    // ErrorWidget.builder = (FlutterErrorDetails details) {
    //   Zone.current.handleUncaughtError(details.exception, details.stack);
    //   return ErrorPage(details.exception.toString() + "\n " + details.stack.toString(), details);};
    runApp(ConfigWrapper(
      child: FlutterReduxApp(),
      config: EnvConfig.fromJson(config),
    ));
    // ignore: deprecated_member_use
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  EasyLoading.instance
    // ..displayDuration = const Duration(milliseconds: 2000)
    // ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    // ..loadingStyle = EasyLoadingStyle.dark
    // ..indicatorSize = 45.0
    // ..radius = 10.0
    // ..progressColor = Colors.yellow
    // ..backgroundColor = Colors.green
    // ..indicatorColor = Colors.yellow
    // ..textColor = Colors.yellow
    // ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true;
    // ..dismissOnTap = true;
    // ..customAnimation = CustomAnimation();
}
