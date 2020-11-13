import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhola/provider/admin.dart';
import 'package:jhola/provider/courier.dart';
import 'package:jhola/provider/courier_location.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/provider/rider.dart';
import 'package:jhola/screens/about_us_screen.dart';
import 'package:jhola/screens/category_checkout_screen.dart';
import 'package:jhola/screens/courier_list_screen.dart';
import 'package:jhola/screens/courier_screen.dart';
import 'package:jhola/screens/forget_password_screen.dart';
import 'package:jhola/screens/latest_news_screen.dart';
import 'package:jhola/screens/login_screen.dart';
import 'package:jhola/screens/rider_selection_screen.dart';
import 'package:jhola/screens/search_screen.dart';
import 'package:jhola/screens/signup_screen.dart';
import 'package:jhola/screens/tabs_screen.dart';
import 'package:jhola/screens/tracking_courier_screem.dart';
import 'package:jhola/screens/welcome_screen.dart';
import 'package:jhola/widgets/category_selected.dart';
import 'package:jhola/widgets/courier_list.dart';
import 'package:provider/provider.dart';

import './screens/category_screen.dart';
import './screens/category_name_screen.dart';
import './provider/cart.dart';
import './screens/cart_screen.dart';
import './provider/order.dart';
import './screens/order_screen.dart';
import './provider/auth.dart';
import './screens/location_screen.dart';
import './provider/current_location.dart';
import './screens/splash_screen.dart';
import './screens/edit_profile_screen.dart';
import './screens/tracking_order_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    // _messaging.subscribeToTopic('orderStatus');
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
        );
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Names(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Order(),
        ),
        ChangeNotifierProvider.value(
          value: CurrentLocation(),
        ),
        ChangeNotifierProvider.value(
          value: Rider(),
        ),
        ChangeNotifierProvider.value(
          value: CourierLocation(),
        ),
        ChangeNotifierProvider.value(
          value: Courier(),
        ),
        ChangeNotifierProvider.value(
          value: Admin(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          ),
        ),
        home: SplashScreen(),
        routes: {
          CategoryScreen.routeName: (ctx) => CategoryScreen(),
          CategoryNameScreen.routeName: (ctx) => CategoryNameScreen(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          LocationScreen.routeName: (ctx) => LocationScreen(),
          SplashScreen.routeName: (ctx) => SplashScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
          TrackingOrderScreen.routeName: (ctx) => TrackingOrderScreen(),
          CourierScreen.routeName: (ctx) => CourierScreen(),
          RiderSelectScreen.routeName: (ctx) => RiderSelectScreen(),
          CourierListScreen.routeName: (ctx) => CourierListScreen(),
          ForgetPassword.routeName: (ctx) => ForgetPassword(),
          TrackingCourierScreen.routeName: (ctx) => TrackingCourierScreen(),
          AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
          LatestNewsScreen.routeName: (ctx) => LatestNewsScreen(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
          CategorySelected.routeName: (ctx) => CategorySelected(),
          CategoryCheckoutScreen.routeName: (ctx) => CategoryCheckoutScreen(),
        },
      ),
    );
  }
}
