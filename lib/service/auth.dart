import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_shop/models/user.dart';


import 'users.dart';

abstract class BaseAuth {
  Future<User> googleSignIn();
}

class Auth implements BaseAuth {
  UserServices _userServices = UserServices();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel _userModel;

//GETTER read data
  UserModel get userModel => _userModel;


  @override
  Future<User> googleSignIn() async {
    User user;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      try {
        UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(
            credential);
        user = userCredential.user;
        print('user google sign in : $user');
      } catch (e) {
        print(e.toString());
        return null;
        }
      }
      return user;
    }

    Future<bool> checkEmail(String email)async{
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      final List<DocumentSnapshot> data = result.docs;
      String dataTo = data.toString();
      print('data snapshot check email : $dataTo');

      if(data.length > 0){
        return false;
      }else{
        return true;
      }
    }
    

    Future<bool> userExist(String uid)async{
      final snapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if(snapShot == null || !snapShot.exists){
        return true;
      }else{
        return false;
      }
    }
/*    void createUser() async {
      try {
          print("Ready to Creating User..");
          _userServices.createUser(
              {
                "name": user.displayName,
                "photo": user.photoURL,
                "email": user.email,
                "uid": user.uid,
              });
      } catch (e) {
        print(e.toString());
        return null;
      }
    }*/
  }
