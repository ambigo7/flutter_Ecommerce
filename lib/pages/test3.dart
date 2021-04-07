import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class test_Pages3 extends StatefulWidget {
  @override
  _test_PagesState createState() => _test_PagesState();
}

class _test_PagesState extends State<test_Pages3> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn user = new GoogleSignIn();
  Future handleSignOut() async{
    await firebaseAuth.currentUser;
    await firebaseAuth.signOut();
    Fluttertoast.showToast(msg: 'Logout Successfull');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new FlatButton(
            color: Colors.red.shade900,
            onPressed: () {handleSignOut();},
            child: new Text('Sign out', style: TextStyle(color: Colors.white))
        ),
      ),
    );
  }
}
