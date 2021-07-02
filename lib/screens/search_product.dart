import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/components/product_card.dart';
import 'package:lets_shop/provider/product_provider.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/cart.dart';
import 'package:lets_shop/screens/product_details.dart';
import 'package:provider/provider.dart';

class SearchProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        backgroundColor: white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        title: CustomText(text: "Products", size: 20, color: blue, weigth: FontWeight.bold,),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
            child: GestureDetector(
            onTap: () {
                changeScreen(context, CartScreen());
                },
                child: userProvider.userModel.countCart > 0
              ? Badge(
              position: BadgePosition.topEnd(top: 0, end: -8),
                                  animationDuration: Duration(milliseconds: 300),
                                    animationType: BadgeAnimationType.slide,
              badgeContent: Text(
                  userProvider.userModel.countCart.toString(),
                  style: TextStyle(color: Colors.white)),
              child: Icon(Icons.shopping_cart_outlined, color: blue))
              : Icon(Icons.shopping_cart_outlined, color: blue)),
          )
        ],
      ),
      // ? is a null awareness(boleh kalo ga punya nilai)
      body: productProvider.productsSearch.length < 1? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.search, color: grey, size: 30,),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(text: "No products Found", color: grey, weigth: FontWeight.w300, size: 22,),
            ],
          )
        ],
      ) : ListView.builder(
          itemCount: productProvider.productsSearch.length,
          itemBuilder: (context, index){
            return GestureDetector(
                onTap: ()async{
                  changeScreen(context, ProductDetails(product: productProvider.productsSearch[index]));
                },
                child: ProductCard(product:  productProvider.productsSearch[index]));
          }),
    );
  }
}