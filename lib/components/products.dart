import 'package:flutter/material.dart';
import 'package:lets_shop/commons/common.dart';

//MY OWN PACKAGES
import 'package:lets_shop/screens/product_details.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

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
      "name": "Skirt",
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
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: single_Product(
              product_name: product_list[index]['name'],
              product_pict: product_list[index]['picture'],
              product_old_price: product_list[index]['old_price'],
              product_price: product_list[index]['price'],
            ),
          );
        });
  }
}

class single_Product extends StatelessWidget {
  final product_name;
  final product_pict;
  final product_old_price;
  final product_price;

// CONSTRUCTURE PRODUCT
  single_Product(
      {this.product_name,
      this.product_pict,
      this.product_old_price,
      this.product_price});

//  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
//            ======PASSING THE VALUES WITH CONSTRUCTURE AND NAVIGATOR.OF(CONTEXT).PUSH=====
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new productDetails(
                    product_detail_name: product_name,
                    product_detail_price: product_price,
                    product_detail_old_price: product_old_price,
                    product_detail_picture: product_pict,
                  ))),
          child: GridTile(
            footer: Container(
              color: white,
              child: ListTile(
                title: Text(product_name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${formatCurrency.format(product_price)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
/*                  child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(product_name,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    new Text('${formatCurrency.format(product_price)}',
                    style: TextStyle(color: Colors.deepOrangeAccent[700], fontSize: 15,fontWeight: FontWeight.bold))
                  ],
                )*/
            ),
            child: Image.asset(
              product_pict,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
