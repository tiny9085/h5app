import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_assistant/common/event/index.dart';
import 'package:smart_assistant/common/utils/helper_data.dart';
import 'package:smart_assistant/common/utils/jsbridge/js_bridge.dart';
import 'package:smart_assistant/model/CommonDataEvent.dart';
import 'package:smart_assistant/widget/cus_behavior.dart';
import 'package:smart_assistant/widget/custom_appbar.dart';
import 'package:ai_barcode/ai_barcode.dart';

class ScanPage extends StatefulWidget {
  static final String sName = "scan";

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  late ScannerController _scannerController;
  final JsBridge _jsBridge = JsBridge();

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      print('scan result==>$result');

      //发送监听
      eventBus.fire(CommonDataEvent(result));

      Navigator.pop(context);//返回上一页面
    }, scannerViewCreated: () {

      _requestMobilePermission();//请求权限

    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_scannerController.isStartCameraPreview) {
      _scannerController.stopCameraPreview();
    }
    if (_scannerController.isStartCamera) {
      _scannerController.stopCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '扫一扫',
      ),
      body: Container(
        color: Colors.black26,
        width: CommonData.screenW,
        height: CommonData.screenH,
        child: PlatformAiBarcodeScannerWidget(
          platformScannerController: _scannerController,
        ),
      ),
    );
  }

  void _requestMobilePermission() async {
    if (await Permission.camera.request().isGranted) {
      print('获取相机权限成功');

      if (Platform.isIOS) {
        Future.delayed(Duration(seconds: 2), () {
          if (!_scannerController.isStartCamera) {
            _scannerController.startCamera();
          }
          if (!_scannerController.isStartCameraPreview) {
            _scannerController.startCameraPreview();
          }
        });
      } else {
        if (!_scannerController.isStartCamera) {
          _scannerController.startCamera();
        }
        if (!_scannerController.isStartCameraPreview) {
          _scannerController.startCameraPreview();
        }
      }
    } else {
      print('获取相机权限失败');
    }
  }
}
