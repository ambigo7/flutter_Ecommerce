import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/models/cart_item.dart';

// MY OWN PACKAGE
import 'package:lets_shop/provider/app_provider.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/service/order.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

import 'checkout.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  final formatDate = new DateFormat.MMMMd();

  final dateTomorrow = DateTime.now().add(Duration(days: 1));
  bool checkListExpress = false;
  bool checkListPick = false;


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: new AppBar(
        iconTheme: IconThemeData(color: blue),
        elevation: 0.1,
        backgroundColor: white,
        title: Text('Shopping cart', style: TextStyle(color: blue)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      //Item Cart
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: userProvider.userModel.cart.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: blue.withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: userProvider.userModel.cart[index].imageProduct,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 140,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: userProvider
                                              .userModel.cart[index].nameProduct +
                                          "\n",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: userProvider
                                          .userModel.cart[index].nameLens != null ? '${userProvider
                                          .userModel.cart[index].nameLens}\n' : 'Default\n\n',
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: userProvider
                                          .userModel.cart[index].adjustLens != null ? '${userProvider
                                          .userModel.cart[index].adjustLens.toUpperCase()}\n\n' : '\n\n',
                                      style: TextStyle(
                                          color: grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          "${formatCurrency.format(userProvider.userModel.cart[index].totalPriceCart)}",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300)),
                                ]),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: redAccent,
                                  ),
                                  onPressed: () async {
                                    appProvider.changeIsLoading();
                                    bool success =
                                        await userProvider.removeFromCart(
                                            cartItem: userProvider
                                                .userModel.cart[index]);
                                    if (success) {
                                      userProvider.reloadUserModel();
                                      print("Item removed from cart");
                                      _key.currentState.showSnackBar(SnackBar(
                                          backgroundColor: white,
                                          content: Text("Removed from Cart!",
                                              style: TextStyle(
                                                  color: blue))));
                                      appProvider.changeIsLoading();
                                      return;
                                    } else {
                                      appProvider.changeIsLoading();
                                    }
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      //
      bottomNavigationBar: Container(
        color: white,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(text: 'SubTotal', color: grey, size: 18,),
                  CustomText(text: '${formatCurrency.format(userProvider.userModel.totalCartPrice)}', size: 22,),
                ],
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: blue),
                child: FlatButton(
                    onPressed: () {
                      if (userProvider.userModel.totalCartPrice == 0) {
                        checkoutDialogEmpty();
                        return null;
                      }
                      changeScreen(context, CheckOut(totalPrice: userProvider.userModel.totalCartPrice,));
                    },
                    child: CustomText(
                      text: "Check out ("+userProvider.userModel.countCart.toString()+")",
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget shippingAddress(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Container(
      color: grey.withOpacity(0.1),
      child: GestureDetector(
        onTap: (){

        },
        child: ListTile(
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Icons.location_on_outlined,
                  color: blue,
                  size: 19,),
              ),
              CustomText(text: 'Shipping Address',)
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 20, top: 3),
            child: CustomText(text: userProvider.userModel.name+' | (+'+userProvider.userModel.phone.toString()+')\n'
                +userProvider.userModel.address,),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
    );
  }

  Widget dashedHorizontalLine(){
    return Container(
      color: grey.withOpacity(0.1),
      child: Row(
        children: [
          for (int i = 0; i < 20; i++)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: blue,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void checkoutDialogEmpty(){
    var dialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
      //this right here
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.shopping_cart_outlined, color: grey, size: 30,),
              CustomText(text: 'Your cart is empty', size: 20, align: TextAlign.center, color: grey,),

            ],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}
