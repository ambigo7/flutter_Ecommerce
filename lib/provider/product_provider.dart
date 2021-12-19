import 'package:flutter/material.dart';
import 'package:lets_shop/service/product.dart';
import 'package:lets_shop/models/product.dart';

import 'package:intl/intl.dart';

class ProductProvider with ChangeNotifier{
  ProductService _productService = ProductService();
  List<ProductModel> productsBubbleSort = [];
  List<ProductModel> productsQuickSort = [];
  List<ProductModel> unSortedProducts = [];
  List<ProductModel> dumpProducts = [];
  List<ProductModel> featured = [];
  List<ProductModel> productsSearch = [];
  List<Map> convertedProduct = [];

  List<ProductModel> _priceBubbleSort = [];
  List<ProductModel> _priceQuickSort = [];

  DateFormat dateFormat = new DateFormat('MM/dd/yyyy hh:mm:ss');


  ProductProvider.initialize(){
    loadProducts();
    loadFeatured();
  }

  Future<List<ProductModel>> bubbleSort(List<ProductModel> arr) {
    int n = arr.length;

    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (arr[j].price < arr[j + 1].price) {
          print('swap arr[j] : ${arr[j].price}, arr[j+1] : ${arr[j+1].price}');
          var temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
      }
      print('');
      print('Sort $i: $arr');
    }
    for(int x =0; x < arr.length; x++){
      _priceBubbleSort.add(arr[x]);
    }
  }

  List<ProductModel> quickSort(List<ProductModel> arr, int low, int high){
    if (low < high) {
      int _pivotIndex = partition(arr, low, high);
      print("pivot: ${arr[_pivotIndex]} now at index $_pivotIndex");

      quickSort(arr, low, _pivotIndex - 1);
      quickSort(arr, _pivotIndex + 1, high);
    }
    _priceQuickSort = arr;
    return _priceQuickSort;
  }

  int partition(List<ProductModel> arr, low, high){
    // Base check
    if (arr.isEmpty){
      return 0;
    }
    // Take our last element as pivot and counter i one less than low
    int pivot = arr[high].price;
    int pIndex = low - 1;

    for (int i = low; i < high; i++) {
      // When i is < than pivot element we increment pIndex and swap arr[pIndex] and arr[j]
      if (arr[i].price < pivot) {
        pIndex++;
        swap(arr, pIndex, i);
      }
    }
    // Swap the last element(pivot) and place in front of the pIndex'th element
    swap(arr, pIndex + 1, high);
    return pIndex + 1;
  }

// Swapping using a temp variable
  void swap(List<ProductModel> list, int i, int j) {
    var temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  loadProducts() async{
    unSortedProducts = await _productService.getProducts();
    /*productsBubbleSort = await _productService.getProducts();
    productsQuickSort = unSortedProducts;
*/
/*    Stopwatch stopwatch = Stopwatch()..start();
    print('Time : ${dateFormat.format(DateTime.now())}');
    bubbleSort(products);
    print('Time : ${dateFormat.format(DateTime.now())}');
    stopwatch.stop();
    print('Time elapsed : ${stopwatch.elapsed}');
    print('priceBubbleSort index 0 ${priceBubbleSort[0].price}');*/
/*    Stopwatch stopwatch = Stopwatch()..start();
    quickSort(products, 0, products.length -1);
    stopwatch.stop();
    print('time elapsed ${stopwatch.elapsed}');
    print('priceQuickSort index 0 ${priceQuickSort[0].price}');*/
    notifyListeners();
  }

  Future loadProductBubble() async{
    productsBubbleSort = await _productService.getProducts();
    notifyListeners();
  }

  Future loadProductQuick() async{
    productsQuickSort = await _productService.getProducts();
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