package com.bdp.bdp_app

import android.content.Context
import android.os.AsyncTask
import com.mesibo.api.Mesibo
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject


class MesiboApi(private val mesiboListener: MesiboListener, private val context: Context) {
    internal var token: String = ""
    private val baseUrl = "https://api.mesibo.com/api.php?token=i1tazh3do9atrbozm0xojobku10ggi6zmtzmpytc6otoqs4thy3od3t1ef49a8ob&appid=com.bdp.bdp_app"

    fun login(email: String): Boolean {
        val url = "$baseUrl&op=useradd&addr=$email"
        LoginTask(this).execute(url)
        return true
    }

    fun logout() {
        Mesibo.stop(false)
    }


    fun startMesibo() {

        val api = Mesibo.getInstance()
        api.init(this.context)

        Mesibo.addListener(this.mesiboListener)

        // set user authentication token obtained by creating user
        Mesibo.setAccessToken(token)
        Mesibo.setDatabase("", 0)
        Mesibo.start()
    }

    fun readMessages() {
        val readDbSession = Mesibo.ReadDbSession("Test_1", mesiboListener)
        readDbSession.read(100000)
    }

    fun sendMessage(text: String, destination: String) {
        val messageParams = Mesibo.MessageParams()
        val groupid = destination.toLongOrNull()
        if (groupid != null)
            messageParams.groupid = groupid
        else
            messageParams.peer = destination
        Mesibo.sendMessage(messageParams, Mesibo.random(), text)
    }

    fun createGroup(name: String) {
        val expiry = 315360000
        val url = "$baseUrl&op=groupadd&name=$name&expiry=$expiry"
        CreateGroupTask(this).execute(url)
    }

    fun addToGroup(group: String, user: String) {
        val url = "$baseUrl&op=groupeditmembers&delete=0&m=$user&gid=$group"
        ChangeGroupMembershipTask().execute(url)
    }

    fun removeFromGroup(group: String, user: String) {
        val url = "$baseUrl&op=groupeditmembers&delete=1&m=$user&gid=$group"
        ChangeGroupMembershipTask().execute(url)
    }
}

private class LoginTask(val mesiboApi: MesiboApi): AsyncTask<String, Void, String>() {

    override fun doInBackground(vararg params: String): String? {
        return try {
            val client = OkHttpClient()
            val request = Request.Builder()
                    .url(params[0])
                    .build()
            val response = client.newCall(request).execute()
            val resStr = response.body?.string()
            val json = JSONObject(resStr)
            json.getJSONObject("user").getString("token")
        } catch (exception: Exception) {
            exception.printStackTrace()
            null
        }
    }

    override fun onPostExecute(tokenResult: String?) {
        tokenResult?.let {
            mesiboApi.token = it
            mesiboApi.startMesibo()
            mesiboApi.readMessages()
        }
    }
}

private class CreateGroupTask(val mesiboApi: MesiboApi): AsyncTask<String, Void, String>() {

    override fun doInBackground(vararg params: String): String? {
        return try {
            val client = OkHttpClient()
            val request = Request.Builder()
                    .url(params[0])
                    .build()
            val response = client.newCall(request).execute()
            val resStr = response.body?.string()
            val json = JSONObject(resStr)
            json.getJSONObject("group").getString("gid")
        } catch (exception: Exception) {
            exception.printStackTrace()
            null
        }
    }

    override fun onPostExecute(groupIdResult: String?) {
        groupIdResult?.let {
            mesiboApi.sendMessage("Gruppe erstellt", groupIdResult)
        }
    }
}

private class ChangeGroupMembershipTask: AsyncTask<String, Void, String>() {

    override fun doInBackground(vararg params: String): String? {
        return try {
            val client = OkHttpClient()
            val request = Request.Builder()
                    .url(params[0])
                    .build()
            val response = client.newCall(request).execute()
            val resStr = response.body?.string()
            val json = JSONObject(resStr)
            json.getJSONObject("group").getString("gid")
        } catch (exception: Exception) {
            exception.printStackTrace()
            null
        }
    }
}