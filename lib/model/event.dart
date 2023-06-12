import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final TimeOfDay time;
  final String userId;

  Event({
    required this.id,
    required this.title,
    required this.time,
    required this.userId
  });

  factory Event.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Event(
      id: data!['id'],
      title: data['title'],
      time: data['time'],
      userId : data['userId']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // ignore: unnecessary_null_comparison
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (time != null) "time": time,
      if (userId != null) "userId" : userId 
    };
  }
}


// class Event {
//   final String title;
//   final TimeOfDay hour;
//   final String? id;
//   final bool time;
  
//   //time perlu required ga ya..
//   Event({required this.title, required this.hour, required this.id, this.time = false,});

//   String toString() => this.title;
//   TimeOfDay toTimeOfDay() => this.hour;
  
// }