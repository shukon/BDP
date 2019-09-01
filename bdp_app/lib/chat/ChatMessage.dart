import 'package:flutter/material.dart';
import 'package:bdp_app/chat/bubble.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({Key key, this.username, this.icon, this.sendername, this.destination, this.chatID, this.text})
      : super(key: key);
  final String username;
  final Icon icon;
  final String sendername;
  final String destination;
  final String chatID;
  final String text;
  final String sentTime = "23:55";
  final bool received = true;

  String getSenderName() {
    return sendername;
  }

  @override
  Widget build(BuildContext context) {
    print("Username = " +
        username +
        " Sendername = " +
        sendername +
        " text = " +
        text);

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
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 0.8)),
                new Container(
                    //margin: const EdgeInsets.only(top: 5.0),
                    constraints: BoxConstraints(maxWidth: 200),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Bubble(
                            child: Text(
                              text,
                              maxLines: 20,
                            ),
                            nip: BubbleNip.rightTop),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(sentTime,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 0.5)),
                            new Icon(received ? Icons.done_all : Icons.done,
                                size: 10.0)
                          ],
                        )
                      ],
                    )),
              ],
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: new CircleAvatar(
                child: icon,
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
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 0.8)),
                new Container(
                    //margin: const EdgeInsets.only(top: 5.0),
                    constraints: BoxConstraints(maxWidth: 200),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Bubble(
                            child: Text(
                              text,
                              maxLines: 20,
                            ),
                            nip: BubbleNip.leftTop),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(sentTime,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 0.5)),
                            new Icon(received ? Icons.done_all : Icons.done,
                                size: 10.0)
                          ],
                        )
                      ],
                    )),
              ],
            )
          ],
        ),
      );
    }
  }
}
