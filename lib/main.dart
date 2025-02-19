import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Tasks Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TasksScreen());
  }
}

