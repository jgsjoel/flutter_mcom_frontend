import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mcommerce/services/SecureStoreService.dart';

class FirebaseState extends ChangeNotifier{

  final storage = FirebaseStorage.instance;

  Future<void> uploadImage(File file)async{
    String? token = await Securestoreservice.getItem("accessToken");
    await storage.ref("customer/${JwtDecoder.decode(token!)["sub"]}").putFile(file);
  }

  


}