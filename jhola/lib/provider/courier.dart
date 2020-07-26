import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'http_exception.dart';

class CourierItem {
  final String userId;
  final String courierId;
  final String productSize;
  final double productWeight;
  final String productDescription;
  final String pickUpLat;
  final String pickUpLng;
  final String deliveryContact;
  final String pickUpDetail;
  final String deliveryLat;
  final String deliveryLng;
  final String deliveryDetail;
  final String riderId;
  final String status;
  final String price;

  CourierItem({
    @required this.userId,
    @required this.courierId,
    @required this.productSize,
    @required this.productWeight,
    @required this.productDescription,
    @required this.pickUpLat,
    @required this.pickUpLng,
    @required this.deliveryContact,
    @required this.pickUpDetail,
    @required this.deliveryLat,
    @required this.deliveryLng,
    @required this.deliveryDetail,
    @required this.riderId,
    this.status,
    @required this.price,
  });
}

class Courier with ChangeNotifier {
  List<CourierItem> _couriers = [];

  List<CourierItem> get getCourier {
    return [..._couriers];
  }

  Future<String> addCourier(
    String userId,
    String userContact,
    String userName,
    String productSize,
    double productWeight,
    String productDescription,
    String pickUpLat,
    String pickUpLng,
    String pickUpDetail,
    String deliveryContact,
    String deliveryLat,
    String deliveryLng,
    String deliveryDetail,
    String riderId,
    String price,
  ) async {
    final String url = "https://jhola-e90ff.firebaseio.com/courier.json";

    var response = await http.post(url,
        body: json.encode({
          "date": DateTime.now().toIso8601String(),
          "userId": userId,
          "userContact": userContact,
          "userName": userName,
          "productSize": productSize,
          "productWeight": productWeight,
          "productDescription": productDescription,
          "pickUpLat": pickUpLat,
          "pickUpLng": pickUpLng,
          "pickUpDetail": pickUpDetail,
          "deliveryContact": deliveryContact,
          "deliveryLat": deliveryLat,
          "deliveryLng": deliveryLng,
          "deliveryDetail": deliveryDetail,
          "riderId": riderId,
          "assignTo": "none",
          "status": "pending",
          "price": double.parse(price).toStringAsFixed(2),
        }));

    print(json.decode(response.body));
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      print("http exception caught");
      throw HttpException(responseData["error"]["message"]);
    }

    _couriers.add(CourierItem(
      userId: userId,
      courierId: json.decode(response.body)['name'],
      productSize: productSize,
      productWeight: productWeight,
      productDescription: productDescription,
      pickUpLat: pickUpLat,
      pickUpLng: pickUpLng,
      deliveryContact: deliveryContact,
      pickUpDetail: pickUpDetail,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      deliveryDetail: deliveryDetail,
      riderId: riderId,
      price: price,
    ));

    notifyListeners();
    return json.decode(response.body)['name'].toString();
  }

  Future<void> fetchAndSetCourier(String userId) async {
    final url =
        'https://jhola-e90ff.firebaseio.com/courier.json?orderBy="userId"&equalTo="$userId"';

    var response = await http.get(url);
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      print("http exception caught");
      throw HttpException(responseData["error"]["message"]);
    }
    print(response.body);
    final List<CourierItem> loadedCourier = [];
    var extractedCourier = json.decode(response.body) as Map<String, dynamic>;
    if (extractedCourier == null) {
      return;
    }

    extractedCourier.forEach((courierId, courierData) {
      loadedCourier.add(CourierItem(
        userId: courierData["userId"],
        courierId: courierId,
        productSize: courierData["productSize"],
        productWeight: courierData["productWeight"],
        productDescription: courierData["productDescription"],
        pickUpLat: courierData["pickUpLat"],
        pickUpLng: courierData["pickUpLng"],
        pickUpDetail: courierData["pickUpDetail"],
        deliveryContact: courierData["deliveryContact"],
        deliveryLat: courierData["deliveryLat"],
        deliveryLng: courierData["deliveryLng"],
        deliveryDetail: courierData["deliveryDetail"],
        riderId: courierData["riderId"],
        status: courierData["status"],
        price: courierData["price"],
      ));
    });

    _couriers = loadedCourier;
    notifyListeners();
  }

  Future<void> updateRider(
    String userId,
    String userContact,
    String userName,
    String courierId,
    String productSize,
    double productWeight,
    String productDescription,
    String pickUpLat,
    String pickUpLng,
    String pickUpDetail,
    String deliveryContact,
    String deliveryLat,
    String deliveryLng,
    String deliveryDetail,
    String riderId,
    String price,
  ) async {
    print(courierId);
    final String url =
        "https://jhola-e90ff.firebaseio.com/courier/$courierId.json";

    var response = await http.patch(url,
        body: json.encode({
          "userId": userId,
          "userContact": userContact,
          "userName": userName,
          "productSize": productSize,
          "productWeight": productWeight,
          "productDescription": productDescription,
          "pickUpLat": pickUpLat,
          "pickUpLng": pickUpLng,
          "pickUpDetail": pickUpDetail,
          "deliveryContact": deliveryContact,
          "deliveryLat": deliveryLat,
          "deliveryLng": deliveryLng,
          "deliveryDetail": deliveryDetail,
          "riderId": riderId,
          "assignTo": "none",
          "status": "pending",
          "price": double.parse(price).toStringAsFixed(2),
        }));
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      print("http exception caught");
      throw HttpException(responseData["error"]["message"]);
    }

    _couriers.removeWhere((element) => element.courierId == courierId);

    _couriers.add(CourierItem(
        userId: userId,
        courierId: courierId,
        productSize: productSize,
        productWeight: productWeight,
        productDescription: productDescription,
        pickUpLat: pickUpLat,
        pickUpLng: pickUpLng,
        deliveryContact: deliveryContact,
        pickUpDetail: pickUpDetail,
        deliveryLat: deliveryLat,
        deliveryLng: deliveryLng,
        deliveryDetail: deliveryDetail,
        riderId: riderId,
        status: "pending",
        price: price));
  }

  Future<String> getAssignTo(String courierId) async {
    print(courierId);
    var assignTo;
    // int courierIdInt = int.parse(courierId);
    final url = 'https://jhola-e90ff.firebaseio.com/courier/$courierId.json';

    var response = await http.get(url);
    print(json.decode(response.body));
    var extractedRiders = json.decode(response.body) as Map<String, dynamic>;
    // extractedRiders.forEach((orderDataId, orderData) {
    assignTo = extractedRiders["assignTo"].toString();
    print(assignTo);
    // });

    return assignTo;
  }
}
