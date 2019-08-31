import 'package:flutter/material.dart';



class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _backButtonPressed() {
    setState(() {
      _activePage = "LoginPage";
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BDP Test App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("chatpage"),
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _backButtonPressed();
                }),
          ],
        ),
      ),
    );
  }
}

