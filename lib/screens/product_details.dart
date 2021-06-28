import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/models/product.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

import 'package:lets_shop/provider/app_provider.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  String _selectedColor = "";
  String _selectedSize = "";


  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.color[0];
    _selectedSize = widget.product.sizes[0];
  }

  @override
  Widget build(BuildContext context) {
    //  ====CREATE MONEY CURRENCY FORMATTER====
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(
        child: Container(
          color: black.withOpacity(0.9),
          child: Column(children: <Widget>[
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          //PRODUCT PRICE
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${formatCurrency.format(widget.product.price)}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
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
/*                                animationDuration: Duration(milliseconds: 300),
                                  animationType: BadgeAnimationType.slide,*/
                                badgeContent: Text(
                                    userProvider.userModel.countCart.toString(),
                                    style: TextStyle (color: Colors.white)),
                                child: Icon(Icons.shopping_cart_outlined, color: redAccent))
                                : Icon(Icons.shopping_cart_outlined, color: redAccent),
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
                        Navigator.pop(context);
/*                        setState(() {
                          _getCountCart(context);
                        });*/
                      userProvider.reloadUserModel();
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
                                color: redAccent,
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
                        offset: Offset(2, 2),
                        /*blurRadius: 10*/
                      )
                    ]),
                child: Column(
                  children: <Widget>[
                    Padding(
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
                              items: widget.product.color
                                  .map<DropdownMenuItem<String>>((value) =>
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
                    ),
                    Padding(
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
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ListTile(
                            title: Text('Description :'),
                            subtitle: Text(widget.product.description,
                                style: TextStyle(color: black)),
                          )),
                    ),
                    //BUTTON BUY
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: redAccent,
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              appProvider.changeIsLoading();
                              bool success = await userProvider.addToCart(
                                  product: widget.product,
                                  color: _selectedColor,
                                  size: _selectedSize);
                              if (success) {
                                /*setState(() {
                                  _getCountCart(context);
                                }); *///TODO: masih gagal belum ketemu kenapa ga mau update datanya.
                                _key.currentState.showSnackBar(SnackBar(
                                    backgroundColor: white,
                                    content: Text("Product has been Added to Cart",
                                        style: TextStyle(color: redAccent))));
                                userProvider.reloadUserModel();
                                appProvider.changeIsLoading();
                                /*return null;*/
                              } else {
                                _key.currentState.showSnackBar(SnackBar(
                                    backgroundColor: white,
                                    content: Text("Sorry, No products added to Cart",
                                        style: TextStyle(color: redAccent))));
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
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
