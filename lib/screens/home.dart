import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import '../pages/calendarr.dart';
import '../pages/focuss.dart';
import '../widgets/nav-drawer.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  late CollectionReference _todosCollection;
  late FirebaseAuth _auth;
  User? _user;

  @override
  void initState() {
    _foundToDo = todosList;
    _auth = FirebaseAuth.instance;
    _fetchUser();
    super.initState();
    controller = TabController(length: 3, vsync: this);
    _todosCollection = FirebaseFirestore.instance.collection('todos');
  }

  Future<void> _fetchUser() async {
  _user = _auth.currentUser;
  if (_user == null) {
    try {
      // Sign in anonymously jika pengguna belum login
      final userCredential = await _auth.signInAnonymously();
      _user = userCredential.user;
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }
  setState(() {});
  }

  late TabController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdYellow,
        title: Text(
          "SEMANGKA!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: tdBlack,
          ),
        ),
        elevation: 10,
        leading: Container(
          child: Image.asset('assets/images/logo.png'),
          margin: EdgeInsets.only(left: 10.0),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: DefaultTabController(
            length: 3,
            child: TabBar(
              controller: controller,
              tabs: [
                Tab(text: "To Do"),
                Tab(text: "Calendar"),
                Tab(text: "Pomodoro"),
              ],
              labelColor: tdBlack,
            ),
          ),
        ),
      ),
      endDrawer: DrawerWidget(),
      body: TabBarView(
        controller: controller,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    searchBox(),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _todosCollection
                                .where('userId', isEqualTo: _user?.uid)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final todos = snapshot.data!.docs.map((doc) {
                              return ToDo(
                                id: doc.id,
                                todoText: doc['todoText'],
                                isDone: doc['isDone'],
                                userId: doc['userId'],
                              );
                            }).toList();

                            return ListView(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 50,
                                    bottom: 20,
                                  ),
                                ),
                                for (ToDo todo in todos.reversed)
                                  ToDoItem(
                                    todo: todo,
                                    onToDoChanged: _handleToDoChange,
                                    onDeleteItem: _deleteToDoItem,
                                  ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                          left: 20,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                          hintText: 'Kuy, add to-do list',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      onPressed: () {
                        _addToDoItem(_todoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: tdGreen,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Calendar(),
        PomodoroTimerPage(),
      ],
    ),
  );
}

void _handleToDoChange(ToDo todo) {
  setState(() {
    todo.isDone = !todo.isDone;
    _todosCollection.doc(todo.id).update({'isDone': todo.isDone});
  });
}

void _deleteToDoItem(String id) {
  setState(() {
    todosList.removeWhere((item) => item.id == id);
    _todosCollection.doc(id).delete();
  });
}

void _addToDoItem(String toDo) {
  setState(() {
    todosList.add(
      ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: toDo,
      isDone: false,
      userId: _user?.uid,
    ));
    _todosCollection.add({
      'todoText': toDo,
      'isDone': false,
      'userId': _user?.uid,
    });
  });
  _todoController.clear();
}

void _runFilter(String enteredKeyword) {
  List<ToDo> results = [];
  if (enteredKeyword.isEmpty) {
    results = todosList;
  } else {
    results = todosList
        .where((item) => item.todoText!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList();
  }

  setState(() {
    _foundToDo = results;
  });
}

Widget searchBox() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      onChanged: (value) => _runFilter(value),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: tdBlack,
          size: 20,
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 20,
          minWidth: 25,
        ),
        border: InputBorder.none,
        hintText: 'Search',
        hintStyle: TextStyle(color: tdGrey),
      ),
    ),
  );
}
}










// //// Coding yang ada tabBar nya

// import 'package:flutter/material.dart';

// import '../model/todo.dart';
// import '../constants/colors.dart';
// import '../widgets/todo_item.dart';
// import '../pages/calendarr.dart';
// import '../pages/focuss.dart';
// import '../widgets/nav-drawer.dart';

// class Home extends StatefulWidget {
//   Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//   final todosList = ToDo.todoList();
//   List<ToDo> _foundToDo = [];
//   final _todoController = TextEditingController();

