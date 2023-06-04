import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTodo extends StatelessWidget {

  List<String> labelOptions = [
    "Personal",
    "Work",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        child: Column(
          children: [
            TextFormField(
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
                border: InputBorder.none,
              ),
            ),
            TextFormField(
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
                border: InputBorder.none,
              ),
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
                                selected: false,
                                onSelected: (selected) {
                                  print(labelOptions[index]);
                                },
                                selectedColor: Color(0xffF5F5F5),
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
    );
  }

}