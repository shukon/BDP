package com.bdp.bdp_app

import android.os.Bundle
import io.flutter.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  var mesiboApi: MesiboApi? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    Log.w("TAG", "Starting Android")
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    mesiboApi = MesiboApi(MesiboListener(FlutterInformer(flutterView)), this)
    setupMethodChannels()
  }

  private fun setupMethodChannels() {
    MethodChannel(flutterView, "com.bdp.bdp_app/login").setMethodCallHandler { call, result ->
      val email = call.argument<String>("email")
      email?.let {
        val loggedIn = mesiboApi?.login(it) ?: false
        if (loggedIn)
          return@setMethodCallHandler result.success(loggedIn)
      }
      result.error("FAILED", "Could not log in", null)
    }
  }
}
