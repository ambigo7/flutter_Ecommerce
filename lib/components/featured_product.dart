import 'package:flutter/material.dart';
import 'package:lets_shop/provider/product_provider.dart';
import 'package:provider/provider.dart';

import 'featured_card.dart';

class FeaturedProducts extends StatefulWidget {
  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductProvider>(context);

    return Container(
        height: 230,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.featured.length,
            itemBuilder: (_, index) {
              return FeaturedCard(product: productProvider.featured[index],);
            }));
  }
}