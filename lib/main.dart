import 'package:flutter/material.dart';
//package carousel a.k.a slider pict
import 'package:carousel_pro/carousel_pro.dart';
//package line icons for icons
import 'package:line_icons/line_icons.dart';
//package bottom bar
import 'package:google_nav_bar/google_nav_bar.dart';

// my own package
import 'package:lets_shop/components/horizontal_listView.dart';
import 'package:lets_shop/components/products.dart';
import 'package:lets_shop/pages/test.dart';

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
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Likes',
      style: optionStyle,
    ),
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {

//  ====Implementation of pub carousel a.k.a slider pict====
    Widget img_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/c1.jpg'),
          AssetImage('images/m1.jpeg'),
          AssetImage('images/w1.jpeg'),
          AssetImage('images/w3.jpeg'),
          AssetImage('images/w4.jpeg'),
        ],
        autoplay: false,
        /*animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),*/
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
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
              onPressed: (){})
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
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100],
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
                    switch(_selectedIndex){
                      case 4: Navigator.push(context, MaterialPageRoute(builder: (context) => new test_Pages()));
                    }
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
      body: new ListView(
        children: <Widget>[

//        ====this part to called img_carousel or slide pict=====
          img_carousel,

//        =====padding widget Categories====
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categories'),
          ),

//        ====Horizontal list view====
          horizontalList(),

//        ===padding textCategories===
          new Padding(padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 10.0, right: 20.0),
            child: new Text('Recent Product'),
          ),

//      GridView Product
          Container(
            // =====bug!!!====
            // ===280.0 for 5 inch display===
            // ===350.0 for 6 or more inch display===
            height: 350.0,
            child: Products(),
          ),
        ],
      ),
    );
  }
}
