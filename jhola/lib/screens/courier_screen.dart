import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:jhola/provider/admin.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/courier.dart';
import 'package:jhola/provider/courier_location.dart';
import 'package:jhola/provider/rider.dart';
import 'package:jhola/screens/location_screen.dart';
import 'package:jhola/screens/rider_selection_screen.dart';
import 'package:jhola/widgets/bezierContainer.dart';
import 'package:provider/provider.dart';

class CourierScreen extends StatefulWidget {
  const CourierScreen({Key key}) : super(key: key);

  static const routeName = "/courier_screen";

  @override
  _CourierScreenState createState() => _CourierScreenState();
}

class _CourierScreenState extends State<CourierScreen> {
  List<RiderItem> rider;
  bool _loading = false;
  bool _initRiderLoading = true;
  bool _change = false;
  bool _submitting = false;
  String chargesSmall;
  String chargesMedium;
  String chargesLarge;

  @override
  void didChangeDependencies() async {
    if (_initRiderLoading) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      if (routeArgs["screen"] == "changeCourier") {
        _courierId = routeArgs["courierId"];

        _productSize = routeArgs['productSize'];
        _productWeight = routeArgs['productWeight'];
        _productDescription = routeArgs['productDescription'];

        _pickUpLat = routeArgs['pickUpLat'];
        _pickUpLng = routeArgs['pickUpLng'];
        _pickUpLocationDetail = routeArgs['pickUpDetail'];

        _deliveryContact = routeArgs["deliveryContact"];
        _deliveryLat = routeArgs['deliveryLat'];
        _deliveryLng = routeArgs['deliveryLng'];
        _deliveryLocationDetail = routeArgs['deliveryDetail'];
        _price = double.parse(
          routeArgs['price'],
        );
        _change = true;
      }

      setState(() {
        _loading = true;
      });
      await Provider.of<Admin>(context, listen: false).fetchAdmin();
      chargesSmall = Provider.of<Admin>(context, listen: false).chargesSmall;
      chargesMedium = Provider.of<Admin>(context, listen: false).chargesMedium;
      chargesLarge = Provider.of<Admin>(context, listen: false).chargesLarge;
      print(chargesSmall);
      print(chargesMedium);
      print(chargesLarge);

      setState(() {
        _loading = false;
      });

      _initRiderLoading = false;
    }

