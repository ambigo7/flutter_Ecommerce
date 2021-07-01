import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/components/custom_text.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            margin: EdgeInsets.only(bottom:25),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/nointernet.png")
              )
            ),
          ),
          CustomText(
            text: "No Internet Connection",
            size: 20,
            weigth: FontWeight.bold,
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: CustomText(text: "You are not connected to the internet. make sure Wi-Fi is on, and Airplace is off.",
                    size: 16,
            ),
          )
        ],
      ),
    );
  }
}
