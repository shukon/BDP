// Flutter code sample for

// This example shows a [Scaffold] with a [body] and [FloatingActionButton].
// The [body] is a [Text] placed in a [Center] in order to center the text
// within the [Scaffold]. The [FloatingActionButton] is connected to a
// callback that increments a counter.
//
// ![A screenshot of the Scaffold widget with a body and floating action button](https://flutter.github.io/assets-for-api-docs/assets/material/scaffold.png)

import 'package:flutter/material.dart';
import 'package:bdp_app/pages/web_view_container.dart';




/// This Widget is the main application widget.
class BillboardPage extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();


}



class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    Text('Pinnwand'),
    WebViewContainer("https://chat.rezepthos.com/appsperten/channels/town-square"),
    Text('Cloud'),
    Text('Wiki'),
    Text('Kalender'),
  ];

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    body: Center(child: _widgetOptions.elementAt(_selectedIndex),
    ),

    bottomNavigationBar: BottomNavigationBar(
    //currentIndex: 0, // this will be set when a new tab is tapped
    items: [
    BottomNavigationBarItem(
    icon: new Icon(Icons.view_compact),
    title: Text('Pinnwand'),
    ),
    BottomNavigationBarItem(
    icon: new Icon(Icons.chat_bubble_outline),
    title: new Text('Chat', style: TextStyle(color: Colors.black)),
    ),
    BottomNavigationBarItem(
    icon: new Icon(Icons.cloud),
    title: new Text('Cloud', style: TextStyle(color: Colors.black)),
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.library_books),
    title: Text('Wiki')
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today),
    title: Text('Kalender')
    ),

    ],
    selectedItemColor: Colors.blue[600],
    unselectedItemColor: Colors.blue[600],
    backgroundColor: Colors.blue[800],
    onTap: _onTapped,
    ),
    );

  }
}
