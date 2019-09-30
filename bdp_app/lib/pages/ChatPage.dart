import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bdp_app/chat/ChatMessage.dart';
import 'package:flutter/services.dart';
import 'package:bdp_app/chat/emoji_picker.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {Key key,
      this.username,
      this.chat,
      this.notifyParentNewMsg,
      this.getMessages})
      : super(key: key);
  final String username;
  final Map chat;
  final Function(dynamic event) notifyParentNewMsg;
  final Function(String chatID) getMessages;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    _listenForMessages();
    _listenConnectionStatus();
    _setConnectionStatus();
    _listenMessageStatus();
    _messages = widget.getMessages(widget.chat["name"]);
    print("This chat is initialized: " + widget.chat.toString());
    super.initState();
  }

  final TextEditingController textEditingController =
      new TextEditingController();


  //emojis added, open problems remaining
  // TODO: remove/replace not recognizable emojis
  // TODO: cursor jumps to start after adding emoji
  bool _emojiInput = false;

  final List<String> _messageIdsPending = <String>[];

  int _connectionStatus;
  List<ChatMessage> _messages;

  // Mesibo method channel
  static const mesiboMethodChannel =
      const MethodChannel("com.bdp.bdp_app/mesibo");

  // Mesibo event channels
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
      //if (_messageIdsPen
      //          destination: widget.username,
      //          chatID: message["senderName"],  // todo because chatMessages are local ding.contains(event["id"])) {
      //  _messageIdsPending.remove(event["id"]);
      //}
    }, onError: (dynamic error) {
      print(error);
    });
  }

  void _listenForMessages() {
    // Listener for new messages
    messageListener.receiveBroadcastStream().listen((dynamic event) {
      print("Messages detected by listener!" + event);
      var message = jsonDecode(event);
      message = new ChatMessage(
          username: widget.username,
          sendername: message["senderName"],
          destination: widget.username,
          messageId: message["id"].toString(),
          chatID: message["senderName"],
          // todo because chatMessages are local
          groupId:
              (message["groupId"] == null) ? "" : message["groupId"].toString(),
          text: message["text"],
          sentTime: DateTime.now().toString().substring(
              11, 16) //todo: this is actually not sentTime. do we want that?
          );

      widget.notifyParentNewMsg(message);

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
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _emojiInput = false;
    print("Widget username: " + widget.username);
    ChatMessage chatMessage = new ChatMessage(
      username: widget.username,
      icon: widget.chat["icon"],
      sendername: widget.username,
      destination: widget.chat["name"],
      groupId: (widget.chat["groupId"] == null) ? "" : widget.chat["groupId"],
      chatID: widget.chat["name"],
      text: text,
      sentTime: DateTime.now().toString().substring(11, 16),
    ); // todo because chatMessages are local
    _sendMessage(text, widget.chat["name"]);
    setState(() {
      widget.notifyParentNewMsg(chatMessage);
    });
  }

  void _emojiButtonPressed() {

    if (_emojiInput){
      _emojiInput = false;
      setState(() {

      });
      SystemChannels.textInput.invokeMethod('TextInput.show');
    } else {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {

      });

      //added small delay to wait for keyboard collapse, otherwise transition is ugly looking
      Future.delayed(const Duration(milliseconds: 60), ()
      {

        setState(() {
          _emojiInput = true;

        });
      });
    }


  }


  Widget _textComposerWidget() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Container(
              child: new IconButton(
                  icon: new Text("😜"),
                  onPressed: () =>
                  {
                    _emojiButtonPressed()
                  }
              ),
            ),
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(
                    hintText: "Enter your message"),
                controller: textEditingController,
                onTap: () => _emojiInput = false,
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
    _messages = (widget.chat["groupId"] == null)
        ? widget.getMessages(widget.chat['name'])
        : widget.getMessages(widget.chat["groupId"]);
    _setConnectionStatus();

    print("show" + _messages.toString());

    return Scaffold(
        appBar: AppBar(
          title: (widget.chat['groupId'] == null)
              ? Text(widget.chat["name"])
              : Text("Gruppenchat: " + (widget.chat["name"])),
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
            ),
            _emojiInput ? new EmojiPicker(
              rows: 3,
              columns: 7,
              recommendKeywords: ["racing", "horse"],
              numRecommended: 10,
              onEmojiSelected: (emoji, category) {
                //this adds emoji always at the end of the text which is not nice
                textEditingController.text = textEditingController.text + emoji.emoji;

                /* this code would enable emoji input anywhere in the text, but cursorPos does very strange things therefore
                not possible
                var cursorPos = textEditingController.selection;
                textEditingController.text = textEditingController.text.substring(0, cursorPos.start)
                    + emoji.emoji + textEditingController.text.substring(cursorPos.start, textEditingController.text.length);
                */
              },
            ) : new Container(width: 0, height: 0),
          ],
        )));
  }
}
