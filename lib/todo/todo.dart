import 'package:dooit/todo/todo_detail.dart';
import 'package:dooit/todo/todo_input.dart';
import 'package:dooit/todo/utils/appbar_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker/faker.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Todo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTodo(),
      body: InputTodo(),
    );
  }

}