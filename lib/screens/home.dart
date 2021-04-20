import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


//PACKAGE CAROUSEL A.K.A SLIDER PICT
import 'package:carousel_pro/carousel_pro.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/horizontal_listView.dart';
import 'package:lets_shop/components/products.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/shopping_cart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
/*  //KONTRUKTOR BUAT GET VALUES YANG DIKIRIM DARI CLASS LOGIN
  const HomePage({Key key, User user})
      : _user = user,
        super(key: key);
  //TAMPUNG VALUESNYA DISINI
  final User _user;*/
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user = FirebaseAuth.instance.currentUser;
  bool _isSigningOut = false;

  TextEditingController _searchController = TextEditingController();

  //FUNGSINYA BUAT MANGGIL NAMA USER, EMAIL, DAN PHOTONYA
/*  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
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
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent[700]),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[50],
          elevation: 0.0,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'The search field cannot be empty';
              }
              return null;
            },
          ),
        ),
/*        title: Text('Lets Shop', style: TextStyle(color: Colors.deepOrangeAccent[700])),*/
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: (){}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),

//             ===PASSING PAGE NO VALUES WITH NAVIGATOR.PUSH====
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new shoppingCart()));
              })
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//        =====HEADER PART OF DRAWER A.K.A DASHBOARD======

            new UserAccountsDrawerHeader(
              //_user.photoURL != null ? VALIDASI HARUSNYA TAPI MASIH BINGUNG NTAR AJA
              accountName: Text('debugging'), //_user.displayName
              accountEmail: Text('debugging'), //_user.email
              currentAccountPicture: GestureDetector(
                child: new ClipOval(
                  child: Material(
                    color: Colors.grey,
                    child: new CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    /*Image.network(
                      _user.photoURL,
                      fit: BoxFit.fitHeight,
                    ),*/
                  ),
                ),
              ),
              decoration:
                  new BoxDecoration(color: Colors.deepOrangeAccent[700]),
            ),

//        ====BODY PART OF DRAWER A.K.A DASHBOARD=====

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Orders History'),
                leading:
                    Icon(Icons.shopping_basket_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Shopping cart'),
                leading: Icon(Icons.shopping_cart_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite_outline, color: Colors.red),
              ),
            ),

            Divider(),
            InkWell(
              onTap: () async {
                await _user.signOut();
                print(_user.status);
/*                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                */ /*Navigator.of(context)
                    .pushReplacement(_routeToLogin());*/ /*
                Navigator.push(context, MaterialPageRoute(builder: (context) => new Login()));*/
              },
              child: ListTile(
                title: Text('Sign Out'),
                leading: Icon(Icons.person),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Setting'),
                leading: Icon(Icons.settings),
              ),
            ),

            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Help and feedback'),
                //leading: Icon(Icons.help),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About Lets Shop'),
                //leading: Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),
      body: new Column(
        children: <Widget>[

//        ====THIS PART TO CALLED IMG_CAROUSEL OR SLIDE PICT=====
          img_carousel,

//        =====PADDING WIDGET CATEGORIES====
          new Padding(padding: const EdgeInsets.all(4.0),
            child: Container(
                alignment: Alignment.centerLeft,
                child: new Text('Categories', style: TextStyle(fontSize: 15.0))),
          ),

//        ====HORIZONTAL LIST VIEW====
          horizontalList(),

//        ===PADDING TEXT CATEGORIES===
          new Padding(padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.centerLeft,
                child: new Text('Recent Product', style: TextStyle(fontSize: 15.0))),
          ),

//      ====GRIDVIEW PRODUCT====
          Flexible(
            child: Products(),
          ),
        ],
      ),
/*      pages[_selectedIndex]*/
    );
  }
}
