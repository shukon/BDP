import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  RoomsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  Future _roomsButtonPressed() async {
    Navigator.pushNamed(context, "chat");
  }

  _backButtonPressed() {
    setState(() {
      Navigator.pop(context);
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
            Text("rooms page"),
            RaisedButton(
                child: Text("Abmelden"),
                onPressed: () {
                  _backButtonPressed();
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _roomsButtonPressed,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}




