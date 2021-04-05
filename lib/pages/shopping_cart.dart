import 'package:flutter/material.dart';

//PACKAGE MONEY FORMATTER
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/cart_product.dart';

class shoppingCart extends StatefulWidget {
  @override
  _shoppingCartState createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  @override
  Widget build(BuildContext context) {
//  ====New Object pub money formatter====
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Shopping cart'),
        actions: <Widget> [
          new IconButton(
              icon: Icon(
                Icons.search_outlined,
                color: Colors.white,
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
                  subtitle: new Text(fmf.copyWith(
                    amount: 229000.0,
                    compactFormatType: CompactFormatType.short,
                    symbol: 'IDR',
                    thousandSeparator: ',',
                    symbolAndNumberSeparator: '-',
                    fractionDigits: 0,
                  )
                      .output
                      .symbolOnLeft),
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
