import 'package:flutter/material.dart';
import 'package:lets_shop/main.dart';

class test_Pages extends StatefulWidget {
  @override
  _test_PagesState createState() => _test_PagesState();
}

class _test_PagesState extends State<test_Pages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: InkWell(
            onTap: () {
//          ===Passing page no values with Navigator.push====
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePage()));
            },
            child: Text('Lets Shop')),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search_outlined,
                color: Colors.white,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
