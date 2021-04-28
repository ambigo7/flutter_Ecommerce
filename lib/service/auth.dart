import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'users.dart';

abstract class BaseAuth {
  Future<User> googleSignIn();
}

class Auth implements BaseAuth {
  UserServices _userServices = UserServices();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(
            credential);
        user = userCredential.user;
        if(user != null) {
          print("Ready to Creating User..");
          _userServices.createUser(
              {
                "name": user.displayName,
                "photo": user.photoURL,
                "email": user.email,
                "uid": user.uid,
              });
        }
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
    return user;
  }

}