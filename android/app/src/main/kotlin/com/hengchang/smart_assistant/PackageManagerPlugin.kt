package com.hengchang.smart_assistant

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

class PackageManagerPlugin: FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
        // 声明通道，第二个参数 name 要和 Flutter 中定义的通道名称保持一致
        var channel = MethodChannel(binding.getBinaryMessenger(), "com.hcyy.jygw/userdefault");
        channel.setMethodCallHandler { call, result -> {
            if (call.method.equals("checkNotificationStatus")) {
                var isOpen = NotificationsUtils.isNotificationEnabled(MyApplication.getContext())
                if (isOpen) {
                    print("通知为打开")
                } else {
                    print("通知为关闭")
                }
                result.success(isOpen)
            } else if (call.method.equals("jumpToAppSettings")) {

            }
        }}
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }

}