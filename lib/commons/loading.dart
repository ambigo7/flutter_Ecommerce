import 'package:flutter/material.dart';
import 'package:lets_shop/commons/common.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(redAccent)),
    );
  }
}
