import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



// MY OWN PACKAGE *use this if the class is the same directory
import 'package:lets_shop/components/google_sign_in_button.dart';
import 'package:lets_shop/pages/signup.dart';
import 'package:lets_shop/service/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
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
//                      TEXTBOX EMAIL
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.1),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left:12.0),
                              child: TextFormField(
                                controller: _emailTextController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  icon: Icon(Icons.email_outlined),
                                  border: InputBorder.none
                                ),
                                keyboardType: TextInputType.emailAddress,
//                              VALIDASI REGEX
                                validator: (value) {
                                  if(value.isEmpty){
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = RegExp(pattern);
                                    if(!regex.hasMatch(value))
                                      return 'Please makes sure your email address is valid';
                                    else
                                      return null;
                                  }
                                  return value;
                                },
                              ),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: TextFormField(
                            controller: _passwordTextController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              icon: Icon(Icons.lock_outline),
                              border: InputBorder.none
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'The password field cannot be empty';
                              }else if(value.length < 6){
                                return'The Password has tobe at leat 6 character';
                              }
                              return value;
                            },
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
                          onTap: (){},
                          child: Text('Forgot Password?',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black)
                          ),
                        ),
                      ),
                    ),
//                  BUTTON SIGN IN
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.deepOrangeAccent[700],
                        elevation: 0.0,
                        child: MaterialButton(
                            onPressed: (){},
                            minWidth: MediaQuery.of(context).size.width,
                          child: Text('Sign in', textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                          ),
                        ),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ),
                      )
                    ),
//                  Divider OR
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                              child: Divider(color: Colors.black)
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8.0),
                            child: Container(
                                child: Text('or', style: TextStyle(fontSize: 16))),
                          ),
                          new Expanded(
                              child: Divider(color: Colors.black)
                          )
                        ],
                      ),
                    ),
//                  BUTTON GOOGLE SIGN IN
                    Padding(
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
                    ),
//                  INKWELL SIGN UP
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("Don't have an account?",
                              style: TextStyle(fontSize: 16)
                          ),
                          InkWell(onTap: (){
                            /*Navigator.of(context)
                                .pushReplacement(_routeToSignUp());*/
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => signUp()));
                          },
                              child: new Text(' Sign up',
                                  style: TextStyle(fontSize: 16, color: Colors.deepOrangeAccent[700])
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),

              ),
            ),
          )
        ],
      ),
    );*/

