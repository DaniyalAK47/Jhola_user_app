import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiderItem {
  final String riderId;
  final String riderName;
  final String riderPhoneNo;
  final double riderLat;
  final double riderLng;

  RiderItem({
    @required this.riderId,
    @required this.riderName,
    @required this.riderPhoneNo,
    @required this.riderLat,
    @required this.riderLng,
  });
}

class Rider with ChangeNotifier {
  List<RiderItem> rider = [];

  var selectedRider;

  List<RiderItem> get getRider {
    return [...rider];
  }

  void selectingRider(String riderId) {
    selectedRider = riderId;
  }

  Future<void> fetchAndSetRider() async {
    final String url =
        "https://jhola-e90ff.firebaseio.com/RegisteredRiders.json";

    var response = await http.get(url);
    print(json.decode(response.body));
    final List<RiderItem> loadedRider = [];
    var extractedRider = json.decode(response.body) as Map<String, dynamic>;
    if (extractedRider == null) {
      return;
    }

    extractedRider.forEach((riderId, riderData) {
      if (riderData["approved"].toString() == "true" &&
          riderData["available"].toString() == "true" &&
          riderData["loggedIn"].toString() == "true") {
        // print(riderData["name"]);
        // print(riderData["phoneNo"]);
        // print(riderData["lat"]);
        // print(riderData["lng"]);

        loadedRider.add(RiderItem(
          riderId: riderId.toString(),
          riderName: riderData["name"].toString(),
          riderPhoneNo: riderData["phoneNo"].toString(),
          riderLat: double.parse(riderData["lat"].toString()),
          riderLng: double.parse(riderData["lng"].toString()),
        ));
      }
    });
    rider = loadedRider;

    // rider.forEach((element) {
    //   print(element.riderId);
    //   print(element.riderLat);
    //   print(element.riderLng);
    //   print(element.riderName);
    //   print(element.riderPhoneNo);
    // });
  }
}
