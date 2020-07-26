import 'package:flutter/material.dart';

class CourierLocation with ChangeNotifier {
  String pickUpLat;
  String pickUpLng;
  String deliveryLat;
  String deliveryLng;

  void setPickUp(String pickuplat, String pickuplng) {
    pickUpLat = pickuplat;
    pickUpLng = pickuplng;
  }

  void setDelivery(String deliverylat, String deliverylng) {
    deliveryLat = deliverylat;
    deliveryLng = deliverylng;
  }
}
