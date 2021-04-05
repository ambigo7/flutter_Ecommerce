import 'package:flutter/material.dart';
//my own packages
import 'package:lets_shop/pages/product_details.dart';

//package money formatter
import 'package:flutter_money_formatter/flutter_money_formatter.dart';


class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": "Blazer",
      "picture": "images/products/blazer1.jpeg",
      "old_price": 350000.0,
      "price": 219000.0,
    },
    {
      "name": "Red Dress",
      "picture": "images/products/dress1.jpeg",
      "old_price": 400000.0,
      "price": 249000.0,
    },
    {
      "name": "Joger Pants",
      "picture": "images/products/pants1.jpg",
      "old_price": 120000.0,
      "price": 99990.0,
    },
    {
    "name" : "Skirt",
    "picture": "images/products/skt1.jpeg",
    "old_price": 120000.0,
    "price": 99990.0,
    },
    {
      "name": "dr.Marteen",
      "picture": "images/products/shoe1.jpg",
      "old_price": 185000.0,
      "price": 149000.0,
    },
    {
      "name": "Nevada Hills",
      "picture": "images/products/hills1.jpeg",
      "old_price": 300000.0,
      "price": 229000.0,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_list.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index){
        return single_Product(
          product_name: product_list[index]['name'],
          product_pict: product_list[index]['picture'],
          product_old_price: product_list[index]['old_price'],
          product_price: product_list[index]['price'],
        );
      });
  }
}

class single_Product extends StatelessWidget {
  final product_name;
  final product_pict;
  final product_old_price;
  final product_price;

// Constructure Product
  single_Product({
    this.product_name,
    this.product_pict,
    this.product_old_price,
    this.product_price
});

  @override
  Widget build(BuildContext context) {

//  ====New Object pub money formatter====
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    return Card(
      child: Hero(
          tag: product_name,
          child: Material(
            child: InkWell(
//            ======Passing the values with constructure and Navigator.of(context).push=====
              onTap: ()=> Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => new productDetails(
                        product_detail_name: product_name,
                        product_detail_price: product_price,
                        product_detail_old_price: product_old_price,
                        product_detail_picture: product_pict,
                      ))),
              child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(product_name,
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      new Text(fmf.copyWith(
                        amount: product_price,
                        compactFormatType: CompactFormatType.short,
                        symbol: 'IDR',
                        thousandSeparator: ',',
                        symbolAndNumberSeparator: '-',
                        fractionDigits: 0,
                      )
                          .output
                          .symbolOnLeft,
                          style: TextStyle(
                              color: Colors.red, fontSize: 15,fontWeight: FontWeight.bold))
                    ],
                  )
                ),
                child: Image.asset(product_pict,
                fit: BoxFit.cover,),
              ),
            ),
          ),
      ),
    );
  }
}
