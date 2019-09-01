import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bdp_app/chat/ChatMessage.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.username, this.chat}) : super(key: key);
  final String username;
  final Map chat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController =
      new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<String> _messageIdsPending = <String>[];

  static const mesiboMethodChannel =
      const MethodChannel("com.bdp.bdp_app/mesibo");
  static const messageListener =
      const EventChannel("com.bdp.bdp_app/message-received");
  static const messageStatusListener =
      const EventChannel("com.bdp.bdp_app/message-status");
  static const connectionListener =
      const EventChannel("com.bdp.bdp_app/connection-status");

  Future<void> _setConnectionStatus() async {
    // gets connection status from mesibo
    try {
      var status =
          await mesiboMethodChannel.invokeMethod('get-connection-status');
      _connectionStatus = status;
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }

  int _connectionStatus;

  @override
  void initState() {
    _getMessages();
    _listenConnectionStatus();
    _setConnectionStatus();
    _listenMessageStatus();
    super.initState();
  }

  bool _listenConnectionStatus() {
    connectionListener.receiveBroadcastStream().listen((dynamic event) {
      print("Connection status changed!");
      print(event);
      _connectionStatus = event;
      //hierdurch wird build ausgeführt
      setState(() {});
    }, onError: (dynamic error) {
      print(error);
    });
  }

  void _listenMessageStatus() {
    messageStatusListener.receiveBroadcastStream().listen((dynamic event) {
      print("Message status changed!");
      print(event);
      if (_messageIdsPending.contains(event["id"])) {
        _messageIdsPending.remove(event["id"]);
      }
    }, onError: (dynamic error) {
      print(error);
    });
  }

  void _getMessages() {
    //warte auf neue Nachricht aus dem Netzwerk
    messageListener.receiveBroadcastStream().listen((dynamic event) {
      print("Messages detected by listener!");
      print(event);
      var message = jsonDecode(event);
      _messages.insert(
          0,
          new ChatMessage(
              username: widget.username,
              icon: widget.chat["icon"],
              sendername: message["senderName"],
              text: message["text"]));

      //hierdurch wird build ausgeführt
      setState(() {});
    }, onError: (dynamic error) {
      print(error);
    });
  }

  int _sendMessage(String message, String destination) {
    print("Trying to send message " + message + " TO: " + destination);
    try {
      var id = mesiboMethodChannel.invokeMethod(
          'send-message', {"message": message, "destination": destination});
      _messageIdsPending.add(id.toString());
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
    print("Message probably sent.");
  }

  void _handleSubmit(String text) {
    textEditingController.clear();
    print("Widget username: " + widget.username);
    ChatMessage chatMessage = new ChatMessage(
        username: widget.username,
        icon: widget.chat["icon"],
        sendername: widget.username,
        text: text);
    _sendMessage(text, widget.chat["name"]);
    setState(() {
      //used to rebuild our widget
      _messages.insert(0, chatMessage);
    });
  }

  Widget _textComposerWidget() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(
                    hintText: "Enter your message"),
                controller: textEditingController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmit(textEditingController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setConnectionStatus();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chat["name"]),
          backgroundColor: (_connectionStatus == 1) ? Colors.green : Colors.red,
          flexibleSpace:
              Text("Connection status: " + _connectionStatus.toString()),
        ),
        body: Center(
            child: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (content, int index) {
                  //if message is from myself, print on right side, else on left side
                  if (_messages[index].getSenderName() == widget.username) {
                    return new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[_messages[index]]);
                  } else {
                    return _messages[index];
                  }
                },
                itemCount: _messages.length,
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _textComposerWidget(),
            )
          ],
        )));
  }
}
