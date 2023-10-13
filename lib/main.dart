import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:mytok_worker/screens/home_test.dart';
import 'package:mytok_worker/screens/login_screen.dart';
import 'package:mytok_worker/screens/web_socket_test.dart';

import 'firebase_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized.
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var users = Hive.box('users');
    var user = users.get("firstname");
    bool isReg = false;
    if(user != null){
      isReg = true;
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: isReg ? HomeTest() : LoginPage(),
    );
  }
}

