import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Admin with ChangeNotifier {
  String tax;
  String deliveryCharge;

  Future<void> fetchAdmin() async {
    final url = 'https://jhola-e90ff.firebaseio.com/Admin.json';
    var response = await http.get(url);
    print(response.body);
    Map<String, dynamic> responseData = json.decode(response.body);

    responseData.forEach((key, value) {
      tax = value["tax"].toString();
      deliveryCharge = value["delivery"].toString();
    });

    notifyListeners();
  }
}
