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
    MethodChannel(flutterView, "com.bdp.bdp_app/mesibo").setMethodCallHandler { call, result ->
      when (call.method) {
        "login" -> {
          val email = call.argument<String>("email")
          email?.let {
            val loggedIn = mesiboApi?.login(it) ?: false
            if (loggedIn)
              return@setMethodCallHandler result.success(loggedIn)
          }
          result.error("FAILED", "Could not log in", null)
        }
        // Send message to destination
        // If destination is a Long, it is interpreted as a group message, otherwise it is a 1 on 1 message
        "send-message" -> {
          val message = call.argument<String>("message")
                  ?: return@setMethodCallHandler result.error("FAILED", "No message specified", null)
          val destination = call.argument<String>("destination")
                  ?: return@setMethodCallHandler result.error("FAILED", "No destination specified", null)
          mesiboApi?.sendMessage(message, destination)
        }
        else -> result.notImplemented()
      }
    }
  }
}
