import 'package:flutter/material.dart';
import 'package:lets_shop/service/product.dart';
import 'package:lets_shop/models/product.dart';

import 'package:intl/intl.dart';

class ProductProvider with ChangeNotifier{
  ProductService _productService = ProductService();
  List<ProductModel> productsBubbleSort = [];
  List<ProductModel> productsQuickSort = [];
  List<ProductModel> unSortedProducts = [];
  List<ProductModel> featured = [];
  List<ProductModel> productsSearch = [];
  List<Map> convertedProduct = [];

  List<ProductModel> priceBubbleSort = [];
  List<ProductModel> priceSelectionSort = [];
  List<ProductModel> priceQuickSort = [];

  DateFormat dateFormat = new DateFormat('MM/dd/yyyy hh:mm:ss');

  ProductProvider.initialize(){
    loadProducts();
    loadFeatured();
  }

  Future<List<ProductModel>> bubbleSort(List<ProductModel> arr) {
    var didSwap = false;
    print('Unsorted: $arr');
    for (var i = 0; i < arr.length - 1; i++) {
      didSwap = false;
      for (var j = 0; j < arr.length - 1; j++) {
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

  List<ProductModel> quickSort(List<ProductModel> arr, int low, int high){
    if (low < high) {
      int pi = partition(arr, low, high);
      print("pivot: ${arr[pi].price} now at index $pi");

      quickSort(arr, low, pi - 1);
      quickSort(arr, pi + 1, high);
    }
    for(int x =0; x < arr.length; x++){
      priceQuickSort.add(arr[x]);
    }
    return priceQuickSort;
  }

  int partition(List<ProductModel> arr, low, high){
    // Base check
    if (arr.isEmpty){
      return 0;
    }
    // Take our last element as pivot and counter i one less than low
    int pivot = arr[high].price;

    int i = low - 1;
    for (int j = low; j < high; j++) {
      // When j is < than pivot element we increment i and swap arr[i] and arr[j]
      if (arr[j].price < pivot) {
        i++;
        swap(arr, i, j);
      }
    }
    // Swap the last element and place in front of the i'th element
    swap(arr, i + 1, high);
    return i + 1;
  }

// Swapping using a temp variable
  void swap(List<ProductModel> list, int i, int j) {
    var temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  loadProducts() async{
    unSortedProducts = await _productService.getProducts();
    productsBubbleSort = await _productService.getProducts();
    productsQuickSort = unSortedProducts;
/*    Stopwatch stopwatch = Stopwatch()..start();
    print('Time : ${dateFormat.format(DateTime.now())}');
    bubbleSort(products);
    print('Time : ${dateFormat.format(DateTime.now())}');
    stopwatch.stop();
    print('Time elapsed : ${stopwatch.elapsed}');
    print('priceBubbleSort index 0 ${priceBubbleSort[0].price}');*/
/*    Stopwatch stopwatch = Stopwatch()..start();
    quickSort(products, 0, products.length -1);
    //TODO:kasih waktu pas eksekusi supaya bisa dicek saat penggunaaa memmory usagenya
    stopwatch.stop();
    print('time elapsed ${stopwatch.elapsed}');
    print('priceQuickSort index 0 ${priceQuickSort[0].price}');*/
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