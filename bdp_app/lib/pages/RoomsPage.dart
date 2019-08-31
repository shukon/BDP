import 'package:flutter/material.dart';

import 'package:bdp_app/pages/ChatPage.dart';

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
              ChatList(username : widget.username),
              Text('status'),
              Text('calls'),
            ],
          )));
}}

List<Map<String, Object>> getChatData(String user) {
  return [{
    'avatar': Icon(Icons.person),
    'name': 'Stefan',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }, {
    'avatar': Icon(Icons.settings),
    'name': 'Thorsten',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }, {
    'avatar': Icon(Icons.cake),
    'name': 'Shuki',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }, {
    'avatar': Icon(Icons.group),
    'name': 'Appsperten',
    'lastMessage': 'hi there',
    'lastSeen': '2:53 in the afternoon',
  }
  ];
}

class ChatList extends StatelessWidget {
  ChatList({Key key, this.username}) : super(key: key);
  final String username;

  @override
  Widget build(BuildContext context) {
    var _chatItems = getChatData(username);

    return ListView.builder(
      itemCount: _chatItems.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(_chatItems[index]['name']),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatPage(username : username, chatID :_chatItems[index]['name']); // passing data to chat room
              }));
            });
      },
    );
  }
}
