package com.hengchang.smart_assistant

import android.content.Context
import io.flutter.embedding.android.FlutterActivity

import com.jarvanmo.rammus.RammusPlugin
import io.flutter.app.FlutterApplication

class MyApplication:FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        RammusPlugin.initPushService(this)
    }


    companion object{

        fun getContext(): Context {
            return getContext();
        }
    }

}
