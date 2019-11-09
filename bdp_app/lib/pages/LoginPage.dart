import 'package:bdp_app/pages/RoomsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  // Invoking methods in mesibo works over this channel - in this case we need to log in and log out
  static const mesiboMethodChannel =
      const MethodChannel("com.bdp.bdp_app/mesibo");

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

  Future<void> _loginMesibo(String username) async {
    try {
      await mesiboMethodChannel.invokeMethod('login', {"email": username});
      print("Successfully logged in as " + username);
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }

  Future<void> _logoutMesibo() async {
    try {
      await mesiboMethodChannel.invokeMethod('logout');
      print("Successfully logged out");
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }

  Future _loginButtonPressed() async {
    setState(() {
      // TODO Check if login data is valid: pretty secure at the moment, probably fine for deployment
      var validLogins = {
        "stefan": "1234",
        "shuki": "aaa",
        "thorsten": "passwort",
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
                      "Benuztername oder Passwort nicht nicht falsch"));
            });
      }
    });

    if (_loggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RoomsPage(username: _username); // passing data to chat room
      }));
      _loginMesibo(_username);
    }
  }

  Future _logoutButtonPressed() async {
    setState(() {
      _logoutMesibo();
      _loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Appearance changes on login-status
    var appearanceLoggedOut = new Column(
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
      _password = "aaa";
    _loginButtonPressed();
    },
        ),
      ],
    );

    var appearanceLoggedIn = new Column(
      children: <Widget>[
        RaisedButton(
          child: Text("Abmelden"),
          color: Colors.deepOrange,
          onPressed: () {
            _logoutButtonPressed();
          },
        ),RaisedButton(
          child: Text("Weiter zum Chatten"),
          color: Colors.deepOrange,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RoomsPage(username: _username); // passing data to chat room
            }));
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
            Text((_loggedIn) ? ("Logged in as user: " + _username) : ("Login"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            new Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: (_loggedIn) ? (appearanceLoggedIn) : (appearanceLoggedOut),
            )
          ],
        ),
      ),
    );
  }
}
