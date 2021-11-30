import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

//PACKAGE CAROUSEL A.K.A SLIDER PICT
import 'package:carousel_pro/carousel_pro.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/commons/random_string.dart';
import 'package:lets_shop/components/column_builder.dart';
import 'package:lets_shop/components/custom_text.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/featured_product.dart';
import 'package:lets_shop/components/product_card.dart';
import 'package:lets_shop/models/product.dart';
import 'package:lets_shop/models/user.dart';
import 'package:lets_shop/provider/app_provider.dart';
import 'package:lets_shop/provider/product_provider.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/cart.dart';
import 'package:lets_shop/screens/order.dart';
import 'package:lets_shop/screens/search_product.dart';
import 'package:lets_shop/service/users.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  TextEditingController _searchController = TextEditingController();

  bool _fabIsOpen = false;

  bool _loading = false;
  int btnSortClicked = 0;
  List<ProductModel> _unSortedProduct = [];
  List<ProductModel> _productBubbleSort = [];
  List<ProductModel> _productQuickSort = [];

  String _nameProductList = 'Recent Products';

  DateFormat dateFormat = new DateFormat('hh:mm:ss:SS');

  List<ProductModel> getProductBubbleFromProvider() {
    setState(() {
      _productBubbleSort = Provider
          .of<ProductProvider>(context, listen: false)
          .productsBubbleSort;
    });
    print('_productBubbleSort : ${_productBubbleSort.length}');
    return _productBubbleSort;
  }

  List<ProductModel> getProductQuickFromProvider() {
    setState(() {
      _productQuickSort = Provider
          .of<ProductProvider>(context, listen: false)
          .productsQuickSort;
    });
    print('_productQuickSort : ${_productQuickSort.length}');
    return _productQuickSort;
  }

  List<ProductModel> getUnSortedProductFromProvider() {
    setState(() {
      _unSortedProduct = Provider
          .of<ProductProvider>(context, listen: false)
          .unSortedProducts;
    });
    print('_unSortedProduct : ${_unSortedProduct.length}');
    return _unSortedProduct;
  }


  //FUNGSINYA BUAT inisilalisasi nilai awal pas screen awal loagd
  @override
  void initState() {
    super.initState();
    getProductBubbleFromProvider();
    getProductQuickFromProvider();
    getUnSortedProductFromProvider();
  }

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
                weight: FontWeight.bold,
                size: 18,
              ), //_user.displayName
              accountEmail: CustomText(
                text: userProvider.userModel?.email ?? "loading...email",
                color: white,
                weight: FontWeight.bold,
                size: 18,
              ), //_user.email
              currentAccountPicture: GestureDetector(
                child: ClipOval(
                  child: Material(
                    color: Colors.grey,
                    child: _user?.photoURL != null
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
                  ),
                ),
              ),

              decoration:
              new BoxDecoration(color: blue),
            ),

//        ====BODY PART OF DRAWER A.K.A DASHBOARD=====

            InkWell(
              onTap: () {
                changeScreen(context, HomePage());
              },
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home_outlined, color: blue),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  _loading = true;
                });
                userProvider.getOrders();
                changeScreen(context, OrdersScreen());
                setState(() {
                  _loading = false;
                });
              },
              child: ListTile(
                title: Text('Orders History'),
                leading:
                Icon(Icons.shopping_basket_outlined, color: blue),
              ),
            ),

            Divider(),
            InkWell(
              onTap: () async {
                await userProvider.signOut();
                print(userProvider.status);
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
                title: Text('About MyOptik'),
                //leading: Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),
      body: _loading ? Loading() : SafeArea(
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
                            color: blue,
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
                          child: userProvider.userModel.countCart > 0
                              ? Badge(
                              position: BadgePosition.topEnd(top: -13, end: -8),
                              animationDuration: Duration(seconds: 1),
                              animationType: BadgeAnimationType.slide,
                              badgeContent: Text(
                                  userProvider.userModel.countCart.toString(),
                                  style: TextStyle(color: Colors.white)),
                              child: Icon(
                                  Icons.shopping_cart_outlined, color: blue))
                              : Icon(Icons.shopping_cart_outlined, color: blue))
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            _key.currentState.showSnackBar(
                                SnackBar(content: Text("Notification",
                                    style: TextStyle(color: blue)),
                                    backgroundColor: white
                                ));
                          },
                          child: Icon(
                            Icons.notifications_none_outlined,
                            color: blue,
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 300),
                        child: Image.asset(
                          "images/LogoOptik.png",
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
                              color: blue,
                              fontWeight: FontWeight.w400)),
                      subtitle: Text('What are you Looking for?',
                          style: TextStyle(
                              fontSize: 20,
                              color: blue)),
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
                        await productProvider.search(productName: pattern);
                        changeScreen(context, SearchProductScreen());
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (Widget child,
                            Animation<double> animation) {
                          return ScaleTransition(
                            child: child, scale: animation,);
                        },
                        child: Text(_nameProductList,
                          key: ValueKey<String>(_nameProductList),
                          style: TextStyle(color: grey, fontSize: 16,),),
                      )
                    /*Text(_nameProductList)*/
                  ),
                ),
                /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async{
                        if(_productBubbleSort.isEmpty){
                          await productProvider.loadProductBubble();
                          setState(() {
                            getProductBubbleFromProvider();
                          });
                        }
                        _loading = true;
                        setState((){
                          _nameProductList = 'Sorted by Bubble Sort Algorithm';
                          btnSortClicked = 1;
                          Stopwatch stopwatch = Stopwatch()..start();
                          print('Time Start: ${dateFormat.format(DateTime.now())}');
                          productProvider.bubbleSort(_productBubbleSort);
                          print('Time End: ${dateFormat.format(DateTime.now())}');
                          stopwatch.stop();
                          print('Time elapsed : ${stopwatch.elapsed}');
                        });
                        _loading = false;
                      },
                      onDoubleTap: () async{
                        if(_productBubbleSort.isEmpty){
                          await productProvider.loadProductQuick();
                          setState(() {
                            getProductQuickFromProvider();
                          });
                        }
                        _loading = true;
                        setState(() {
                          _nameProductList = 'Sorted by Quick Sort Algorithm';
                          btnSortClicked = 2;
                          Stopwatch stopwatch = Stopwatch()..start();
                          print('Time Start: ${dateFormat.format(DateTime.now())}');
                          productProvider.quickSort(_productQuickSort, 0, _productQuickSort.length -1);
                          print('Time End: ${dateFormat.format(DateTime.now())}');
                          stopwatch.stop();
                          print('Time elapsed : ${stopwatch.elapsed}');
                        });
                        _loading = false;
                      },
                      onLongPress: (){
                        _loading = true;
                        setState((){
                          _nameProductList = 'Recent Products';
                          btnSortClicked = 0;
                        });
                        _loading = false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: blue)
                        ),
                        height: 30,
                        width: 30,
                        child: Icon(Icons.filter_list_outlined),
                      ),
                    ),
                  )*/
              ],
            ),


