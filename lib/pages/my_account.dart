import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_shop/service/auth.dart';

//MY OWN PACKAGE
import 'login.dart';

class myAccount extends StatefulWidget {
  @override
  _myAccountState createState() => _myAccountState();
}

class _myAccountState extends State<myAccount> {
  User user = FirebaseAuth.instance.currentUser;
  bool _isSigningOut = false;
  //ANIMASI SLIDE TRANSISI
  Route _routeToLogin() {
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
      appBar: new AppBar(
        //REMOVE BUTTON BACK
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text('My Account', style: TextStyle(color: Colors.red)),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                user.photoURL != null
              ? ClipOval(
                  child: Material(
                    color: Colors.grey,
                    child: Image.network(user.photoURL),
                  ),
                ) : ClipOval(
                  child: Material(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.person,
                      size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.0),
              Text('Hi,',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 26
                )
              ),
              SizedBox(height: 8.0),
              Text(user.displayName,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 26
                  )
              ),
              SizedBox(height: 8.0),
              Text(user.email,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 26,
                    letterSpacing: 0.5
                  )
              ),
              SizedBox(height: 24.0),
              Text('You are now signed in using your Google account. '
                  'To sign out of your account, click the "Sign Out" button below.',
                  style: TextStyle(
                      color: Colors.red.withOpacity(0.8),
                      fontSize: 14,
                      letterSpacing: 0.2
                  )
              ),
              SizedBox(height: 16.0),
              _isSigningOut
              ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              )
               : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
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
                        .pushReplacement(_routeToLogin());
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
            ],
          ),
        ),
      ),
    );
  }
}

/*      body: new Center(
        child: new FlatButton(
            color: Colors.red,
            onPressed: () async{
              setState(() {
                _isSigningOut = true;
              });
              await Authentication.signOut(context: context);
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context)
                  .pushReplacement(_routeToLogin());
              /*Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => new Login()));*/
            },
            child: new Text('Sign out', style: TextStyle(color: Colors.white))
        ),
      ),*/