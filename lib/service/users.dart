import 'package:cloud_firestore/cloud_firestore.dart';


class UserServices{
/*  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String coll = "users";*/
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void createUser(Map<String, dynamic> data) async {
    try {
      await users.doc(data['userId']).set(data);
      print("User Was Created");
    }catch(e){
      print('ERROR: ${e.toString()}');
    }
  }
}