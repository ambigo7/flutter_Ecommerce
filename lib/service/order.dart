import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop/models/cart_item.dart';
import 'package:lets_shop/models/order.dart';
import 'package:lets_shop/tidak_terpakai/signup.dart';


class OrderServices{
  CollectionReference _orders = FirebaseFirestore.instance.collection('orders');
  String collection = 'orders';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void createOrder({String userId, String id,String description, String status, String message,
    String service,  List<CartItemModel> cart,int charges, int totalPrice, int totalPayment}) {
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
      "service": service,
      "charges": charges,
      "totalPrice": totalPrice,
      "totalPayment": totalPayment,
      "orderTime": DateTime.now().millisecondsSinceEpoch,
      "paymentTime": 0,
      "shipTime": 0,
      "completedTime": 0,
      "description": description,
      "status": status
    });
  }

  void updateOrder({String orderId, String status, String imgUrlPayment, String imgRef}){
    try {
      _firestore.collection(collection).doc(orderId).update({
        "paymentTime": DateTime.now().millisecondsSinceEpoch,
        "status": status,
        "imgUrlPayment": imgUrlPayment,
        "imgRef": imgRef
      });
    }catch(e){
      print('ERROR: ${e.toString()}');
    }
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
          /*.where('status', isEqualTo: '')*/
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