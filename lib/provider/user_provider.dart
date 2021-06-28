import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_shop/models/cart_item.dart';
import 'package:lets_shop/models/order.dart';
import 'package:lets_shop/models/product.dart';
import 'package:lets_shop/models/user.dart';
import 'package:lets_shop/service/order.dart';
import 'package:lets_shop/service/users.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();

  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;

  UserModel _userModel;
  OrderModel _orderModel;

//GETTER read data
  UserModel get userModel => _userModel;
  OrderModel get orderModel => _orderModel;
  Status get status => _status;
  User get user => _user;


  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged,);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(_status);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async{
            print("Ready to Creating User..");
            _userServices.createUser(
              {
                "name": name,
                "email": email,
                "uid" : user.user.uid,
              }
            );
            print("User Was Created");
      });
      print(_status);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }
  
  Future signOut() async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      //just For Debugging
      print("My Cart ${user.email}: ${userModel.cart.length}");
      print("My Cart ${user.email}: ${userModel.cart.length}");
      print("My Cart ${user.email}: ${userModel.cart.length}");
      print("My Cart ${user.email}: ${userModel.cart.length}");
      print("My Cart ${user.email}: ${userModel.cart.length}");

/*      print("My Orders ${user.email} : ${orderModel.cart.length}");
      print("My Orders ${user.email} : ${orderModel.cart.length}");
      print("My Orders ${user.email} : ${orderModel.cart.length}");
      print("My Orders ${user.email} : ${orderModel.cart.length}");
      print("My Orders ${user.email} : ${orderModel.cart.length}");*/

      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future countCart(String currentUser) async{
    _userModel = await _userServices.getUserById(currentUser);
    print("My Cart Stream ${user.email}: ${userModel.cart.length}");
    notifyListeners();
  }

  Future<bool> addToCart({ProductModel product, String size, String color}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.imageUrl,
        "productId": product.id,
        "price": product.price,
        "size": size,
        "color": color
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      //just For Debugging
      print("CART ITEMS ARE: ${cart.toString()}");

      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }
  // public variables
  List<OrderModel> orders = [];
  getOrders()async{
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

//RELOAD USER FROM DB, CAN USE FOR PRODUCT TOO I GUESS
  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(user.uid);
    int _countCart = _userModel.countCart;
    print('Update my Count Cart $_countCart');
    notifyListeners();
  }
}
