import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(redAccent));
  }
}