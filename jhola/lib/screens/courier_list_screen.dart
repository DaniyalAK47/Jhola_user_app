import 'package:flutter/material.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/courier.dart';
import 'package:jhola/screens/courier_screen.dart';
import 'package:jhola/widgets/app_drawer.dart';
import 'package:jhola/widgets/courier_list.dart';
import 'package:provider/provider.dart';

class CourierListScreen extends StatefulWidget {
  const CourierListScreen({Key key}) : super(key: key);
  static const routeName = '/courier_list_screen';

  @override
  _CourierListScreenState createState() => _CourierListScreenState();
}

class _CourierListScreenState extends State<CourierListScreen> {
  List<CourierItem> courier;
  bool loading = false;
  bool initLoading = true;
  String userId;
  @override
  void didChangeDependencies() async {
    if (initLoading) {
      setState(() {
        loading = true;
      });
      userId = Provider.of<Auth>(context, listen: false).guserId;
      await Provider.of<Courier>(context, listen: false)
          .fetchAndSetCourier(userId);
      courier = Provider.of<Courier>(context, listen: false).getCourier;
      setState(() {
        loading = false;
      });
      initLoading = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print(courier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                CourierScreen.routeName,
                arguments: {
                  "screen": "newCourier",
                },
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: courier.length,
              itemBuilder: (ctx, index) {
                return CourierList(
                  courierInfo: courier[index],
                  courierId: courier[index].courierId,
                  pickUpDetail: courier[index].pickUpDetail,
                  deliveryDetail: courier[index].deliveryDetail,
                  productSize: courier[index].productSize,
                  productDescription: courier[index].productDescription,
                );
              },
            ),
    );
  }
}
