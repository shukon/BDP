import 'package:flutter/material.dart';

String _ownName = "stefan";

String name = "Gast";

class ChatMessage extends StatelessWidget {
  final String text ;
  //for opotional params we use curly braces
  ChatMessage(String author, {this.text}){
    name = author;
  }

  String getName(){
    return name;
  }

  @override
  Widget build(BuildContext context) {
    if (name == _ownName){
    return new Container(

      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name,style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              )

            ],
          ),
          new Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: new CircleAvatar(
              child: new Text(name[0]),
            ),
          ),
        ],
      ),
    );}else{
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                child: new Text(name[0]),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(name,style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