/*              Column(
//              LOADING DATA in list product provider
                children: productProvider.products
                    .map((item) => GestureDetector(
                  child: ProductCard(
                    product: item,
                  ),
                  )).toList(),
                )*/
            ColumnBuilder(
                itemCount: productProvider.unSortedProducts.length,
                itemBuilder: (context, index) {
/*                    List<int> arr = [];
                    arr.add(productProvider.products[index].price);
                    print('array price : ${arr[4]}');
                    // bubbleSort(arr);*/
                  return ProductCard(
                      product: btnSortClicked == 0
                          ? _unSortedProduct[index]
                          : btnSortClicked == 1
                          ? _productBubbleSort[index]
                          : _productQuickSort[index]
                  );
                }),
          ]
          )
      ),
      floatingActionButton: Builder(
        builder: (context) =>
            FabCircularMenu(
              key: fabKey,
              alignment: Alignment.bottomRight,
              ringColor: Colors.black.withAlpha(35),
              ringDiameter: 250.0,
              ringWidth: 75.0,
              fabSize: 40.0,
              fabElevation: 10.0,
              // Also can use specific color based on wether
              // the menu is open or not:
              // fabOpenColor: Colors.white
              // fabCloseColor: Colors.white
              // These properties take precedence over fabColor
              fabColor: blue,
              fabOpenIcon: Icon(Icons.sort, color: white),
              fabCloseIcon: Icon(Icons.close, color: white),
              fabMargin: const EdgeInsets.all(10.0),
              animationDuration: const Duration(milliseconds:1000),
              animationCurve: Curves.easeInOutCirc,
              onDisplayChange: (isOpen) {

              },
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    fabKey.currentState.close();
                    _loading = true;
                    setState((){
                      _nameProductList = 'Recent Products';
                      btnSortClicked = 0;
                    });
                    _loading = false;
                  },
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.fiber_new_outlined, color: white)
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async{
                    fabKey.currentState.close();
                    if(_productQuickSort.isEmpty){
                      await productProvider.loadProductQuick();
                      setState(() {
                        getProductQuickFromProvider();
                      });
                    }
                    _loading = true;
                    setState(() {
                      _nameProductList = 'Sorted by Quick Sort Algorithm';
                      btnSortClicked = 2;
                      Stopwatch stopwatch = Stopwatch()..start();
                      print('Time Start: ${dateFormat.format(DateTime.now())}');
                      productProvider.quickSort(_productQuickSort, 0, _productQuickSort.length -1);
                      print('Time End: ${dateFormat.format(DateTime.now())}');
                      stopwatch.stop();
                      print('Time elapsed : ${stopwatch.elapsed}');
                    });
                    _loading = false;
                  },
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.arrow_downward_outlined, color: white)
                  )
                ),
                RawMaterialButton(
                  onPressed: () async{
                    fabKey.currentState.close();
                    if(_productBubbleSort.isEmpty){
                      await productProvider.loadProductBubble();
                      setState(() {
                        getProductBubbleFromProvider();
                      });
                    }
                    _loading = true;
                    setState((){
                      _nameProductList = 'Sorted by Bubble Sort Algorithm';
                      btnSortClicked = 1;
                      Stopwatch stopwatch = Stopwatch()..start();
                      print('Time Start: ${dateFormat.format(DateTime.now())}');
                      productProvider.bubbleSort(_productBubbleSort);
                      print('Time End: ${dateFormat.format(DateTime.now())}');
                      stopwatch.stop();
                      print('Time elapsed : ${stopwatch.elapsed}');
                    });
                    _loading = false;
                  },
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.arrow_upward_outlined, color: white)
                  )
                ),
              ],
            ),
      ),
    );
  }
}