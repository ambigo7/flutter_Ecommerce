import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_shop/pages/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/users.dart';

/* ===CALL OBJECT SHARED PREFERENCES===
    is like Session, save a simple data*/
SharedPreferences preferences;

abstract class BaseAuth {
  Future<User> googleSignIn();
}

class Authentication implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<User> googleSignIn() async {
    User user;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;
    }catch(e){
      print(e.toString());
      return null;
    }
    return user;
  }

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
  signUpUser(fullname, email, pass, {BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((user) => {
              _userServices.createUser(
              {
                "username": fullname,
                "email": email,
                "userId": user.user.uid,
              })
            })
        .catchError((err) => {print(err.toString())});
    ScaffoldMessenger.of(context).showSnackBar(
      Authentication.customSnackBar(
        content: 'User was Created',
      ),
    );
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
        if (user != null) {
          await _firestore.collection(coll).doc(user.uid).set({
            "username": user.displayName,
            "email": user.email,
            "userId": user.uid,
          });
          print("User Was Created");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Sign-In Successful',
          ),
        );
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
