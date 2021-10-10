import 'package:flutter/material.dart';
import 'package:lets_shop/service/product.dart';
import 'package:lets_shop/models/product.dart';

class ProductProvider with ChangeNotifier{
  ProductService _productService = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> featured = [];
  List<ProductModel> productsSearch = [];
  List<Map> convertedProduct = [];
  var arrPrice = [];
  List<ProductModel> priceBubbleSort = [];
  List<ProductModel> priceSelectionSort = [];

  ProductProvider.initialize(){
    loadProducts();
    loadFeatured();
  }

  void bubbleSort(List<ProductModel> arr) {
    var didSwap = false;
    print('Unsorted: $arr');
    for (var i = 0; i < arr.length - 1; i++) {
      didSwap = false;
      for (var j = 0; j < arr.length - 1; j++) {
        //TODO : Kalo mau jadi descending tinggal ganti operator dibawah ini jadi '<'
        if (arr[j].price > arr[j + 1].price) {
          didSwap = true;
          var temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
      }

      print('Sort $i: $arr');
      if (!didSwap) break;
    }
    for(int x =0; x < arr.length; x++){
      priceBubbleSort.add(arr[x]);
    }
  }

  void selectionSort(List<ProductModel> arr) {
    var i = 0, j = 1;
    print('Unsorted: $arr');
    // Traverse through all array elements
    for (i = 0; i < arr.length; i++) {
      // Find the minimum element in remaining unsorted array
      var min_index = i;
      for (j = i + 1; j < arr.length; j++) {
        //TODO : Kalo mau jadi descending tinggal ganti operator dibawah ini jadi '<'
        if (arr[min_index].price > arr[j].price) min_index = j; // Save minimum element's index
      }
      // Swap the found minimum element with the first element
      var temp = arr[min_index];
      arr[min_index] = arr[i];
      arr[i] = temp;
      print('Iter $i, arr: $arr');
    }
    print('Sorted: $arr');
    for(int x =0; x < arr.length; x++){
      priceSelectionSort.add(arr[x]);
    }
  }

  loadProducts() async{
    products = await _productService.getProducts();
/*    print("product provider list : $products");
    print("length product provider list : ${products.length}");
    int i;
    for(i=0; i<products.length;i++){
      arrPrice.add(products[i].price);
      *//*print("price index $i product provider list : ${products[i].price}");*//*
    }
    print('arrPrice $arrPrice');*/
    // bubbleSort(products);
    selectionSort(products);
    print('priceSelectionSort index 9 ${priceSelectionSort[9].price}');
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