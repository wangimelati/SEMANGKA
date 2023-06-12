import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:semangka_todolist_new/providers/events.dart';
import '../screens/home.dart';
import '../pages/auth_page.dart';
import 'providers/auth2.dart';
import '../providers/products.dart';
import 'package:firebase_core/firebase_core.dart';

// // INI YANG DARI CHATPGT WAK
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:semangka_todolist_new/providers/events.dart';
// import 'package:semangka_todolist_new/screens/home.dart';
// import 'package:semangka_todolist_new/pages/auth_page.dart';
// import 'package:semangka_todolist_new/providers/auth2.dart';
// import 'package:semangka_todolist_new/providers/products.dart';
// import 'package:firebase_core/firebase_core.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => EventProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => Auth2(),
//         ),
//         // ... tambahkan provider lainnya jika ada
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(statusBarColor: Colors.transparent));
//     // return MaterialApp(
//     //   theme: ThemeData(
//     //     primarySwatch: Colors.amber,
//     //   ),
//     //   debugShowCheckedModeBanner: false,
//     //   home: Home(),
//     // );
//     return MultiProvider(providers: const [],
//     builder: (context, child) => Consumer<Auth2>(
//         builder: (context, auth, child) => MaterialApp(
//            theme: ThemeData(
//           primarySwatch: Colors.amber,
//         ),
//           debugShowCheckedModeBanner: false,
//           home: auth.isAuth
//               ? Home()
//               : FutureBuilder(
//                   future: auth.autoLogin(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Scaffold(
//                         body: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     }

//                     return LoginPage();
//                   },
//                 ),
//         ),
//       )
//     );
//   }
// }
// // INI YANG DARI CHATPGT WAK


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  runApp(const MyApp());
  // ChangeNotifierProvider(
  //     create: (_) => EventProvider(),
  //     child: MyApp(),
  //   );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // return MaterialApp(
    //     theme: ThemeData(
    //       primarySwatch: Colors.amber,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: const Welcome());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
      create: (_) => EventProvider(),
    ),
        ChangeNotifierProvider(
          create: (ctx) => Auth2(), 
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   create: (context) => Products(), 
        //   update: (context, auth, products) =>
        //       products!..updateData(auth.token, auth.userId),
        // ),
      ],
      builder: (context, child) => Consumer<Auth2>(
        
        builder: (context, auth, child) => 
        // User? currentUser = auth.currentUser;
        MaterialApp(
           theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return LoginPage();
                  },
                ),
          // routes: {
          //   AddProductPage.route: (ctx) => AddProductPage(),
          //   EditProductPage.route: (ctx) => EditProductPage(),
          // },
        ),
      ),
    );
  }
}
