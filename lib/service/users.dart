import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop/pages/controller.dart';

class UserServices{
/*  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String coll = "users";*/
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    try {
      await users.doc(uid).set(data);
      print("User Was Created");
    }catch(e){
      print('ERROR: ${e.toString()}');
    }
  }
}