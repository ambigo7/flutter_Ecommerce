import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:provider/provider.dart';

//MY OWN PACKAGE
import '../screens/login_regist.dart';

class myAccount extends StatefulWidget {
  @override
  _myAccountState createState() => _myAccountState();
}

class _myAccountState extends State<myAccount> {
  User user = FirebaseAuth.instance.currentUser;
  bool _isSigningOut = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  //ANIMASI SLIDE TRANSISI
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
    final _user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: new AppBar(
        //REMOVE BUTTON BACK
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent[700]),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text('My Account',
            style: TextStyle(color: Colors.deepOrangeAccent[700])),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                user.photoURL != null
                    ? ClipOval(
                        child: Material(
                          color: Colors.grey,
                          child: Image.network(user.photoURL),
                        ),
                      )
                    : ClipOval(
                        child: Material(
                          color: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                SizedBox(height: 16.0),
                Text('Hi,', style: TextStyle(color: Colors.red, fontSize: 26)),
                SizedBox(height: 8.0),
                //Get data user from doc user.uid
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc(user.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data();
                      return Text("${data['name']}",
                          style: TextStyle(color: Colors.red, fontSize: 26));
                    }
                    return Text("loading");
                  },
                ),
                SizedBox(height: 8.0),
                //Get data user from doc user.uid
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc(user.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data();
                      return Text("${data['email']}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 26,
                              letterSpacing: 0.5));
                    }

                    return Text("loading");
                  },
                ),
                SizedBox(height: 24.0),
                SizedBox(height: 16.0),
                _isSigningOut
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepOrangeAccent[700]),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.deepOrangeAccent[700]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                        ),
                        onPressed: () async {
                          await _user.signOut();
                          print(_user.status);
/*                          changeScreenReplacement(context, Login());*/
/*                          setState(() {
                            _isSigningOut = true;
                          });
                          await Authentication.signOut(context: context);
                          setState(() {
                            _isSigningOut = false;
                          });
                          Navigator.of(context).pushReplacement(_routeToSignIn());*/
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text('Sign Out',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2)),
                        ))
              ],
            ),
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
