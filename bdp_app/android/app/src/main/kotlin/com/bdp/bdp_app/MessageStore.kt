package com.bdp.bdp_app

class MessageStore {
    private val messages: MutableList<Message> = ArrayList()

    fun storeMessage(message: Message) {
        messages.add(message)
    }

    fun getMessagesFor(id: String): List<Message> {
        val groupId = id.toLongOrNull()
        return if (groupId != null) {
            messages.filter { it.groupId == groupId}
        } else {
            messages.filter { it.senderId == id && it.groupId == 0L}
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