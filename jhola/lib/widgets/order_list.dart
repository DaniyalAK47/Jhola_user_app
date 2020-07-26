import 'package:flutter/material.dart';
import 'package:jhola/screens/tracking_order_screen.dart';
// import 'package:provider/provider.dart';
import './../provider/cart.dart';
// import './../provider/names.dart';
import 'dart:convert';

class OrderList extends StatelessWidget {
  final String userName;
  final String address;
  final String shopId;
  final String orderId;
  final List<CartItem> products;
  final double amount;
  final String status;

  OrderList({
    @required this.userName,
    @required this.address,
    @required this.orderId,
    @required this.shopId,
    @required this.products,
    @required this.amount,
    this.status,
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
                      'username:',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          userName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        'address',
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          address,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Order Id:',
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          '$orderId',
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
                          '$status',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    products[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(products[index].price.toString()),
                  trailing: Text('x${products[index].quantity.toString()}'),
                );
              },
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
                    '\$${amount.toString()}',
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
              onPressed: () {
                Navigator.of(context).pushNamed(TrackingOrderScreen.routeName,
                    arguments: {"orderId": orderId});
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
