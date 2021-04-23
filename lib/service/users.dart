import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop/models/cart_item.dart';
import 'package:lets_shop/models/user.dart';


class UserServices{
  /*FirebaseFirestore _firestore = FirebaseFirestore.instance;*/
  /*String coll = "users";*/
  CollectionReference users = FirebaseFirestore.instance.collection('users');
//send data to database
  void createUser(Map<String, dynamic> data){
    try {
      users.doc(data['uid']).set(data);
    }catch(e){
      print('ERROR: ${e.toString()}');
    }
  }
  Future<UserModel> getUserById(String id) => users.doc(id).get().then((doc){
      return UserModel.fromSnapshot(doc);
  });
//Send data to database
  void addToCart({String userId, CartItemModel cartItem}){
    users.doc(userId).update({'cart': FieldValue.arrayUnion([cartItem.toMap()])
    });
  }
//remove data from database
  void removeFromCart({String userId, CartItemModel cartItem}){
    users.doc(userId).update({'cart': FieldValue.arrayRemove([cartItem.toMap()])
    });
  }
}