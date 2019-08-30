package com.bdp.bdp_app

import com.mesibo.api.Mesibo
import io.flutter.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.view.FlutterView

class FlutterInformer (flutterView: FlutterView){
    var messageReceivedSink: EventChannel.EventSink? = null

    init {
        EventChannel(flutterView, "com.bdp.bdp_app/message-received").setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventChannel.EventSink) {
                        Log.w("TAG", "adding listener")
                        messageReceivedSink = events
                    }

                    override fun onCancel(args: Any?) {
                        Log.w("TAG", "cancelling listener")
                        messageReceivedSink = null
                    }
                }
        )
    }

    fun notifyMessage(params: Mesibo.MessageParams, dataString: String) {
        this.messageReceivedSink?.success(dataString)
    }
}