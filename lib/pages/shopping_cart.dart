import 'package:flutter/material.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/cart_product.dart';

class shoppingCart extends StatefulWidget {
  @override
  _shoppingCartState createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  double moneyValue = 229000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text('Shopping cart', style: TextStyle(color: Colors.red)),
        actions: <Widget> [
          new IconButton(
              icon: Icon(
                Icons.search_outlined,
              ),
              onPressed: (){}),
        ],
      ),

      body: new cartProduct(),

//    ===BOTTOM NAV FOR TOTAL PRICE & BUTTON CHECK OUT===
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
                  title: new Text('Total:'),
                  subtitle: new Text('${formatCurrency.format(moneyValue)}',
                  style: TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.bold))
                )
            ),

            Expanded(
              child: new MaterialButton(
                onPressed: (){},
                child: new Text('Check out', style: TextStyle(color: Colors.white)),
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
