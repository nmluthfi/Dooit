import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Home/home.dart';

Future<UserCredential> signInWithGoogle(BuildContext context, DatabaseReference ref) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  try {
    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((userCredential) async {
      // Retrieve the userId from the userCredential
      final String? userId = userCredential.user?.uid;

      // Check if the userId exists in the database
      final dataSnapshot = await ref.child("users").orderByChild("userid").equalTo(userId).once();

      if (dataSnapshot.snapshot.value != null) {
        // User already exists, log in directly
        print("User already exists. Logging in...");
        // Move to Home after successful login
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false
        );
        return userCredential; // Return the userCredential without saving
      }

      // User doesn't exist, save user data to Firebase Database
      await ref.child("users").push().set({
        "userid": userId,
        "name": userCredential.user?.displayName,
        "email": userCredential.user?.email,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      }).then((_) {
        // Data saved successfully!
        print("Success saves users credential");

        // Move to Home after successful login
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false
        );
      }).catchError((error) {
        // The write failed...
        print("Something wrong while saving user data: $error");
      });
      return userCredential;
    }).catchError((error) {
      // The write failed...
      print("Can't login with Google: $error");
      throw error;
    });
    return userCredential;
  } catch (e) {
    // Handle any errors
    print('Error signing in with Google: $e');
    // You can choose to show an error message or handle the error in any other way
    throw e;
  }

}