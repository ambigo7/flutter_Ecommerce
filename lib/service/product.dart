import 'package:lets_shop/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
/*  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'products';*/
  CollectionReference _products = FirebaseFirestore.instance.collection(
      'products');

  // Get data Products
  Future<List<ProductModel>> getProducts() async =>
      _products
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<ProductModel>> searchProducts({String productName}) {
// CONVERT THE FIRST CHARACTER TO UPPERCASE
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _products.orderBy('name')
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result){
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
    });
  }
}
