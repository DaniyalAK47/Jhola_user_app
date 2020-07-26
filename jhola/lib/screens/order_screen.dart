import 'package:flutter/material.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/widgets/order_list.dart';
import 'package:provider/provider.dart';

import './../provider/order.dart';
import './../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // var _isLoading = false;
  String status = 'ava';
  String userId;
  bool _loading = false;

  @override
  void initState() {
    setState(() {
      _loading = true;
    });
    userId = Provider.of<Auth>(context, listen: false).userId;
    Provider.of<Order>(context, listen: false).fetchAndSetOrders(userId);
    setState(() {
      _loading = false;
    });
    // print('dadadadadadadadadad');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context);
    final orderData = order.orders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
        ),
        backgroundColor: Colors.deepOrange,
      ),
      drawer: AppDrawer(),
      body: _loading
          ? CircularProgressIndicator()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: orderData.length,
              itemBuilder: (ctx, index) {
                return OrderList(
                  userName: orderData[index].userName,
                  address: orderData[index].address,
                  orderId: orderData[index].orderId,
                  shopId: orderData[index].shopId,
                  products: orderData[index].products,
                  amount: orderData[index].amount,
                  status: orderData[index].status,
                );
              },
            ),
    );
  }
}
