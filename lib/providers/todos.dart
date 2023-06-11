// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../model/todo.dart';

// class ToDoProvider extends ChangeNotifier {
//   late CollectionReference _todosCollection;
//   List<ToDo> _todos = [];

//   List<ToDo> get todos => _todos;

//   ToDoProvider() {
//     _todosCollection = FirebaseFirestore.instance.collection('todos');
//     _fetchTodos();
//   }

// //   Future<void> _fetchTodos() async {
// //   try {
// //     final currentUser = FirebaseAuth.instance.currentUser;
// //     if (currentUser != null) {
// //       final querySnapshot = await _todosCollection
// //           .where('userId', isEqualTo: currentUser.uid)
// //           .get();
// //       _todos = querySnapshot.docs.map((doc) {
// //         return ToDo.fromFirestore(
// //           doc.data() as DocumentSnapshot<Map<String, dynamic>>,
// //           doc.id as SnapshotOptions?,
// //         );
// //       }).toList();
// //       notifyListeners();
// //     }
// //   } catch (e) {
// //     print('Error fetching todos: $e');
// //   }
// // }


//   Future<void> _fetchTodos() async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser!;
//       final querySnapshot = await _todosCollection
//           .where('userId', isEqualTo: currentUser.uid)
//           .get();
//       _todos = querySnapshot.docs.map((doc) {
//         return ToDo.fromFirestore(
//           doc.data() as DocumentSnapshot<Map<String, dynamic>>,
//           doc.id as SnapshotOptions?,
//         );
//       }).toList();
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching todos: $e');
//     }
//   }

//   Future<void> addToDoItem(String todoText) async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser!;
//       final newToDo = ToDo(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         todoText: todoText,
//         isDone: false,
//         userId: currentUser.uid,
//       );
//       await _todosCollection.add(newToDo.toFirestore());
//       _todos.add(newToDo);
//       notifyListeners();
//     } catch (e) {
//       print('Error adding todo item: $e');
//     }
//   }

//   Future<void> updateToDoStatus(ToDo todo) async {
//     try {
//       final docRef = _todosCollection.doc(todo.id);
//       await docRef.update({'isDone': todo.isDone});
//       final updatedTodoIndex = _todos.indexWhere((item) => item.id == todo.id);
//       if (updatedTodoIndex != -1) {
//         _todos[updatedTodoIndex] = todo;
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error updating todo status: $e');
//     }
//   }

//   Future<void> deleteToDoItem(ToDo todo) async {
//     try {
//       await _todosCollection.doc(todo.id).delete();
//       _todos.removeWhere((item) => item.id == todo.id);
//       notifyListeners();
//     } catch (e) {
//       print('Error deleting todo item: $e');
//     }
//   }
// }




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/todo.dart';
import '../providers/auth2.dart';

class ToDoProvider extends ChangeNotifier {
  late CollectionReference _todosCollection;
  User? _user;
  List<ToDo> _todos = [];

  List<ToDo> get todos => _todos;

  ToDoProvider() {
    _todosCollection = FirebaseFirestore.instance.collection('todos');
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    try {
      final querySnapshot = await _todosCollection.get();
      _todos = querySnapshot.docs.map((doc) {
        return ToDo.fromFirestore(doc.data() as DocumentSnapshot<Map<String, dynamic>> , doc.id as SnapshotOptions?);
        return ToDo(id: doc.id, todoText: doc['todoText'] as String, userId: doc['userId']);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addToDoItem(ToDo todoText) async {
    try {
      final newToDo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todoText.toString(),
        isDone: false,
        userId: _user?.uid,
      );
      await _todosCollection.add(newToDo.toFirestore());
      _todos.add(newToDo);
      notifyListeners();
    } catch (e) {
      print('Error adding todo item: $e');
    }
  }

  Future<void> updateToDoStatus(ToDo todo) async {
    try {
      final docRef = _todosCollection.doc(todo.id);
      await docRef.update({'isDone': todo.isDone});
      final updatedTodoIndex = _todos.indexWhere((item) => item.id == todo.id);
      if (updatedTodoIndex != -1) {
        _todos[updatedTodoIndex] = todo;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<void> deleteToDoItem(ToDo todo) async {
    try {
      await _todosCollection.doc(todo.id).delete();
      _todos.removeWhere((item) => item.id == todo.id);
      notifyListeners();
    } catch (e) {
      print('Error deleting todo item: $e');
    }
  }
}
