import 'package:flutter/material.dart';
//package carousel a.k.a slider pict
import 'package:carousel_pro/carousel_pro.dart';
//package line icons for icons
import 'package:line_icons/line_icons.dart';

// my own package
import 'package:lets_shop/components/horizontal_listView.dart';
import 'package:lets_shop/components/products.dart';


class homeBody extends StatefulWidget {
  @override
  _homeBodyState createState() => _homeBodyState();
}

class _homeBodyState extends State<homeBody> {
  @override
  Widget build(BuildContext context) {
    //  ====Implementation of pub carousel a.k.a slider pict====
    Widget img_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/c1.jpg'),
          AssetImage('images/m1.jpeg'),
          AssetImage('images/w1.jpeg'),
          AssetImage('images/w3.jpeg'),
          AssetImage('images/w4.jpeg'),
        ],
        autoplay: false,
        /*animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),*/
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
    return Scaffold(
      body: new ListView(
        children: <Widget>[

//        ====this part to called img_carousel or slide pict=====
          img_carousel,

//        =====padding widget Categories====
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categories'),
          ),

//        ====Horizontal list view====
          horizontalList(),

//        ===padding textCategories===
          new Padding(padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 10.0, right: 20.0),
            child: new Text('Recent Product'),
          ),

//      GridView Product
          Container(
            // =====bug!!!====
            // ===280.0 for 5 inch display===
            // ===350.0 for 6 or more inch display===
            height: 350.0,
            child: Products(),
          ),
        ],
      ),
    );
  }
}
