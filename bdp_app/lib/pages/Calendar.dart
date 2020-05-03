//example app can be found @ https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';




class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key:key);

  @override
  _CalendarState createState() => _CalendarState();
}


class _CalendarState extends State<Calendar> {


  Map<DateTime, List> _events = {
    DateTime(2019, 12, 24): ['Weihnachte', 'Tannenbaum', 'Tannenbaum2', 'Tannenbaum3', 'Tannenbaum4'],
    DateTime(2019, 12, 31): ['Silveschter'],
    DateTime(2020, 1, 1): ['sNeujahr'],
    DateTime(2020, 2, 21): ['Hacken'],
    DateTime(2020, 2, 22): ['Hacken'],
    DateTime(2020, 2, 23): ['Hacken'],
  };

  Map<DateTime, List> _selectedEvents = {};

  final _calendarController = CalendarController();


  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents.clear();
      _events.forEach((date,event){
        //check if there are events on the selected day and add them to _selectedDay
        if (date.toString().substring(0,10) == _calendarController.selectedDay.toString().substring(0,10)){
          _selectedEvents[date] = event;
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TableCalendar(
                calendarController: _calendarController,
                locale: 'de_DE',
                events: _events,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
                onDaySelected: _onDaySelected,
              ),
              const SizedBox(height: 8.0),
              //this prints events below calendar.
              Expanded(child: _buildEventList())
        ]
        ));
  }


  Widget _buildEventList() {
    List<Widget> list = new List<Widget>();
    _selectedEvents.forEach((date, event){
      event.forEach((element) {
        list.add(
            RaisedButton(onPressed: null, disabledColor: Colors.orange, child: Text(element.toString())));
      });
    });
    return new ListView(children: list);


  }

}


