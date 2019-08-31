import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//void main() => runApp(MyApp());

String _activePage = "k";

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginRoute(),
      routes: <String, WidgetBuilder>{
        '/rooms': (BuildContext context) => new RoomsRoute(),
      })
  );
}

class LoginRoute extends StatefulWidget {
  LoginRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

  static const platform = const MethodChannel("com.bdp.bdp_app/login");

  String _username = "";
  String _password = "";

  _LoginRouteState() {
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
      final int result =
          await platform.invokeMethod('login', {"email": username});
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }

  Future _loginButtonPressed() async {
    setState(() {
      if (_username == "stefan" && _password == "1234") {
        _loginSuccess = true;

      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Benuztername oda Paswoat falsch"));
            });
      }

    });
    if (_loginSuccess) {
      Navigator.pushNamed(context, '/rooms');
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






class RoomsRoute extends StatefulWidget {
  RoomsRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RoomsRouteState createState() => _RoomsRouteState();
}

class _RoomsRouteState extends State<RoomsRoute> {
  Future _roomsButtonPressed() async {
    setState(() {
      _activePage = "ChatPage";
    });
  }

  _backButtonPressed() {
    setState(() {
      _activePage = "LoginPage";
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







class ChatRoute extends StatefulWidget {
  ChatRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChatRouteState createState() => _ChatRouteState();
}

class _ChatRouteState extends State<ChatRoute> {
  _backButtonPressed() {
    setState(() {
      _activePage = "LoginPage";
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
            Text("chatpage"),
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _backButtonPressed();
                }),
          ],
        ),
      ),
    );
  }
}

