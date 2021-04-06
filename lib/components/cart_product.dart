import 'package:flutter/material.dart';

//MY OWN PACKAGE
import 'package:lets_shop/pages/test.dart';

//PACKAGE MONEY FORMATTER
import 'package:flutter_money_formatter/flutter_money_formatter.dart';


class cartProduct extends StatefulWidget {
  @override
  _cartProductState createState() => _cartProductState();
}

class _cartProductState extends State<cartProduct> {
  var product_on_the_cart = [
    {
      "name": "Blazer",
      "picture": "images/products/blazer1.jpeg",
      "price": 219000.0,
      "size": "L",
      "color": "Black",
      "qty": 1
    },
    {
      "name": "Red Dress",
      "picture": "images/products/dress1.jpeg",
      "price": 249000.0,
      "size": "S",
      "color": "Red",
      "qty": 2
    }
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: product_on_the_cart.length,
        itemBuilder: (context, index){
         return singleCart_Product(
           cart_prod_name: product_on_the_cart[index]['name'],
           cart_prod_pict: product_on_the_cart[index]['picture'],
           cart_prod_price: product_on_the_cart[index]['price'],
           cart_prod_size: product_on_the_cart[index]['size'],
           cart_prod_color: product_on_the_cart[index]['color'],
           cart_prod_qty: product_on_the_cart[index]['qty'],
         );
        });
  }
}

class singleCart_Product extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_pict;
  final cart_prod_price;
  final cart_prod_size;
  final cart_prod_color;
  final cart_prod_qty;

// Constructure Product
  singleCart_Product({
    this.cart_prod_name,
    this.cart_prod_pict,
    this.cart_prod_price,
    this.cart_prod_size,
    this.cart_prod_color,
    this.cart_prod_qty
  });
  @override
  Widget build(BuildContext context) {

//  ====NEW OBJECT PUB MONEY FORMATTER====
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    return Card(
        child: ListTile(

//      ===THIS PART IS FOR PUT THE PICTURE===
          leading: Image.asset(cart_prod_pict,
            height: 50.0,
            width: 50.0,
          ),

//      ====THIS TITLE FOR PRODUCT NAME====
          title: new Text(cart_prod_name),

//      ===THIS SUBTITLE FOR SIZE & COLOR=======
          subtitle: new Column(
            children: <Widget>[

//          ===USE ROW INSIDE THE COLUMN====
              new Row(
                children: <Widget>[

//              ====THIS PART IS FOR THE SIZE OF THE PRODUCT====
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Text('Size:')
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text(cart_prod_size, style: TextStyle(color: Colors.black))
                  ),

//              ====THIS PART IS FOR THE COLOR OF THE PRODUCT====
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 3.0, 8.0),
                      child: new Text('Color:')
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(cart_prod_color, style: TextStyle(color: Colors.black))
                  ),
                ],
              ),

//            ====THIS PART IS FOR PRODUCT PRICE===
              Container(
                alignment: Alignment.topLeft,
                child: new Text(fmf.copyWith(
                  amount: cart_prod_price,
                  compactFormatType: CompactFormatType.short,
                  symbol: 'IDR',
                  thousandSeparator: ',',
                  symbolAndNumberSeparator: '-',
                  fractionDigits: 0,
                )
                    .output
                    .symbolOnLeft,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
              )
            ]
          ),

//      ===TRAILING IS FOR ADDING OR REDUCING PRODUCT QTY====
          trailing: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 3.0, 8.0),
                      child: new IconButton(icon: Icon(Icons.add, size: 20.0), onPressed: (){}),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 1.7, 0.0),
                    child: new Text("${cart_prod_qty}")
                  ),
                    new IconButton(icon: Icon(Icons.remove, size: 20.0), onPressed: (){})
                  ],
                )
        ),
      );
  }
}

