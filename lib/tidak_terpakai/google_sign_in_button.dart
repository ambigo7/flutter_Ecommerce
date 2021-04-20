import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/common.dart';
import 'file:///D:/App%20Flutter%20build/lets_shop/lib/tidak_terpakai/controller.dart';
import 'file:///D:/App%20Flutter%20build/lets_shop/lib/tidak_terpakai/authentication.dart';
import 'package:lets_shop/service/auth.dart';
import 'package:lets_shop/service/users.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {

  Auth auth = Auth();
  UserServices _userServices = UserServices();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent[700]),
            ),
        )
        // BUTTON SIGN IN
        : Material(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueAccent,
            elevation: 0.0,
          child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
              // this for elevatedbutton or outlinedbutton
/*            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),*/
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                /*User user = await Authentication.signInWithGoogle(context: context);*/
                User user = await auth.googleSignIn();

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  _userServices.createUser(
                  {
                        "username": user.displayName,
                        "photo": user.photoURL,
                        "email": user.email,
                        "userId": user.uid,
                  });
                  changeScreenReplacement(context, controller_Page());
/*                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          //ROUTE KE HOMEPAGE PARAMETER USER
                          controller_Page(), //user: user
                    ),
                  );*/
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.topLeft,
                        child: Image(
                          image: AssetImage("images/google_logo.png"),
                          height: 35.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in / Sign up with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        );
  }
}
