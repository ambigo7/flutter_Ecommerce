/*import 'dart:js';*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_shop/pages/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'users.dart';

/* ===CALL OBJECT SHARED PREFERENCES===
    is like Session, save a simple data*/
SharedPreferences preferences;

class Authentication {
  UserServices _userServices = UserServices();

// KALO PAKE STATIC METHOD SEWAKTU PANGGIL DI CLASS LAIN GA PERLU BIKIN NEW OBJECT LAGI, BISA LANGSUNG PANGGIL METHODNYA
// METHOD INISIALISASI FIREBASE
  static Future<FirebaseApp> initializeFirebase({BuildContext context}) async {
//  INISIALISASI FIREBASE, BUAT PAKE SEMUA SERVICE FIREBSE
    FirebaseApp firebaseApp = await Firebase.initializeApp();

//  AUTO LOGIN
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              //ROUTE KE HOMEPAGE PARAMETER USER
              controller_Page(),
        ),
      );
    }
    return firebaseApp;
  }

//  METHOD SIGN UP USER
    signUp_user(fullname, email, pass, gender, {BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
/*    try {
      UserCredential result = await auth
          .createUserWithEmailAndPassword(email: email, password: pass);
    } catch (e) {

    }*/
    User user =
    await auth.currentUser;
    if (user == null) {
       auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((user) => {_userServices.createUser(user.user.uid,
              {
                "username": fullname,
                "email": email,
                "userId": user.user.uid,
                "gender": gender,
              })
           }).catchError((err) => {print(err.toString())});
       /*user = result.user; */
    }

    /*else{
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'The email already exists with a different credential.',
        ),
      );
    }*/
  }

// METHOD SIGN IN GOOGLE
  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String gender;
    User user;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String coll = "users";
    preferences = await SharedPreferences.getInstance();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    // CEK UDAH MILIH AKUN ATAU BELUM
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      //
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        if(user != null){
          await _firestore.collection(coll).doc(user.uid).set(
              {
                "username": user.displayName,
                "email": user.email,
                "userId": user.uid,
                "gender": gender,
              }
          );
          print("User Was Created");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Sign-In Successful',
          ),
        );
/*        if (user != null) {
          //    ==GET COLLECTION NAME 'USER' DOCUMENT 'ID' == GOOGLE USER,ID===
          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: user.uid)
              .get();
          //    ===TAKING THE result IN LIST 'documents'==
          final List<DocumentSnapshot> documents = result.docs;

          //    ===IF THE USER DOESN'T EXIST ON YOUR 'documents' COLLECTION(FIRESTORER)===
          if (documents.length == 0) {
            //     ===INSERT INTO THE USER ON YOUR COLECTION(AUTHENTICATION And USER firestore)===
            FirebaseFirestore.instance.collection("users").doc(user.uid).set({
              "id": user.uid,
              "username": user.displayName,
              "profilePicture": user.photoURL
            });
            //      ==PUT DATA USER ID,DISPLAYNAME,PHOTOURL ON PREFERENCE== GUA NGERTI BUAT APA FUNGSINYA
            await preferences.setString("id", user.uid);
            await preferences.setString("username", user.displayName);
            await preferences.setString("photoUrl", user.photoURL);
            //    ELSE IF THE USER DOES EXIST ON YOUR 'documents' COLLECTION FireStore
          } else {
            //      ==PUT DATA USER ID,DISPLAYNAME,PHOTOURL ON PREFERENCE== GUA NGERTI BUAT APA FUNGSINYA
            await preferences.setString("id", documents[0]["id"]);
            await preferences.setString("username", documents[0]["username"]);
            await preferences.setString("photoUrl", documents[0]["photoURL"]);
          }
          *//*Fluttertoast.showToast(msg: "Login Successfull");*//*
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Sign-In Successful',
            ),
          );
        } else {
          *//*Fluttertoast.showToast(msg: 'Login Failed');*//*
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Sign-In Failed',
            ),
          );
        }*/
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }
    return user;
  }

  //METHOD SIGN OUT GOOGLE
  static Future<void> signOut({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  //METHOD CUSTOM SNACKBAR
  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: TextStyle(color: Colors.red, letterSpacing: 0.5),
      ),
    );
  }
}
