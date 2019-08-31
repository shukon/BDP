import 'package:flutter/material.dart';
import 'package:bdp_app/chat/bubble.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({Key key, this.username, this.sendername, this.text})
      : super(key: key);
  final String username;
  final String sendername;
  final String text;

  String getSenderName() {
    return sendername;
  }

  @override
  Widget build(BuildContext context) {
    print("Username = " + username + " Sendername = " + sendername + " text = " + text);

    if (username == sendername) {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(sendername,
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Bubble(child: Text(text, maxLines: 20,),  nip: BubbleNip.rightTop, color: Colors.lightGreen),
                  constraints: BoxConstraints(maxWidth: 200),
                )
              ],
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: new CircleAvatar(
                child: new Text(sendername[0]),
              ),
            ),
          ],
        ),
      );
    } else {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                child: new Text(sendername[0]),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(sendername,
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  constraints: BoxConstraints(maxWidth: 200),
                  child: new Bubble(child: Text(text, maxLines: 20,), nip: BubbleNip.leftTop),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
