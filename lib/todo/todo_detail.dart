import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker/faker.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailTodo extends StatelessWidget {

  List<String> labelOptions = [
    "Personal",
    "Work",
    "Others"
  ];

  var faker = new Faker();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ),
            TextFormField(
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
      );
  }

}