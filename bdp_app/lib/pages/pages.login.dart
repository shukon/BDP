import 'package:bdp_app/pages/pages.rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

  static const platform = const MethodChannel("com.bdp.bdp_app/login");

  String _username = "";
  String _password = "";

  _LoginPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      setState(() {
        _username = "";
      });
    } else {
      setState(() {
        _username = _usernameFilter.text;
      });
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      setState(() {
        _password = "";
      });
    } else {
      setState(() {
        _password = _passwordFilter.text;
      });
    }
  }

  bool _loginSuccess = false;

  Future<void> _loginMesibo(String username) async {
    try {
      await platform.invokeMethod('login', {"email": username});
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }

  Future _loginButtonPressed() async {
    setState(() {
      // Check if login data is valid: pretty secure at the moment, probably fine for deployment
      var validLogins = {"stefan" : "1234",
                         "shuki" : "aaa",
                         "thorsten" : "passwort"};
      if (validLogins.containsKey(_username) && validLogins[_username] == _password){
        _loginSuccess = true;
      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Benuztername oder Passwort nicht nicht falsch"));
            });
      }
    });
    if (_loginSuccess) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RoomsPage(username : _username); // passing data to chat room
      }));
      _loginMesibo(_username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("BDP Test App"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
            new Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new TextField(
                      controller: _usernameFilter,
                      decoration: new InputDecoration(labelText: 'Username'),
                    ),
                  ),
                  new Container(
                    child: new TextField(
                      controller: _passwordFilter,
                      decoration: new InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                  RaisedButton(
                    child: Text("Anmelden"),
                    color: Colors.deepOrange,
                    onPressed: () {
                      _loginButtonPressed();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




