import 'package:flutter/material.dart';
import 'package:jhola/provider/courier.dart';
import 'package:jhola/screens/courier_screen.dart';
import 'package:jhola/screens/tracking_courier_screem.dart';
import 'package:jhola/screens/tracking_order_screen.dart';
// import 'package:provider/provider.dart';
import './../provider/cart.dart';
// import './../provider/names.dart';
import 'dart:convert';

class CourierList extends StatelessWidget {
  final CourierItem courierInfo;
  final String courierId;
  final String pickUpDetail;
  final String deliveryDetail;
  final String productSize;
  final String productDescription;

  CourierList({
    @required this.courierInfo,
    @required this.courierId,
    @required this.pickUpDetail,
    @required this.deliveryDetail,
    @required this.productSize,
    @required this.productDescription,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(60),
        bottomRight: Radius.circular(60),
        topLeft: Radius.circular(20),
      ),
      child: Card(
        color: Colors.orangeAccent,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Product Size:',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          productSize,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Product Description',
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          productDescription,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Courier Id:',
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          courierId,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Status:',
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          courierInfo.status,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Text(
                    "Total Price:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 20, 20),
                  child: Text(
                    double.parse(courierInfo.price).toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: courierInfo.status != "rejected" &&
                      courierInfo.status != "pending"
                  ? null
                  : () {
                      Navigator.of(context).pushNamed(
                        CourierScreen.routeName,
                        arguments: {
                          "screen": "changeCourier",
                          "userId": courierInfo.userId,
                          "productSize": courierInfo.productSize,
                          "productWeight": courierInfo.productWeight.toString(),
                          "productDescription": courierInfo.productDescription,
                          "pickUpLat": courierInfo.pickUpLat,
                          "pickUpLng": courierInfo.pickUpLng,
                          "pickUpDetail": courierInfo.pickUpDetail,
                          "deliveryContact": courierInfo.deliveryContact,
                          "deliveryLat": courierInfo.deliveryLat,
                          "deliveryLng": courierInfo.deliveryLng,
                          "deliveryDetail": courierInfo.deliveryDetail,
                          "riderId": courierInfo.riderId,
                          "courierId": courierInfo.courierId,
                          "price": courierInfo.price
                        },
                      );
                    },
              textColor: Colors.white,
              color: Color(0xFF1976D2),
              child: Text('Change Rider', style: TextStyle(fontSize: 15)),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(TrackingCourierScreen.routeName,
                    arguments: {"courierId": courierId});
              },
              textColor: Colors.white,
              color: Color(0xFF1976D2),
              child: Text('Track Order', style: TextStyle(fontSize: 15)),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "**Refresh rider location by tapping anywhere on the map!",
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
