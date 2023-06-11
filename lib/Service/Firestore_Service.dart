import '../model/User.dart';
import '../Service/Auth_Service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  static var db = FirebaseFirestore.instance;
  late CollectionReference firestoreInstance;

  FireStore(String collection, var from, var to) {
    firestoreInstance = db
        .collection(collection)
        .withConverter(fromFirestore: from, toFirestore: to);
  }

  // static User? getUser(String email) async {
  //   final docRef = db.collection('users').where('email', isEqualTo: email);
  //   final docSnap = await docRef.get();
  //   final data = docSnap.docs;
  //   final options = SnapshotOptions();
  //   return User.fromFirestore(data.single, options);
  // }

  static Future<User> getUser(String email) async {
    final docRef = db.collection('users').where('email', isEqualTo: email);
    final docSnap = await docRef.get();
    final data = docSnap.docs.single;
    final options = SnapshotOptions();
    return User.fromFirestore(data, options);
  }

  static Future<String> editUser(
      String email, List<Map<String, String>> parameter) async {
    final docRef = db.collection('users').where('email', isEqualTo: email);
    final docSnap = await docRef.get();
    try {
      final data = docSnap.docs.first.reference;
      for (var updateData in parameter) {
        await data.update(updateData);
      }
      return 'Success';
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }

  Future<Object?> getData(String key) async {
    final docRef = firestoreInstance.doc(key);
    final docSnap = await docRef.get();
    final data = docSnap.data();
    if (data != null) {
      print(data);
    } else {
      print('No such document');
    }
    return data;
  }

  Future<String?> addData(Object model) async {
    String? message;
    try {
      await firestoreInstance.add(model);
      message = 'Success';
    } on FirebaseException catch (e) {
      message = e.message;
    }
    return message;
  }
}