import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Home/home.dart';
import '../model/todo.dart';

// Future<void> fetchTodosFromFirebase(Query todosRef) async {
//   DatabaseEvent event = await todosRef.once();
//   DataSnapshot snapshot = event.snapshot;
//
//   dynamic todosData = snapshot.value;
//
//   if (todosData != null) {
//     Map<dynamic, dynamic> todosMap = todosData;
//     List<Todo> fetchedTodos = todosMap.entries.map((entry) {
//       Map<String, dynamic> todoMap = Map<String, dynamic>.from(entry.value);
//       return Todo(
//         todoId: todoMap["todoId"] = entry.key,
//         title: todoMap['title'],
//         description: todoMap['description'],
//         label: todoMap['label'] == 0 ? 'Personal' : todoMap['label'] == 1 ? 'Work' : 'Others',
//         date: DateTime.fromMillisecondsSinceEpoch(int.parse(todoMap['timestamp'])),
//         userid: todoMap['userid'],
//       );
//     }).toList();
//
//     setState(() {
//       todos = fetchedTodos;
//     });
//
//   }
//
// void deleteTodoFromFirebase(String todoId) {
//   DatabaseReference todoToDelete = FirebaseDatabase.instance
//       .ref('todos').child(todoId);
//   todoToDelete.remove().then((value) {
//     print("Todo deleted successfully");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Todo deleted successfully')),
//     );
//     fetchTodosFromFirebase();
//   }).catchError((error) {
//     print("Failed to delete todo: $error");
//   });
// }

Future<void> CreateNewTodo(BuildContext context,
    DatabaseReference ref,
    String userId,
    String titleController,
    String descController,
    int selectedOption) async {

  await ref.child("todos").push().set({
    "userid": userId,
    "title": titleController,
    "description": descController,
    "label": selectedOption,
    "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
  }).then((_) {
    print("Success Add New Todo");
    // Data saved successfully!
    Timer(Duration(seconds: 2), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success Add New Todo'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Home()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }).catchError((error) {
    // The write failed...
    print("Someting went wrong");
  });

}

void updateTodo(BuildContext context,
    DatabaseReference todosRef,
    String todoId,
    String titleController,
    String descController,
    int selectedOption) {
  todosRef.update({
    'title': titleController,
    'description': descController,
    'label': selectedOption,
    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
  }).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todo updated successfully')),
    );
    // navigate to HomePage
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );
    });
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to update todo')),
    );
  });
}

void deleteTodoFromFirebase(BuildContext context, String todoId) {
  DatabaseReference todoToDelete = FirebaseDatabase.instance
      .ref('todos').child(todoId);
  todoToDelete.remove().then((value) {
    print("Todo deleted successfully");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todo deleted successfully')),
    );
    // navigate to HomePage
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );
    });
  }).catchError((error) {
    print("Failed to delete todo: $error");
  });
}