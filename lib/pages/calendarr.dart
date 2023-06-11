import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/event.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../constants/colors.dart';


import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final TimeOfDay time;

  Event({required this.title, required this.time});
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  Future<void> _loadEvents() async {
    QuerySnapshot querySnapshot =
        await firestore.collection('events').get();

    querySnapshot.docs.forEach((doc) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      Event event = Event(
        title: doc['title'],
        time: TimeOfDay.fromDateTime(date),
      );

      if (selectedEvents[date] != null) {
        selectedEvents[date]!.add(event);
      } else {
        selectedEvents[date] = [event];
      }
    });

    setState(() {});
  }

  Future<void> _addEvent(Event event) async {
    DateTime date = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    CollectionReference events = firestore.collection('events');
    await events.add({
      'title': event.title,
      'date': date,
    });

    if (selectedEvents[date] != null) {
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







// class Calendar extends StatefulWidget {
//   @override
//   _CalendarState createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> {
//   late Map<DateTime, List<Event>> selectedEvents;
//   CalendarFormat format = CalendarFormat.month;
//   DateTime selectedDay = DateTime.now();
//   DateTime focusedDay = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();

//   TextEditingController _eventController = TextEditingController();
//   TextEditingController _timeController = TextEditingController();

//   @override
//   void initState() {
//     selectedEvents = {};
//     super.initState();
//   }

//   List<Event> _getEventsfromDay(DateTime date) {
//     return selectedEvents[date] ?? [];
//   }

//   @override
//   void dispose() {
//     _eventController.dispose();
//     super.dispose();
//     _timeController.dispose();
//   }

//   @override
//   StatefulWidget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tdBGColor,
//       body: Column(
//         children: [
//           TableCalendar(
//             focusedDay: selectedDay,
//             firstDay: DateTime(1990),
//             lastDay: DateTime(2050),
//             calendarFormat: format,
//             onFormatChanged: (CalendarFormat _format) {
//               setState(() {
//                 format = _format;
//               });
//             },
//             startingDayOfWeek: StartingDayOfWeek.sunday,
//             daysOfWeekVisible: true,

//             //Day Changed
//             onDaySelected: (DateTime selectDay, DateTime focusDay) {
//               setState(() {
//                 selectedDay = selectDay;
//                 focusedDay = focusDay;
//               });
//               print(focusedDay);
//             },
//             selectedDayPredicate: (DateTime date) {
//               return isSameDay(selectedDay, date);
//             },

//             eventLoader: _getEventsfromDay,

//             //To style the Calendar
//             calendarStyle: CalendarStyle(
//               isTodayHighlighted: true,
//               selectedDecoration: BoxDecoration(
//                 color: Colors.amber,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               selectedTextStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
//               todayDecoration: BoxDecoration(
//                 color: Color.fromARGB(255, 72, 120, 18),
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               defaultDecoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               weekendDecoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//             ),
//             headerStyle: HeaderStyle(
//               formatButtonVisible: true,
//               titleCentered: true,
//               formatButtonShowsNext: false,
//               formatButtonDecoration: BoxDecoration(
//                 color: Colors.amber,
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               formatButtonTextStyle: TextStyle(
//                 color: Color.fromARGB(255, 0, 0, 0),
//               ),
//             ),
//           ),
//           ..._getEventsfromDay(selectedDay).map(
//             (Event event) => ListTile(
//               title: Text(
//                 event.title,
//               ),
//               subtitle: Text(
//                 (event.hour).format(context),
//               ),
//             ),
//           ),
//         ],  
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => showTimePicker(context: context, initialTime: TimeOfDay.now(), 
//         ).then((time){
//           if(time == null){
//             return;
//           }showDialog(context: context, builder: (context) => AlertDialog(
//             title: Text("Add Event"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _eventController,  
//               ),
              
//               Text(time.format(context)),
//             ]
//           ),
//           actions: [
//                 TextButton(
//                   child: Text("Cancel"),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 TextButton(
//                   child: Text("Ok"),
//                   onPressed: () {
//                     if (_eventController.text.isEmpty) {
//                     return;
//                     }
//                     if (selectedEvents[selectedDay] != null) {
//                     // selectedEvents[dateTime]!.add(Event(title: _eventController.text, subtitle: DateTimePicker));
//                     selectedEvents[selectedDay]!.add(Event(title: _eventController.text, hour: time, id: ,));
//                     } else {
//                     selectedEvents[selectedDay] = [Event(title: _eventController.text, hour: time, id: ,)];
//                     }
//                     Navigator.pop(context);
//                     _eventController.clear();
//                     setState(() {});
//                     return;
//                   },
//                 ),
//               ],
//         ),
//       );
//         }),
//           label: Text("Add Event"),
//           icon: Icon(Icons.add),
//       ),

//     );
//   }
// }
