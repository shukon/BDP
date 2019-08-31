package com.bdp.bdp_app

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.flutter.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.view.FlutterView

class FlutterInformer (flutterView: FlutterView){
    private var messageReceivedSink: EventChannel.EventSink? = null
    private val gson: Gson = GsonBuilder().create()

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

    fun notifyMessage(message: Message) {
        this.messageReceivedSink?.success(gson.toJson(message))
    }
}