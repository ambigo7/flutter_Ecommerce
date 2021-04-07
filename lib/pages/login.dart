/*import 'dart:html';*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// MY OWN PACKAGE *use this if the class is the same directory
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // ==NEW VARIABLES OBJECT FOR GOOGLE SIGN IN===
  final GoogleSignIn googleSignIn = new GoogleSignIn();

// ==NEW VARIABLES OBJECT FOR FIREBASE AUTHENTICATION===
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

/* ===CALL OBJECT SHARED PREFERENCES
  for get the simple data like the login data a.k.a LIKE SESSION ON WEBSITE
  https://www.byriza.com/flutter-41-menyimpan-data-dengan-shared-preferences-pada-flutter#:~:text=Hello%20world%2C,pengaturan%20pada%20tiap%2Dtiap%20pengguna.===*/
  SharedPreferences preferences;

  bool loading = false;
  bool isLogedin = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }
//FOR http://www.udacoding.com/mengenal-stream-async-yield-dan-yield-pada-flutter/
  void isSignedIn() async{
//  ==LOADING PROCCESS START===
    setState(() {
      loading = true;
    });

//  ==AWAIT FOR sharePeferences getTnstance a.k.a NEW OBJECT====
    preferences = await SharedPreferences.getInstance();

/*  ==FOR RETURN A VARIABEL BOOL(isLogedin)
    IS GOING TO CHECK WHAT THE USER IS LOGIN OR NOT===*/
    isLogedin = await googleSignIn.isSignedIn();

//  IF USER LOGED IN == TRUE
    if(isLogedin){
//    ==MOVE TO A NEW SCREEN WITHOUT BACK BUTTON IN FLUTTER a.k.a for login==
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
    }

//  ==LOADING PROCCESS END===
    setState(() {
      loading = false;
    });
  }
//FOR http://www.udacoding.com/mengenal-stream-async-yield-dan-yield-pada-flutter/
  Future handleSignIn() async{

//  ==AWAIT FOR sharePeferences getTnstance a.k.a NEW OBJECT====
    preferences = await SharedPreferences.getInstance();

//  ==LOADING PROCCESS START===
    setState(() {
      loading = true;
    });

//  ==SEMENTARA PAKE INI KARNA BELUM KETEMU CARA BUAT SIGN OUT
//  atau Uninstall App/Clear data App
//  ===
    /*googleSignIn.disconnect();*/
//  ===THIS PART FOR GOOGLE USER AUTH but use await so after===
//  ===GOOGLE USER SIGNIN===
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
//  ===GOOGLE SIGN IN AUTHENTICATION===
    GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
/*  ===GOOGLE AUTHENTICANTION GET CREDENTIAL ID TOKEN & ACCESS TOKEN
    *Updated on firebase_auth latest version*
    https://stackoverflow.com/questions/63482162/undefined-class-firebaseuser*/
    GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
//  ===AFTER GOOGLE USER AUTH GET USER===
    final UserCredential authresult = await firebaseAuth.signInWithCredential(
        credential);
    final User user = authresult.user;

//  ===IF USER EXIST & await GOOGLE AUTH USER===
    if(user != null){
//    ==GET COLLECTION NAME 'USER' DOCUMENT 'ID' == GOOGLE USER,ID===
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid).get();
//    ===TAKING THE result IN LIST 'documents'==
      final List<DocumentSnapshot> documents = result.docs;

//    ===IF THE USER DOESN'T EXIST ON YOUR 'documents' COLLECTION(FIRESTORER)===
        if(documents.length == 0){
//     ===INSERT INTO THE USER ON YOUR COLECTION(AUTHENTICATION And USER firestore)===
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid).set({
            "id": user.uid,
            "username": user.displayName,
            "profilePicture": user.photoURL
          });
//      ==PUT DATA USER ID,DISPLAYNAME,PHOTOURL ON PREFERENCE==
          await preferences.setString("id", user.uid);
          await preferences.setString("username", user.displayName);
          await preferences.setString("photoUrl", user.photoURL);
//    ELSE IF THE USER DOES EXIST ON YOUR 'documents' COLLECTION FireStore
        }else{
//      ==PUT DATA USER ID,DISPLAYNAME,PHOTOURL ON PREFERENCE==
          await preferences.setString("id", documents[0]["id"]);
          await preferences.setString("username", documents[0]["username"]);
          await preferences.setString("photoUrl", documents[0]["photoURL"]);
        }
//    IF SUCCESSFULLY DONE
        Fluttertoast.showToast(msg: "Login Successfull");
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
      }else{
        Fluttertoast.showToast(msg: 'Login Failed');
      }
  }
//===FOR LOGOUT===
  Future handleSignOut() async{
    await firebaseAuth.signOut();
/*    await googleSignIn.disconnect();*/
    Fluttertoast.showToast(msg: 'Logout Successfull');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text('Login', style: TextStyle(color: Colors.red.shade900)
        ),
      ),
      
      body: new Stack(
        children: <Widget>[
          Center(
            child: new FlatButton(
                color: Colors.red.shade900,
                onPressed: () {handleSignIn();},
                child: new Text('Sign in / Sign Up with Google', style: TextStyle(color: Colors.white))
            ),
          ),
          Visibility(
            visible: loading ?? true,
            child: new Center(
              child: new Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: new CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          )
        ],
      ),
/*      bottomNavigationBar: new Container(
        child: new Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: RaisedButton(onPressed: () {handleSignIn();},
              child: new Text('Sign in / Sign Up with Google',
                  style: TextStyle(color: Colors.black))
          ),
        ),
      ),*/
    );
  }
}
