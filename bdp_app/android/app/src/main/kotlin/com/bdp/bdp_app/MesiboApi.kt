package com.bdp.bdp_app

import android.content.Context
import android.os.AsyncTask
import com.mesibo.api.Mesibo
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject


class MesiboApi(private val mesiboListener: MesiboListener, private val context: Context) {
  internal var token: String = ""

  fun login(email: String): Boolean {
    val url = "https://api.mesibo.com/api.php?token=i1tazh3do9atrbozm0xojobku10ggi6zmtzmpytc6otoqs4thy3od3t1ef49a8ob&op=useradd&appid=com.bdp.bdp_app&addr=$email"
    LoginTask(this).execute(url)
    return true
  }

  fun startMesibo() {


    val api = Mesibo.getInstance()
    api.init(this.context)

    Mesibo.addListener(this.mesiboListener)

    // set user authentication token obtained by creating user
    Mesibo.setAccessToken(token)
    Mesibo.start()
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

  override fun onPostExecute(result: String?) {
    result?.let {
      mesiboApi.token = it
      mesiboApi.startMesibo()
    }
  }
}