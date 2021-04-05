import 'package:flutter/material.dart';

class horizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[

/*          Category(
            img_loc: 'images/cats/accessories.png',
            img_caption: 'Accessories',
          ),*/

          Category(
            img_loc: 'images/cats/tshirt.png',
            img_caption: 'Shirt',
          ),

          Category(
            img_loc: 'images/cats/dress.png',
            img_caption: 'Dress',
          ),

          Category(
            img_loc: 'images/cats/formal.png',
            img_caption: 'Formal',
          ),
          Category(
            img_loc: 'images/cats/informal.png',
            img_caption: 'Jacket',
          ),

          Category(
            img_loc: 'images/cats/jeans.png',
            img_caption: 'Pants',
          ),

          Category(
            img_loc: 'images/cats/shoe.png',
            img_caption: 'Shoes',
          ),

        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String img_loc;
  final String img_caption;

// CONSTRUCTOR CATEGORY
  Category({
    this.img_loc,
    this.img_caption
});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: (){},

//      =====USE WRAP CONTAINER IF U FOUND A PROBLEM WITH INFINITE WIDTH=====
        child: Container(
          width: 100.0,
          child: ListTile(
            title: Image.asset(
              img_loc,
              width: 100.0,
              height: 70.0),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(img_caption),
            ),
          ),
        ),
      ),
    );
  }
}
