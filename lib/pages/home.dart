import 'package:flutter/material.dart';

//PACKAGE LINE ICONS FOR ICONS
import 'package:line_icons/line_icons.dart';

//PACKAGE BOTTOM BAR
import 'package:google_nav_bar/google_nav_bar.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/homeContent.dart';
import 'package:lets_shop/pages/shopping_cart.dart';
//DEBUGGING
import 'package:lets_shop/pages/test.dart';
import 'package:lets_shop/pages/test2.dart';
import 'package:lets_shop/pages/test3.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

// FOR VALUES SELESTED ITEM
  int _selectedIndex = 0;

// LIST PAGES BOTTOM NAV
  final List<Widget> pages = [
    homeBody(),

//  DEBUGGING JUST TEST ITSN'T WORK
    test_Pages(),
    test_Pages2(),
    test_Pages3()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Lets Shop'),
        actions: <Widget> [
          new IconButton(
              icon: Icon(
                Icons.search_outlined,
                color: Colors.white,
              ),
              onPressed: (){}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),

//             ===PASSING PAGE NO VALUES WITH NAVIGATOR.PUSH====
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => new shoppingCart()));
              })
        ],
      ),

//    ====BOTTOM NAV=====
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
                activeColor: Colors.red,
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

      drawer: new Drawer(
        child : new ListView(
          children: <Widget>[

//        =====HEADER PART OF DRAWER A.K.A DASHBOARD======

            new UserAccountsDrawerHeader(
              accountName: Text('Dendi Rizka Poetra'),
              accountEmail: Text('dendirizkapoetra@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(
                  color: Colors.red
              ),
            ),

//        ====BODY PART OF DRAWER A.K.A DASHBOARD=====

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Orders History'),
                leading: Icon(Icons.shopping_basket_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Shopping cart'),
                leading: Icon(Icons.shopping_cart_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite_outline, color: Colors.red),
              ),
            ),

            Divider(),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Setting'),
                leading: Icon(Icons.settings),
              ),
            ),

            Divider(),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Help and feedback'),
                //leading: Icon(Icons.help),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('About Lets Shop'),
                //leading: Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}