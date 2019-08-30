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

//Klasse für den Login-Screem
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
  int _counter = 0;

  String _activePage = "LoginPage";


  Future _loginButtonPressed() async {
    setState(() {
      _activePage = "RoomsPage";
    });
  }

  Future _roomsButtonPressed() async {
    setState(() {
      _activePage = "ChatPage";
    });
  }

  _backButtonPressed() {
    if (_activePage == "RoomsPage") {
      setState((){_activePage = "LoginPage";});
    } else if (_activePage == "ChatPage") {
      setState((){_activePage = "RoomsPage";});
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
            Text("Login Page"),
            new Row(
              children: [Text("Username")]
            )
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loginButtonPressed,
        tooltip: 'Login',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
            Text("roomspage"),
            TextField(
              maxLines: 4,
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () { _backButtonPressed();}
            ),
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
                }
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const channel = EventChannel('someStream');
    channel.receiveBroadcastStream().listen((dynamic event) {
      print('Received event: $event');
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    });

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


