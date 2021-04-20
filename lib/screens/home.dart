import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


//PACKAGE CAROUSEL A.K.A SLIDER PICT
import 'package:carousel_pro/carousel_pro.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/custom_app_bar.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/featured_product.dart';
import 'package:lets_shop/components/product_card.dart';
import 'file:///D:/App%20Flutter%20build/lets_shop/lib/tidak_terpakai/products.dart';
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
    final _key = GlobalKey<ScaffoldState>();


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
      key: _key,
      backgroundColor: white,
      endDrawer: new Drawer(
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

      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar
            //           Custom App bar
            Stack(
              children: <Widget>[
                Positioned(
                  top: 10,
                  right: 20,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            _key.currentState.openEndDrawer();
                          },
                          child: Icon(Icons.menu, color: redAccent,))),
                ),
                Positioned(
                  top: 10,
                  right: 60,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: (){
                            /*changeScreen(context, CartScreen());*/
                          },
                          child: Icon(Icons.shopping_cart_outlined, color: redAccent,))),
                ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                      alignment: Alignment.topRight, child: GestureDetector(
                      onTap: (){
                        _key.currentState.showSnackBar(SnackBar(
                            content: Text("User profile")));
                      },
                        child: Icon(Icons.person_outline, color: redAccent,))),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 300),
                              child: Image.asset("images/Logo.png",
                                height: 50,
                                width: 50,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Text('What are you Looking For?',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: redAccent,
                                    fontWeight: FontWeight.w400))
                          ],
                        )),
/*                    subtitle: Text('Lets Shop',
                        style: TextStyle(
                            fontSize: 15,
                            color: redAccent,
                            fontWeight: FontWeight.w400)),*/

                  /*Text(
                    'Lets Shop\nLooking For something?',
                    style: TextStyle(
                        fontSize: 30,
                        color: redAccent,
                        fontWeight: FontWeight.w400),
                  ),*/
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: black,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (pattern)async{
                        /*await productProvider.search(productName: pattern);
                        changeScreen(context, ProductSearchScreen());*/
                      },
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //            featured products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Featured products')),
                ),
              ],
            ),
            FeaturedProducts(),

//          recent products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Recent products')),
                ),
              ],
            ),

            ProductCard(
              brand: 'Gucci',
              name: 'Speedy Bustom',
              price: 199999.0,
              onSale: true,
              picture: 'images/w1.jpeg',
            ),
            ProductCard(
              brand: 'Crooz',
              name: 'T-shirt Crooz',
              price: 150000.0,
              onSale: false,
              picture: 'images/m1.jpeg',
            ),
            ProductCard(
              brand: 'Sch',
              name: 'T-shirt Sch',
              price: 92000.0,
              onSale: true,
              picture: 'images/w3.jpeg',
            ),
          ]
        )
      )
/*      body: new Column(
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
      ),*/
    );
  }
}
