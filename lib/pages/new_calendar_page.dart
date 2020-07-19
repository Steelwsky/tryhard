import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:tryhard/pages/addition_page.dart';
import 'package:tryhard/style/colors.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;

  final Map<DateTime, List> _events = {
    DateTime(2020, 7, 7): [
      {'name': 'Event A', 'isDone': true},
    ],
    DateTime(2020, 7, 9): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
    ],
    DateTime(2020, 7, 10): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
    ],
    DateTime(2020, 7, 13): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
      {'name': 'Event C', 'isDone': false},
    ],
    DateTime(2020, 7, 25): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
      {'name': 'Event C', 'isDone': false},
    ],
    DateTime(2020, 8, 6): [
      {'name': 'Event A', 'isDone': false},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AnimatedContainer(
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 600),
            key: PageStorageKey('calendar'),
            child: Calendar(
              startOnMonday: true,
              weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
              events: _events,
              onRangeSelected: (range) => print("Range is ${range.from}, ${range.to}"),
              onDateSelected: (date) => _handleNewDate(date),
              isExpandable: false,
              isExpanded: true,
              hideBottomBar: false,
              eventDoneColor: Colors.green,
              selectedColor: Colors.pink,
              todayColor: Colors.yellow,
              eventColor: Colors.grey,
              dayOfWeekStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          AddEvent(),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return
//      _selectedEvents.length == 0
//        ? AddEvent() :
        Expanded(
      child: ListView.builder(
        key: PageStorageKey('calendarMonth'),
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: ListTile(
            title: Text(
              _selectedEvents[index]['name'].toString(),
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {},
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }
}

class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: <Widget>[
          Text(
            'Add new one',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              iconSize: 24,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdditionPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}
