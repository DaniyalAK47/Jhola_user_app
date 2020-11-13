import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:jhola/provider/admin.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/screens/category_checkout_screen.dart';
import 'package:jhola/widgets/cart_list_item.dart';
import 'package:provider/provider.dart';

import './../provider/cart.dart' show Cart;
import './../widgets/cart_list.dart';
import './../provider/order.dart';
import './../widgets/bezierContainer.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  // static final _form = GlobalKey<FormState>();

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int group = 1;
  static final _descriptionFocusNode = FocusNode();
  static GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _orderLoading = false;
  bool _initDataLoad = true;
  bool _delivery = true;

  // var deliveryCharges;
  // var tax;

  @override
  void didChangeDependencies() async {
    if (_initDataLoad) {
      setState(() {
        _orderLoading = true;
      });
      await Provider.of<Admin>(context, listen: false).fetchAdmin();
      // deliveryCharges =
      //     Provider.of<Admin>(context, listen: false).deliveryCharge;

      // tax = Provider.of<Admin>(context, listen: false).tax;

      setState(() {
        _orderLoading = false;
      });
      _initDataLoad = false;
    }
    super.didChangeDependencies();
  }

  int currentStep = 0;
  go(int step) {
    setState(() {
      currentStep = currentStep + step;
    });
  }

  // static final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    final cart = Provider.of<Cart>(context, listen: false);
    // final cartItems = cart.items;

    // static final _descriptionFocusNode = FocusNode();
    // static final _form = GlobalKey<FormState>();
    // static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    var _address;
    var _name;
    bool _isLoading = false;

    var userData = Provider.of<Auth>(context, listen: false);

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

    // bool _saveForm() {
    //   final isValid = _form.currentState.validate();
    //   if (!isValid) {
    //     return false;
    //   }
    //   _form.currentState.save();
    //   return true;
    // }

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

    // var deliveryCharges =
    //     Provider.of<Admin>(context, listen: false).deliveryCharge;

    // var tax = Provider.of<Admin>(context, listen: false).tax;
    // var total = (cart.totalAmount + double.parse(deliveryCharges)) *
    //     ((100 + double.parse(tax)) / 100);

    // List<String> items = ['shampoo', 'water', "sanitizer", "chips"];

    return Scaffold(
      body: _orderLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/cart_screen_short.png',
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 12, right: 10),
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                width: 3,
                                color: Colors.grey[400],
                              ),
                              vertical: BorderSide.none,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 35),
                                child: Text(
                                  "ITEM NAME",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              Text(
                                "QUANTITY",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                              Text(
                                "PRICE",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, right: 10),
                        child: Container(
                          // padding: EdgeInsets.only(left: 10, right: 10),
                          // height: 250,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.grey[400],
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) => CartListItem(
                                // cart,
                                cart.items.values.toList()[index].cartId,
                                cart.items.values.toList()[index].shopId,
                                cart.items.keys.toList()[index],
                                cart.items.values.toList()[index].title,
                                cart.items.values.toList()[index].price,
                                cart.items.values.toList()[index].quantity),
                            itemCount: cart.itemLength,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: _delivery ? Colors.blue : Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              setState(() {
                                _delivery = true;
                              });
                            },
                            child: Text(
                              "HOME \nDELIVERY",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: _delivery
                                ? Colors.grey[400]
                                : Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              setState(() {
                                _delivery = false;
                              });
                            },
                            child: Text(
                              "STORE \nPICKUP",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.lightGreen,
                        onPressed: Provider.of<Cart>(context).totalAmount <= 0
                            ? null
                            : () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return CategoryCheckoutScreen(
                                    delivery: _delivery,
                                  );
                                }));
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
                                "CHECKOUT",
                                style: TextStyle(
                                  fontSize: 40,
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
                      )
                    ],
                  ),
                  Positioned(top: 25, left: 10, child: _backButton()),
                ],
              ),
            ),
    );
  }
}

//class OrderButton extends StatefulWidget {
//  final Function saveForm;
//
//  const OrderButton({
//    Key key,
//    @required Function this.saveForm,
//    @required this.cart,
//  }) : super(key: key);
//
//  final Cart cart;
//
//  @override
//  _OrderButtonState createState() => _OrderButtonState();
//}
//
//class _OrderButtonState extends State<OrderButton> {
//  var _isLoading = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return FlatButton(
//        child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
//        onPressed: () {
//          widget.saveForm();
//        });
//  }
//}
