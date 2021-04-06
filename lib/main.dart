import 'package:flutter/material.dart';

//PACKAGE LINE ICONS FOR ICONS
import 'package:line_icons/line_icons.dart';

//PACKAGE BOTTOM BAR
import 'package:google_nav_bar/google_nav_bar.dart';

// MY OWN PACKAGE
import 'package:lets_shop/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Login(),
    )
  );
}
