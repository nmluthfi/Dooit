import 'package:dooit/todo/todo_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    'https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fempty_todo_state.svg?alt=media&token=7297b2d0-87e6-4585-a2b7-2bb3fe6e6df9',
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              Text(
                  "Create your first to-do list...",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Codec Cold Trial',
                  )
              ),
              SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputTodo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF000000),
                  minimumSize: Size(125, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon( // <-- Icon
                  Icons.add,
                  size: 24.0,
                ),
                label: Text(
                  'New List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Codec Cold Trial',
                  ),
                ), // <-- Text
              ),
            ],
          ),
        ),
      ],
    );
  }
}