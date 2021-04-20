import 'package:flutter/material.dart';

//FIREBASE CORE
import 'package:firebase_core/firebase_core.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/screens/home.dart';
import 'package:provider/provider.dart';

// MY OWN PACKAGE
import 'file:///D:/App%20Flutter%20build/lets_shop/lib/tidak_terpakai/controller.dart';
import 'package:lets_shop/screens/splash.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/login.dart';
import 'package:lets_shop/commons/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (_) => UserProvider.initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: redAccent),
        home: ScreensController(),
      ))
  );
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
        return Login();
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      default: return Login();
    }
  }
}
