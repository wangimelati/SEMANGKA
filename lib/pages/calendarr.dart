import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final TimeOfDay time;
  final String userId;

  Event({required this.title, required this.time, required this.userId});
}

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String? uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getUid();
    selectedEvents = {};
    _loadEvents();
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
  DateTime dayKey = DateTime(date.year, date.month, date.day);

  if (selectedEvents.containsKey(dayKey)) {
    return selectedEvents[dayKey]!;
  }

  return [];
}

void getUid()async{
  final prefs = await SharedPreferences.getInstance();
    // final _uid = prefs.getString('id');
    // final authData = prefs.get('authData');
    // print(prefs.get('authData'));
    Map<String, dynamic> data = jsonDecode(prefs.get("authData") as String) as Map<String, dynamic>;
  String iniId = data['uid'];
  setState(() {
    uid = iniId;
  });
  print(uid);
}

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    // final _uid = prefs.getString('id');
    // final authData = prefs.get('authData');
    // print(prefs.get('authData'));
    Map<String, dynamic> data = jsonDecode(prefs.get("authData") as String) as Map<String, dynamic>;
  String iniId = data['uid'];
  print(iniId);
  QuerySnapshot querySnapshot = await firestore.collection('events').where('userId', isEqualTo: iniId).get();

  querySnapshot.docs.forEach((doc) {
    Timestamp timestamp = doc['date'];
    DateTime date = timestamp.toDate();
    Event event = Event(
      title: doc['title'],
      time: TimeOfDay.fromDateTime(date),
      userId : doc['userId']
    );

    if (selectedEvents.containsKey(date)) {
      selectedEvents[date]!.add(event);
      print(selectedEvents[date]);
    } else {
      selectedEvents[date] = [event];
      print(selectedEvents[date]);
    }
  });

  print(selectedEvents);

  setState(() {});
}


  Future<void> _addEvent(Event event) async {
    DateTime date = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    CollectionReference events = firestore.collection('events');
    await events.add({
      'title': event.title,
      'date': date,
      'userId' : uid
    });

    if (selectedEvents.containsKey(date)) {
      selectedEvents[date]!.add(event);
    } else {
      selectedEvents[date] = [event];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            eventLoader: _getEventsfromDay,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsfromDay(selectedDay).length,
              itemBuilder: (context, index) {
                Event event = _getEventsfromDay(selectedDay)[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.time.format(context)),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            TextEditingController _eventController = TextEditingController();
            TimeOfDay _selectedTime = TimeOfDay.now();

            return AlertDialog(
              title: Text('Add Event'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _eventController,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );

                      if (selectedTime != null) {
                        setState(() {
                          _selectedTime = selectedTime;
                        });
                      }
                    },
                    child: Text(
                      _selectedTime.format(context),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    String eventTitle = _eventController.text;
                    if (eventTitle.isNotEmpty) {
                      Event event = Event(
                        title: eventTitle,
                        time: _selectedTime,
                        userId: "hello"
                      );
                      _addEvent(event);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
