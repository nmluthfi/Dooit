import 'dart:async';

import 'package:dooit/Home/home.dart';
import 'package:dooit/model/todo.dart';
import 'package:faker/faker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../firebase_services/firebase_realtime_database.dart';

class DetailTodo extends StatefulWidget {
  // In the constructor, require the key.
  const DetailTodo({Key? key, required this.todoId});

  // Declare a field that holds the key.
  final String todoId;

  @override
  State<DetailTodo> createState() => _DetailTodoState();
}

class _DetailTodoState extends State<DetailTodo> {
  final _formKey = GlobalKey<FormState>();

  List<String> labelOptions = [
    "Personal",
    "Work",
    "Others"
  ];

  var selectedOption;

  // form handler
  final titleController = TextEditingController();
  final descController = TextEditingController();

  var faker = new Faker();

  late DatabaseReference todosRef;
  late Todo todo;

  @override
  void initState() {
    super.initState();
    print(widget.todoId);
    todosRef = FirebaseDatabase.instance.ref('todos').child(widget.todoId);
    fetchTodoData(); // Fetch the todo data
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    selectedOption = -1;
    super.dispose();
  }

  void fetchTodoData() {
    todosRef.once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          print(data);
          try {
            setState(() {
              todo = Todo.fromMap(Map<String, dynamic>.from(data));
              print(todo);
              selectedOption = todo.label;
              titleController.text = todo.title;
              descController.text = todo.description;

              print(selectedOption);
              print(titleController.text);
              print(descController.text);
            });
          } catch (error) {
            print('Error during Todo.fromMap: $error');
          }
        }
      }
    }, onError: (error) {
      print("Some error: " + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        title: Row(
          children: [
            // SvgPicture.network(
            //     'https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fdooit_logo.svg?alt=media&token=059e3656-89dc-4e2b-810c-89485b210b88',
            //     width: 25,
            //     height: 25,
            //     fit: BoxFit.contain
            // ),
            SizedBox(width: 7),
            Text(
                'Dooit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Codec Cold Trial',
                )
            ),
          ],
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.image,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //
          //   },
          // ),
          IconButton(
            padding: EdgeInsets.fromLTRB(4, 0, 2, 0),
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () {
              if (selectedOption == null || selectedOption == -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select the label')),
                );
              } else {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  print(titleController.text + "\n" + descController.text + "\n" + selectedOption.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  // saveTodo(context);
                  updateTodo(context, todosRef, widget.todoId, titleController.text, descController.text, selectedOption);
                }
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () {
              print("Todo to delete " + widget.todoId);
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
                          deleteTodoFromFirebase(context, widget.todoId);
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
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              children: [
                // SvgPicture.network(
                //   "https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fempty_todo_state.svg?alt=media&token=7297b2d0-87e6-4585-a2b7-2bb3fe6e6df9",
                //   fit: BoxFit.fill,
                //   width: 250,
                //   height: 180,
                // ),
                TextFormField(
                  controller: titleController,
                  maxLines: 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descController,
                  onTapOutside: (text) {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 30,
                  minLines: 1,
                  style: TextStyle(
                    color: Color(0xd8000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: "Write your to-do here...",
                    hintStyle: TextStyle(
                      color: Color(0xd8000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets. fromLTRB(0, 0, 0, 50),
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xDADADADA),
                                    width: 1
                                )
                            )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose a label",
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(labelOptions.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.fromLTRB(0, 8, 13, 0),
                                  child: ChoiceChip(
                                    label: Text(
                                      labelOptions[index],
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    selected: selectedOption == index,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedOption = index;
                                        print(selectedOption);
                                      });
                                      print(labelOptions[index]);
                                    },
                                    selectedColor: Colors.black,
                                    backgroundColor: selectedOption == index ? Colors.black : Color(0xff898989),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color: Color(0xFFFFFFFF),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}