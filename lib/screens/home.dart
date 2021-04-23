import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//PACKAGE CAROUSEL A.K.A SLIDER PICT
import 'package:carousel_pro/carousel_pro.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/custom_text.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/featured_product.dart';
import 'package:lets_shop/components/product_card.dart';
import 'package:lets_shop/provider/product_provider.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/cart.dart';
import 'package:lets_shop/screens/order.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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

    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

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
                accountName: CustomText(
                  text: userProvider.userModel?.name ?? "loading...username",
                  color: white,
                  weigth: FontWeight.bold,
                  size: 18,
                ), //_user.displayName
                accountEmail: CustomText(
                  text: userProvider.userModel?.email ?? "loading...email",
                  color: white,
                  weigth: FontWeight.bold,
                  size: 18,
                ), //_user.email
                currentAccountPicture: GestureDetector(
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey,
                      child: _user.photoURL != null
                          ? CircleAvatar(
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: _user.photoURL,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
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
                onTap: () async{
                  await userProvider.getOrders();
                  changeScreen(context, OrdersScreen());
                },
                child: ListTile(
                  title: Text('Orders History'),
                  leading:
                      Icon(Icons.shopping_basket_outlined, color: Colors.red),
                ),
              ),

              Divider(),
              InkWell(
                onTap: () async {
                  await userProvider.signOut();
                  print(userProvider.status);
/*
                */ /*Navigator.of(context)
                    .pushReplacement(_routeToLogin());*/ /*
                Navigator.push(context, MaterialPageRoute(builder: (context) => new Login()));*/
                },
                child: ListTile(
                  title: Text('Sign Out'),
                  leading: Icon(Icons.exit_to_app_outlined),
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
            child: ListView(children: <Widget>[
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
                        child: Icon(
                          Icons.menu,
                          color: redAccent,
                        ))),
              ),
                Positioned(
                  top: 10,
                  right: 60,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          changeScreen(context, CartScreen());
                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: redAccent,
                        ))),
              ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("User profile", style: TextStyle(color: redAccent)),
                                  backgroundColor: white
                              ));
                        },
                        child: Icon(
                          Icons.person_outline,
                          color: redAccent,
                        ))),
              ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 300),
                      child: Image.asset(
                        "images/Logo.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.fitWidth,
                      ),
                    )),
              ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ListTile(
                        title: Text('Hi, ${userProvider.userModel.name}',
                            style: TextStyle(
                                fontSize: 30,
                                color: redAccent,
                                fontWeight: FontWeight.w400)),
                        subtitle: Text('What are you Looking for?',
                            style: TextStyle(
                                fontSize: 20,
                                color: redAccent)),
                      ),
                    ),
                  )
            ],
          ),
              Container(
                decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
                child: Padding(
                padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
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
                        onSubmitted: (pattern) async {
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


              Column(
//              LOADING DATA in list product provider
                children: productProvider.products
                    .map((item) => GestureDetector(
                  child: ProductCard(
                    product: item,
                  ),
                  )).toList(),
                )
              ]
            )
        )
    );
  }
}
