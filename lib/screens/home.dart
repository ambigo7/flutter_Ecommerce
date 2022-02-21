import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:category_picker/category_picker.dart';
import 'package:category_picker/category_picker_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

  bool _checkAllCat = true;
  bool _checkPlusCat = false;
  bool _checkMinCat = false;
  bool _checkProgressiveCat = false;

  bool _checkAscBubble = false;
  bool _checkDescBubble = false;
  bool _checkAscQuick = false;
  bool _checkDescQuick = false;

  bool _itemAscBubble = true;
  bool _itemDescBubble = true;
  bool _itemAscQuick = true;
  bool _itemDescQuick = true;

  bool _itemSortClicked = false;

  bool _clearSortClicked = false;

  bool _loading = false;
  bool btnCategoryClicked = false;
  bool btnSortedClicked = false;
  int _selectedProductList = 0;
  int _selectedCatList = 0;
  int _selectedSort = 0;
  //int btnSortClicked = 0;

  List<ProductModel> _unSortedProduct = [];
  List<ProductModel> _productBubbleSort = [];
  List<ProductModel> _productQuickSort = [];
  List<ProductModel> _productsCatPlus = [];
  List<ProductModel> _productsCatMin = [];
  List<ProductModel> _productsCatProgressive = [];

  //List<ProductModel> _priceQuickSort = [];

  String _nameProductList = 'Recent Products';

  DateFormat dateFormat = new DateFormat('hh:mm:ss:SS');

  List<ProductModel> getProductBubbleFromProvider() {
    setState(() {
      _productBubbleSort = Provider
          .of<ProductProvider>(context, listen: false)
          .priceBubbleSort;
    });
    print('_productBubbleSort : ${_productBubbleSort.length}');
    return _productBubbleSort;
  }

  List<ProductModel> getProductQuickFromProvider() {
    setState(() {
      _productQuickSort = Provider
          .of<ProductProvider>(context, listen: false)
          .priceQuickSort;
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

  List<ProductModel> getProductCatPlusFromProvider() {
    setState(() {
      _productsCatPlus = Provider
          .of<ProductProvider>(context, listen: false)
          .productsCatPlus;
    });
    print('_productsCatPlus : ${_productsCatPlus.length}');
    return _productsCatPlus;
  }

  List<ProductModel> getProductCatMinFromProvider() {
    setState(() {
      _productsCatMin = Provider
          .of<ProductProvider>(context, listen: false)
          .productsCatMin;
    });
    print('_productsCatMin : ${_productsCatMin.length}');
    return _productsCatMin;
  }

  List<ProductModel> getProductCatProgressiveFromProvider() {
    setState(() {
      _productsCatProgressive = Provider
          .of<ProductProvider>(context, listen: false)
          .productsCatProgressive;
    });
    print('_productsCatProgressive : ${_productsCatProgressive.length}');
    return _productsCatProgressive;
  }


  //FUNGSINYA BUAT inisilalisasi nilai awal pas screen awal loagd
  @override
  void initState() {
    super.initState();
    getProductBubbleFromProvider();
    getProductQuickFromProvider();
    getUnSortedProductFromProvider();
    getProductCatPlusFromProvider();
    getProductCatMinFromProvider();
    getProductCatProgressiveFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ScaffoldState>();

    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

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
                      child: Text(
                          'Featured products',
                          style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      )
                  ),
                ),
              ],
            ),
            FeaturedProducts(),

