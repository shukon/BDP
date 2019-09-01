package com.bdp.bdp_app

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.flutter.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.view.FlutterView

class FlutterInformer (flutterView: FlutterView){
    private var messageReceivedSink: EventChannel.EventSink? = null
    private var messageStatusSink: EventChannel.EventSink? = null
    private var connectionStatusSink: EventChannel.EventSink? = null
    private val gson: Gson = GsonBuilder().create()

    init {
        EventChannel(flutterView, "com.bdp.bdp_app/message-received").setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventChannel.EventSink) {
                        Log.w("TAG", "adding message listener")
                        messageReceivedSink = events
                    }

                    override fun onCancel(args: Any?) {
                        Log.w("TAG", "cancelling message listener")
                        messageReceivedSink = null
                    }
                }
        )
        EventChannel(flutterView, "com.bdp.bdp_app/message-status").setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventChannel.EventSink) {
                        Log.w("TAG", "adding message status listener")
                        messageStatusSink = events
                    }

                    override fun onCancel(args: Any?) {
                        Log.w("TAG", "cancelling message status listener")
                        messageStatusSink = null
                    }
                }
        )
        EventChannel(flutterView, "com.bdp.bdp_app/connection-status").setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                        Log.i("TAG", "adding connection listener")
                        connectionStatusSink = events
                    }

                    override fun onCancel(args: Any?) {
                        Log.i("TAG", "cancelling connection listener")
                        connectionStatusSink = null
                    }
                }
        )
    }

    fun notifyMessage(message: Message) {
        this.messageReceivedSink?.success(gson.toJson(message))
    }

    fun notifyMessageStatus(params: Map<String, String>
    ) {
        this.messageStatusSink?.success(gson.toJson(params))
    }

    fun notifyConnectionStatus(status: Int) {
        this.connectionStatusSink?.success(status)
    }
}