import 'package:flutter/material.dart';
import 'package:bdp_app/pages/LoginPage.dart';




class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Body',
            ),
          ],
        ),
      ),
    );
  }

  choiceAction(String choice){
    if(choice == Constants.SignOut){
      Navigator.pop(context);


    }
  }
}

class Constants {

  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    SignOut
  ];
}