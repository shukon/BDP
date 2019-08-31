import 'package:flutter/material.dart';
import 'ChatMessage.dart';
import 'package:flutter/services.dart';


class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = new TextEditingController();
  final List<ChatMessage> _messages= <ChatMessage>[];

  static const platform = const EventChannel("com.bdp.bdp_app/message-received");

  Future<void> _getMessages() async {
    try {
      await _messages.insert(0, new ChatMessage("pc", text: platform.receiveBroadcastStream().toString()));
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }



  void _handleSubmit(String text) {
    textEditingController.clear();
    ChatMessage chatMessage = new ChatMessage("stefhan", text: text);
    //TODO: send message on mesibo
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
    _getMessages();
    return new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (content ,int index){
                //if message is from myself, print on right side, else on left side
                if (_messages[index].getName() == "stefan") {
                  return new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[_messages[index]]);
                } else{
                  return _messages[index];
                }
                },
              itemCount: _messages.length,

            ),
          ),
          new Divider(height: 1.0,),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _textComposerWidget(),
          )
        ],
      );
  }
}
