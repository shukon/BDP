import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        home: HomePage(title: 'BDP Test App'));
  }
}

//Klasse für den Login-Screen
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

  static const platform = const MethodChannel("com.bdp.bdp_app/login");

  static const messageReceived = const EventChannel("com.bdp.bdp_app/message-received");

  _HomePageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  String _username = "";
  String _password = "";

  String _loginSuccess = "login failed";

  String _activePage = "LoginPage";

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
      final int result = await platform.invokeMethod(
          'login', {"email": username});
    } on PlatformException catch (e) {
      print("Something utterly wrong: '${e.message}'.");
    }
  }

  Future<String> _getMessages(){

  }


  Future _loginButtonPressed() async {
    setState(() {
      if (_username == "stefan" && _password == "1234") {
        _loginSuccess = "erfolgreich angemeldet als stefan";
        _activePage = "RoomsPage";
        _loginMesibo(_username);
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
  }

  Future _roomsButtonPressed() async {
    setState(() {
      _activePage = "ChatPage";
    });
  }

  _backButtonPressed() {
    if (_activePage == "RoomsPage") {
      setState(() {
        _activePage = "LoginPage";
      });
    } else if (_activePage == "ChatPage") {
      setState(() {
        _activePage = "RoomsPage";
      });
    }
  }

  Widget _LoginPage() {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
            Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
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

  Widget _RoomsPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("rooms page"),
            Text(_loginSuccess),
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

  Widget _ChatPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print(_activePage);
    if (_activePage == "ChatPage") {
      return _ChatPage();
    } else if (_activePage == "RoomsPage") {
      return _RoomsPage();
    } else if (_activePage == "LoginPage") {
      return _LoginPage();
    }
  }
}
