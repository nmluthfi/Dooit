import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// firebase
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../Home/home.dart';
import '../screens/splash_screen.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();

// label options
List<String> labelOptions = [
  "Personal",
  "Work",
  "Others"
];
var selectedOption;

// form handler
final titleController = TextEditingController();
final descController = TextEditingController();

var userId;

Future<void> saveTodo(BuildContext context) async {

  await ref.child("todos").push().set({
    "userid": userId,
    "title": titleController.text,
    "description": descController.text,
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
    print("Someting wrong");
  });

}

class InputTodo extends StatefulWidget {
  @override
  State<InputTodo> createState() => _InputTodoState();
}

class _InputTodoState extends State<InputTodo> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      // if user is not signed in, move to SplashScreen
      if (user == null) {
        // move to SplashScreen
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)  => SplashScreen()), (Route<dynamic> route) => false);
      } else {
        userId = user.uid;
        print('User is signed in!');
      }
    });
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.clear();
    descController.clear();
    selectedOption = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.network(
                'https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fdooit_logo.svg?alt=media&token=059e3656-89dc-4e2b-810c-89485b210b88',
                width: 25,
                height: 25,
                fit: BoxFit.contain
            ),
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
                    const SnackBar(content: Text('Creating new todo')),
                  );
                  saveTodo(context);
                }
              }
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 18),
            child: Column(
              children: [
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
                  maxLines: null,
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
                        margin: const EdgeInsets. fromLTRB(0, 27.5, 0, 50),
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
                                        selectedOption = selected ? index : -1;
                                        print(selectedOption);
                                        print(labelOptions[index]);
                                      });
                                    },
                                    selectedColor: Colors.black,
                                    backgroundColor: Color(0xff898989),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color: Color(0xffDADADA),
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