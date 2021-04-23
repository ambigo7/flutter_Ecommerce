import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: white,
        child: SpinKitFadingCircle(
          color: redAccent,
          size: 30,
        )
    );
  }
}
