import 'package:badges/badges.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/components/column_builder.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/components/expand_image_file.dart';
import 'package:lets_shop/components/expand_image_network.dart';
import 'package:lets_shop/models/adjust_lens.dart';
import 'package:lets_shop/models/lens.dart';
import 'package:lets_shop/models/product.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

import 'package:lets_shop/provider/app_provider.dart';
import 'package:lets_shop/provider/lens_provider.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/cart.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

enum Page { detail, custom }

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  ScrollController _scrollController;
  bool _toTopButton = false;
  bool _isVisibleBottomNav;


  List<LensModel> _selectedLens;
  final _key = GlobalKey<ScaffoldState>();
  String _selectedColor = "";
  String _selectedSize = "";

  Page _selectedPage = Page.detail;

  Color active = blue;
  Color noActive = grey;

  String _priceCustomText = 'Price';

  int _idLensLength;
  int _totalPrice;
  int _indexSelectedLens = -1;

  bool _fromTop = true;

  final _editableKey = GlobalKey<EditableState>();

  List _dataAdjustLens;

  ///Print only edited rows.
  void _submitDataAdjustLens(List dataAdjust) {
    _dataAdjustLens = dataAdjust;
    if(dataAdjust.isNotEmpty){
      setState(() {
        rowsAdjustLens[0]['sph'] = _dataAdjustLens[0]['sph'] ?? '';
        rowsAdjustLens[0]['cyl'] = _dataAdjustLens[0]['cyl'] ?? '';
        rowsAdjustLens[0]['axis'] =  _dataAdjustLens[0]['axis'] ?? '';
        rowsAdjustLens[0]['add'] = _dataAdjustLens[0]['add'] ?? '';

        rowsAdjustLens[0]['pd'] =  _dataAdjustLens[0]['pd'] ?? '';

        rowsAdjustLens[1]['sph'] = _dataAdjustLens[1]['sph'] ?? '';
        rowsAdjustLens[1]['cyl'] = _dataAdjustLens[1]['cyl'] ?? '';
        rowsAdjustLens[1]['axis'] =  _dataAdjustLens[1]['axis'] ?? '';
        rowsAdjustLens[1]['add'] = _dataAdjustLens[1]['add'] ?? '';
      });
    }else{
      setState(() {
        rowsAdjustLens[0]['sph'] = '';
        rowsAdjustLens[0]['cyl'] = '';
        rowsAdjustLens[0]['axis'] = '';
        rowsAdjustLens[0]['add'] = '';

        rowsAdjustLens[0]['pd'] =  '';

        rowsAdjustLens[1]['sph'] = '';
        rowsAdjustLens[1]['cyl'] = '';
        rowsAdjustLens[1]['axis'] = '';
        rowsAdjustLens[1]['add'] = '';

        rowsAdjustLens[0]['pd'] =  'X';
      });
    }
    print(_dataAdjustLens);
  }

  List rowsAdjustLens;

  List colsAdjustLens = [
    {"title": ' ', 'widthFactor': 0.1, 'key': 'rl', 'editable': false},
    {"title": 'SPH', 'key': 'sph'},
    {"title": 'CYL', 'key': 'cyl'},
    {"title": 'AXIS', 'key': 'axis'},
    {"title": 'ADD', 'key': 'add'},
    {"title": 'PD', 'widthFactor': 0.1, 'key': 'pd'},
  ];


  getPrice(int lens, int product){
    setState(() {
      _totalPrice = lens+product;
    });
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }


  @override
  void initState() {
    super.initState();
    _dataAdjustLens = [];
    rowsAdjustLens =  [
      {
        "rl": 'R',
        "sph": '',
        "cyl": '',
        "axis": '',
        "add": '',
        "pd": ''
      },
      {
        "rl": 'L',
        "sph": '',
        "cyl": '',
        "axis": '',
        "add": '',
        "pd": 'X'
      }
    ];
    _idLensLength = -1;
    getPrice(0, widget.product.price);
    _isVisibleBottomNav = true;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        setState(() {
          _toTopButton = true; // to-top button
        });
      } else {
        setState(() {
          _toTopButton = false;
        });
      }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleBottomNav)
            setState(() {
              _isVisibleBottomNav = false;
            });
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisibleBottomNav)
            setState(() {
              _isVisibleBottomNav = true;
            });
        }
      },
    );
    // _selectedColor = widget.product.color[0];
  }

  @override
  Widget build(BuildContext context) {
    //  ====CREATE MONEY CURRENCY FORMATTER====

    final userProvider = Provider.of<UserProvider>(context);
    final lensProvider = Provider.of<LensProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(
        child: Container(
          color: black.withOpacity(0.9),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Loading(),
                        )),
//              IMPLEMENTATION LOADING IMAGE TRANSPARENT WHEN PRODUCT IMAGE LOAD FROM DB
                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.product.imageUrl,
                        fit: BoxFit.fill,
                        height: 350,
                        width: double.infinity,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            // Box decoration takes a gradient
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              colors: [
                                // Colors are easy thanks to Flutter's Colors class.
                                Colors.black.withOpacity(0.7),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.07),
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.025),
                              ],
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container())),
                    ),
                    //PICTURE BOX
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: (){
                          print('clicked');
                          changeScreen(context, ExpandImageNetwork(
                            imageUrl: widget.product.imageUrl,
                            enableSlideOutPage: true,
                          )
                          );
                        },
                        child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              // Box decoration takes a gradient
                              gradient: LinearGradient(
                                // Where the linear gradient begins and ends
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                // Add one stop for each color. Stops should increase from 0 to 1
                                colors: [
                                  // Colors are easy thanks to Flutter's Colors class.
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.4),
                                  Colors.black.withOpacity(0.07),
                                  Colors.black.withOpacity(0.05),
                                  Colors.black.withOpacity(0.025),
                                ],
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container())),
                      ),
                    ),
                    //PRODUCT NAME
                    Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    widget.product.name,
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              //PRODUCT PRICE
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Visibility(
                                        visible: widget.product.sale ? true : false,
                                        child: Text(
                                          '${formatCurrency.format(widget.product.oldPrice)}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: redAccent,
                                              fontSize: 17,
                                              decoration: TextDecoration.lineThrough,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${formatCurrency.format(widget.product.price)}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    //CART PRODUCT
                    Positioned(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            changeScreen(context, CartScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(35))),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: userProvider.userModel.countCart > 0
                                    ? Badge(
                                    position: BadgePosition.topEnd(top: -13, end: -8),
                                    animationDuration: Duration(seconds: 1),
                                    animationType: BadgeAnimationType.slide,
                                    badgeContent: Text(
                                        userProvider.userModel.countCart.toString(),
                                        style: TextStyle (color: Colors.white)),
                                    child: Icon(Icons.shopping_cart_outlined, color: blue))
                                    : Icon(Icons.shopping_cart_outlined, color: blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //BUTTON BACK
                    Positioned(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            print("CLICKED");
                            userProvider.reloadUserModel();
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(35))),
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: blue,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //DESC & BUTTON BUY BOX
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: white,
                            offset: Offset(0, 1),
                            /*blurRadius: 10*/
                          )
                        ]),
                    child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details){
                        if (details.primaryVelocity > 0) {
                          // User swiped Left
                          setState(() {
                            _selectedPage = Page.detail;
                          });
                        } else if (details.primaryVelocity < 0) {
                          // User swiped Right
                          setState(() {
                            _selectedPage = Page.custom;
                          });
                        }
                      },
                      child: ListView(
                        controller: _scrollController,
                        children: <Widget>[
                          /*Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Select a Color :',
                                color: black,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton<String>(
                                value: _selectedColor,
                                style: TextStyle(color: black),
                                items: widget.product.color.map<DropdownMenuItem<String>>((value) =>
                                    DropdownMenuItem(
                                        value: value,
                                        child: CustomText(text: value)))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedColor = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),*/
                          /*Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Select a size :',
                                color: black,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton<String>(
                                value: _selectedSize,
                                style: TextStyle(color: black),
                                items: widget.product.sizes
                                    .map<DropdownMenuItem<String>>((value) =>
                                    DropdownMenuItem(
                                        value: value,
                                        child: CustomText(text: value)))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSize = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),*/
                          SizedBox(height: 8,),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _selectedPage = Page.detail;
                                      });
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Product Details', weight: FontWeight.bold,),
                                          Divider(thickness: 3, color: _selectedPage == Page.detail ? active : noActive,)
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _selectedPage = Page.custom;
                                      });
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Custom Eyeglass', weight: FontWeight.bold,),
                                          Divider(thickness: 3, color: _selectedPage == Page.custom ? active : noActive,)
                                        ],
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          contentPage()
                        ],
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),

      //BUTTON Add to cart
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(9),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: _isVisibleBottomNav ? 45 : 0.0,
          child: Material(
              borderRadius: BorderRadius.circular(15.0),
              color: blue,
              elevation: 0.0,
              child: MaterialButton(
                onPressed: () async {
                  appProvider.changeIsLoading();
                  print('index selected lens: $_indexSelectedLens');
                  if(_indexSelectedLens == -1){
                    bool success = await userProvider.addToCart(
                      product: widget.product, totalPrice: _totalPrice);
                    if (success) {
                      _key.currentState.showSnackBar(SnackBar(
                          backgroundColor: white,
                          content: Text("Product has been Added to Cart",
                              style: TextStyle(color: blue))));
                      userProvider.reloadUserModel();
                      appProvider.changeIsLoading();
                      return null;
                    } else {
                      _key.currentState.showSnackBar(SnackBar(
                          backgroundColor: white,
                          content: Text("Sorry, No products added to Cart",
                              style: TextStyle(color: blue))));
                      appProvider.changeIsLoading();
                      return null;
                    }
                  }else{
                    print('data lens name : ${lensProvider.lens[_indexSelectedLens].name}');
                    print('list adjust : $_dataAdjustLens');

                    bool success = await userProvider.addToCart(
                        product: widget.product,
                        lens: lensProvider.lens[_indexSelectedLens],
                        adjustLens: _dataAdjustLens,
                        totalPrice: _totalPrice
                    );
                    if (success) {
                      _key.currentState.showSnackBar(SnackBar(
                          backgroundColor: white,
                          content: Text("Product has been Added to Cart",
                              style: TextStyle(color: blue))));
                      userProvider.reloadUserModel();
                      appProvider.changeIsLoading();
                      return null;
                    } else {
                      _key.currentState.showSnackBar(SnackBar(
                          backgroundColor: white,
                          content: Text("Sorry, No products added to Cart",
                              style: TextStyle(color: blue))));
                      appProvider.changeIsLoading();
                      return null;
                    }
                  }
                },
                minWidth: MediaQuery.of(context).size.width,
                child: appProvider.isLoading
                    ? Loading()
                    : Text(
                  "Add to Cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              )),
        ),
      ),
    );
  }

  Widget contentPage(){
    switch(_selectedPage){
      case Page.detail:
        return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ListTile(
              // title: CustomText(text: 'Product Details', weight: FontWeight.bold,),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Divider(color: grey,),
                  RichText(
                    text: TextSpan(
                        text: 'Brands \t\t\t\t\t\t\t',
                        style: TextStyle(color: grey, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${widget.product.brand}',
                            style: TextStyle(color: black),
                          )
                        ]
                    ),
                  ),
                  Divider(color: grey,),
                  RichText(
                    text: TextSpan(
                        text: 'Color \t\t\t\t\t\t\t\t\t\t',
                        style: TextStyle(color: grey, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${widget.product.color}',
                            style: TextStyle(color: black),
                          )
                        ]
                    ),
                  ),
                  Divider(color: grey,),
                  CustomText(text: 'Description', color: grey,),
                  SizedBox(height: 8,),
                  CustomText(text: widget.product.description,)
                ],
              ),
            )
        );
        break;
      case Page.custom:
        final lensProvider = Provider.of<LensProvider>(context, listen: false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Divider(color: grey,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (Widget child, Animation<double> animation){
                            return ScaleTransition(child: child, scale: animation,);
                          },
                          child: Text(_priceCustomText,
                            key: ValueKey<String>(_priceCustomText),
                            style: TextStyle(color: grey, fontSize: 16,),),
                        ),/*CustomText(text: _priceCustomText, color: grey,),*/
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (Widget child, Animation<double> animation){
                            return ScaleTransition(child: child, scale: animation,);
                          },
                          child: Text('${formatCurrency.format(_totalPrice)}',
                            style: TextStyle(color: blue, fontSize: 16, fontWeight:FontWeight.bold),
                            key: ValueKey<int>(_totalPrice),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: grey,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 5),
              child: Row(
                children: <Widget>[
                  CustomText(text: 'Select Eyeglass',),
                  GestureDetector(
                    onTap: (){
                      _key.currentState.showSnackBar(
                          SnackBar(content: RichText(text: TextSpan(
                              text: 'Tap ',
                              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'for select eyeglass.\n',
                                  style: TextStyle(color: black, fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: 'Double Tap ',
                                  style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'for detail eyeglass.\n',
                                  style: TextStyle(color: black, fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: 'Long Press ',
                                  style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'for cancel custom eyeglass',
                                  style:  TextStyle(color: black, fontWeight: FontWeight.normal),
                                ),
                              ]
                          )),
                              backgroundColor: white
                          ));
                    },
                    child: Icon(LineIcons.questionCircle, color: grey, size: 18,),
                  )
                ],
              ),
            ),
            ColumnBuilder(
                itemCount: lensProvider.lens.length,
                itemBuilder: (_, index){
                  return GestureDetector(
                    onTap: (){
                      _scrollToTop();
                      setState(() {
                        _isVisibleBottomNav = true;
                        _indexSelectedLens = index;
                        print('selected index : $_indexSelectedLens');
                        _priceCustomText = 'Price after custom';
                        getPrice(lensProvider.lens[index].price, widget.product.price);
                        _idLensLength = index;
                      });
                      // Future.delayed(Duration(milliseconds: 500));
                      lensAdjutDialog();
                    },
                    onDoubleTap: (){
                      lensDetailModal(
                          lensProvider.lens[index].name, lensProvider.lens[index].brand,
                          lensProvider.lens[index].imageUrl, lensProvider.lens[index].oldPrice,
                          lensProvider.lens[index].price, lensProvider.lens[index].sale,
                          lensProvider.lens[index].color, lensProvider.lens[index].description);
                    },
                    onLongPress: (){
                      _indexSelectedLens = -1;
                      _priceCustomText = 'Price';
                      getPrice(0, widget.product.price);
                      _idLensLength = -1;
                      _scrollToTop();
                      setState(() {
                        _isVisibleBottomNav = true;
                        rowsAdjustLens =  [
                          {
                            "rl": 'R',
                            "sph": '',
                            "cyl": '',
                            "axis": '',
                            "add": '',
                            "pd": ''
                          },
                          {
                            "rl": 'L',
                            "sph": '',
                            "cyl": '',
                            "axis": '',
                            "add": '',
                            "pd": 'X'
                          }
                        ];
                        _dataAdjustLens = [];
                      });
                    },
                    child: ListTile(
                      leading: Container(
                        height: 80,
                        width: 80,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: lensProvider.lens[index].imageUrl,
                          fit: BoxFit.fill,
                          height: 120,
                          width: 140,
                        ),
                      ),
                      title: CustomText(text: lensProvider.lens[index].name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            text: lensProvider.lens[index].sale ? '${formatCurrency.format(lensProvider.lens[index].oldPrice)}' : '',
                            decoration: TextDecoration.lineThrough, color: redAccent, size: 14,),
                          Row(
                            children: <Widget>[
                              CustomText(text: '${formatCurrency.format(lensProvider.lens[index].price)}',),
                              Visibility(
                                visible: lensProvider.lens[index].sale ? true : false,
                                  child: CustomText(
                                    text: ' ON SALE', color: redAccent,)
                              )
                            ],
                          ),
                        ],
                      ),
                      trailing: _idLensLength == index ? Icon(Icons.check_outlined, color: blue) : null,
                    ),
                  );
                }
            ),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void lensAdjutDialog(){
    var dialog = Align(
      alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: Container(
          height: 270,
          margin: EdgeInsets.only(top: 160),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Material(
                color: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomText(
                        text: 'Adjust Your\nSelected Eyeglass ',
                        color: blue,
                        size: 18,
                        align: TextAlign.center,
                        weight: FontWeight.bold,),
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: Tooltip(
                            decoration: BoxDecoration(color: black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                            textStyle: TextStyle(color: white),
                            waitDuration: Duration(microseconds: 0),
                            message: 'Optional, If you want to adjust the eyeglass to your eyes',
                            child: Icon(LineIcons.questionCircle, color: grey, size: 18,)),
                      ),
                    ],
                  )),
              SizedBox(height: 10,),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: Editable(
                    key: _editableKey,
                    thSize: 16,
                    thWeight: FontWeight.bold,
                    thAlignment: TextAlign.center,
                    tdStyle: TextStyle(fontSize: 16),
                    tdAlignment: TextAlign.center,
                    columns: colsAdjustLens,
                    rows: rowsAdjustLens,
                    zebraStripe: true,
                    borderColor: black,
                    stripeColor2: grey.withOpacity(0.3),
                    onSubmitted: (value) {
                      print(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 10, 14.0, 10),
                child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: blue,
                    elevation: 0.0,
                    child: MaterialButton(
                        onPressed: (){
                          _submitDataAdjustLens(_editableKey.currentState.editedRows);
                          Navigator.pop(context);
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: CustomText(text: 'Submit', weight: FontWeight.bold, color: white,)
                    )
                ),
              )
            ],
          )
      )
    );
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 500),
        context: context,
        pageBuilder: (context, anim1, anim2){
          return dialog;
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        });
  }

  void lensDetailModal(nameLens, brand, img, oldPrice, price, sale, color, desc){
    var modal = Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: CustomText(text: 'Eyeglass Details', weight: FontWeight.bold, size: 18,),
            ),
            SizedBox(height: 2,),
            Divider(thickness: 3, color: blue,),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            changeScreen(context, ExpandImageNetwork(imageUrl: img, enableSlideOutPage: true,));
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: img,
                              fit: BoxFit.fill,
                              height: 120,
                              width: 140,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 15),
                          child: RichText(text: TextSpan(
                              text: '$nameLens\n',
                              style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold,),
                              children: <TextSpan>[
                                TextSpan(
                                  text: sale ? '${formatCurrency.format(oldPrice)}\n' : '\n',
                                  style: TextStyle(color: redAccent, fontSize: 14,
                                      decoration: TextDecoration.lineThrough, fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: '${formatCurrency.format(price)}',
                                  style: TextStyle(color: blue, fontSize: 18,),
                                ),
                                TextSpan(
                                  text: sale ? ' ON SALE' : '',
                                  style: TextStyle(color: redAccent, fontSize: 18,
                                      decoration: TextDecoration.none, fontWeight: FontWeight.normal),
                                )
                              ]
                          ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: grey,),
                    RichText(
                      text: TextSpan(
                          text: 'Brands \t\t\t\t\t\t\t',
                          style: TextStyle(color: grey, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: brand,
                              style: TextStyle(color: black),
                            )
                          ]
                      ),
                    ),
                    Divider(color: grey,),
                    RichText(
                      text: TextSpan(
                          text: 'Color \t\t\t\t\t\t\t\t\t\t',
                          style: TextStyle(color: grey, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: color,
                              style: TextStyle(color: black),
                            )
                          ]
                      ),
                    ),
                    Divider(color: grey,),
                    CustomText(text: 'Description', color: grey,),
                    SizedBox(height: 8,),
                    CustomText(text: desc)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showBarModalBottomSheet(
        barrierColor: black.withOpacity(0.5),
        backgroundColor: black.withOpacity(0.1),
        context: context,
        builder: (_) => modal);
  }
}
