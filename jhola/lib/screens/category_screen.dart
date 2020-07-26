import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:provider/provider.dart';
import './category_name_screen.dart';
import 'courier_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category_screen';
  static const restaurant = 'Restaurants';
  static const shop = 'Shops';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _width = 170.0;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void didChangeDependencies() async {
    String userLat = await Provider.of<Auth>(context, listen: false).userLat;
    String userLong = await Provider.of<Auth>(context, listen: false).userLong;
    // print(userLat);
    // print(userLong);
    Provider.of<CurrentLocation>(context, listen: false)
        .updateLatLong(double.parse(userLat), double.parse(userLong));
    var userId = Provider.of<Auth>(context, listen: false).guserId;
    print(userId);
    _messaging.subscribeToTopic(userId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: Container(
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xfffbb448), Color(0xffe46b10)])),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/company_logo.png',
                  height: height * 0.2,
                  width: height * 0.5,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushReplacementNamed(
                            CategoryNameScreen.routeName,
                            arguments: {'category': CategoryScreen.restaurant},
                          ),
                          splashColor: Colors.deepOrange,
                          child: Container(
                            width: _width,
                            height: height * 0.37,
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.asset(
                                      'assets/images/restaurant_category.jpg',
                                      height: height * 0.17,
                                      width: _width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      width: _width,
                                      height: 120,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: _width,
                                            child: Text(
                                              'restaurants',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                            width: _width,
                                          ),
                                          SizedBox(
                                            width: _width,
                                            child: Text(
                                              'Burgers, pizza, desi and more',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                            width: _width,
                                          ),
                                          SizedBox(
                                            width: _width,
                                            child: Text(
                                              'Order food',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.deepOrange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushReplacementNamed(
                            CategoryNameScreen.routeName,
                            arguments: {'category': CategoryScreen.shop},
                          ),
                          child: Container(
                            width: _width,
                            height: 315,
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.asset(
                                      'assets/images/shop_category.jpg',
                                      height: 150,
                                      width: _width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      width: _width,
                                      height: 120,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: _width,
                                            child: Text(
                                              'shops',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                            width: _width,
                                          ),
                                          SizedBox(
                                            width: _width,
                                            child: Text(
                                              'Groceries, medicines and more',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                            width: _width,
                                          ),
                                          SizedBox(
                                            width: _width,
                                            child: Text(
                                              'Shop now',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.deepOrange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushReplacementNamed(
                        CourierListScreen.routeName,
                      ),
                      child: Container(
                        width: _width,
                        height: 315,
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Image.asset(
                                  'assets/images/courier_image.jpg',
                                  height: 150,
                                  width: _width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: _width,
                                  height: 120,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: _width,
                                        child: Text(
                                          'courier',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                        width: _width,
                                      ),
                                      SizedBox(
                                        width: _width,
                                        child: Text(
                                          'Anything to anywhere...',
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                        width: _width,
                                      ),
                                      SizedBox(
                                        width: _width,
                                        child: Text(
                                          'Courier now',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.deepOrange),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
