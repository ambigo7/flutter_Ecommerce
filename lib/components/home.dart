import 'package:flutter/material.dart';

//PACKAGE CAROUSEL A.K.A SLIDER PICT
import 'package:carousel_pro/carousel_pro.dart';

// MY OWN PACKAGE
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

//        ====THIS PART TO CALLED IMG_CAROUSEL OR SLIDE PICT=====
          img_carousel,

//        =====PADDING WIDGET CATEGORIES====
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categories'),
          ),

//        ====HORIZONTAL LIST VIEW====
          horizontalList(),

//        ===PADDING TEXT CATEGORIES===
          new Padding(padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 10.0, right: 20.0),
            child: new Text('Recent Product'),
          ),

//      ====GRIDVIEW PRODUCT====
          Container(
            height: 350.0,
            child: Products(),
          ),
        ],
      ),
    );
  }
}
