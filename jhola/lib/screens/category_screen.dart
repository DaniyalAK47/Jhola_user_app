import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/cart.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/widgets/app_drawer.dart';
import 'package:jhola/widgets/badge.dart';
import 'package:provider/provider.dart';
import './category_name_screen.dart';
import 'cart_screen.dart';
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
    _messaging.subscribeToTopic('offer');
    super.didChangeDependencies();
  }

  Widget leftSidedView(String name, String image, double fontSize, int color) {
    return Row(
      children: [
        Container(
          // width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                )
              ],
              color: Colors.yellow[color],
              // color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              )),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    name,
                    style: GoogleFonts.abrilFatface(
                        color: Colors.white, fontSize: fontSize),
                  )),
              // Image.asset('assets/images/restaurant_category.jpg')
              Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(image),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget leftSidedView2(String name, String image, double fontSize, int color) {
    return Row(
      children: [
        Container(
          // width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                )
              ],
              color: Colors.orange[color],
              // color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              )),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    name,
                    style: GoogleFonts.abrilFatface(
                        color: Colors.white, fontSize: fontSize),
                  )),
              // Image.asset('assets/images/restaurant_category.jpg')
              Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(image),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget rightSidedView(String name, String image, double fontSize, int color) {
    return Row(
      children: [
        Spacer(),
        Container(
          // width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                )
              ],
              color: Colors.yellow[color],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              )),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(image),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    name,
                    style: GoogleFonts.abrilFatface(
                        color: Colors.white, fontSize: fontSize),
                  )),
              // Image.asset('assets/images/restaurant_category.jpg')
            ],
          ),
        ),
      ],
    );
  }

  Widget rightSidedView2(
      String name, String image, double fontSize, int color) {
    return Row(
      children: [
        Spacer(),
        Container(
          // width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                )
              ],
              color: Colors.orange[color],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              )),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(image),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    name,
                    style: GoogleFonts.abrilFatface(
                        color: Colors.white, fontSize: fontSize),
                  )),
              // Image.asset('assets/images/restaurant_category.jpg')
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // drawer: AppDrawer(),
        appBar: AppBar(
          actions: [
            Consumer<Cart>(
              builder: (ctx, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCount.toString(),
                color: Colors.orange,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/images/logoFinal.png',
            height: 50,
            width: 50,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [Color(0xfffbb448), Color(0xffe46b10)])),
            child: Column(
              children: [
                // Image.asset(
                //   'assets/images/company_logo_editted.png',
                //   height: 150,
                //   width: 150,
                // ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/welcome.jpg',
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      CategoryNameScreen.routeName,
                      arguments: {'category': CategoryScreen.restaurant},
                    );
                  },
                  child: leftSidedView(
                    'FOOD & \nRESTAURANTS',
                    'assets/images/restaurantCategory.png',
                    20,
                    400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      CategoryNameScreen.routeName,
                      arguments: {'category': CategoryScreen.shop},
                    );
                  },
                  child: rightSidedView('LOCAL \nSTORES',
                      'assets/images/shopCategory.png', 28, 600),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      CourierListScreen.routeName,
                    );
                  },
                  child: leftSidedView2(
                      'COURIER', 'assets/images/courierCategory.jpg', 28, 300),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {},
                  child: rightSidedView2('REFER & \nEARN',
                      'assets/images/referAFriendCategory.png', 25, 600),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        // body: Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.all(Radius.circular(5)),
        //       boxShadow: <BoxShadow>[
        //         BoxShadow(
        //             color: Colors.grey.shade200,
        //             offset: Offset(2, 4),
        //             blurRadius: 5,
        //             spreadRadius: 2)
        //       ],
        //       gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //           colors: [Color(0xfffbb448), Color(0xffe46b10)])),
        //   height: double.infinity,
        //   width: double.infinity,
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         Image.asset(
        //           'assets/images/company_logo.png',
        //           height: height * 0.2,
        //           width: height * 0.5,
        //         ),
        //         Column(
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 InkWell(
        //                   onTap: () =>
        //                       Navigator.of(context).pushReplacementNamed(
        //                     CategoryNameScreen.routeName,
        //                     arguments: {'category': CategoryScreen.restaurant},
        //                   ),
        //                   splashColor: Colors.deepOrange,
        //                   child: Container(
        //                     width: _width,
        //                     height: 315,
        //                     child: Card(
        //                       elevation: 4,
        //                       margin: EdgeInsets.all(10),
        //                       child: Column(
        //                         children: [
        //                           ClipRRect(
        //                             borderRadius: BorderRadius.only(
        //                               topLeft: Radius.circular(15),
        //                               topRight: Radius.circular(15),
        //                             ),
        //                             child: Image.asset(
        //                               'assets/images/restaurant_category.jpg',
        //                               height: 150,
        //                               width: _width,
        //                               fit: BoxFit.cover,
        //                             ),
        //                           ),
        //                           Padding(
        //                             padding: EdgeInsets.all(10),
        //                             child: Container(
        //                               width: _width,
        //                               height: 120,
        //                               child: Column(
        //                                 children: [
        //                                   SizedBox(
        //                                     width: _width,
        //                                     child: Text(
        //                                       'restaurants',
        //                                       textAlign: TextAlign.left,
        //                                       style: TextStyle(
        //                                           color: Colors.deepOrange,
        //                                           fontSize: 20),
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     height: 10,
        //                                     width: _width,
        //                                   ),
        //                                   SizedBox(
        //                                     width: _width,
        //                                     child: Text(
        //                                       'Burgers, pizza, desi and more',
        //                                       textAlign: TextAlign.left,
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     height: 25,
        //                                     width: _width,
        //                                   ),
        //                                   SizedBox(
        //                                     width: _width,
        //                                     child: Text(
        //                                       'Order food',
        //                                       textAlign: TextAlign.left,
        //                                       style: TextStyle(
        //                                           color: Colors.deepOrange),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 InkWell(
        //                   onTap: () =>
        //                       Navigator.of(context).pushReplacementNamed(
        //                     CategoryNameScreen.routeName,
        //                     arguments: {'category': CategoryScreen.shop},
        //                   ),
        //                   child: Container(
        //                     width: _width,
        //                     height: 315,
        //                     child: Card(
        //                       elevation: 4,
        //                       margin: EdgeInsets.all(10),
        //                       child: Column(
        //                         children: [
        //                           ClipRRect(
        //                             borderRadius: BorderRadius.only(
        //                               topLeft: Radius.circular(15),
        //                               topRight: Radius.circular(15),
        //                             ),
        //                             child: Image.asset(
        //                               'assets/images/shop_category.jpg',
        //                               height: 150,
        //                               width: _width,
        //                               fit: BoxFit.cover,
        //                             ),
        //                           ),
        //                           Padding(
        //                             padding: EdgeInsets.all(10),
        //                             child: Container(
        //                               width: _width,
        //                               height: 120,
        //                               child: Column(
        //                                 children: [
        //                                   SizedBox(
        //                                     width: _width,
        //                                     child: Text(
        //                                       'shops',
        //                                       textAlign: TextAlign.left,
        //                                       style: TextStyle(
        //                                           color: Colors.deepOrange,
        //                                           fontSize: 20),
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     height: 10,
        //                                     width: _width,
        //                                   ),
        //                                   SizedBox(
        //                                     width: _width,
        //                                     child: Text(
        //                                       'Groceries, medicines and more',
        //                                       textAlign: TextAlign.left,
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     height: 25,
        //                                     width: _width,
        //                                   ),
        //                                   SizedBox(
        //                                     width: _width,
        //                                     child: Text(
        //                                       'Shop now',
        //                                       textAlign: TextAlign.left,
        //                                       style: TextStyle(
        //                                           color: Colors.deepOrange),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             InkWell(
        //               onTap: () => Navigator.of(context).pushReplacementNamed(
        //                 CourierListScreen.routeName,
        //               ),
        //               child: Container(
        //                 width: _width,
        //                 height: 315,
        //                 child: Card(
        //                   elevation: 4,
        //                   margin: EdgeInsets.all(10),
        //                   child: Column(
        //                     children: [
        //                       ClipRRect(
        //                         borderRadius: BorderRadius.only(
        //                           topLeft: Radius.circular(15),
        //                           topRight: Radius.circular(15),
        //                         ),
        //                         child: Image.asset(
        //                           'assets/images/courier_image.jpg',
        //                           height: 150,
        //                           width: _width,
        //                           fit: BoxFit.cover,
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: EdgeInsets.all(10),
        //                         child: Container(
        //                           width: _width,
        //                           height: 120,
        //                           child: Column(
        //                             children: [
        //                               SizedBox(
        //                                 width: _width,
        //                                 child: Text(
        //                                   'courier',
        //                                   textAlign: TextAlign.left,
        //                                   style: TextStyle(
        //                                       color: Colors.deepOrange,
        //                                       fontSize: 20),
        //                                 ),
        //                               ),
        //                               SizedBox(
        //                                 height: 10,
        //                                 width: _width,
        //                               ),
        //                               SizedBox(
        //                                 width: _width,
        //                                 child: Text(
        //                                   'Anything to anywhere...',
        //                                   textAlign: TextAlign.left,
        //                                 ),
        //                               ),
        //                               SizedBox(
        //                                 height: 25,
        //                                 width: _width,
        //                               ),
        //                               SizedBox(
        //                                 width: _width,
        //                                 child: Text(
        //                                   'Courier now',
        //                                   textAlign: TextAlign.left,
        //                                   style: TextStyle(
        //                                       color: Colors.deepOrange),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
