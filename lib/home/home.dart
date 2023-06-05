import 'package:dooit/home/empty_state.dart';
import 'package:dooit/home/main_layout.dart';
import 'package:dooit/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void initState() {
    super.initState();
    // checking if user is signed in
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      // if user is not signed in, move to SplashScreen
      if (user == null) {
        // move to SplashScreen
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)  => SplashScreen()), (Route<dynamic> route) => false);
      } else {
        print('User is signed in!');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
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
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {

            },
          ),
          SizedBox(width: 16),
        ],
      ),

      body:
      //    if not empty, show the data
      // MainLayout(),

      //  if empty, show the empty state
      EmptyState(),
    );
  }
}