import 'package:dooit/Home/home.dart';
import 'package:dooit/home/empty_state.dart';
import 'package:dooit/screens/splash_screen.dart';
import 'package:dooit/todo/todo.dart';
import 'package:dooit/todo/todo_detail.dart';
import 'package:dooit/todo/todo_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

// flutter
import 'package:flutter/material.dart';

// firebease
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ideal time to initialize
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final title = "Dooit";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Todo(),
    );
  }
}




