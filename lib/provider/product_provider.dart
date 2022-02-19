import 'package:flutter/material.dart';
import 'package:lets_shop/service/product.dart';
import 'package:lets_shop/models/product.dart';

import 'package:intl/intl.dart';

class ProductProvider with ChangeNotifier{
  ProductService _productService = ProductService();

  List<ProductModel> productsBubbleSort = [];
  List<ProductModel> productsQuickSort = [];

  List<ProductModel> productsCatPlus = [];
  List<ProductModel> productsCatMin = [];
  List<ProductModel> productsCatProgressive = [];
  List<ProductModel> unSortedProducts = [];
  List<ProductModel> dumpProducts = [];
  List<ProductModel> featured = [];
  List<ProductModel> productsSearch = [];
  List<Map> convertedProduct = [];

  List<ProductModel> priceBubbleSort = [];
  List<ProductModel> priceQuickSort = [];

  DateFormat dateFormat = new DateFormat('MM/dd/yyyy hh:mm:ss');


  ProductProvider.initialize(){
    loadProducts();
    loadFeatured();
  }

  List<ProductModel> bubbleSort(bool desc,List<ProductModel> arr) {
/*    List<int> priceBubbleSort = [];
    for(int y=0; y < arr.length; y++){
      priceBubbleSort.add(arr[y].price);
    }
    print('Unsorted Price : $priceBubbleSort');*/
    int n = arr.length;
    int i;
    int  j;
    if(desc == true){
      for (i = 0; i < n - 1; i++) {
        for (j = 0; j < n - i - 1; j++) {
          if (arr[j].price < arr[j + 1].price) {
            //print('Sort $i : swap price[$j] ${arr[j].price}, price[${j+1}] ${arr[j+1].price}');
            var temp = arr[j];
            arr[j] = arr[j + 1];
            arr[j + 1] = temp;
          }
        }
      }
    }else{
      for (i = 0; i < n - 1; i++) {
        for (j = 0; j < n - i - 1; j++) {
          if (arr[j].price > arr[j + 1].price) {
            //print('Sort $i : swap price[$j] ${arr[j].price}, price[${j+1}] ${arr[j+1].price}');
            var temp = arr[j];
            arr[j] = arr[j + 1];
            arr[j + 1] = temp;
          }
        }
      }
    }
    /*print('Sorted Price');
    for(int x =0; x < n; x++){
      print('${x+1}. ${arr[x].price}');
    }*/
    priceBubbleSort = arr;
    return priceBubbleSort;
  }

  List<ProductModel> quickSortAsc(List<ProductModel> arr, int low, int high){
    if (low < high) {
      int _pivotIndex = partitionAsc(arr, low, high);
      //print("pivot: ${arr[_pivotIndex].price} now at index $_pivotIndex");

      quickSortAsc(arr, low, _pivotIndex - 1);
      quickSortAsc(arr, _pivotIndex + 1, high);
    }
    priceQuickSort = arr;
    notifyListeners();
    return priceQuickSort;
  }

  int partitionAsc(List<ProductModel> arr, low, high){
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

  List<ProductModel> quickSortDesc(List<ProductModel> arr, int low, int high){
    if (low < high) {
      int _pivotIndex = partitionDesc(arr, low, high);
      //print("pivot: ${arr[_pivotIndex].price} now at index $_pivotIndex");

      quickSortDesc(arr, low, _pivotIndex - 1);
      quickSortDesc(arr, _pivotIndex + 1, high);
    }
    priceQuickSort = arr;
    notifyListeners();
    return priceQuickSort;
  }

  int partitionDesc(List<ProductModel> arr, low, high){
    // Base check
    if (arr.isEmpty){
      return 0;
    }
    // Take our last element as pivot and counter i one less than low
    int pivot = arr[high].price;
    int pIndex = low - 1;

    for (int i = low; i < high; i++) {
      // When i is < than pivot element we increment pIndex and swap arr[pIndex] and arr[j]
      if (arr[i].price > pivot) {
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
    print('Unsorted Category : ');
    //unSortedProducts.removeWhere((item) => item.category == 'Casual');
    for(int x =0; x < unSortedProducts.length; x++){
      print('${x+1}. ${unSortedProducts[x].category}');
    }
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

  Future loadProductPlus()async {
    productsCatPlus = await _productService.getProducts();
    /*dynamic res = productsCatPlus.remove(productsCatPlus[i]);
    print('The value of the element $res');*/
    productsCatPlus.removeWhere((item) => item.category == 'Minus');
    productsCatPlus.removeWhere((item) => item.category == 'Progressive');
    productsCatPlus.removeWhere((item) => item.category == 'Casual');
    for(int x =0; x < productsCatPlus.length; x++){
      print('${x+1}. ${productsCatPlus[x].category}');
    }
    notifyListeners();
}

  Future loadProductMin()async {
    productsCatMin = await _productService.getProducts();
    productsCatMin.removeWhere((item) => item.category == 'Plus');
    productsCatMin.removeWhere((item) => item.category == 'Progressive');
    productsCatMin.removeWhere((item) => item.category == 'Casual');
    for(int x =0; x < productsCatMin.length; x++){
      print('${x+1}. ${productsCatMin[x].category}');
    }
    notifyListeners();
  }

  Future loadProductProgressive()async {
    productsCatProgressive = await _productService.getProducts();
    //productsCatPlus.removeRange(0, 1);
    productsCatProgressive.removeWhere((item) => item.category == 'Plus');
    productsCatProgressive.removeWhere((item) => item.category == 'Minus');
    productsCatProgressive.removeWhere((item) => item.category == 'Casual');
    for(int x =0; x < productsCatProgressive.length; x++){
      print('${x+1}. ${productsCatProgressive[x].category}');
    }
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

  void clearProductBubbleSort(){
    productsBubbleSort.clear();
    notifyListeners();
  }

  void clearProductQuickSort(){
    productsQuickSort.clear();
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