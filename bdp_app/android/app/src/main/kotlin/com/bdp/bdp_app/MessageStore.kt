package com.bdp.bdp_app

import android.content.Context
import android.os.AsyncTask
import androidx.room.*
import java.util.*

class MessageStore(private val messageDao: MessageDao?) {

    internal var messages: MutableList<Message> = ArrayList()

    init {
        LoadMessagesTask(messageDao, this).execute()
    }

    fun storeMessage(message: Message) {
        InsertMessageTask(messageDao, this, message)
    }

    fun getMessagesFor(id: String): List<Message> {
        val groupId = id.toLongOrNull()
        return if (groupId != null) {
            messages.filter { it.groupId == groupId}
        } else {
            messages.filter { (it.senderId == id && it.groupId == 0L) || (it.groupId == 0L && it.destination == id)}
        }
    }

    fun getConversationIds(): List<String> {
        return messages
                .map {
                    if (it.groupId != 0L) {
                        it.groupId.toString()
                    } else {
                        it.senderId
                    }
                }
                .distinct()
    }
}

private class LoadMessagesTask(private val messageDao: MessageDao?,
                               private val messageStore: MessageStore): AsyncTask<String, Void, Unit>() {

    override fun doInBackground(vararg params: String) {
        messageDao?.let { messageStore.messages = ArrayList(it.getAll()) }
    }
}

private class InsertMessageTask(private val messageDao: MessageDao?,
                                private val messageStore: MessageStore,
                                private val message: Message): AsyncTask<String, Void, Unit>() {

    override fun doInBackground(vararg params: String) {
        messageDao?.let {
            it.insert(message)
            LoadMessagesTask(messageDao, messageStore).execute()
        }
    }
}



@Entity
data class Message(val text: String,
                   @PrimaryKey val id: Long,
                   val groupId: Long?,
                   val senderId: String,
                   val senderName: String,
                   val destination: String)

@Dao
interface MessageDao {
    @Query("SELECT * FROM message")
    fun getAll(): List<Message>

    @Insert
    fun insert(message: Message)
}

@Database(entities = [Message::class], version = 1, exportSchema = false)
abstract class MessageDatabase : RoomDatabase(){
    abstract fun messageDao() : MessageDao

    companion object {

        private var INSTANCE : MessageDatabase? = null

        fun getDatabase(context: Context) : MessageDatabase? {
            if (INSTANCE == null)
                INSTANCE = Room.databaseBuilder(context.applicationContext, MessageDatabase::class.java, "message").build()
            return INSTANCE
        }
    }
}