//          recent products
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      _nameProductList,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
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
            appProvider.isLoading
            ? Loading()
            : ColumnBuilder(
                itemCount: _selectedProductList == 0
                    ? productProvider.unSortedProducts.length
                    : _selectedProductList == 1
                    ? _productsCatPlus.length
                    : _selectedProductList == 2
                    ? _productsCatMin.length
                    : _selectedProductList == 3
                    ? _productsCatProgressive.length
                    : _selectedProductList == 4
                    ? _productBubbleSort.length
                    : _productQuickSort.length,
                itemBuilder: (context, index) {
/*                    List<int> arr = [];
                    arr.add(productProvider.products[index].price);
                    print('array price : ${arr[4]}');
                    // bubbleSort(arr);*/
                  return ProductCard(
                      product: _selectedProductList == 0
                          ? _unSortedProduct[index]
                          : _selectedProductList == 1
                          ? _productsCatPlus[index]
                          : _selectedProductList == 2
                          ? _productsCatMin[index]
                          : _selectedProductList == 3
                          ? _productsCatProgressive[index]
                          : _selectedProductList == 4
                          ? _productBubbleSort[index]
                          : _productQuickSort[index]
                  );
                }),
          ]
          )
      ),
      floatingActionButton: Builder(
        builder: (context) =>
            /*FabCircularMenu(
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
                    //if(_productQuickSort.isEmpty){
                      await productProvider.loadProductQuick();
                      setState(() {
                        getProductQuickFromProvider();
                      });
                    //}
                    _loading = true;
                    setState(() {
                      _nameProductList = 'Sorted by Quick Sort Algorithm';
                      btnSortClicked = 2;
                      Stopwatch stopwatch = Stopwatch()..start();
                      print('Time Start: ${dateFormat.format(DateTime.now())}');
                      productProvider.quickSort(_productQuickSort, 0, _productQuickSort.length -1);
                      print('Time End: ${dateFormat.format(DateTime.now())}');
                      stopwatch.stop();
                      print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                    });
                    print('Sorted Price : ');
                    for(int x =0; x < productProvider.priceQuickSort.length; x++){
                      print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                    }
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
                   // if(_productBubbleSort.isEmpty){
                      await productProvider.loadProductBubble();
                      setState(() {
                        getProductBubbleFromProvider();
                      });
                    //}
                    _loading = true;
                    setState((){
                      _nameProductList = 'Sorted by Bubble Sort Algorithm';
                      btnSortClicked = 1;
                      Stopwatch stopwatch = Stopwatch()..start();
                      print('Time Start: ${dateFormat.format(DateTime.now())}');
                      productProvider.bubbleSort(_productBubbleSort);
                      print('Time End: ${dateFormat.format(DateTime.now())}');
                      stopwatch.stop();
                      print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                    });
                    print('Sorted Price');
                    for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                      print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                    }
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
            ),*/
          Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: blue),
              borderRadius: BorderRadius.circular(10),
                color: white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: CustomText(
                        text: 'Categories',
                        color: blue,
                        size: 15,
                        align: TextAlign.center,
                      ),
                      ),
                    onTap: () {
                      categoryListProduct();
                      setState(() {
                        btnCategoryClicked = true;
                      });
                      print('btnCategoryClicked : $btnCategoryClicked');
                    }),
                ),
                VerticalDivider(
                  color: blue,
                  thickness: 1,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: CustomText(
                        text: 'Sort',
                        color: blue,
                        size: 15,
                        align: TextAlign.center,
                        ),
                      ),
                    onTap: (){
                      sortListProduct();
                      setState(() {
                        btnSortedClicked = true;
                      });
                      print('btnSortedClicked : $btnSortedClicked');
                    },
                    ),
                ),
              ],
            ),
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void categoryListProduct(){
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    var modal = Container(
      //height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: <Widget>[
            Material(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomText(text: 'Categories', weight: FontWeight.bold, size: 20,),
                      IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(
                        Icons.close,
                        color: grey,)
                      )
                    ],
                  ),
                ),
              ),
            ),
            Material(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _checkAllCat = true;
                    _checkPlusCat = false;
                    _checkMinCat = false;
                    _checkProgressiveCat = false;

                    _nameProductList = "Recent Product";
                    _selectedProductList = 0;
                  });
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: CustomText(text: 'All Product',),
                  subtitle: CustomText(text: 'Recent Product',),
                  trailing: _checkAllCat ? Icon(Icons.check_outlined, color: blue) : null,
                ),
              ),
            ),
            Divider(color: blue,),
            Material(
              child: GestureDetector(
                onTap: ()async{
                  await productProvider.loadProductPlus();
                  appProvider.changeIsLoading();
                  setState(() {
                    getProductCatPlusFromProvider();
                    _checkAllCat = false;
                    _checkPlusCat = true;
                    _checkMinCat = false;
                    _checkProgressiveCat = false;

                    _nameProductList = "Plus Glasses Category";
                    _selectedProductList = 1;
                  });
                  //print('_productsCatPlus.length : ${_productsCatPlus.length}');
                  Navigator.pop(context);
                  appProvider.changeIsLoading();
                },
                child: ListTile(
                  title: CustomText(text: 'Plus Products',),
                  subtitle: CustomText(text: 'Plus Glasses Category',),
                  trailing: _checkPlusCat ? Icon(Icons.check_outlined, color: blue) : null,
                ),
              ),
            ),
            Divider(color: blue,),
            Material(
              child: GestureDetector(
                onTap: ()async{
                  await productProvider.loadProductMin();
                  appProvider.changeIsLoading();
                  setState(() {
                    getProductCatMinFromProvider();
                    _checkAllCat = false;
                    _checkPlusCat = false;
                    _checkMinCat = true;
                    _checkProgressiveCat = false;

                    _nameProductList = "Min Glasses Category";
                    _selectedProductList = 2;
                  });
                  Navigator.pop(context);
                  appProvider.changeIsLoading();
                },
                child: ListTile(
                  title: CustomText(text: 'Min Products',),
                  subtitle: CustomText(text: 'Min Glasses Category',),
                  trailing: _checkMinCat ? Icon(Icons.check_outlined, color: blue) : null,
                ),
              ),
            ),
            Divider(color: blue,),
            Material(
              child: GestureDetector(
                onTap: ()async{
                  await productProvider.loadProductProgressive();
                  appProvider.changeIsLoading();
                  setState(() {
                    getProductCatProgressiveFromProvider();
                    _checkAllCat = false;
                    _checkPlusCat = false;
                    _checkMinCat = false;
                    _checkProgressiveCat = true;

                    _nameProductList = "Progressive Glasses Category";
                    _selectedProductList = 3;
                  });
                  Navigator.pop(context);
                  appProvider.changeIsLoading();
                },
                child: ListTile(
                  title: CustomText(text: 'Progressive Products',),
                  subtitle: CustomText(text: 'Progressive Glasses Category',),
                  trailing: _checkProgressiveCat ? Icon(Icons.check_outlined, color: blue) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
   showModalBottomSheet(
        context: context,
        //topRadius: Radius.circular(10),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10),
         ),
       ),
        isScrollControlled: true,
        builder: (_) => modal);
  }

  void sortListProduct(){
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    var modal = Container(
      //height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: <Widget>[
            Material(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Sort', weight: FontWeight.bold, size: 20,),
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(
                            Icons.close,
                            color: grey,)
                          )
                        ],
                      ),
                      Visibility(
                        visible: _itemSortClicked ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: ()async{
                              _clearSortClicked = true;
                              print('_clearClicked : $_clearSortClicked');
                              print('_selectedCatList diClear sblm : $_selectedCatList');
                              if(_selectedCatList == 0){
                                await productProvider.loadProducts();
                                setState(() {
                                  getUnSortedProductFromProvider();
                                  _nameProductList = 'Recent Products';
                                  _selectedProductList = 0;
                                });
                              }else if(_selectedCatList == 1){
                                await productProvider.loadProductPlus();
                                setState(() {
                                  getProductCatPlusFromProvider();
                                  _nameProductList = "Plus Glasses Category";
                                  _selectedProductList = 1;
                                });
                              }else if(_selectedCatList == 2){
                                await productProvider.loadProductMin();
                                setState(() {
                                  getProductCatMinFromProvider();
                                  _nameProductList = "Min Glasses Category";
                                  _selectedProductList = 2;
                                });
                              }else if(_selectedCatList == 3){
                                await productProvider.loadProductProgressive();
                                setState(() {
                                  getProductCatProgressiveFromProvider();
                                  _nameProductList = "Progressive Glasses Category";
                                  _selectedProductList = 3;
                                });
                              }
                              print('_selectedCatList diClear ssdh : $_selectedCatList');
                              productProvider.clearProductBubbleSort();
                              productProvider.clearProductQuickSort();
                              setState(() {
                                _checkAscBubble = false;
                                _checkDescBubble = false;
                                _checkAscQuick = false;
                                _checkDescQuick = false;

                                _itemAscBubble = true;
                                _itemDescBubble = true;
                                _itemAscQuick = true;
                                _itemDescQuick = true;

                                _itemSortClicked = false;
                              });
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              text: 'Clear',
                              weight: FontWeight.bold,
                              color: blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _itemAscBubble ? true : false,
              child: Material(
                child: GestureDetector(
                  onTap: (){
                    if(_selectedProductList == 0){
                      setState((){
                        _selectedCatList = 0;
                        _nameProductList = 'Recent Products have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(false, _unSortedProduct);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }else if(_selectedProductList == 1){
                      setState((){
                        _selectedCatList = 1;
                        _nameProductList = 'Plus Glasses Category have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(false, _productsCatPlus);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }else if(_selectedProductList == 2){
                      setState((){
                        _selectedCatList = 2;
                        _nameProductList = 'Min Glasses Category have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(false, _productsCatMin);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }else if(_selectedProductList == 3){
                      setState((){
                        _selectedCatList = 3;
                        _nameProductList = 'Progressive Glasses Category have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(false, _productsCatProgressive);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }
                    setState(() {
                      _itemSortClicked = true;
                      _checkAscBubble = true;
                      getProductBubbleFromProvider();
                      _selectedProductList = 4;

                      _itemDescBubble = false;
                      _itemAscQuick = false;
                      _itemDescQuick = false;
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: CustomText(text: 'Ascending Bubble',),
                    subtitle: CustomText(
                      text: 'Sort price from low to high with bubble algorithm',
                      size: 14,
                      color: grey,
                    ),
                    trailing: _checkAscBubble ? Icon(Icons.check_outlined, color: blue) : null,
                  ),
                ),
              ),
            ),
            Visibility(visible: _itemDescBubble ? true : false,child: Divider(color: blue,)),
            Visibility(
              visible: _itemDescBubble ? true : false,
              child: Material(
                child: GestureDetector(
                  onTap: ()async{
                    if(_selectedProductList == 0){
                      setState((){
                        _selectedCatList = 0;
                        _nameProductList = 'Recent Products have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(true, _unSortedProduct);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }else if(_selectedProductList == 1){
                      setState((){
                        _selectedCatList = 1;
                        _nameProductList = 'Plus Glasses Category have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(true, _productsCatPlus);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }else if(_selectedProductList == 2){
                      setState((){
                        _selectedCatList = 2;
                        _nameProductList = 'Min Glasses Category have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(true, _productsCatMin);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }else if(_selectedProductList == 3){
                      setState((){
                        _selectedCatList = 3;
                        _nameProductList = 'Progressive Glasses Category have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.bubbleSort(true, _productsCatProgressive);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Bubble Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price');
                      for(int x =0; x < productProvider.priceBubbleSort.length; x++){
                        print('${x+1}. ${productProvider.priceBubbleSort[x].price}');
                      }
                    }
                    setState(() {
                      _itemSortClicked = true;
                      _checkDescBubble = true;
                      getProductBubbleFromProvider();
                      _selectedProductList = 4;

                      _itemAscBubble = false;
                      _itemAscQuick = false;
                      _itemDescQuick = false;
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: CustomText(text: 'Descending Bubble',),
                    subtitle: CustomText(
                      text: 'Sort price from high to low with bubble algorithm',
                      size: 14,
                      color: grey,
                    ),
                    trailing: _checkDescBubble ? Icon(Icons.check_outlined, color: blue) : null,
                  ),
                ),
              ),
            ),
            Visibility(visible: _itemAscQuick  ? true : false,child: Divider(color: blue,)),
            Visibility(
              visible: _itemAscQuick  ? true : false,
              child: Material(
                child: GestureDetector(
                  onTap: ()async{
                    if(_selectedProductList == 0){
                      setState((){
                        _selectedCatList = 0;
                        _nameProductList = 'Recent Products have been sorted low to high with quick algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortAsc(_unSortedProduct, 0, _unSortedProduct.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }else if(_selectedProductList == 1){
                      setState((){
                        _selectedCatList = 1;
                        _nameProductList = 'Plus Glasses Category have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortAsc(_productsCatPlus, 0, _productsCatPlus.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }else if(_selectedProductList == 2){
                      setState((){
                        _selectedCatList = 2;
                        _nameProductList = 'Min Glasses Category have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortAsc(_productsCatMin, 0, _productsCatMin.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }else if(_selectedProductList == 3){
                      setState((){
                        _selectedCatList = 3;
                        _nameProductList = 'Progressive Glasses Category have been sorted low to high with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortAsc(_productsCatProgressive, 0, _productsCatProgressive.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }
                    setState(() {
                      _itemSortClicked = true;
                      _checkAscQuick = true;
                      getProductQuickFromProvider();
                      _selectedProductList = 5;

                      _itemAscBubble = false;
                      _itemDescBubble = false;
                      _itemDescQuick = false;
                    });
                    Navigator.pop(context);

                  },
                  child: ListTile(
                    title: CustomText(text: 'Ascending Quick',),
                    subtitle: CustomText(
                      text: 'Sort price from low to high with quick algorithm',
                      size: 14,
                      color: grey,
                    ),
                    trailing: _checkAscQuick ? Icon(Icons.check_outlined, color: blue) : null,
                  ),
                ),
              ),
            ),
            Visibility(visible: _itemDescQuick ? true : false,child: Divider(color: blue,)),
            Visibility(
              visible: _itemDescQuick ? true : false,
              child: Material(
                child: GestureDetector(
                  onTap: ()async{
                    if(_selectedProductList == 0){
                      setState((){
                        _selectedCatList = 0;
                        _nameProductList = 'Recent Products have been sorted high to low with quick algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortDesc(_unSortedProduct, 0, _unSortedProduct.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }else if(_selectedProductList == 1){
                      setState((){
                        _selectedCatList = 1;
                        _nameProductList = 'Plus Glasses Category have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortDesc(_productsCatPlus, 0, _productsCatPlus.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }else if(_selectedProductList == 2){
                      setState((){
                        _selectedCatList = 2;
                        _nameProductList = 'Min Glasses Category have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortDesc(_productsCatMin, 0, _productsCatMin.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }else if(_selectedProductList == 3){
                      setState((){
                        _selectedCatList = 3;
                        _nameProductList = 'Progressive Glasses Category have been sorted high to low with bubble algorithm';
                        Stopwatch stopwatch = Stopwatch()..start();
                        print('Time Start: ${dateFormat.format(DateTime.now())}');
                        productProvider.quickSortDesc(_productsCatProgressive, 0, _productsCatProgressive.length -1);
                        print('Time End: ${dateFormat.format(DateTime.now())}');
                        stopwatch.stop();
                        print('Time elapsed Quick Sort : ${stopwatch.elapsed}');
                      });
                      print('Sorted Price : ');
                      for(int x =0; x < productProvider.priceQuickSort.length; x++){
                        print('${x+1}. ${productProvider.priceQuickSort[x].price}');
                      }
                    }
                    setState(() {
                      _itemSortClicked = true;
                      _checkDescQuick = true;
                      getProductQuickFromProvider();
                      _selectedProductList = 5;

                      _itemAscBubble = false;
                      _itemDescBubble = false;
                      _itemAscQuick = false;
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: CustomText(text: 'Descending Quick',),
                    subtitle: CustomText(
                      text: 'Sort price from high to low with quick algorithm',
                      size: 14,
                      color: grey,
                    ),
                    trailing: _checkDescQuick ? Icon(Icons.check_outlined, color: blue) : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showModalBottomSheet(
        context: context,
        //topRadius: Radius.circular(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isScrollControlled: true,
        builder: (_) => modal);
  }

  void detailAlgorithmDialog(){
    var dialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 185,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5,),
              CustomText(
                text: 'Detail Algorithm',
                weight: FontWeight.bold, size: 20,
                color: blue,
              ),
              SizedBox(height: 15,),
              CustomText(
                text: "Time Start : \n Time Stop  : \n Time Elapsed : ",
                align: TextAlign.center,
              ),
              SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)
                    ),
                  ),
                  child: Center(child: CustomText(text: "Close", color: white,)),
                ),
              )
            ],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}