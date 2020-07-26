import 'package:flutter/material.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/screens/category_screen.dart';
import 'package:jhola/screens/location_screen.dart';
import 'package:jhola/screens/welcome_screen.dart';
import './../widgets/bezierContainer.dart';
import './login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../provider/auth.dart';
import './../provider/http_exception.dart';
// import './../provider/current_location.dart';
import 'package:geolocator/geolocator.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key, this.title}) : super(key: key);

  static const routeName = 'signup';

  final String title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  static final _form = GlobalKey<FormState>();

  var _email;
  var _password;
  var _phoneNo;
  var _name;
  var _selectedLat;
  var _seletedLong;

  Future<bool> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return false;
    }
    _form.currentState.save();
    _seletedLong =
        Provider.of<CurrentLocation>(context, listen: false).logitude;
    _selectedLat =
        Provider.of<CurrentLocation>(context, listen: false).latitude;
    if (_selectedLat == null && _seletedLong == null) {
      _showErrorDialog("Select your location.");
      return false;
    }

    try {
      await Provider.of<Auth>(context, listen: false).signUp(_email, _password);
    } on HttpException catch (error) {
      print(" http exception in auth screen");
      var errorMessage = 'Could not Authenticate';
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'The email entered is incorrect';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'The password entered is incorrect';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'The email is already in use';
      } else if (error.toString().contains("Please verify your email")) {
        errorMessage = "Please verify your email";
      } else if (error.toString().contains("USER_NOT_FOUND")) {
        errorMessage = "You are not a user";
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

  Widget _entryField(String name, String phoneNo, String email, String password,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide your name";
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
                obscureText: isPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
            Text(
              phoneNo,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide your phone number";
                  }
                  return null;
                },
                onSaved: (value) => _phoneNo = value,
                keyboardType: TextInputType.number,
                obscureText: isPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
            Text(
              email,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide your email";
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
                keyboardType: TextInputType.emailAddress,
                obscureText: isPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
            Text(
              password,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide your password";
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true))
          ],
        ),
      ),
    );
  }

  Future<Position> _getCureentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    return position;
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        var result = await _saveForm();
        if (!result) {
          return;
        }
        String lat = Provider.of<CurrentLocation>(context, listen: false)
            .latitude
            .toString();
        String long = Provider.of<CurrentLocation>(context, listen: false)
            .logitude
            .toString();

        Provider.of<Auth>(context, listen: false)
            .registerUser(_email, _name, _password, _phoneNo, lat, long);
        Provider.of<Auth>(context, listen: false)
            .setUserInfo(_name, _phoneNo, _email);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("You successfully signed up!"),
            content: Text("Verify your email and log in to continue..."),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: Text('okay'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _selectLocation() {
    return InkWell(
      onTap: () async {
        Position position = await _getCureentLocation();
        print(position);
        await Navigator.of(context)
            .pushNamed(LocationScreen.routeName, arguments: {
          'lat': position.latitude.toString(),
          'long': position.longitude.toString(),
          'screen': "signup",
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Select your location',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
        _entryField("Username", 'Phone No.', "Email id", "Password"),
      ],
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
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _selectLocation(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
