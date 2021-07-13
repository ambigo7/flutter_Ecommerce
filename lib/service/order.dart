import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop/models/cart_item.dart';
import 'package:lets_shop/models/order.dart';


class OrderServices{
  CollectionReference _orders = FirebaseFirestore.instance.collection('orders');
  String collection = 'orders';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void createOrder({String userId ,String id,String description, String status, String message, List<CartItemModel> cart, int totalPrice}) {
    List<Map> convertedCart = [];

    //Semua item yang ada di CartItemModel harus di convert dulu ke Map
    // terus masukin ke List<Map> convertedCart
    for(CartItemModel item in cart){
      convertedCart.add(item.toMap());
    }

    _firestore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "message": message,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status
    });
  }

  //Ini buat jaga2 kalo dibutuhin
/*  Future<OrderModel> getOrderByUserId({String userId}) async =>
      _firestore.collection(collection)
          .where('userId', isEqualTo: userId)
          .get().then((result) {
        DocumentSnapshot order;
        for (order in result.docs) {
          OrderModel.fromFirebase(order.data());
        }
        return OrderModel.fromFirebase(order.data());
      });*/


  Future<List<OrderModel>> getUserOrders({String userId}) async =>

      _firestore.collection(collection)
          .where('userId', isEqualTo: userId)
          .get().then((result) {
        List<OrderModel> orders = [];
        DocumentSnapshot order;
        for (order in result.docs) {
          /*print('result getOrders : ${order.data()}');*/
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

}