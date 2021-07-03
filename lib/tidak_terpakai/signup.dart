import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/service/auth.dart';
import 'package:lets_shop/service/users.dart';
import 'package:provider/provider.dart';

import '../screens/login_regist.dart';

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
//        All of Widget

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
