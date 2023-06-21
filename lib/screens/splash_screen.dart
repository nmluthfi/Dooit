import 'package:dooit/Home/home.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// auth
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';

import '../firebase_services/firebase_authentication.dart';

// Firebase
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void iniState()  {
    super.initState();
     // FirebaseAuth.instance.signOut();
     // GoogleSignIn().signOut();
     // GoogleSignIn().disconnect();

    // checking if user is signed in
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      // if user is signed in, move to Home
      if (user != null) {
        // move to Home
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)  => Home()), (Route<dynamic> route) => false);
      } else {
        print('User is not signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            child: Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(
                            'https://firebasestorage.googleapis.com/v0/b/doit-766f8.appspot.com/o/assets%2Fdooit_logo.svg?alt=media&token=059e3656-89dc-4e2b-810c-89485b210b88',
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 42),
                          child: Text(
                            "Dooit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Codec Cold Trial',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 28),
                          child: Text(
                            "Write what you need to \ndo. Everyday.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xC4C4C4C4),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Codec Cold Trial',
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(onPressed: () async {
                    signInWithGoogle(context, ref);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(199, 53),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                  ),
                  icon: Icon(
                    BoxIcons.bxl_google
                  ),
                  label: Text(
                    "Login with Google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:  16,
                      fontWeight:  FontWeight.w500,
                      height:  1.2999999523,
                      color:  Color(0xff000000),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}

