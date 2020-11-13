import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhola/widgets/bezierContainer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key key}) : super(key: key);
  static const routeName = "/about_us";

  final String aboutUs =
      " We are jhola. We provide all types of delivery and e-commerce service to our customers local aria. Our dream was to connect our customers to every local store and businesses. Our local courier service will give a very use full features to our customers.\n\n Our customer was very precious for us. We are trying to give our best and give a new level of facilities to our customer and other user. Our customer’s support and their security was our first priority. There genuine feedback was helps us to upgrade our service and quality. We are evolvable for our user in any time or any cause.\n\n Jhola is a mobile application based company. Our dream was every type of local store and local businesses make online.\n\n We need our customers support because if our customer support us then the local business was automatically supported by jhola.\n\n Finally, this is a 100% made in India product. And it was evolvable for every types of person in India. ";

  Widget _title(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'abo',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ut',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' us',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _title1(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'conta',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ct',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' us',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  _title1(context),
                  SizedBox(height: 10),
                  Text("Phone/WhatsApp:- +91 84719 96089"),
                  Text("Gmail ID:- jhola.cmail@gmail.com"),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton(context)),
        ],
      ),
    ));
  }
}
