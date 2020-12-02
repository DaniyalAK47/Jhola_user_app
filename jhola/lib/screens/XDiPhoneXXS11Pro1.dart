import 'package:flutter/material.dart';
import 'package:jhola/provider/cart.dart';
import 'package:jhola/widgets/badge.dart';
import 'package:provider/provider.dart';
import './XDComponent11.dart';
import 'cart_screen.dart';
import 'category_name_screen.dart';
import 'category_screen.dart';
import 'courier_list_screen.dart';

class XDiPhoneXXS11Pro1 extends StatelessWidget {
  static const routeName = '/Home_screen_new';
  XDiPhoneXXS11Pro1({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xf2ffffff),
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: 355.0,
                height: 174.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(73.0),
                  image: DecorationImage(
                    image: const AssetImage(
                        'assets/images/welcome_image_home.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        CategoryNameScreen.routeName,
                        arguments: {'category': CategoryScreen.restaurant},
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 162.0,
                          height: 168.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29.0),
                            image: DecorationImage(
                              image: const AssetImage(
                                  'assets/images/foodRestaurantHome.png'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 20,
                          child: SizedBox(
                            child: Text(
                              'Food & \nRestaurants ',
                              style: TextStyle(
                                fontFamily: 'Century725 Cn BT',
                                fontSize: 28,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        CategoryNameScreen.routeName,
                        arguments: {'category': CategoryScreen.shop},
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 162.0,
                          height: 168.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29.0),
                            image: DecorationImage(
                              image: const AssetImage(
                                  'assets/images/localStoresHome.png'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 20,
                          child: SizedBox(
                            child: Text(
                              'Local Stores',
                              style: TextStyle(
                                fontFamily: 'Century725 Cn BT',
                                fontSize: 28,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    CourierListScreen.routeName,
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 355.0,
                      height: 118.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(37.0),
                        image: DecorationImage(
                          image:
                              const AssetImage('assets/images/courierHome.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 100,
                      top: 30,
                      child: SizedBox(
                        width: 184.0,
                        height: 52.0,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                CourierListScreen.routeName,
                              );
                            },
                            child: XDComponent11()),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 216.0,
                    height: 117.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            const AssetImage('assets/images/referEarnHome.jpg'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 121.0,
                        height: 117.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.elliptical(9999.0, 9999.0)),
                          color: const Color(0xff1f4ad5),
                          border: Border.all(
                              width: 1.0, color: const Color(0xff707070)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 25,
                        top: 10,
                        child: SizedBox(
                          child: Text(
                            'Refer\n&\nEarn',
                            style: TextStyle(
                              fontFamily: 'GeoSlab703 Md BT',
                              fontSize: 25,
                              color: const Color(0xffffffff),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 375.0,
                height: 330.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/footerHome.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
