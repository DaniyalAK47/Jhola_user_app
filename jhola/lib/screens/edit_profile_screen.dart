import 'package:flutter/material.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/screens/category_name_screen.dart';
import 'package:jhola/screens/category_screen.dart';
import 'package:provider/provider.dart';
import './../widgets/bezierContainer.dart';
import 'package:geolocator/geolocator.dart';
import './location_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  static const routeName = '/edit_profile_screen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static final _form = GlobalKey<FormState>();
  String _userName;
  String _phone;
  String _lat;
  String _long;
  var _loading = false;

  Widget _entryField(String username, String email, String phoneNo,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              username,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                onSaved: (value) => _userName = value,
                obscureText: false,
                initialValue: _userName,
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
                onSaved: (value) => _phone = value,
                obscureText: false,
                initialValue: _phone,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Name", "Email", "Phone Number"),
      ],
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushReplacementNamed(CategoryScreen.routeName);
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            SizedBox(
              width: 25,
            ),
            Text('Edit Profile',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return InkWell(
      onTap: () async {
        _form.currentState.save();
        _lat = Provider.of<CurrentLocation>(context, listen: false)
            .latitude
            .toString();
        _long = Provider.of<CurrentLocation>(context, listen: false)
            .logitude
            .toString();
        setState(() {
          _loading = true;
        });
        await Provider.of<Auth>(context, listen: false)
            .updateUserInfo(_userName, _phone, _lat, _long);
        setState(() {
          _loading = false;
        });
        // Navigator.of(context).pushReplacementNamed(CategoryScreen.routeName);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.save, color: Colors.black),
            ),
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

  Widget _selectLocation() {
    return InkWell(
      onTap: () async {
        print("button working");
        Position position = await _getCureentLocation();
        print(position);
        await Navigator.of(context)
            .pushNamed(LocationScreen.routeName, arguments: {
          'lat': position.latitude.toString(),
          'long': position.longitude.toString(),
          'screen': "edit",
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var _userData = Provider.of<Auth>(context, listen: false);
    var _locationData = Provider.of<CurrentLocation>(context, listen: false);
    _userName = _userData.userName;
    _phone = _userData.phoneNo;
    _lat = _locationData.latitude.toString();
    _long = _locationData.logitude.toString();
    return Scaffold(
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
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
                        SizedBox(height: height * .3),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _selectLocation()
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
                Positioned(top: 40, right: 0, child: _saveButton()),
              ],
            ),
    );
  }
}
