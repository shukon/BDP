import 'package:flutter/material.dart';
import 'package:bdp_app/chat/ChatMessage.dart';
import 'package:bdp_app/chat/ChatScreen.dart';



class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat App"),
        ),
        body: new ChatScreen()
    );
  }
}

