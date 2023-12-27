import 'package:crud_firebase/SQLite/input_data_sqlite.dart';
import 'package:crud_firebase/screens/input_data_Firestore.dart';
import 'package:crud_firebase/screens/input_data_Reltime.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//jika ingin menggunakan Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
//Jika ingin menggunakan SQLite
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   sqfliteFfiInit();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Firebase CRUD',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InputDataRealtime());
  }
}
