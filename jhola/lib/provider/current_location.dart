import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentLocation with ChangeNotifier {
  double _lat;
  double _long;

  void updateLocation(Map<String, double> selectedLocation) {
    _lat = selectedLocation['lat'];
    _long = selectedLocation['long'];
    // notifyListeners();
  }

  void updateLatLong(double lat, double long) {
    _lat = lat;
    _long = long;
    // notifyListeners();
  }

  get latitude {
    return _lat;
  }

  get logitude {
    return _long;
  }

  Future<Map<String, String>> getRiderLocation(String assignTo) async {
    var riderLat;
    var riderLong;
    final url =
        'https://jhola-e90ff.firebaseio.com/RegisteredRiders.json?orderBy="email"&equalTo="$assignTo"';
    var response = await http.get(url);
    var extractedRiders = json.decode(response.body) as Map<String, dynamic>;
    extractedRiders.forEach((riderId, riderData) {
      riderLat = riderData["lat"].toString();
      riderLong = riderData["lng"].toString();
    });
    return {"riderLat": riderLat, "riderLong": riderLong};
  }
}
