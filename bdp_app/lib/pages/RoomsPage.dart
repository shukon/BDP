import 'dart:convert';

import 'package:bdp_app/chat/ChatMessage.dart';
import 'package:flutter/material.dart';

import 'package:bdp_app/pages/ChatPage.dart';
import 'package:flutter/services.dart';

class RoomsPage extends StatefulWidget {
  RoomsPage({Key key, this.username}) : super(key: key);
  final String username;

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {

  final _tabs = <Widget>[
    Tab(icon: Icon(Icons.camera_alt)),
    Tab(text: 'CHATS'),
    Tab(text: 'STATUS'),
    Tab(text: 'CALLS'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        initialIndex: 1,
        child: Scaffold(
            appBar: AppBar(
              title: Text("BDP Test App"),
              bottom: TabBar(tabs: _tabs),
            ),
            // body (tab views)
            body: TabBarView(
              children: <Widget>[
                Text('camera'),
                ChatList(username: widget.username),
                Text('status'),
                Text('calls'),
              ],
            )));
  }
}

List<Map<String, Object>> getChatData(String user) {
  return [{
    'avatar': Icon(Icons.person),
    'name': 'stefan',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }, {
    'avatar': Icon(Icons.settings),
    'name': 'thorsten',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }, {
    'avatar': Icon(Icons.cake),
    'name': 'shuki',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }, {
    'avatar': Icon(Icons.group),
    'name': 'appsperten',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
    'groupId': '22225'
  }
  ];
}

class ChatList extends StatefulWidget {
  ChatList({Key key, this.username}) : super(key: key);
  final String username;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    _listenForMessages();
    super.initState();
  }

  // save all messages here in live context
  final Map<String, List<ChatMessage>> _messages = Map();

  // Mesibo event channels
  static const messageListener = const EventChannel("com.bdp.bdp_app/message-received");


  void _listenForMessages() {
    // Listener for new messages todo can we use listener from parent?
    messageListener.receiveBroadcastStream().listen((dynamic event) {
      print("Messages detected by listener!" + event);
      var message = jsonDecode(event);
      message = new ChatMessage(
          username: widget.username,
          sendername: message["senderName"],
          chatID: message["senderName"],  // todo because chatMessages are local
          text: message["text"],
          groupId: (message["groupId"] == null) ? "" : message["groupId"].toString(),
          sentTime: DateTime.now().toString().substring(11,16) //todo: this is actually not sent Time but received time. do we want that?
      );

      newMessage(message);

      //hierdurch wird build ausgeführt
      setState(() {});
    }, onError: (dynamic error) {
      print(error);
    });
  }


  void newMessage(chatMessage) {
    //if message is not a group message
    if(chatMessage.groupId == "") {
      // Create new list in map if conversation doesnt exist locally
      if (!_messages.containsKey(chatMessage.chatID)) {
        _messages[chatMessage.chatID] = new List<ChatMessage>();
      }
      _messages[chatMessage.chatID].insert(
          0,
          chatMessage);
      print("new" + _messages.toString());
    }
    //if message IS a group message
    else{
      if (!_messages.containsKey(chatMessage.groupId)) {
        _messages[chatMessage.groupId] = new List<ChatMessage>();
      }
      _messages[chatMessage.groupId].insert(
          0,
          chatMessage);
      print("new group message" + _messages.toString());
    }
    //hierdurch wird build ausgeführt
    setState(() {});
  }

  List<ChatMessage> getMessages(chatID) {
    print("Get" + _messages.toString());
    if (_messages.containsKey(chatID)) {
      return _messages[chatID];
    } else {
      return new List<ChatMessage>();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _chatItems = getChatData(widget.username);

    return ListView.builder(
      itemCount: _chatItems.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(_chatItems[index]['name']),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatPage(username: widget.username,
                    chat: _chatItems[index],
                    notifyParentNewMsg: newMessage,
                    getMessages: getMessages); // passing data to chat room
              }));
            });
      },
    );
  }
}
