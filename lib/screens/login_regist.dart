import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



// MY OWN PACKAGE
import 'package:lets_shop/service/auth.dart';
import 'package:provider/provider.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/provider/user_provider.dart';

enum Page { login, register}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Auth auth = Auth();

  Page _selectedPage = Page.login;

  User user;

  bool loading = false;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  TextEditingController _emailSignUp = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _passwordSignUp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      body: user.status == Status.Authenticating ? Loading()
          : ListView(
        children: <Widget>[
          SizedBox(height: 10),
          //                LOGO
          Container(
            alignment: Alignment.topCenter,
            height: 240,
            child: Image.asset(
              "images/AppLogoOptik.png",
              height: 230,
              fit: BoxFit.fill,
            ),
          ),
//        All of Content login
          pageScreen()
        ],
      ),
    );
  }
  Widget pageScreen(){
    final user = Provider.of<UserProvider>(context);
    switch (_selectedPage) {
      case Page.login:
        return Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                  children: <Widget>[
//                      TEXTBOX EMAIL
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
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
//                  TEXTBOX PASSWORD
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _password,
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  icon: Icon(Icons.lock_outline),
                                  border: InputBorder.none,
//                            SHOW/HIDE PASSWORD
                                  suffixIcon: Padding(
                                    padding:
                                    const EdgeInsets.only(right: 16.0),
                                    child: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                            !_passwordVisible;
                                          });
                                        }),
                                  )),
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
                    ),
//                  FORGOT PASSWORD INKWELL
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 14.0, 8.0),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {},
                          child: Text('Forgot Password?',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: black)),
                        ),
                      ),
                    ),
//                  BUTTON SIGN IN
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: blue,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (!await user.signIn(_email.text, _password.text)) {
                                _key.currentState.showSnackBar(SnackBar(
                                  backgroundColor: white,
                                  content: Text('Sign in Failed',
                                      style: TextStyle(color: blue)),
                                ));
                              }
                              print(user.status);
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            'Sign in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
/*//                  LOADING
                      Visibility(
                          visible: loading ?? true,
                          child: new Center(
                            child: new Container(
                              alignment: Alignment.center,
                              color: Colors.white.withOpacity(0.9),
                              child: new CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ),
                          )),*/
//                  Divider OR
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Row(
                        children: <Widget>[
                          new Expanded(child: Divider(color: Colors.black)),
                          new Padding(
                            padding:
                            const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                                child: Text('or',
                                    style: TextStyle(fontSize: 16))),
                          ),
                          new Expanded(child: Divider(color: Colors.black))
                        ],
                      ),
                    ),
//                  BUTTON GOOGLE SIGN IN
                    loading
                        ? Loading()
                        : Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                      elevation: 0.0,
                      child: MaterialButton(
                        minWidth: 200,
                        onPressed: () async{
                          setState(() {
                            loading = true;
                          });
                          await auth.googleSignIn();
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: white),
                              child: Image(
                                image: AssetImage("images/google_logo.png"),
                                height: 35.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right:10),
                              child: Text(
                                'Sign in with Google',
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

//                  INKWELL SIGN UP
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("Don't have an account?",
                              style: TextStyle(fontSize: 16)),
                          InkWell(
                              onTap: () {
                                /*Navigator.of(context)
                                  .pushReplacement(_routeToSignUp());*/
                                /*Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => signUp()));*/
                                setState(() {
                                  _selectedPage = Page.register;
                                });
                              },
                              child: new Text(' Sign up',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: blue)
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      break;
      case Page.register:
        return Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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

//                  TEXTBOX FULL NAME
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
                              controller: _emailSignUp,
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
                            controller: _passwordSignUp,
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
                        color: blue,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (!await user.signUp(_name.text, _emailSignUp.text, _passwordSignUp.text)) {
                                _key.currentState.showSnackBar(SnackBar(
                                  content: Text('Sign up Failed',
                                      style: TextStyle(color: blue)),
                                  backgroundColor: white,
                                ));
                                return null;
                              }
/*                                      changeScreenReplacement(
                                          context, controller_Page());*/
                              print(user.status);
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
//                  BUTTON GOOGLE SIGN UP
                    loading
                        ? Loading()
                        : Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                      elevation: 0.0,
                      child: MaterialButton(
                        minWidth: 200,
                        onPressed: () async{
                          setState(() {
                            loading = true;
                          });
                          await auth.googleSignIn();

                          setState(() {
                            loading = false;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: white
                              ),
                              child: Image(
                                image: AssetImage("images/google_logo.png"),
                                height: 35.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right:10),
                              child: Text(
                                'Sign up with Google',
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
/*                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => Login()));*/
                                  setState(() {
                                    _selectedPage = Page.login;
                                  });
                              },
                              child: new Text(' Sign in',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: blue)))
                        ],
                      ),
                    ),
//                  LOADING
/*                            Visibility(
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
                                )),*/
                  ],
                ),
              ),
            ),
          ),
        );
    }
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),

              ),
            ),
          )
        ],
      ),
    );*/
