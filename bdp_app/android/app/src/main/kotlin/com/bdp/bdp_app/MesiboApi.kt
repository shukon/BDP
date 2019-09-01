package com.bdp.bdp_app

import android.os.AsyncTask
import com.mesibo.api.Mesibo
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject

class MesiboApi(private val mesiboListener: MesiboListener,
                private val messageStore: MessageStore) {
    private var userName: String = ""
    private var userId: String = ""
    internal var token: String = ""
    private val baseUrl = "https://api.mesibo.com/api.php?token=i1tazh3do9atrbozm0xojobku10ggi6zmtzmpytc6otoqs4thy3od3t1ef49a8ob&appid=com.bdp.bdp_app"

    fun login(email: String): Boolean {
        val url = "$baseUrl&op=useradd&addr=$email"
        this.userName = email
        this.userId = email
        mesiboListener.userId = email
        LoginTask(this).execute(url)
        return true
    }

    fun logout() {
        Mesibo.stop(false)
    }

    fun startMesibo() {

        Mesibo.addListener(this.mesiboListener)

        // set user authentication token obtained by creating user
        Mesibo.setAccessToken(token)
        Mesibo.start()
    }

    fun sendMessage(text: String, destination: String) : Long {
        val messageParams = Mesibo.MessageParams()
        val groupid = destination.toLongOrNull()
        if (groupid != null)
            messageParams.groupid = groupid
        else
            messageParams.peer = destination
        val id = Mesibo.random()
        Mesibo.sendMessage(messageParams, id, text)
        messageStore.storeMessage(Message(text, id, groupid, this.userId, this.userName, destination))
        return id;
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

    fun getConnectionStatus() : Int {
        return Mesibo.getConnectionStatus();
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