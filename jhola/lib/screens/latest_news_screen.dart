import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhola/screens/category_screen.dart';
import 'package:jhola/screens/welcome_screen.dart';
import 'package:jhola/widgets/bezierContainer.dart';

class LatestNewsScreen extends StatefulWidget {
  const LatestNewsScreen({Key key}) : super(key: key);
  static const routeName = "/latest_news";

  @override
  _LatestNewsScreenState createState() => _LatestNewsScreenState();
}

class _LatestNewsScreenState extends State<LatestNewsScreen> {
  String autoLogin;
  final String aboutUs =
      " Our new and dynamic system updates are coming very shortly with a multi level accretive features and offers.\n\n Stay alert for our new updates. Because it was remarkable.";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    autoLogin = routeArgs['autoLogin'];
  }

  Widget _title(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'comi',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ng',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' soon',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () async {
      if (autoLogin == 'true') {
        // Navigator.of(context).pushReplacementNamed(LatestNewsScreen.routeName,
        // arguments: {"autoLogin:true"});
        Navigator.of(context).pushReplacementNamed(CategoryScreen.routeName);
      } else {
        // Navigator.of(context).pushReplacementNamed(LatestNewsScreen.routeName,
        // arguments: {"autoLogin:false"});
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
      }
    });
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(context),
                  SizedBox(height: 10),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(aboutUs),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
