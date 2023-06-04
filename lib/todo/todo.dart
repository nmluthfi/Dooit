import 'package:dooit/todo/todo_detail.dart';
import 'package:dooit/todo/todo_input.dart';
import 'package:dooit/todo/utils/appbar_todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker/faker.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/splash_screen.dart';

class Todo extends StatefulWidget {

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  void initState() {
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
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