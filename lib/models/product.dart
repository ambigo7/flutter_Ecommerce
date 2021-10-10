import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  static const ID = 'id';
  static const NAME = 'name';
  static const OLD_PRICE = 'oldPrice';
  static const PRICE = 'price';
  static const BRAND = 'brand';
  static const DESCRIPTION = "description";
  static const COLOR = 'color';
  static const FEATURED = 'featured';
  static const IMAGES = 'images';
  static const IMAGES_REF = 'imagesref';
  static const SALE = 'sale';

// Private Variabel
  String _id;
  String _brand;
  String _name;
  String _description;
  String _imageUrl;
  String _imageRef;
  String _color;
  int _oldPrice;
  int _price;
  bool _featured;
  bool _sale;

//Getter read only for private variabel
  String get id => _id;
  String get name => _name;
  String get brand => _brand;
  String get description => _description;
  String get imageUrl => _imageUrl;
  String get imageRef => _imageRef;
  int get oldPrice => _oldPrice;
  int get price => _price;
  String get color => _color;
  bool get featured => _featured;
  bool get sale => _sale;

//Contructure data from DB
  ProductModel.fromSnapshot(DocumentSnapshot snapshot){
    /*Map data = snapshot.data();*/
    _id = snapshot.data()[ID];
    _name = snapshot.data()[NAME];
    _brand = snapshot.data()[BRAND];
    _description = snapshot.data()[DESCRIPTION] ?? "";
    _imageUrl = snapshot.data()[IMAGES];
    _imageRef = snapshot.data()[IMAGES_REF];
    _oldPrice = snapshot.data()[OLD_PRICE].floor() ?? 0;
    _price = snapshot.data()[PRICE].floor();
    _color = snapshot.data()[COLOR];
    _featured = snapshot.data()[FEATURED];
    _sale = snapshot.data()[SALE];
  }

}