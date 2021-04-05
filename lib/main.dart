import 'package:flutter/material.dart';
//package carousel a.k.a slider pict
import 'package:carousel_pro/carousel_pro.dart';
//package line icons for icons
import 'package:line_icons/line_icons.dart';
//package bottom bar
import 'package:google_nav_bar/google_nav_bar.dart';

// my own package
import 'package:lets_shop/pages/home.dart';
import 'package:lets_shop/pages/shopping_cart.dart';
//Debugging
import 'package:lets_shop/pages/test.dart';
import 'package:lets_shop/pages/test2.dart';
import 'package:lets_shop/pages/test3.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : HomePage(),
    )
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// For values selested item
  int _selectedIndex = 0;
// List Pages Bottom nav
  final List<Widget> pages = [
    homeBody(),
//  debugging just test itsn't work
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
//             ===Passing page no values with Navigator.push====
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => new shoppingCart()));
              })
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
                    text: 'Orders History',
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

//        =====header part of drawer a.k.a dashboard======

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

//        ====body part of drawer a.k.a dashboard=====

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
