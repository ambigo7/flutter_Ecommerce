import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/models/product.dart';
import 'package:lets_shop/screens/product_details.dart';
import 'package:transparent_image/transparent_image.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

class FeaturedCard extends StatelessWidget {
  final ProductModel product;

  const FeaturedCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  ====CREATE MONEY CURRENCY FORMATTER====
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: (){
          changeScreen(context, ProductDetails(product: product,));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                Color.fromARGB(62, 168, 174, 201),
                offset: Offset(0, 9),
                blurRadius: 14,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Loading(),
                    )),
//              IMPLEMENTATION LOADING IMAGE TRANSPARENT WHEN PRODUCT IMAGE LOAD FROM DB
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: product.imageUrl,
                    fit: BoxFit.cover,
                    height: 220,
                    width: 200,
                  ),
                ),
/*                Image.network(
                  product.imageUrl,
                  height: 220,
                  width: 200,
                  fit: BoxFit.cover,
                ),*/

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 100,
                      width: 200,
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
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),

                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container()
                      )),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: RichText(text: TextSpan(children: [
                        TextSpan(text: '${product.name.length > 15
                            ? product.name.replaceRange(16, product.name.length, '...')
                            : product.name} \n', style: TextStyle(fontSize: 18)),
                        TextSpan(
                          text:  product.sale ? '${formatCurrency.format(product.oldPrice)} \n' : '',
                          style: TextStyle(fontSize: 18, color: redAccent, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${formatCurrency.format(product.price)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                      ]))
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}