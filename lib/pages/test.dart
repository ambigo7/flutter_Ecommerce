import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/main.dart';
import 'package:lets_shop/service/auth.dart';

import 'login.dart';

class test_Pages extends StatefulWidget {
  @override
  _test_PagesState createState() => _test_PagesState();
}

// CLASS KEBUTUHAN DEBUGGING
class _test_PagesState extends State<test_Pages> {
  bool _isSigningOut = false;
  User user = FirebaseAuth.instance.currentUser;
  Route _routeToSignIn() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: _isSigningOut
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent[700]),
        )
            : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent[700]),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
              ),
            ),
            onPressed: () async {
              setState(() {
                _isSigningOut = true;
              });
              await Authentication.signOut(context: context);
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context)
                  .pushReplacement(_routeToSignIn());
            }, child: Padding(
          padding: EdgeInsets.only(top:8.0, bottom: 8.0),
          child: Text('Sign Out',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2
              )
          ),
        )
        )
      ),
    );
  }
}
