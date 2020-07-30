import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String orderId;
  final String shopId;
  final String userName;
  final String address;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String status;

  OrderItem({
    @required this.orderId,
    @required this.shopId,
    @required this.userName,
    @required this.address,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.status,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<String> addOrder(
    String shopId,
    String shopName,
    String shopAddress,
    String shopContact,
    String username,
    String address,
    double amount,
    String phoneNo,
    String userId,
    List<CartItem> product,
  ) async {
    final url = 'https://jhola-e90ff.firebaseio.com/orders.json?';

    var response = await http.post(url,
        body: json.encode({
          "address": address,
          "date": DateTime.now().toIso8601String(),
          "assignTo": "null",
          "userId": userId,
          "userName": username,
          "orderId": "none",
          "RiderPhone": "null",
          "phone": phoneNo,
          "registeredId": shopId,
          "status": "pending",
          "totalAmount": amount,
          "restaurantName": shopName,
          "restaurantContact": shopContact,
          "restaurantAddress": shopAddress,
          "products": product
              .map((e) => {
                    "productId": e.productId,
                    "title": e.title,
                    "quantity": e.quantity,
                    "price": e.price,
                    "shopId": e.shopId,
                    "cartId": e.cartId,
                    "description": e.description
                  })
              .toList(),
        }));
    var orderId = json.decode(response.body)['name'];
    // print(orderId);

    final orderUrlCount = 'https://jhola-e90ff.firebaseio.com/orders.json';
    var responseCount = await http.get(orderUrlCount);
    var orderdata = json.decode(responseCount.body) as Map<String, dynamic>;
    int orderIdCount = 1;
    orderdata.forEach((key, value) {
      orderIdCount += 1;
    });

    final updateUrl = 'https://jhola-e90ff.firebaseio.com/orders/$orderId.json';

    await http.patch(updateUrl,
        body: json.encode({"orderId": "a$orderIdCount"}));

    _orders.insert(
        0,
        OrderItem(
          orderId: orderId,
          shopId: shopId,
          userName: username,
          address: address,
          amount: amount,
          products: product,
          dateTime: DateTime.now(),
          status: "pending",
        ));

    return orderId;
  }

  Future<void> fetchAndSetOrders(String userId) async {
    final url =
        'https://jhola-e90ff.firebaseio.com/orders.json?orderBy="userId"&equalTo="$userId"';
    var response = await http.get(url);
    // print(response.body);
    final List<OrderItem> loadedOrders = [];
    var extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrders == null) {
      return;
    }

    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            orderId: orderData["orderId"].toString(),
            shopId: orderData["shopId"],
            userName: orderData["userName"],
            address: orderData["address"],
            amount: orderData["totalAmount"],
            products: (orderData["products"] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    description: e['description'],
                    cartId: e["cartId"],
                    shopId: e["shopId"],
                    productId: e["productId"],
                    title: e["title"],
                    quantity: e["quantity"],
                    price: e["price"],
                  ),
                )
                .toList(),
            dateTime: DateTime.now(),
            status: orderData["status"]),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<String> getAssignTo(String orderId) async {
    // print(orderId);
    var assignTo;
    // int orderIdInt = int.parse(orderId);
    final url =
        'https://jhola-e90ff.firebaseio.com/orders.json?orderBy="orderId"&equalTo="$orderId"';

    var response = await http.get(url);
    // print(json.decode(response.body));
    var extractedRiders = json.decode(response.body) as Map<String, dynamic>;
    extractedRiders.forEach((orderDataId, orderData) {
      assignTo = orderData["assignTo"];
      // print(assignTo);
    });

    return assignTo;
  }
}