    super.didChangeDependencies();
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
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An Error has Occured!"),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('okay'),
          ),
        ],
      ),
    );
  }

  Future<bool> sendFcmMessage(String riderId, String courierId) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAR4QiP88:APA91bFgqwRkhNoUnzDmuuIzzUJ8ih4HaUaJTn1hD4eYf1DHBXQREa-IPT-2wOA_vCcEGeqcrLj4iR5P0mxgpHTAX_7mGWV7jdtCcjBM9-fJX6l1N3JYvaqAvS7V8Np2CtxY7g-UgVNr",
      };
      var request = {
        "notification": {
          "title": "New Courier",
          "text": "Pending Courier. Tap to see.",
          "sound": "default",
          "color": "#ffffff",
          // "click_button": "OPEN_ACTIVITY_1",
          "click_action": "OPEN_ACTIVITY_1",
        },
        "data": {"OrderId": courierId, "courier": true},
        "priority": "high",
        "to": "/topics/$riderId"
      };
      print(courierId);

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

  //Calculates distance in km
  double calculateDistance(pickUpLat, userLong, deliveryLat, deliveryLong) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((deliveryLat - pickUpLat) * p) / 2 +
        c(pickUpLat * p) *
            c(deliveryLat * p) *
            (1 - c((deliveryLong - userLong) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  static final _form = GlobalKey<FormState>();

  Future<Map<String, String>> _saveForm() async {
    String courierId;
    Map<String, String> result = {"bool": "true", "courierId": "$courierId"};
    _pickUpLat = Provider.of<CourierLocation>(context, listen: false).pickUpLat;
    _pickUpLng = Provider.of<CourierLocation>(context, listen: false).pickUpLng;
    _deliveryLat =
        Provider.of<CourierLocation>(context, listen: false).deliveryLat;
    _deliveryLng =
        Provider.of<CourierLocation>(context, listen: false).deliveryLng;
    _riderChosen = Provider.of<Rider>(context, listen: false).selectedRider;

    final isValid = _form.currentState.validate();
    if (!isValid) {
      result["bool"] = "false";
      return result;
    }

    if (_pickUpLat.isEmpty &&
        _pickUpLat.isEmpty &&
        _pickUpLat.isEmpty &&
        _pickUpLat.isEmpty &&
        _pickUpLat.isEmpty &&
        _productSize.isEmpty) {
      _showErrorDialog("Please fill all the fields");
      result["bool"] = "false";
      return result;
    }
    _form.currentState.save();

    var userData = Provider.of<Auth>(context, listen: false);
    var userContact = userData.phoneNo;

    double km = calculateDistance(
        double.parse(_pickUpLat),
        double.parse(_pickUpLng),
        double.parse(_deliveryLat),
        double.parse(_deliveryLng));
    String rate;

    print(_productSize);

    if (_productSize == "Small") {
      rate = chargesSmall;
    } else if (_productSize == "Medium") {
      rate = chargesMedium;
    } else if (_productSize == "Large") {
      rate = chargesLarge;
    }
    print(rate);

    _price = (km * double.parse(rate));
    // if (_price < 50) {
    //   _price = 50;
    // }

    try {
      courierId = await Provider.of<Courier>(context, listen: false).addCourier(
        userData.guserId,
        userContact.toString(),
        userData.userName.toString(),
        _productSize,
        double.parse(_productWeight),
        _productDescription,
        _pickUpLat,
        _pickUpLng,
        _pickUpLocationDetail,
        _deliveryContact,
        _deliveryLat,
        _deliveryLng,
        _deliveryLocationDetail,
        _riderChosen,
        _price.toString(),
      );
    } catch (error) {
      print(error);
      const errorMessage = 'Something went wrong please try again later.';
      _showErrorDialog(errorMessage);
      result["bool"] = "false";
      return result;
    }
    result["bool"] = "true";
    result["courierId"] = courierId.toString();
    return result;
  }

  Widget _submitButton() {
    return InkWell(
      onTap: _change
          ? () {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //   content:
              //       Text("Kindly wait as your order is being processed."),
              //   duration: Duration(
              //     seconds: 2,
              //   ),
              // ));

              // print("rider chosen $_riderChosen");
              final isValid = _form.currentState.validate();
              if (!isValid) {
                return false;
              }

              if (_pickUpLat.isEmpty &&
                  _pickUpLat.isEmpty &&
                  _pickUpLat.isEmpty &&
                  _pickUpLat.isEmpty &&
                  _pickUpLat.isEmpty &&
                  _productSize.isEmpty &&
                  _riderChosen.isEmpty) {
                _showErrorDialog("Please fill all the fields");
                return false;
              }
              _riderChosen =
                  Provider.of<Rider>(context, listen: false).selectedRider;
              _form.currentState.save();

              var userData = Provider.of<Auth>(context, listen: false);

              double km = calculateDistance(
                  double.parse(_pickUpLat),
                  double.parse(_pickUpLng),
                  double.parse(_deliveryLat),
                  double.parse(_deliveryLng));

              // double _price = 35 + (km * 4);
              // if (_price < 50) {
              //   _price = 50;
              // }
              String rate;
              if (_productSize == "Small") {
                rate = Provider.of<Admin>(context, listen: false).chargesSmall;
              } else if (_productSize == "Medium") {
                rate = Provider.of<Admin>(context, listen: false).chargesMedium;
              } else if (_productSize == "Large") {
                rate = Provider.of<Admin>(context, listen: false).chargesLarge;
              }

              _price = (km * double.parse(rate));

              try {
                Provider.of<Courier>(context, listen: false).updateRider(
                  userData.guserId,
                  userData.phoneNo.toString(),
                  userData.userName.toString(),
                  _courierId,
                  _productSize,
                  double.parse(_productWeight),
                  _productDescription,
                  _pickUpLat,
                  _pickUpLng,
                  _pickUpLocationDetail,
                  _deliveryContact,
                  _deliveryLat,
                  _deliveryLng,
                  _deliveryLocationDetail,
                  _riderChosen,
                  _price.toString(),
                );
              } catch (error) {
                print(error);
                const errorMessage =
                    'Something went wrong please try again later.';
                _showErrorDialog(errorMessage);
                return false;
              }
              // sendFcmMessage(_riderChosen, _courierId);

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Image.asset(
                          'assets/images/success_order.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Your courier request was successful and we will soon let you know if the rider accepted your request or not.",
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
                            "You can track the courier in the 'Courier' section.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              color: Colors.deepOrange,
                              onPressed: () {
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
            }
          : () async {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //   content:
              //       Text("Kindly wait as your order is being processed."),
              //   duration: Duration(
              //     seconds: 2,
              //   ),
              // ));

              var result = await _saveForm();
              if (result["bool"] == "false") {
                return;
              }

              // sendFcmMessage(_riderChosen, result["courierId"]);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Image.asset(
                          'assets/images/success_order.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Your courier request was successful and we will soon let you know if the rider accepted your request or not.",
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
                            "You can track the courier in the 'Courier' section.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              color: Colors.deepOrange,
                              onPressed: () {
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          _change ? "Update" : 'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _selectRider() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RiderSelectScreen.routeName);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blue[200], Colors.blue[300]])),
        child: Text(
          'Select Rider',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Future<Position> _getCureentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    print(position);
    return position;
  }

  Widget _selectLocation(String kinOfMoney) {
    print("Helooo from the button");

    return InkWell(
      onTap: () async {
        String screen;
        if (kinOfMoney == "Pick Up Location") {
          print("helo from if");
          screen = "pickup";
        } else {
          screen = "delivery";
        }
        Position position = await _getCureentLocation();
        print(position);
        Navigator.of(context).pushNamed(LocationScreen.routeName, arguments: {
          'lat': position.latitude.toString(),
          'long': position.longitude.toString(),
          'screen': screen,
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blue[200], Colors.blue[300]])),
        child: Text(
          kinOfMoney,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  String _courierId;

  String _productSize;
  String _productWeight;
  String _productDescription;

  String _pickUpLat;
  String _pickUpLng;
  String _pickUpLocationDetail;

  String _deliveryContact;
  String _deliveryLat;
  String _deliveryLng;
  String _deliveryLocationDetail;

  String _riderChosen;

  double _price;

  Widget _entryField(
      String productSize, String productWeight, String productDescription) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              productSize,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Please provide your product size.";
                }
                return null;
              },
              items: <String>["Small", "Medium", "Large"]
                  .map<DropdownMenuItem<dynamic>>((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (newValueSelected) {
                setState(() {
                  _productSize = newValueSelected;
                });
              },
              // onSaved: (value) {
              //   _productSize = value;
              // },
            ),
            Text(
              '$productWeight(kg)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: _productWeight,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please provide your product weight.";
                }
                return null;
              },
              onSaved: (value) {
                _productWeight = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
            Text(
              productDescription,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: _productDescription,
              keyboardType: TextInputType.text,
              maxLines: 4,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please provide your product description.";
                }
                return null;
              },
              onSaved: (value) => _productDescription = value,
              obscureText: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
            SizedBox(
              height: 20,
            ),
            _selectLocation("Pick Up Location"),
            SizedBox(
              height: 10,
            ),
            Text(
              "Pick Up Location Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: _pickUpLocationDetail,
              keyboardType: TextInputType.text,
              maxLines: 2,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please provide your pick up location dtails.";
                }
                return null;
              },
              onSaved: (value) => _pickUpLocationDetail = value,
              obscureText: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
            Text(
              'Delivery Contact',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: _deliveryContact,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please provide your delivery contact.";
                }
                return null;
              },
              onSaved: (value) {
                _deliveryContact = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
            SizedBox(
              height: 20,
            ),
            _selectLocation("Delivery Location"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Delivery Location Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: _deliveryLocationDetail,
              keyboardType: TextInputType.text,
              maxLines: 2,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please provide your delivery location detail.";
                }
                return null;
              },
              onSaved: (value) => _deliveryLocationDetail = value,
              obscureText: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
            SizedBox(
              height: 10,
            ),
            _selectRider(),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Product Size", "Product Weight", "Product Description"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    rider = Provider.of<Rider>(context, listen: false).getRider;
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: height,
                child: Stack(
                  children: [
                    Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer(),
                    ),
                    // Positioned(top: 40, left: 0, child: _backButton()),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: height * .2),
                            // _title(),
                            SizedBox(
                              height: 50,
                            ),
                            _emailPasswordWidget(),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ),
            ),
    );
  }
}
