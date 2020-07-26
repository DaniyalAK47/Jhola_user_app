import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jhola/provider/current_location.dart';
import 'package:provider/provider.dart';
import './http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _nodeId;
  Timer _authTimer;
  String _name;
  String _phoneNo;
  String _email;
  String _userLat;
  String _userLong;

  void setUserInfo(String name, String phoneNo, String email) {
    _name = name;
    _phoneNo = phoneNo;
    _email = email;
  }

  get guserId {
    return _userId;
  }

  get userName {
    return _name;
  }

  get phoneNo {
    return _phoneNo;
  }

  get email {
    return _email;
  }

  get userLat {
    return _userLat;
  }

  get userLong {
    return _userLong;
  }

  Future<void> updateUserInfo(
      String name, String phoneNo, String lat, String long) async {
    final url =
        'https://jhola-e90ff.firebaseio.com/registeredUser/$_nodeId.json';

    var response = await http.patch(url,
        body: json.encode({
          "name": name,
          "phoneNo": phoneNo,
          "latitude": lat,
          "longitude": long,
        }));
    _name = name;
    _phoneNo = phoneNo;
    _userLat = userLat;
    _userLong = userLong;
    notifyListeners();

    // print(json.decode(response.body));
  }

  Future<void> getUserInfo() async {
    final url =
        'https://jhola-e90ff.firebaseio.com/registeredUser/.json?orderBy="userId"&equalTo="$_userId"';
    var response = await http.get(url);
    // print(json.decode(response.body));
    var extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((userId, userData) {
      _name = userData['name'];
      _phoneNo = userData['phoneNo'];
      _email = userData['email'];
      _nodeId = userId;
      _userLat = userData['latitude'];
      _userLong = userData['longitude'];
    });

    // print(_userLat);
    // print(_userLong);
  }

  bool get isAuth {
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (_userId != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _userId;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB8f3J-uuvbXhfgaBLJ9EV_KQxfmTVoYRI";
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print("http exception caught");
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _nodeId = responseData['name'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      if (urlSegment == "signUp") {
        final urlVerification =
            "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyB8f3J-uuvbXhfgaBLJ9EV_KQxfmTVoYRI";

        final response = await http.post(urlVerification,
            body: json
                .encode({"requestType": "VERIFY_EMAIL", "idToken": _token}));
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          print("http exception caught");
          throw HttpException(responseData["error"]["message"]);
        }
      }
      if (urlSegment == "signInWithPassword") {
        final urlEmailVerified =
            "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyB8f3J-uuvbXhfgaBLJ9EV_KQxfmTVoYRI";

        final responseVerified = await http.post(urlEmailVerified,
            body: json.encode({"idToken": _token}));

        Map<String, dynamic> emailVerifiedData =
            json.decode(responseVerified.body);
        // print(emailVerifiedData);
        // print(emailVerifiedData["users"][0]["emailVerified"]);

        if (emailVerifiedData["users"][0]["emailVerified"] != true) {
          throw HttpException("Please verify your email");
        }
      }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expiryDate.toIso8601String(),
        'email': email,
        'password': password
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    await getUserInfo();
    // print("all this is happening");

    // print(userLat);
    // print(userLong);
  }

  Future<void> registerUser(String email, String name, String password,
      String phoneNo, String lat, String lng) async {
    final sigUpUrl = 'https://jhola-e90ff.firebaseio.com/registeredUser.json';
    // print(_userId);

    var response = await http.post(sigUpUrl,
        body: json.encode({
          "email": email,
          "name": name,
          "password": password,
          "phoneNo": phoneNo,
          "latitude": lat,
          "longitude": lng,
          "userId": _userId,
        }));
    print(json.decode(response.body));
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      print("http exception caught");
      throw HttpException(responseData["error"]["message"]);
    }
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userId')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expireDate']);
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = extractedUserData['expireDate'];
  //   notifyListeners();
  //   return true;
  // }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  void logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
//    prefs.remove('userId');
    prefs.clear();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      print("must be doing this");
      return false;
    }

    try {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var email = extractedUserData["email"];
      var password = extractedUserData["password"];
      await logIn(email, password);
    } catch (err) {
      print(err);
      return false;
    }

    return true;
  }

  void forgotPassword(String email) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyB8f3J-uuvbXhfgaBLJ9EV_KQxfmTVoYRI";

    final response = await http.post(url,
        body: json.encode({
          "requestType": "PASSWORD_RESET",
          "email": email,
        }));

    print(json.decode(response.body));
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      print("http exception caught");
      throw HttpException(responseData["error"]["message"]);
    }
  }
}
