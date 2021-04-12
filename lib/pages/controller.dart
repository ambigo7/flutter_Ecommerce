import 'package:flutter/material.dart';
import 'package:lets_shop/components/home_body.dart';
import 'package:lets_shop/pages/home.dart';
import 'package:lets_shop/pages/test.dart';
import 'package:lets_shop/pages/test2.dart';

//PACKAGE BOTTOM BAR
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'my_account.dart';

class controller_Page extends StatefulWidget {
  @override
  _controller_PageState createState() => _controller_PageState();
}

class _controller_PageState extends State<controller_Page> {

  // FOR VALUES SELESTED ITEM
  int _selectedIndex = 0;
// LIST PAGES BOTTOM NAV
  final List<Widget> pages = [
    //work
    HomePage(),
//  DEBUGGING JUST TEST ITSN'T WORK
    test_Pages(),
    test_Pages2(),
    //work
    myAccount()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),

//          ====IMPLEMENTATION OF GNAV BOTTOM PUB.DEV====
            child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                activeColor: Colors.deepOrangeAccent[700],
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.white,
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.shoppingBasket,
                    text: 'History',
                  ),
                  GButton(
                    icon: LineIcons.heart,
                    text: 'Favorites',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Account',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}

