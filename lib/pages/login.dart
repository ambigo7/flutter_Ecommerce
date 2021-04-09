import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/service/auth.dart';


// MY OWN PACKAGE *use this if the class is the same directory
import 'package:lets_shop/components/google_sign_in_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text('Login', style: TextStyle(color: Colors.red)
        ),
      ),
      body: new Stack(
        children: <Widget>[
          Padding(
          padding: const EdgeInsets.fromLTRB(16.0,250.0,16.0,20.0),
            child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //FUNGSINYA BUAT MANGGIL METHOD INISIALISASI FIREBASE, KALO KONEKSI BERMASLAAH BUTTON GA NONGOL
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase, Check Your Connection');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    //class button ada di component
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

// BOTTON ALGORITMA SANTOS
/*      body: new Stack(
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),*/

/*              ),*
            ),
          )
        ],
      ),
    );*/

