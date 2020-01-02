import 'package:bdp_app/pages/web_view_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bdp_app/pages/BottomBar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }


  // TODO this should be replaced by a safer method
  String _username = "";
  String _password = "";

  bool _loggedIn = false;

  // For username and password fields
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

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



  Future _loginButtonPressed() async {
    setState(() {
      // TODO Check if login data is valid: pretty secure at the moment, probably fine for deployment
      var validLogins = {
        "stefan": "1234",
        "shuki": "bbb",
        "thorsten": "passwort",
        "marian": "37",
        "sanja": "qwerty",
        "rene": "rene"
      };
      if (validLogins.containsKey(_username) &&
          validLogins[_username] == _password) {
        _loggedIn = true;
      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text(
                      "Benutztername oder Passwort nicht falsch"));
            });
      }
    });

    if (_loggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        _loggedIn = false;
        return BottomBar(); // passing data to chat room
      }));

    }
  }



  @override
  Widget build(BuildContext context) {
    // Appearance changes on login-status
    var appearance = new Column(
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
          },)
          ,
    RaisedButton(
    child: Text("Schnell-Anmelden"),
    color: Colors.deepOrange,
    onPressed: () {
      _username = "shuki";
      _password = "bbb";
    _loginButtonPressed();
    },
        ),
      ],
    );



    return Scaffold(
      appBar: AppBar(
        title: Text("BDP Test App"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            new Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:appearance,
            )
          ],
        ),
      ),
    );
  }
}
