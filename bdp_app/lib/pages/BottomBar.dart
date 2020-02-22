// Flutter code sample for

// This example shows a [Scaffold] with a [body] and [FloatingActionButton].
// The [body] is a [Text] placed in a [Center] in order to center the text
// within the [Scaffold]. The [FloatingActionButton] is connected to a
// callback that increments a counter.
//
// ![A screenshot of the Scaffold widget with a body and floating action button](https://flutter.github.io/assets-for-api-docs/assets/material/scaffold.png)

import 'package:flutter/material.dart';
import 'package:bdp_app/pages/web_view_container.dart';
import 'package:bdp_app/pages/HomePage.dart';
import 'package:bdp_app/pages/Calendar.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    HomePage(),
    WebViewContainer("http://217.160.13.225:3000/home"),
    //WebViewContainer("https://chat.rezepthos.com/appsperten/channels/town-square"),
    WebViewContainer("https://nextcloud.bawue.bdp.org"),
    WebViewContainer("https://wiki.bawue.bdp.org/start"),
    WebViewContainer("https://nextcloud.bawue.bdp.org/index.php/apps/calendar/dayGridMonth/now"),
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
    selectedItemColor: Colors.blue[900],
    //selectedbackgroundColor: Colors.blue[600],
    unselectedItemColor: Colors.blue[600],
    //backgroundColor: Colors.blue[800],
    onTap: _onTapped,
    ),
    );

  }
}
