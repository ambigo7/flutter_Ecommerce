import 'package:flutter/material.dart';

Color redAccent = Colors.deepOrangeAccent[700];
Color black = Colors.black;
Color white = Colors.white;

//methods

void changeScreen(BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void changeScreenReplacement(BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
}