//   @override
//   void initState() {
//     _foundToDo = todosList;
//     super.initState();
//     controller = TabController(length: 3, vsync: this);
//   }

//   late TabController controller;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tdBGColor,

//       //AppBar
//       appBar: AppBar(
//           backgroundColor: tdYellow,
//           title: Text(
//             "SEMANGKA!",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontSize: 30, fontWeight: FontWeight.w500, color: tdBlack),
//           ),
//           elevation: 10,
//           leading: Container(
//             child: Image.asset('assets/images/logo.png'), margin: EdgeInsets.only(left: 10.0),
//           ),
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(50),
//             child: DefaultTabController(
//                 length: 3,
//                 child: TabBar(
//                     controller: controller,
//                     tabs: [
//                       Tab(text: "To Do"),
//                       Tab(text: "Calendar"),
//                       Tab(text: "Pomodoro")
//                     ],
//                     labelColor: tdBlack)),
//           )),

//       //drawer
//       endDrawer: DrawerWidget(),

//       //To-Do List
//       body: TabBarView(
//         controller: controller,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 15,
//                 ),
//                 child: Column(
//                   children: [
//                     searchBox(),
//                     Expanded(
//                       child: ListView(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(
//                               top: 50,
//                               bottom: 20,
//                             ),
//                           ),
//                           for (ToDo todoo in _foundToDo.reversed)
//                             ToDoItem(
//                               todo: todoo,
//                               onToDoChanged: _handleToDoChange,
//                               onDeleteItem: _deleteToDoItem,
//                             ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),

//               //To-Do Input
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Row(children: [
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         bottom: 20,
//                         right: 20,
//                         left: 20,
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 5,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0.0, 0.0),
//                             blurRadius: 10.0,
//                             spreadRadius: 0.0,
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       //cara input new to-do list
//                       child: TextField(
//                         controller: _todoController,
//                         decoration: InputDecoration(
//                             hintText: 'Kuy, add to-do list',
//                             border: InputBorder.none),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(
//                       bottom: 20,
//                       right: 20,
//                     ),

//                     //Button + melayang
//                     child: ElevatedButton(
//                       child: Text(
//                         '+',
//                         style: TextStyle(
//                           fontSize: 40,
//                         ),
//                       ),

//                       //function untuk tambah to do list
//                       onPressed: () {
//                         _addToDoItem(_todoController.text);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: tdGreen,
//                         minimumSize: Size(60, 60),
//                         elevation: 10,
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ],
//           ),
//           Calendar(),
//           PomodoroTimerPage()
//         ],
//       ),
//     );
//   }

//   void _handleToDoChange(ToDo todo) {
//     setState(() {
//       todo.isDone = !todo.isDone;
//     });
//   }

//   void _deleteToDoItem(String id) {
//     setState(() {
//       todosList.removeWhere((item) => item.id == id);
//     });
//   }

//   void _addToDoItem(String toDo) {
//     setState(() {
//       todosList.add(ToDo(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         todoText: toDo,
//       ));
//     });
//     _todoController.clear();
//   }

//   void _runFilter(String enteredKeyword) {
//     List<ToDo> results = [];
//     if (enteredKeyword.isEmpty) {
//       results = todosList;
//     } else {
//       results = todosList
//           .where((item) => item.todoText!
//               .toLowerCase()
//               .contains(enteredKeyword.toLowerCase()))
//           .toList();
//     }

//     setState(() {
//       _foundToDo = results;
//     });
//   }

//   Widget searchBox() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: TextField(
//         onChanged: (value) => _runFilter(value),
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.all(0),
//           prefixIcon: Icon(
//             Icons.search,
//             color: tdBlack,
//             size: 20,
//           ),
//           prefixIconConstraints: BoxConstraints(
//             maxHeight: 20,
//             minWidth: 25,
//           ),
//           border: InputBorder.none,
//           hintText: 'Search',
//           hintStyle: TextStyle(color: tdGrey),
//         ),
//       ),
//     );
//   }
// }
