import 'dart:async';
import 'dart:math';

import 'package:dooit/todo/todo_detail.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:random_date/random_date.dart';

import '../model/todo.dart';
import '../todo/todo_input.dart';

// This is the list type used by the popup menu below.
enum MenuItem { itemOne }

var userId;

class MainLayout extends StatefulWidget {

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  // generates a random date for given range
  var randomDateOptions = RandomDateOptions.withDefaultYearsToCurrent(10);
  var randomDate = RandomDate.withStartYear(2000);
  var faker = new Faker();

  MenuItem? selectedMenu;

  List<Todo> todos = [];

  // reference to todos in the database
  Query todosRef = FirebaseDatabase.instance
      .ref('todos')
      .orderByChild("userid")
      .equalTo(FirebaseAuth.instance.currentUser!.uid);

  final searchFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodosFromFirebase();
  }

  Future<void> fetchTodosFromFirebase() async {
    DatabaseEvent event = await todosRef.once();
    DataSnapshot snapshot = event.snapshot;

    dynamic todosData = snapshot.value;

    if (todosData != null) {
      Map<dynamic, dynamic> todosMap = todosData;
      List<Todo> fetchedTodos = todosMap.entries.map((entry) {
        Map<String, dynamic> todoMap = Map<String, dynamic>.from(entry.value);
        return Todo(
          todoId: todoMap["todoId"] = entry.key,
          title: todoMap['title'],
          description: todoMap['description'],
          label: todoMap['label'] == 0 ? 'Personal' : todoMap['label'] == 1 ? 'Work' : 'Others',
          date: DateTime.fromMillisecondsSinceEpoch(int.parse(todoMap['timestamp'])),
          userid: todoMap['userid'],
        );
      }).toList();

      setState(() {
        todos = fetchedTodos;
      });

    }
  }

  void deleteTodoFromFirebase(String todoId) {
    DatabaseReference todoToDelete = FirebaseDatabase.instance
        .ref('todos').child(todoId);
    todoToDelete.remove().then((value) {
      print("Todo deleted successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo deleted successfully')),
      );
      fetchTodosFromFirebase();
    }).catchError((error) {
      print("Failed to delete todo: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: TextFormField(
            controller: searchFilter,
            onChanged: (String value) {
              setState(() {

              });
            },
            onTapOutside: (text) {
              FocusScope.of(context).unfocus();
            },
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Search any todo here...',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black.withOpacity(1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(1),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 72, 24, 18),
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final title = todo.title.toLowerCase();
                if (searchFilter.text.isEmpty) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailTodo(todoId: todo.todoId)),
                        );
                        print(todo.todoId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // SvgPicture.network(
                            //   "https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fempty_todo_state.svg?alt=media&token=7297b2d0-87e6-4585-a2b7-2bb3fe6e6df9",
                            //   fit: BoxFit.fill,
                            //   width: 250,
                            //   height: 180,
                            // ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                todo.description,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.3,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.9),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff000000),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 8, 16, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      todo.label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Row(
                                    children: [
                                      SvgPicture.network(
                                        'https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Ficon_calendar.svg?alt=media&token=8ea6944c-c521-4aaf-a0f0-8ce92cf86594',
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 4),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
                                        child: Text(
                                          DateFormat('dd - MM - yyyy').format(todo.date),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton<MenuItem>(
                                        initialValue: selectedMenu,
                                        // Callback that sets the selected popup menu item.
                                        onSelected: (MenuItem item) {
                                          print("Selected item $item to delete" + todo.todoId);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Are you sure, want to delete ' + todo.title + '?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        )
                                                    ),
                                                    onPressed: () {
                                                      print("Ok");
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          duration: Duration(seconds: 1),
                                                          content: Text("Deleting " + todo.title + '...'),
                                                        ),
                                                      );
                                                      deleteTodoFromFirebase(todo.todoId);
                                                      Timer(Duration(seconds: 1), () {
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        print("No");
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("No")
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                                          const PopupMenuItem<MenuItem>(
                                            value: MenuItem.itemOne,
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 9, 0, 9),
                  );
                } else if (searchFilter.text.isNotEmpty && title.contains(searchFilter.text.toLowerCase().toString())) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailTodo(todoId: todo.todoId)),
                        );
                        print(todo.todoId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // SvgPicture.network(
                            //   "https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fempty_todo_state.svg?alt=media&token=7297b2d0-87e6-4585-a2b7-2bb3fe6e6df9",
                            //   fit: BoxFit.fill,
                            //   width: 250,
                            //   height: 180,
                            // ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                todo.description,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.3,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.9),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff000000),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 8, 16, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      todo.label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Row(
                                    children: [
                                      SvgPicture.network(
                                        'https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Ficon_calendar.svg?alt=media&token=8ea6944c-c521-4aaf-a0f0-8ce92cf86594',
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 4),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
                                        child: Text(
                                          DateFormat('dd - MM - yyyy').format(todo.date),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton<MenuItem>(
                                        initialValue: selectedMenu,
                                        // Callback that sets the selected popup menu item.
                                        onSelected: (MenuItem item) {
                                          print("Selected item $item to delete" + todo.todoId);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Are you sure, want to delete ' + todo.title + '?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        )
                                                    ),
                                                    onPressed: () {
                                                      print("Ok");
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          duration: Duration(seconds: 1),
                                                          content: Text("Deleting " + todo.title + '...'),
                                                        ),
                                                      );
                                                      deleteTodoFromFirebase(todo.todoId);
                                                      Timer(Duration(seconds: 1), () {
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        print("No");
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("No")
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                                          const PopupMenuItem<MenuItem>(
                                            value: MenuItem.itemOne,
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 9, 0, 9),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 24, 24),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InputTodo()),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}