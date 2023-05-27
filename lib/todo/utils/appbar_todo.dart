import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarTodo extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}