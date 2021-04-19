import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/pages/controller.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/service/auth.dart';
import 'package:lets_shop/service/users.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  Auth auth = Auth();
  UserServices _userServices = UserServices();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _passwordVisible = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      body: user.status == Status.Authenticating
          ? Loading()
          : ListView(
              children: <Widget>[
//        All of Widget
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[350],
                              blurRadius: 20,
                            )
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                LOGO
                            Container(
                              alignment: Alignment.topCenter,
                              width: 240.0,
                              child: Image.asset(
                                "images/lets_ShopLogo.png",
                                fit: BoxFit.fill,
                              ),
                            ),
//                  TEXTBOX FULL NAME
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 0.0, 14.0, 8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(0.1),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    title: TextFormField(
                                      controller: _name,
                                      decoration: InputDecoration(
                                          hintText: 'Full Name',
                                          icon: Icon(Icons.person_outline),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'The name field cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),

//                  TEXTBOX EMAIL
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 14.0, 8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(0.1),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    title: TextFormField(
                                      controller: _email,
                                      decoration: InputDecoration(
                                          hintText: 'Email',
                                          icon: Icon(Icons.email_outlined),
                                          border: InputBorder.none),
                                      keyboardType: TextInputType.emailAddress,
//                              VALIDASI REGEX
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = RegExp(pattern);
                                          if (!regex.hasMatch(value))
                                            return 'Please makes sure your email address is valid';
                                          else
                                            return null;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),

/*//                  RADIO BUTTON GENDER
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Row(
                          children: <Widget>[
*/ /*                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 0.0, 8.0),
                              child: Icon(Icons.people_outline,
                                  color: Colors.grey[600]),
                            ),*/ /*
                            Expanded(
                                child: ListTile(
                                  title: Text('Male',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.black)),
                                  trailing: Radio(
                                  activeColor: Colors.deepOrangeAccent[700],
                                  value: 'male',
                                  groupValue: groupValue,
                                  onChanged: (e) => valueChanged(e)),
                            )),
                            Expanded(
                                child: ListTile(
                                  title: Text('Female',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.black)),
                                  trailing: Radio(
                                  activeColor: Colors.deepOrangeAccent[700],
                                  value: 'female',
                                  groupValue: groupValue,
                                  onChanged: (e) => valueChanged(e)),
                            )),
                          ],
                        ),
                      ),*/
//                  TEXTBOX PASSWORD
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 14.0, 8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(0.1),
                                elevation: 0.0,
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _password,
                                    obscureText: _passwordVisible,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 14.0),
                                          child: Icon(Icons.lock_outline),
                                        ),
                                        border: InputBorder.none,
//                            SHOW/HIDE PASSWORD
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            })),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'The password field cannot be empty';
                                      } else if (value.length < 6) {
                                        return 'The Password has tobe at leat 6 character';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),

/*//                  TEXTBOX CONFIRM PASSWORD
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black.withOpacity(0.1),
                          elevation: 0.0,
                          child: ListTile(
                            title: TextFormField(
                              controller: _confirmPasswordTextController,
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                  hintText: 'Confirm  Password',
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 14.0),
                                    child: Icon(Icons.lock_outline),
                                  ),
                                  border: InputBorder.none,
//                            SHOW/HIDE PASSWORD
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      })),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'The password field cannot be empty';
                                } else if (value.length < 6) {
                                  return 'The Password has tobe at leat 6 character';
                                } else if (_passwordTextController.text != value) {
                                  return 'The password do not match';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),*/

//                  BUTTON SIGN UP
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 14.0, 8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: redAccent,
                                elevation: 0.0,
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (!await user.signUp(_name.text, _email.text, _password.text)) {
                                        _key.currentState.showSnackBar(SnackBar(
                                            content: Text('Sign up Failed',
                                          style: TextStyle(color: redAccent)),
                                          backgroundColor: white,
                                        ));
                                        return null;
                                      }
/*                                      changeScreenReplacement(
                                          context, controller_Page());*/
                                    }
                                  },
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Sign up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ),
                            //                  Divider OR
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 14.0, 8.0),
                              child: Row(
                                children: <Widget>[
                                  new Expanded(
                                      child: Divider(color: Colors.black)),
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Container(
                                        child: Text('or',
                                            style: TextStyle(fontSize: 16))),
                                  ),
                                  new Expanded(
                                      child: Divider(color: Colors.black))
                                ],
                              ),
                            ),
//                  BUTTON GOOGLE SIGN IN
                            loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                redAccent)))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: MaterialButton(
                                          onPressed: () async {
                                            User user =
                                                await auth.googleSignIn();
                                            if (user != null) {
                                              _userServices.createUser({
                                                "name": user.displayName,
                                                "photo": user.photoURL,
                                                "email": user.email,
                                                "userId": user.uid,
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            "images/google_logo.png",
                                            width: 30,
                                          )),
                                    ),
                                  ),
/*                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: FutureBuilder(
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
                      ),*/

//                  BUTTON BACK TO SIGN IN PAGES
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 20.0, 8.0, 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text("Already have an account?",
                                      style: TextStyle(fontSize: 16)),
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Login()));
                                      },
                                      child: new Text(' Sign in',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors
                                                  .deepOrangeAccent[700])))
                                ],
                              ),
                            ),
//                  LOADING
                            Visibility(
                                visible: loading ?? true,
                                child: new Center(
                                  child: new Container(
                                    alignment: Alignment.center,
                                    color: Colors.white.withOpacity(0.9),
                                    child: new CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.deepOrangeAccent[700]),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

/*  Future validationForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.reset();
      await _authentication.signUpUser(_nameTextController.text,
          _emailTextController.text, _passwordTextController.text, context: context);
      }
    }*/
}
