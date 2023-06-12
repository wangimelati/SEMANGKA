import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/event.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;

  Future<void> fetchEvents(Event eventData) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('events').get({
        'title': eventData.title,
        'time': eventData.time,
        'userId' : eventData.userId
      } as GetOptions?);

      // final QuerySnapshot snapshot =
      //     await FirebaseFirestore.instance.collection('events').get();
    

//       _events = snapshot.docs.map((doc) {
//   final eventData = doc.data();
//   final title = eventData['title'] as String?;
//   final time = TimeOfDay.fromDateTime(DateTime.parse(eventData['time'] as String));
//   return Event(
//     id: doc.id,
//     title: title ?? '',
//     time: time,
//   );
// }).toList();

      
      // _events = snapshot.docs.map((doc) {
      //   final eventData = doc.data()!;
      //   return Event(
      //     id: doc.id,
      //     title: eventData['title'],
      //     time: eventData['time'],
      //   );
      // }).toList();

      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      final docRef =
          await FirebaseFirestore.instance.collection('events').add({
        'title': event.title,
        'time': event.time,
        'userId' : event.userId
      });

      final newEvent = Event(
        id: docRef.id,
        title: event.title,
        time: event.time,
        userId : event.userId
      );

      _events.add(newEvent);

      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }
}
