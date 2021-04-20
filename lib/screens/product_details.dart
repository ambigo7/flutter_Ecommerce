import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'file:///D:/App%20Flutter%20build/lets_shop/lib/tidak_terpakai/controller.dart';

//MY OWN PACKAGES
import 'package:lets_shop/screens/home.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

class ProductDetails extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String productPicture;

//Constructor product details
  ProductDetails({@required this.productName, @required this.productPrice, @required this.productPicture});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  //  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: black.withOpacity(0.9),
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  widget.productPicture,
                  height: 350,
                  fit: BoxFit.cover,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 350,
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
                              widget.productName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${formatCurrency.format(widget.productPrice)}',
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        /*changeScreen(context, CartScreen());*/
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            color: white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.shopping_cart_outlined, color: redAccent,),
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  top: 7,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        print("CLICKED");
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Select Color: ',
                              style: TextStyle(color: black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Select Size: ',
                                style: TextStyle(color: black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  'S',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: black, fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  'M',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: black, fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  'L',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: black, fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                  color: white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  'XL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: black, fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Description:\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s  Lorem Ipsum has been the industry standard dummy text ever since the 1500s ',
                            style: TextStyle(color: black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: redAccent,
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () {},
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text(
                              "Buy now",
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
/*      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,

//              ====GIVE A 'WIDGET' CZ THE CLASS IS DIFFERENT TO EACHOTHER A.K.A THE VALUES IS PASS FROM ANOTHER CLASS===
                child: Image.asset(widget.product_detail_picture),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
//                ===GIVE A 'WIDGET' CZ THE CLASS IS DIFFERENT TO EACHOTHER===
                  leading: new Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ),

//        ====ROW OF PRICE====
          new Container(
            color: Colors.white,
            child: new Row(
              children: <Widget>[
                Container(
//                      ====GIVE A "${}" CZ THIS PART ONLY APPROVE STRING====
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('${formatCurrency.format(widget.product_detail_price)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.deepOrangeAccent[700])),
                )),
                Container(
                    child: Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                          child: new Text('${formatCurrency.format(widget.product_detail_old_price)}',
                          style: TextStyle(fontSize: 17.0, color: Colors.grey, decoration: TextDecoration.lineThrough))
                    ),
                ),
              ],
            ),
          ),

//        =======FIRST BUTTON=======
          Row(
            children: <Widget>[

//          =======SIZE BUTTON======
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text('Size'),
                            content: new Text('Choose the size'),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text('close'),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text('Size')),
                      Expanded(child: new Icon(Icons.arrow_drop_down_outlined))
                    ],
                  ),
                ),
              ),

//          =======COLOR BUTTOn======
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text('Color'),
                            content: new Text('Choose a color'),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text('close'),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text('Color')),
                      Expanded(child: new Icon(Icons.arrow_drop_down_outlined))
                    ],
                  ),
                ),
              ),

//          =======QUANTITY BUTTON======
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text('Quantity'),
                            content: new Text('Choose the quantity'),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text('close'),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text('Qty')),
                      Expanded(child: new Icon(Icons.arrow_drop_down_outlined))
                    ],
                  ),
                ),
              ),
            ],
          ),

          Divider(),
//        ======PRODUCT DESCRIPTION====
          new ListTile(
            title: new Text('Product description'),
            subtitle: new Text(
                'Lorem Ipsum is simply dummy text of the printing and '
                'typesetting industry. Lorem Ipsum has been the industry '
                'standard dummy text ever since the 1500s, when an unknown '
                'printer took a galley of type and scrambled it to make a '
                'type specimen book. It has survived not only five centuries,'
                ' but also the leap into electronic typesetting, remaining '
                'essentially unchanged. It was popularised in the 1960s with'
                ' the release of Letraset sheets containing Lorem Ipsum '
                'passages, and more recently with desktop publishing '
                'software like Aldus PageMaker including versions of Lorem '
                'Ipsum.'
                'Lorem Ipsum is simply dummy text of the printing and '
                'typesetting industry. Lorem Ipsum has been the industry '
                'standard dummy text ever since the 1500s, when an unknown '
                'printer took a galley of type and scrambled it to make a '
                'type specimen book. It has survived not only five centuries,'
                ' but also the leap into electronic typesetting, remaining '
                'essentially unchanged. It was popularised in the 1960s with'
                ' the release of Letraset sheets containing Lorem Ipsum '
                'passages, and more recently with desktop publishing '
                'software like Aldus PageMaker including versions of Lorem '
                'Ipsum.'),
          ),

          Divider(),

          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  'Product name',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(widget.product_detail_name),
              )
            ],
          ),

          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  'Product brand',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text('brand X'),
              )
            ],
          ),

          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  'Product condition',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text('New'),
              )
            ],
          ),
          Divider(),

//      =====SIMILIAR PRODUCT====
          Padding(
            padding: EdgeInsets.all(8.0),
              child: new Text('Similiar Product'),
          ),
            new Container(
              height: 300.0,
              child: similiar_Product(),
          ),
        ],
      ),
    );
  }
}

class similiar_Product extends StatefulWidget {
  @override
  _similiar_ProductState createState() => _similiar_ProductState();
}

class _similiar_ProductState extends State<similiar_Product> {
  var product_list = [
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
          return similiar_single_Product(
            product_name: product_list[index]['name'],
            product_pict: product_list[index]['picture'],
            product_old_price: product_list[index]['old_price'],
            product_price: product_list[index]['price'],
          );
        });
  }
}

class similiar_single_Product extends StatelessWidget {
  final product_name;
  final product_pict;
  final product_old_price;
  final product_price;

// Constructure Product
  similiar_single_Product({
    this.product_name,
    this.product_pict,
    this.product_old_price,
    this.product_price
  });

//  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_name,
        child: Material(
          child: InkWell(
//            ======Passing the values with constructure and Navigator.of(context).push=====
            onTap: ()=> Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context) => new ProductDetails(
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
                      new Text('${formatCurrency.format(product_price)}',
                      style: TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.bold))
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
}*/
  }
}
