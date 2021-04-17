import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lets_shop/service/auth.dart';

import 'controller.dart';
import 'login.dart';

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  Authentication _authentication = Authentication();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  String gender;
  String groupValue = "male";
  bool _passwordVisible = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
        children: <Widget>[
//        LOGO
          Container(
            alignment: Alignment.topCenter,
            height: 300.0,
            child: Image.asset(
              "images/lets_ShopLogo.png",
              fit: BoxFit.fill,
            ),
          ),

//        All of Widget
          Container(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
//                  TEXTBOX FULL NAME
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            controller: _nameTextController,
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

//                  TEXTBOX EMAIL
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            controller: _emailTextController,
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

//                  RADIO BUTTON GENDER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 0.0,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 0.0, 8.0),
                              child: Icon(Icons.people_outline,
                                  color: Colors.grey[600]),
                            ),
                            Expanded(
                                child: ListTile(
                                  title: Text('Male',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.grey[600])),
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
                                  style: TextStyle(color: Colors.grey[600])),
                                  trailing: Radio(
                                  activeColor: Colors.deepOrangeAccent[700],
                                  value: 'female',
                                  groupValue: groupValue,
                                  onChanged: (e) => valueChanged(e)),
                            )),
                          ],
                        ),
                      ),
                    ),
//                  TEXTBOX PASSWORD
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 0.0,
                        child: TextFormField(
                          controller: _passwordTextController,
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Icon(Icons.lock_outline),
                              ),
                              border: InputBorder.none,
//                            SHOW/HIDE PASSWORD
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
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

//                  TEXTBOX CONFIRM PASSWORD
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 0.0,
                        child: TextFormField(
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
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    }),
                              )),
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

//                  BUTTON SIGN UP
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.deepOrangeAccent[700],
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await validationForm();
                            setState(() {
                              loading = false;
                            });
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    controller_Page(),
                                  )
                              );
/*                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => controller_Page()));*/
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
//                  BUTTON BACK TO SIGN IN PAGES
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("Already have an account?",
                              style: TextStyle(fontSize: 16)),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Login()));
                              },
                              child: new Text(' Sign in',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepOrangeAccent[700])))
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
          )
        ],
      ),
    );
  }

  valueChanged(e) {
    setState(() {
      if (e == 'male') {
        groupValue = e;
        gender = e;
      } else if (e == 'female') {
        groupValue = e;
        gender = e;
      }
    });
  }

  Future validationForm() async {
    FormState formState = _formKey.currentState;
/*    User user = await firebaseAuth.currentUser;*/
    if (formState.validate()) {
      formState.reset();
      await _authentication.signUpUser(_nameTextController.text,
          _emailTextController.text, _passwordTextController.text, gender, context: context);
      }
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => controller_Page()));*/
    }
  }
