import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:jhola/provider/admin.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/cart.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/provider/order.dart';
import 'package:provider/provider.dart';

import 'location_screen.dart';

class CategoryCheckoutScreen extends StatefulWidget {
  static const routeName = '/category_checkout_screen';
  final bool delivery;

  CategoryCheckoutScreen({
    this.delivery,
  });

  @override
  _CategoryCheckoutScreenState createState() => _CategoryCheckoutScreenState();
}

class _CategoryCheckoutScreenState extends State<CategoryCheckoutScreen> {
  String currentLocation;
  bool _loading = false;
  double lat;
  double lng;
  @override
  void didChangeDependencies() async {
    setState(() {
      _loading = true;
    });
    lat = Provider.of<CurrentLocation>(context, listen: false).latitude;
    lng = Provider.of<CurrentLocation>(context, listen: false).logitude;
    final coordinates = new Coordinates(lat, lng);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    currentLocation = first.addressLine;
    setState(() {
      _loading = false;
    });
    // print(first.featureName);
    // print(first.addressLine);
    // print(first.countryName);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    double itemCost = Provider.of<Cart>(context, listen: false).totalAmount;
    double bookingCharges = 20.0;
    double deliveryCharges =
        double.parse(Provider.of<Admin>(context, listen: false).deliveryCharge);
    double serviceTax = 0.0;
    double total = itemCost + bookingCharges + deliveryCharges + serviceTax;

    Future<Position> _getCureentLocation() async {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position);
      return position;
    }

    Future<bool> sendFcmMessage(
        String shopId, String orderId, String userId) async {
      try {
        var url = 'https://fcm.googleapis.com/fcm/send';
        var header = {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAR4QiP88:APA91bFgqwRkhNoUnzDmuuIzzUJ8ih4HaUaJTn1hD4eYf1DHBXQREa-IPT-2wOA_vCcEGeqcrLj4iR5P0mxgpHTAX_7mGWV7jdtCcjBM9-fJX6l1N3JYvaqAvS7V8Np2CtxY7g-UgVNr",
        };
        var request = {
          "notification": {
            "title": "New Order",
            "text": "Pending Order. Tap to see.",
            "sound": "default",
            "color": "#ffffff",
            "click_button": "OPEN_ACTIVITY_1",
          },
          "data": {"orderId": orderId, "userId": userId},
          "priority": "high",
          "to": "/topics/$shopId"
        };
        // print(shopId);

        var client = new Client();
        var response =
            await client.post(url, headers: header, body: json.encode(request));
        print(response.body);
        return true;
      } catch (e) {
        print(e);

        return false;
      }
    }

    Widget _backButton() {
      return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Text('Back',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white))
            ],
          ),
        ),
      );
    }

    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/checkout_screen_short.png',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 12, right: 9),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.grey[400],
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30))),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 30, right: 30),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "ITEM'S COST -",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      itemCost.toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 15,
                                indent: 15,
                                thickness: 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 30, right: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "BOOKING CHARGES -",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      bookingCharges.toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 15,
                                indent: 15,
                                thickness: 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 30, right: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "DELIVERY CHARGES/KM -",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      deliveryCharges.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 15,
                                indent: 15,
                                thickness: 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 30, right: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "SERVICE TAX -",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      serviceTax.toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 15,
                                indent: 15,
                                thickness: 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 30, right: 30, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "TOTAL -",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      total.toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400],
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  bottom: 0,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Note",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Divider(
                                indent: 15,
                                endIndent: 245,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Text(
                                  "This delivery charges is subject to change according to your delivery location.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400],
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "ADDRESS",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      currentLocation,
                                      maxLines: 4,
                                      style: TextStyle(
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  LocationScreen.routeName,
                                  arguments: {
                                    'lat': lat.toString(),
                                    'long': lng.toString(),
                                    'screen': "edit",
                                  });
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400],
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 55,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Position position = await _getCureentLocation();
                              lat = position.latitude;
                              lng = position.longitude;
                              final coordinates = new Coordinates(lat, lng);
                              var address = await Geocoder.local
                                  .findAddressesFromCoordinates(coordinates);
                              var first = address.first;
                              setState(() {
                                currentLocation = first.addressLine;
                              });
                              Provider.of<CurrentLocation>(context)
                                  .updateLatLong(lat, lng);
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400],
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.my_location,
                                size: 55,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.lightGreen,
                          onPressed: cart.totalAmount <= 0
                              ? null
                              : () async {
                                  var shopId =
                                      cart.items.values.toList()[0].shopId;
                                  // print(_shopId);
                                  Map<String, String> shopInfo =
                                      Provider.of<Names>(context, listen: false)
                                          .getShopInfo(shopId);
                                  var shopName = shopInfo["name"];
                                  var shopAddress = shopInfo["address"];
                                  var shopContact = shopInfo["contact"];
                                  var user =
                                      Provider.of<Auth>(context, listen: false);
                                  var userName = user.userName;
                                  var phoneNo = user.phoneNo;
                                  var userId = user.guserId;

                                  String userLat = Provider.of<CurrentLocation>(
                                          context,
                                          listen: false)
                                      .latitude
                                      .toString();

                                  String userLong =
                                      Provider.of<CurrentLocation>(context,
                                              listen: false)
                                          .logitude
                                          .toString();

                                  String orderId = await Provider.of<Order>(
                                          context,
                                          listen: false)
                                      .addOrder(
                                    shopId,
                                    shopName,
                                    shopAddress,
                                    shopContact,
                                    userName,
                                    currentLocation,
                                    userLat,
                                    userLong,
                                    total,
                                    widget.delivery == true
                                        ? "home delivery"
                                        : "self delivery",
                                    phoneNo,
                                    userId,
                                    cart.items.values.toList(),
                                  );
                                  sendFcmMessage(shopId, orderId, userId);
                                  cart.clear();
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 20, 10, 10),
                                            child: Image.asset(
                                              'assets/images/success_order.png',
                                              width: 200,
                                              height: 200,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Your order was successful.",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                "You can track the delivery in the 'Orders' section.",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: FlatButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                  color: Colors.deepOrange,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Continue Shopping",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "PLACE ORDER",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(top: 25, left: 10, child: _backButton()),
                ],
              ),
            ),
          );
  }
}
