import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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