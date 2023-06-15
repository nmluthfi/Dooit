import 'package:dooit/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker/faker.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:flutter_svg/flutter_svg.dart';


List<String> labelOptions = [
  "Personal",
  "Work",
  "Others"
];

var selectedOption;

// form handler
final titleController = TextEditingController();
final descController = TextEditingController();

class DetailTodo extends StatefulWidget {

  @override
  State<DetailTodo> createState() => _DetailTodoState();
}

class _DetailTodoState extends State<DetailTodo> {

  final _formKey = GlobalKey<FormState>();

  var faker = new Faker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
          IconButton(
            icon: Icon(
              Icons.image,
              color: Colors.black,
            ),
            onPressed: () {

            },
          ),
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
                }
              }
            },
          ),
          IconButton(
            onPressed: () {

            },
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
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
                SvgPicture.network(
                  "https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fempty_todo_state.svg?alt=media&token=7297b2d0-87e6-4585-a2b7-2bb3fe6e6df9",
                  fit: BoxFit.fill,
                  width: 250,
                  height: 180,
                ),
                TextFormField(
                  controller: titleController,
                  maxLines: 1,
                  initialValue: faker.lorem.word(),
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
                  initialValue: loremIpsum(paragraphs: 10),
                  onTapOutside: (text) {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 17,
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
                                    selected: false,
                                    onSelected: (selected) {
                                      print(labelOptions[index]);
                                    },
                                    selectedColor: Color(0xffF5F5F5),
                                    backgroundColor: Color(0xff000000),
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