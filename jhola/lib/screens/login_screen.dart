import 'package:flutter/material.dart';
import 'package:jhola/screens/category_screen.dart';
import 'package:jhola/screens/forget_password_screen.dart';
import 'package:jhola/screens/welcome_screen.dart';
import './signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../provider/auth.dart';
import './../provider/http_exception.dart';

import './../widgets/bezierContainer.dart';
import 'latest_news_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  static const routeName = '/login';

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _form = GlobalKey<FormState>();
  // var _isLoading = false;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An Error has Occured!"),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('okay'),
          ),
        ],
      ),
    );
  }

  Future<bool> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return false;
    }
    _form.currentState.save();
    try {
      await Provider.of<Auth>(context, listen: false).logIn(_email, _password);
    } on HttpException catch (error) {
      print(" http exception in login screen");
      var errorMessage = 'Could not Authenticate';
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'The email entered is incorrect';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'The password entered is incorrect';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'The email is already in use';
      } else if (error.toString().contains("Please verify your email")) {
        errorMessage = "Please verify your email";
      }
      _showErrorDialog(errorMessage);
      return false;
    } catch (error) {
      const errorMessage = 'Could not authenticate please try again later.';
      _showErrorDialog(errorMessage);
      return false;
    }
    return true;
  }

  // List<String> userInfo = [];
  var _email;
  var _password;

  Widget _entryField(String title1, String title2, {bool isPassword = false}) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   title1,
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide your email";
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(30),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(80),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  hintText: "Username",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  icon: Icon(Icons.person_outline),
                ),
              ),
            ),
            // Text(
            //   title2,
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 10),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide your password";
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(30),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  // border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  icon: Icon(Icons.lock_outline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        // _saveForm();
        // Navigator.of(context).pop();
        var result = await _saveForm();
        if (!result) {
          return;
        }
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();

        // Navigator.of(context).pushReplacementNamed(CategoryScreen.routeName);
        Navigator.of(context).pushReplacementNamed(LatestNewsScreen.routeName,
            arguments: {"autoLogin": "true"});
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            // boxShadow: <BoxShadow>[
            //   BoxShadow(
            //       color: Colors.grey.shade200,
            //       offset: Offset(2, 4),
            //       blurRadius: 5,
            //       spreadRadius: 2)
            // ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.arrow_forward,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'jh',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'o',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'la',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id", "Password"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'assets/images/login_top.png',
            width: double.infinity,
            height: 250,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 10,
              top: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //   width: 3,
                //   color: Colors.grey[400],
                // ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(90),
                  topRight: Radius.circular(90),
                ),
              ),
              child: Stack(
                children: [
                  _emailPasswordWidget(),
                  Positioned(right: 5, top: 50, child: _submitButton()),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 20, 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ForgetPassword.routeName);
                  },
                  child: Text(
                    "Forgot?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => SignUpScreen()));
                  // Navigator.popAndPushNamed(context, SignUpScreen.routeName);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent[700],
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/images/login_bottom.png',
            width: double.infinity,
            height: 250,
            fit: BoxFit.fill,
          )
        ],
      ),
    )
        //     Container(
        //   height: height,
        //   child: Stack(
        //     children: <Widget>[
        //       Positioned(
        //           top: -height * .15,
        //           right: -MediaQuery.of(context).size.width * .4,
        //           child: BezierContainer()),
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 20),
        //         child: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: <Widget>[
        //               SizedBox(height: height * .2),
        //               _title(),
        //               SizedBox(height: 50),
        //               _emailPasswordWidget(),
        //               SizedBox(height: 20),
        //               _submitButton(),
        //               InkWell(
        //                 onTap: () {
        //                   Navigator.of(context).pushNamed(ForgetPassword.routeName);
        //                 },
        //                 child: Container(
        //                   padding: EdgeInsets.symmetric(vertical: 10),
        //                   alignment: Alignment.centerRight,
        //                   child: Text('Forgot Password ?',
        //                       style: TextStyle(
        //                           fontSize: 14, fontWeight: FontWeight.w500)),
        //                 ),
        //               ),
        //               // _divider(),
        //               // _facebookButton(),
        //               SizedBox(height: height * .055),
        //               _createAccountLabel(),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Positioned(top: 40, left: 0, child: _backButton()),
        //     ],
        //   ),
        // )
        );
  }
}
