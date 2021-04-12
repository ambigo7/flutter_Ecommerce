import 'package:flutter/material.dart';

//FIREBASE CORE
import 'package:firebase_core/firebase_core.dart';

// MY OWN PACKAGE
import 'package:lets_shop/pages/login.dart';

void main() async{
/*  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();*/
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent[700]
      ),
      home : Login(),
    )
  );
}
