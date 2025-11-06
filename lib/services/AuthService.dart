import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mcommerce/components/Snackbar.dart';
import 'package:mcommerce/main.dart';
import 'package:mcommerce/pages/LoginPage.dart';
import 'package:mcommerce/pages/MainLayout.dart';
import 'package:mcommerce/services/ApiService.dart';
import 'package:mcommerce/services/SecureStoreService.dart';

void login(Object data) async {
  Apiservice.postRequest("/auth/login", data,
      Options(headers: {Headers.contentTypeHeader: "application/json"}),
      (response) {
    if (response.statusCode == 200) {
      String accessToken = response.data["access_token"];
      String refreshToken = response.data["refresh_token"];

      Securestoreservice.setItem("accessToken", accessToken);
      Securestoreservice.setItem("refreshToken", refreshToken);

      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const Mainlayout()));
    }
  });
}

void register(Object? data) async {
  Apiservice.postRequest("/auth/register", data,
      Options(headers: {Headers.contentTypeHeader: "application/json"}),
      (response) {
    if (response.statusCode == 201) {
      showSnackBar("Register Coplete, Check Email To Verify", navigatorKey.currentContext!);

      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  });
}

void logout(){
  Securestoreservice.deleteItem("accessToken");
  Securestoreservice.deleteItem("refreshToken");
  navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_)=> const LoginPage()));
}
