package com.bdp.bdp_app

import android.os.Bundle
import com.mesibo.api.Mesibo
import io.flutter.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(), Mesibo.MessageListener,
        Mesibo.ConnectionListener {
  var eventSink: EventChannel.EventSink? = null
  private var count: Int = 0
  private var status: String = ""

  override fun onCreate(savedInstanceState: Bundle?) {
    Log.w("TAG", "Starting Android")
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    EventChannel(flutterView, "someStream").setStreamHandler(
            object : EventChannel.StreamHandler {
              override fun onListen(args: Any?, events: EventChannel.EventSink) {
                Log.w("TAG", "adding listener $count $status")
                eventSink = events
              }

              override fun onCancel(args: Any?) {
                Log.w("TAG", "cancelling listener")
                eventSink = null
              }
            }
    )

    val api = Mesibo.getInstance()
    api.init(this)

    Mesibo.addListener(this)

    // set user authentication token obtained by creating user
    Mesibo.setAccessToken("f667e24cacea93ecf80fce9425d5ab6b51978ab1d17a60e7eaa5a549")
    Mesibo.start()
  }

  override fun Mesibo_onConnectionStatus(status: Int) {
    // You will receive the connection status here
    val text = "on Mesibo Connection: $status"
    Log.w("TAG", text)
    count++
    this.status = this.status + status
    Mesibo.STATUS_ACTIVITY
    eventSink?.success(text)
  }

  override fun Mesibo_onMessage(params: Mesibo.MessageParams, data: ByteArray): Boolean {
    val dataString = String(data)
    Log.e("TAG", "on Mesibo Message: $params and $dataString")
    eventSink?.success("Received message")
    return true
  }

  override fun Mesibo_onMessageStatus(params: Mesibo.MessageParams) {
    Log.e("TAG", "on Mesibo Message: $params")
  }

  override fun Mesibo_onActivity(p0: Mesibo.MessageParams?, p1: Int) {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun Mesibo_onLocation(p0: Mesibo.MessageParams?, p1: Mesibo.Location?) {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun Mesibo_onFile(p0: Mesibo.MessageParams?, p1: Mesibo.FileInfo?) {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

}
