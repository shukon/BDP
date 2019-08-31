package com.bdp.bdp_app

import com.mesibo.api.Mesibo
import io.flutter.Log

class MesiboListener (private val flutterInformer: FlutterInformer,
                      private val messageStore: MessageStore):
        Mesibo.MessageListener, Mesibo.ConnectionListener {

    override fun Mesibo_onConnectionStatus(status: Int) {
        val text = "on Mesibo Connection: $status"
        Log.w("TAG", text)
        flutterInformer.notifyConnectionStatus(status)
    }

    override fun Mesibo_onMessage(params: Mesibo.MessageParams, data: ByteArray): Boolean {
        val dataString = String(data)
        Log.e("TAG", "on Mesibo Message: $params and $dataString")
        val groupId = if (params.groupid != 0L) params.groupid else null
        val message = Message(
                text = String(data),
                id = params.mid,
                groupId = groupId,
                senderId = params.profile.address,
                senderName = params.profile.name)
        flutterInformer.notifyMessage(message)
        messageStore.storeMessage(message)
        return true
    }

    override fun Mesibo_onMessageStatus(params: Mesibo.MessageParams) {
        Log.e("TAG", "on Mesibo Message Status: $params")
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

data class Message(val text: String,
                   val id: Long,
                   val groupId: Long?,
                   val senderId: String,
                   val senderName: String)