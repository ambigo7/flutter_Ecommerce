import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop/models/cart_item.dart';

class UserModel{
  static const ID = 'uid';
  static const NAME = 'name';
  static const EMAIL = 'email';
  static const ADDRESS = 'address';
  static const PHONE = 'phone';
  static const CART = 'cart';

// Private Variabel
  String _id;
  String _name;
  String _email;
  String _address;
  int _phone;
  int _priceSumCart = 0;
  int _priceSumProduct = 0;
  int _priceSumLens = 0;

  //Getter read only, private variabel
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get address => _address;
  int get phone => _phone;

//Public variabel
  List<CartItemModel> cart;
  int totalProductPrice;
  int totalLensPrice;
  int totalCartPrice;
  int countCart;

  //Contructure data from DB
  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    /*Map data = snapshot.data();*/
    _id = snapshot.data()[ID];
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _address = snapshot.data()[ADDRESS] ?? "";
    _phone = snapshot.data()[PHONE] ?? 0;
    countCart = snapshot.data()[CART] == null ? 0 : snapshot.data()[CART].length;
    cart = _convertCartItems(snapshot.data()[CART] ?? []);
    totalProductPrice = snapshot.data()[CART] == null ? 0 : getTotalProductPrice(cart: snapshot.data()[CART]);
    totalLensPrice = snapshot.data()[CART] == null ? 0 : getTotalLensPrice(cart: snapshot.data()[CART]);
    totalCartPrice = snapshot.data()[CART] == null ? 0 : getTotalCartPrice(cart: snapshot.data()[CART]);
  }

//Firebase tdk mengerti tipe data List makanya harus diconvert ke Map
  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  //Total Price for cart item
  int getTotalLensPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSumLens += cartItem["priceLens"];
    }

    int total = _priceSumLens;
    return total;
  }

  //Total Price for cart item
  int getTotalProductPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSumProduct += cartItem["priceProduct"];
    }

    int total = _priceSumProduct;
    return total;
  }

//Total Price for cart item
  int getTotalCartPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSumCart += cartItem["totalPriceCart"];
    }

    int total = _priceSumCart;
    return total;
  }
}