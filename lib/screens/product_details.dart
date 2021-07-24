import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/components/column_builder.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/components/expand_image_file.dart';
import 'package:lets_shop/components/expand_image_network.dart';
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

  ScrollController _hideBottomNavController;
  bool _isVisibleBottomNav;


  List<LensModel> _selectedLens;
  final _key = GlobalKey<ScaffoldState>();
  String _selectedColor = "";
  String _selectedSize = "";

  Page _selectedPage = Page.detail;

  Color active = blue;
  Color noActive = grey;

  String _priceCustomText = 'Price';
  String _expansion;
  bool _selectedExpansionLens = false;
  bool _selectedExpansionAdjustLens = false;

  int _idLensLength;
  int _totalPrice;

  getPrice(int lens, int product){
    setState(() {
      _totalPrice = lens+product;
    });
  }

  @override
  void initState() {
    super.initState();
    _idLensLength = -1;
    getPrice(0, widget.product.price);
    _isVisibleBottomNav = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
          () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleBottomNav)
            setState(() {
              _isVisibleBottomNav = false;
            });
        }
        if (_hideBottomNavController.position.userScrollDirection ==
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
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  widget.product.name,
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              //PRODUCT PRICE
                              Padding(
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
                                            fontSize: 20,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${formatCurrency.format(widget.product.price)}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
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
                    child: ListView(
                      controller: _hideBottomNavController,
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
                  bool success = await userProvider.addToCart(
                      product: widget.product,
                      color: _selectedColor,
                      size: _selectedSize);
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
                        CustomText(text: _priceCustomText, color: grey,),
                        CustomText(text: '${formatCurrency.format(_totalPrice)}', weight: FontWeight.bold, color: blue,),
                      ],
                    ),
                    Divider(color: grey,),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: _selectedExpansionAdjustLens ? true : false,
                child: ExpansionTile(
                  initiallyExpanded: _selectedExpansionAdjustLens,
                  onExpansionChanged: (newState){
                    setState(() {

                    });
                  },
                  title: CustomText(
                    text: 'Adjust your selected eyeglass',),
                  children: <Widget>[
                    CustomText(text: 'TEST',),
                    CustomText(text: 'TEST',),
                    CustomText(text: 'TEST',),
                  ],

                )
            ),
            ExpansionTile(
/*              onExpansionChanged: (newState){
                setState(() {
                  Duration(seconds: 20000);
                });
              },*/
              initiallyExpanded: _selectedExpansionLens,
              title: Row(
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
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ColumnBuilder(
                    itemCount: lensProvider.lens.length,
                    itemBuilder: (_, index){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            _priceCustomText = 'Price after custom';
                            getPrice(lensProvider.lens[index].price, widget.product.price);
                            _idLensLength = index;
                            _selectedExpansionLens = false;
                            _selectedExpansionAdjustLens = true;
                          });
                        },
                        onDoubleTap: (){
                          lensDetailModal(
                              lensProvider.lens[index].name, lensProvider.lens[index].brand,
                              lensProvider.lens[index].imageUrl, lensProvider.lens[index].oldPrice,
                              lensProvider.lens[index].price, lensProvider.lens[index].sale,
                              lensProvider.lens[index].color, lensProvider.lens[index].description);
                        },
                        onLongPress: (){
                          _priceCustomText = 'Price';
                          getPrice(0, widget.product.price);
                          _idLensLength = -1;
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
                )
              ],
            ),
          ],
        );
        break;
      default:
        return Container();
    }
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
              child: CustomText(text: 'Eyeglass Details', weight: FontWeight.bold,),
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
        backgroundColor: black.withOpacity(0.1),
        context: context,
        builder: (_) => modal);
  }
}
