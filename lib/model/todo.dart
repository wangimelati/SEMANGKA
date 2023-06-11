import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String? userId;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    required this.userId,
  });

  // static List<ToDo> todoList() {
  //   return [
  //     ToDo(id: '01', todoText: 'Kerjain PemMob yh', isDone: true ),
  //     ToDo(id: '02', todoText: 'Haduh PemWeb CDM + PDM', isDone: true ),
  //     ToDo(id: '03', todoText: 'APS prak ngab', ),
  //     ToDo(id: '04', todoText: 'Jangan lupa laundry baju!', ),
  //     ToDo(id: '05', todoText: 'Beli indomie sama sosis', ),
  //     ToDo(id: '06', todoText: 'Cuci sepatu, bau', ),
  //   ];
  // }

  factory ToDo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ToDo(
      id: data!['id'],
      todoText: data['todoText'],
      isDone: data['isDone'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (todoText != null) "todoText": todoText,
      if (isDone != null) "isDone": isDone,
      if (userId != null) 'userId': userId,
    };
  }

  // factory ToDo.fromJson(Map<String, dynamic> json) {
  //   return ToDo(
  //     id: json['id'],
  //     todoText: json['todoText'],
  //     isDone: json['isDone'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'todoText': todoText,
  //     'isDone': isDone,
  //   };
  // }

  static List<ToDo> todoList() {
    return [
      ToDo(
        id: '1',
        todoText: 'Example Todo 1',
        userId: '111',
        isDone: false,
      ),
      ToDo(
        id: '2',
        todoText: 'Example Todo 2',
        userId: '111',
        isDone: true,
      ),
      ToDo(
        id: '3',
        todoText: 'Example Todo 3',
        userId: '111',
        isDone: false,
      ),
    ];
  }
}
