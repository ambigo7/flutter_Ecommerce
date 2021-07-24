import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop/models/lens.dart';

class LensService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'lens';

  // Get data lens
  Future<List<LensModel>> getLens() async =>
      _firestore
          .collection(ref)
          .get()
          .then((result) {
        List<LensModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(LensModel.fromSnapshot(product));
        }
        return products;
      });


}