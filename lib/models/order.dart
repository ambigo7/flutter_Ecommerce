import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const MESSAGE = "message";
  static const SERVICE = "service";
  static const CHARGES = "charges";
  static const USER_ID = "userId";
  static const TOTAL_PRICE = "totalPrice";
  static const TOTAL_PAYMENT= "totalPayment";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  String _id;
  String _description;
  String _userId;
  String _status;
  String _message;
  String _service;
  int _createdAt;
  int _charges;
  int _totalPrice;
  int _totalPayment;

  //Ini buat jaga2 kalo dibutuhin
/*  String _idMap;
  String _descriptionMap;
  String _userIdMap;
  String _statusMap;
  String _messageMap;
  int _createdAtMap;
  int _totalMap;

  String get idMap => _idMap;
  String get descriptionMap => _descriptionMap;
  String get userIdMap => _userIdMap;
  String get statusMap => _statusMap;
  String get messageMap => _messageMap;
  int get totalMap => _totalMap;
  int get createdAtMap => _createdAtMap;

  List<CartItemModel> cartMap;*/

//  getters
  String get id => _id;
  String get description => _description;
  String get userId => _userId;
  String get status => _status;
  String get message => _message;
  String get service => _service;
  int get charges => _charges;
  int get totalPrice => _totalPrice;
  int get totalPayment => _totalPayment;
  int get createdAt => _createdAt;
  // public variable
  List<CartItemModel> cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _totalPrice = snapshot.data()[TOTAL_PRICE];
    _totalPayment = snapshot.data()[TOTAL_PAYMENT];
    _status = snapshot.data()[STATUS];
    _message = snapshot.data()[MESSAGE] ?? "";
    _service = snapshot.data()[SERVICE];
    _charges = snapshot.data()[CHARGES];
    _userId = snapshot.data()[USER_ID];
    _createdAt = snapshot.data()[CREATED_AT];
    cart = _convertCartItems(snapshot.data()[CART] ?? []);
  }

  //Ini buat jaga2 kalo dibutuhin
/*
  OrderModel.fromFirebase(Map data){
    _idMap = data[ID];
    _descriptionMap = data[DESCRIPTION];
    _totalMap = data[TOTAL];
    _statusMap = data[STATUS];
    _messageMap = data[MESSAGE] ?? "";
    _userIdMap = data[USER_ID];
    _createdAtMap = data[CREATED_AT];
    cartMap = _convertCartItems(data[CART] ?? []);
  }
*/

  //Firebase tdk mengerti tipe data List makanya harus diconvert ke Map
  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }
}