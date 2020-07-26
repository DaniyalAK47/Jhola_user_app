import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jhola/provider/admin.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/names.dart';
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

  var deliveryCharges;
  var tax;

  @override
  void didChangeDependencies() async {
    if (_initDataLoad) {
      setState(() {
        _orderLoading = true;
      });
      await Provider.of<Admin>(context, listen: false).fetchAdmin();
      deliveryCharges =
          Provider.of<Admin>(context, listen: false).deliveryCharge;

      tax = Provider.of<Admin>(context, listen: false).tax;

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

    bool _saveForm() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return false;
      }
      _form.currentState.save();
      return true;
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

    // var deliveryCharges =
    //     Provider.of<Admin>(context, listen: false).deliveryCharge;

    // var tax = Provider.of<Admin>(context, listen: false).tax;
    // var total = (cart.totalAmount + double.parse(deliveryCharges)) *
    //     ((100 + double.parse(tax)) / 100);

    return Scaffold(
      body: _orderLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Stack(
                      children: [
                        Positioned(top: 40, left: 0, child: _backButton()),
                        Positioned(
                          top: -MediaQuery.of(context).size.height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: BezierContainer(),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Card(
                        margin: EdgeInsets.all(15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        Spacer(),
                                        Chip(
                                          label: Text(
                                            '${cart.totalAmount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              // fontSize: 10,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Delivery Charges",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        Spacer(),
                                        Chip(
                                          label: Text(
                                            deliveryCharges.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              // fontSize: 10,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Tax",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        Spacer(),
                                        Chip(
                                          label: Text(
                                            tax.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              // fontSize: 10,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text(
                                          "Grand Total",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Chip(
                                          label: Text(
                                            ((cart.totalAmount +
                                                        double.parse(
                                                            deliveryCharges)) *
                                                    ((100 + double.parse(tax)) /
                                                        100))
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                              color: Colors.black,
                                              // fontSize: 10,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              FlatButton(
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : Text("ORDER NOW"),
                                onPressed: cart.totalAmount <= 0
                                    ? null
                                    : () async {
                                        bool saving = _saveForm();

                                        if (!saving) {
                                          return;
                                        }

                                        var _userId = userData.guserId;
                                        var _phoneNo = userData.phoneNo;
                                        var _shopId = cart.items.values
                                            .toList()[0]
                                            .shopId;

                                        print(_shopId);
                                        Map<String, String> shopInfo =
                                            Provider.of<Names>(context,
                                                    listen: false)
                                                .getShopInfo(_shopId);
                                        var shopName = shopInfo["name"];
                                        var shopAddress = shopInfo["address"];
                                        var shopContact = shopInfo["contact"];

                                        String orderId =
                                            await Provider.of<Order>(context,
                                                    listen: false)
                                                .addOrder(
                                          cart.items.values.toList()[0].shopId,
                                          shopName,
                                          shopAddress,
                                          shopContact,
                                          _name,
                                          _address,
                                          (cart.totalAmount +
                                                  double.parse(
                                                      deliveryCharges)) *
                                              ((100 + double.parse(tax)) / 100),
                                          _phoneNo,
                                          _userId,
                                          cart.items.values.toList(),
                                        );
                                        sendFcmMessage(
                                            _shopId, orderId, _userId);

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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                      "You can track the delivery in the 'Orders' section.",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      child: FlatButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                        ),
                                                        color:
                                                            Colors.deepOrange,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
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
                                textColor: Colors.purple,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) => CartList(
                              cart.items.values.toList()[index].cartId,
                              cart.items.values.toList()[index].shopId,
                              cart.items.keys.toList()[index],
                              cart.items.values.toList()[index].title,
                              cart.items.values.toList()[index].price,
                              cart.items.values.toList()[index].quantity),
                          itemCount: cart.itemLength,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: _form,
                          child: Column(
                            children: [
                              TextFormField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                onSaved: (value) => _name = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please provide your name";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: "Delivery Address",
                                ),
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                focusNode: _descriptionFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please provide a delivery address!";
                                  }
                                  return null;
                                },
                                onSaved: (value) => _address = value,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                    child: Text(
                                  "Payment Method",
                                  textAlign: TextAlign.left,
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: group,
                                          onChanged: (T) {
                                            print(T);
                                            setState(() {
                                              group = T;
                                            });
                                          },
                                        ),
                                        Text("Cash on delivery"),
                                      ],
                                    ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Radio(
                                    //       value: 2,
                                    //       groupValue: group,
                                    //       onChanged: (T) {
                                    //         print(T);
                                    //         setState(() {
                                    //           group = T;
                                    //         });
                                    //       },
                                    //     ),
                                    //     Text("Online Payment:"),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Stepper(
                      //   currentStep: currentStep,
                      //   onStepContinue: () {
                      //     if (currentStep != 1) {
                      //       go(1);
                      //     }
                      //   },
                      //   onStepCancel: () {
                      //     if (currentStep != 0) {
                      //       go(-1);
                      //     }
                      //   },
                      //   controlsBuilder: (BuildContext ctx,
                      //       {VoidCallback onStepContinue,
                      //       VoidCallback onStepCancel}) {
                      //     return Row(
                      //       children: [
                      //         FlatButton(
                      //           onPressed: onStepContinue,
                      //           child: Text('Next'),
                      //         ),
                      //         FlatButton(
                      //           onPressed: onStepCancel,
                      //           child: Text("Cancel"),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      //   steps: [
                      //     Step(
                      //       isActive: currentStep == 0 ? true : false,
                      //       title: Text("Confirm Order"),
                      //       content: Container(
                      //         height: 250,
                      //         child: ListView.builder(
                      //           shrinkWrap: true,
                      //           itemBuilder: (ctx, index) => CartList(
                      //               cart.items.values.toList()[index].cartId,
                      //               cart.items.values.toList()[index].shopId,
                      //               cart.items.keys.toList()[index],
                      //               cart.items.values.toList()[index].title,
                      //               cart.items.values.toList()[index].price,
                      //               cart.items.values.toList()[index].quantity),
                      //           itemCount: cart.itemLength,
                      //         ),
                      //       ),
                      //     ),
                      //     Step(
                      //       isActive: currentStep == 1 ? true : false,
                      //       title: Text('Delivery Details'),
                      //       content: Padding(
                      //         padding: EdgeInsets.all(16),
                      //         child: Form(
                      //           key: _form,
                      //           child: Column(
                      //             children: [
                      //               TextFormField(
                      //                 autofocus: false,
                      //                 decoration: InputDecoration(
                      //                   labelText: "Name",
                      //                 ),
                      //                 textInputAction: TextInputAction.next,
                      //                 onFieldSubmitted: (_) {
                      //                   FocusScope.of(context).requestFocus(
                      //                       _descriptionFocusNode);
                      //                 },
                      //                 onSaved: (value) => _name = value,
                      //                 validator: (value) {
                      //                   if (value.isEmpty) {
                      //                     return "Please provide your name";
                      //                   }
                      //                   return null;
                      //                 },
                      //               ),
                      //               TextFormField(
                      //                 autofocus: false,
                      //                 decoration: InputDecoration(
                      //                   labelText: "Delivery Address",
                      //                 ),
                      //                 maxLines: 3,
                      //                 keyboardType: TextInputType.multiline,
                      //                 focusNode: _descriptionFocusNode,
                      //                 validator: (value) {
                      //                   if (value.isEmpty) {
                      //                     return "Please provide a delivery address!";
                      //                   }
                      //                   return null;
                      //                 },
                      //                 onSaved: (value) => _address = value,
                      //               ),
                      //               Padding(
                      //                 padding: EdgeInsets.all(10),
                      //                 child: SizedBox(
                      //                     child: Text(
                      //                   "Payment Method",
                      //                   textAlign: TextAlign.left,
                      //                 )),
                      //               ),
                      //               Padding(
                      //                 padding: EdgeInsets.all(10),
                      //                 child: Column(
                      //                   children: [
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Radio(
                      //                           value: 1,
                      //                           groupValue: group,
                      //                           onChanged: (T) {
                      //                             print(T);
                      //                             setState(() {
                      //                               group = T;
                      //                             });
                      //                           },
                      //                         ),
                      //                         Text("Cash on delivery"),
                      //                       ],
                      //                     ),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Radio(
                      //                           value: 2,
                      //                           groupValue: group,
                      //                           onChanged: (T) {
                      //                             print(T);
                      //                             setState(() {
                      //                               group = T;
                      //                             });
                      //                           },
                      //                         ),
                      //                         Text("Online Payment:"),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
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
