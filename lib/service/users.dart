import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String coll = "users";

  createUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(coll).doc(uid).set(data);
      print("User Was Created");
    }catch(e){
      print('ERROR: ${e.toString()}');
    }
  }
}