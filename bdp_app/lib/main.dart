import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';



import 'package:bdp_app/pages/LoginPage.dart';

void main() {
  //initializeDateFormatting is needed for table_calendar plugin - remove if calendar operated differently
  initializeDateFormatting().then((_) => runApp(MaterialApp(
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
      home : LoginPage(),
      )
  ));
}
