import 'package:flutter/material.dart';
import 'package:lets_shop/pages/controller.dart';

//MY OWN PACKAGES
import 'package:lets_shop/pages/home.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

class productDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_price;
  final product_detail_old_price;
  final product_detail_picture;

//Constructor product details
  productDetails(
      {this.product_detail_name,
      this.product_detail_price,
      this.product_detail_old_price,
      this.product_detail_picture});

  @override
  _productDetailsState createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {

  //  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: InkWell(
            onTap: () {
//          ===Passing page no values with Navigator.push====
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new controller_Page()));
            },
            child: Text('Lets Shop', style: TextStyle(color: Colors.deepOrangeAccent[700]))),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search_outlined,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              onPressed: () {})
        ],
      ),

//        =======SECOND BUTTON BELOW=======
      bottomNavigationBar: new Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          children: <Widget>[
//          =======Size Button======
            Expanded(
              child: MaterialButton(
                  onPressed: () {},
                  color: Colors.deepOrangeAccent[700],
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: new Text('Buy now')),
            ),

            new IconButton(
                icon: Icon(Icons.add_shopping_cart_outlined, color: Colors.deepOrangeAccent[700]),
                onPressed: () {}),
            new IconButton(
                icon: Icon(
                  Icons.favorite_outline,
                  color: Colors.deepOrangeAccent[700],
                ),
                onPressed: () {})
          ],
        ),
      ),

      body: new ListView(
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
}

