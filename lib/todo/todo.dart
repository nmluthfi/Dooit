import 'package:dooit/todo/todo_input.dart';
import 'package:dooit/todo/utils/appbar_todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Todo extends StatefulWidget {

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  void initState() {
    super.initState();

    // checking if user is signed in
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      // if user is not signed in, move to SplashScreen
      if (user == null) {
        // move to SplashScreen
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)  => SplashScreen()), (Route<dynamic> route) => false);
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTodo(),
      body: InputTodo(),
    );
  }
}