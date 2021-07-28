import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/models/adjust_lens.dart';
import 'package:lets_shop/models/cart_item.dart';
import 'package:lets_shop/models/lens.dart';
import 'package:lets_shop/models/order.dart';
import 'package:lets_shop/models/product.dart';
import 'package:lets_shop/models/user.dart';
import 'package:lets_shop/service/auth.dart';
import 'package:lets_shop/service/order.dart';
import 'package:lets_shop/service/users.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();

  Auth authService = Auth();

  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;

  UserModel _userModel;
  OrderModel _orderModel;
  Widget _msg;

//GETTER read data
  UserModel get userModel => _userModel;
  OrderModel get orderModel => _orderModel;
  Status get status => _status;
  User get user => _user;
  Widget get msg => _msg;

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    User userSignIn;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential _userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      userSignIn = _userCred.user;
      print('userprovider user : $userSignIn');
      if(!userSignIn.emailVerified){
        _msg = Text('Sign In Failed\n Please, check your email to active your account',
          style: TextStyle(color: blue),);
        signOut();
      }else{
        _msg = Text('Sign In Success',
          style: TextStyle(color: blue),);
      }
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password, int phone,String address) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      bool _checkEmail = await authService.checkEmail(email);
      print('check email : $_checkEmail');
      if(_checkEmail != false) {
         await _auth.createUserWithEmailAndPassword(
            email: email, password: password)
            .then((user) async {
          print("Ready to send email");
          await user.user.sendEmailVerification();
          print("email already sended");
          print("Ready to Creating User..");
          _userServices.createUser(
              {
                "name": name,
                "email": email,
                "uid" : user.user.uid,
                "phone": phone,
                "address": address
              });
          print("user has been created from signUp method");
        });
        return true;
      }else{
        return false;
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print("An error occured while trying to send email verification");
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
    print('user onstateChanged : $user');
    bool verifyEmail = user?.emailVerified ?? false;
    if (user == null || verifyEmail != true) {
      print('user null onstate : '+ user.toString());
        _msg = Text('Sign In Failed\n Email/Password incorrect',
          style: TextStyle(color: blue),);
      _status = Status.Unauthenticated;
    }else {
      _user = user;
      String testUser = user.uid;
      bool validateUser = await authService.userExist(user.uid);
      print('validateUser : $validateUser');
      if(validateUser != false) {
        print('User does not exist');
        print("Ready to Creating User..");
        _userServices.createUser(
            {
              "name": user.displayName,
              "photo": user.photoURL,
              "email": user.email,
              "uid": user.uid,
              "phone": user.phoneNumber, //update belom commit
              "address": "" //update belom commit
            });
        print('User was Created');
      }
      print('cek login user uid blm getuser: $testUser');
      _userModel = await _userServices.getUserById(user.uid);
      print('cek login user uid sudah getuser: $testUser');
      //just For Debugging
      print("My Cart ${user.email}: ${userModel.cart.length}");
      print("My address ${user.email}: ${userModel.address}");
      print("My phone ${user.email}: ${userModel.phone}");

      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> updatePhoneAddress(userId, phone, address) async{
    try{
      _userServices.updatePhoneAddress(userId,
          {
            "address": address,
            "phone": int.parse(phone),
          });
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> addToCart({ProductModel product, LensModel lens, List adjustLens, int totalPrice}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      print('list<AdjustLens> adjust : $adjustLens');


      CartItemModel item;
      if(lens != null){
        if(adjustLens.isNotEmpty){
          List<AdjustLens> _adjustLens = [];
          for(Map _dataAdjust in adjustLens){
            _adjustLens.add(AdjustLens.fromMap(_dataAdjust));
          }
          print('converted adjust from map : $_adjustLens');
          Map cartItem = {
            "id": cartItemId,
            "nameProduct": product.name,
            "imageProduct": product.imageUrl,
            "productId": product.id,
            "priceProduct": product.price,
            "nameLens": lens.name,
            "imageLens": lens.imageUrl,
            "lensId": lens.id,
            "priceLens": lens.price,
            "totalPriceCart": totalPrice,
            "adjustLens":
            'R => sph : ${_adjustLens[0].sph ?? ' '},'
                ' cyl : ${_adjustLens[0].cyl ?? ' '},'
                ' axis : ${_adjustLens[0].axis ?? ' '},'
                ' add : ${_adjustLens[0].add ?? ' '},'
                '\nL => sph : ${_adjustLens[1].sph ?? ' '},'
                ' cyl :  ${_adjustLens[1].cyl ?? ' '},'
                ' axis : ${_adjustLens[1].axis ?? ' '},'
                ' add : ${_adjustLens[1].add ?? ' '},'
                '\npd : ${_adjustLens[0].pd ?? ' '}'
          };
          item = CartItemModel.fromMap(cartItem);
        }else{
          Map cartItem = {
            "id": cartItemId,
            "nameProduct": product.name,
            "imageProduct": product.imageUrl,
            "productId": product.id,
            "priceProduct": product.price,
            "nameLens": lens.name,
            "imageLens": lens.imageUrl,
            "lensId": lens.id,
            "priceLens": lens.price,
            "totalPriceCart": totalPrice,
            "adjustLens": ''
          };
          item = CartItemModel.fromMap(cartItem);
        }
        _userServices.addToCart(userId: _user.uid, cartItem: item);
      }else{
        Map cartItem = {
          "id": cartItemId,
          "nameProduct": product.name,
          "imageProduct": product.imageUrl,
          "productId": product.id,
          "priceProduct": product.price,
          "totalPriceCart": totalPrice,
        };
        item = CartItemModel.fromMap(cartItem);

        _userServices.addToCart(userId: _user.uid, cartItem: item);
      }
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem})async{
    try{
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  Future<bool> createOrder(userId, id, description, status, message, service,
      charges, cart, totalCartPrice, totalProductPrice, totalLensPrice,totalPayment) async{
    try{
       _orderServices.createOrder(
        userId: userId,
         id: id,
         description: description,
         status: status,
         message: message ?? "",
         service: service,
         charges: charges,
         cart: cart,
         totalProductPrice: totalProductPrice,
         totalLensPrice: totalLensPrice,
         totalCartPrice: totalCartPrice,
         totalPayment: totalPayment
      );
       print('Message for admin: ${message}');
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateOrder(File image, orderId, status,)async{
    String imgUrl;
    try{
          final firebase_storage.FirebaseStorage storage =
              firebase_storage.FirebaseStorage.instance;

          final String pictureRef =
              '${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg';
          firebase_storage.UploadTask uploadTask =
          storage.ref().child(pictureRef).putFile(image);

          firebase_storage.TaskSnapshot snapshot =
          await uploadTask.then((snapshot) => snapshot);

          uploadTask.then((snapshot) async {
            imgUrl = await snapshot.ref.getDownloadURL();

            _orderServices.updateOrder(
              orderId: orderId,
              status: status,
              imgUrlPayment: imgUrl,
              imgRef: pictureRef
            );
          });

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
    //Ini buat jaga2 kalo dibutuhin
    /*_orderModel = await _orderServices.getOrderByUserId(userId: _user.uid);
    print("My Cart Order ${user.email}: ${orderModel.cartMap.length}");*/
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
