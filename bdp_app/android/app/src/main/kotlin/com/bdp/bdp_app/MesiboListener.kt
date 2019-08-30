package com.bdp.bdp_app

import com.mesibo.api.Mesibo
import io.flutter.Log

class MesiboListener (private val flutterInformer: FlutterInformer):
        Mesibo.MessageListener, Mesibo.ConnectionListener {

    override fun Mesibo_onConnectionStatus(status: Int) {
        val text = "on Mesibo Connection: $status"
        Mesibo.STATUS_ACTIVITY
        Log.w("TAG", text)
    }

    override fun Mesibo_onMessage(params: Mesibo.MessageParams, data: ByteArray): Boolean {
        val dataString = String(data)
        Log.e("TAG", "on Mesibo Message: $params and $dataString")
        flutterInformer.notifyMessage(params, dataString)
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