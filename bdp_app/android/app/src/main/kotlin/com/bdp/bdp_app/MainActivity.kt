package com.bdp.bdp_app

import android.os.Bundle
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.flutter.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  private var mesiboApi: MesiboApi? = null
  private val messageStore = MessageStore()
  private val gson: Gson = GsonBuilder().create()
  override fun onCreate(savedInstanceState: Bundle?) {
    Log.w("TAG", "Starting Android")
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    mesiboApi = MesiboApi(MesiboListener(FlutterInformer(flutterView), messageStore), this)
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
        "logout" -> {
          mesiboApi?.logout()
          result.success(true)
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
        "get-conversations" -> {
          val conversationIds = messageStore.getConversationIds()
          result.success(gson.toJson(conversationIds))
        }
        "get-messages" -> {
          val id = call.argument<String>("id")
          id?.let {
            val messages = messageStore.getMessagesFor(id)
            return@setMethodCallHandler result.success(gson.toJson(messages))
          }
          result.error("FAILED", "No id specified", null)
        }
        "create-group" -> {
          val name = call.argument<String>("name")
          name?.let {
            mesiboApi?.createGroup("name")
            return@setMethodCallHandler result.success(true)
          }
          result.error("FAILED", "No group name specified", null)
        }
        "add-from-group" -> {
          val group = call.argument<String>("groupId")
                  ?: return@setMethodCallHandler result.error("FAILED", "No group id specified", null)
          val user = call.argument<String>("userId")
                  ?: return@setMethodCallHandler result.error("FAILED", "No user id specified", null)
          mesiboApi?.addToGroup(group, user)
        }
        "remove-from-group" -> {
          val group = call.argument<String>("groupId")
                  ?: return@setMethodCallHandler result.error("FAILED", "No group id specified", null)
          val user = call.argument<String>("userId")
                  ?: return@setMethodCallHandler result.error("FAILED", "No user id specified", null)
          mesiboApi?.removeFromGroup(group, user)
        }
        else -> result.notImplemented()
      }
    }
  }
}
