import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/screens/category_screen.dart';
import 'package:jhola/screens/latest_news_screen.dart';
import 'package:jhola/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _bigger = true;
  Tween<double> _scaleTween = Tween<double>(begin: 1, end: 1);
  bool autoLogin = true;
  bool loading = false;

  // @override
  // void didChangeDependencies() async {
  //   if (!loading) {
  //     autoLogin = await Provider.of<Auth>(context, listen: false).autoLogin();
  //     print(autoLogin);
  //     loading = true;
  //   }

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Timer(Duration(seconds: 3), () async {
      autoLogin = await Provider.of<Auth>(context, listen: false).autoLogin();
      print(autoLogin);
      if (autoLogin) {
        Navigator.of(context).pushReplacementNamed(LatestNewsScreen.routeName,
            arguments: {"autoLogin": "true"});
        // Navigator.of(context).pushReplacementNamed(CategoryScreen.routeName);
      } else {
        // Navigator.of(context).pushReplacementNamed(LatestNewsScreen.routeName,
        //     arguments: {"autoLogin": "false"});
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
      }
    });
    return Scaffold(
      backgroundColor: Color(0xfffbb448),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'assets/images/logoFinal.png',
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
            ),
            Text(
              "Made in India.",
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
