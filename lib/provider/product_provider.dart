import 'package:flutter/material.dart';
import 'package:lets_shop/service/product.dart';
import 'package:lets_shop/models/product.dart';

class ProductProvider with ChangeNotifier{
  ProductService _productService = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> featured = [];
  List<ProductModel> productsSearch = [];

  ProductProvider.initialize(){
    loadProducts();
    loadFeatured();
  }

  loadProducts() async{
    products = await _productService.getProducts();
    notifyListeners();
  }

  loadFeatured() async{
    featured = await _productService.getFeatured();
    notifyListeners();
  }

  Future search({String productName}) async{
    productsSearch = await _productService.searchProducts(productName: productName);
    notifyListeners();
  }
}