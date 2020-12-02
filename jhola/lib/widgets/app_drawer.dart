import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jhola/screens/XDiPhoneXXS11Pro1.dart';
import 'package:jhola/screens/about_us_screen.dart';
import 'package:jhola/screens/courier_list_screen.dart';
import 'package:jhola/screens/edit_profile_screen.dart';
import 'package:jhola/screens/order_screen.dart';
import 'package:jhola/screens/welcome_screen.dart';
import './../screens/category_name_screen.dart';
import './../screens/category_screen.dart';
import 'package:provider/provider.dart';
import './../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<Auth>(context, listen: false).guserId;

    String username = Provider.of<Auth>(context).userName;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.deepOrange,
            title: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    username,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ]),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              XDiPhoneXXS11Pro1.routeName,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text("Restaurant"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              CategoryNameScreen.routeName,
              arguments: {'category': CategoryScreen.restaurant},
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.store),
            title: Text("Shops"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              CategoryNameScreen.routeName,
              arguments: {'category': CategoryScreen.shop},
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.train),
            title: Text("Courier"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(CourierListScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text("Orders"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              OrderScreen.routeName,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text("Edit Profile"),
            onTap: () => Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About Us"),
            onTap: () => Navigator.of(context).pushNamed(
              AboutUsScreen.routeName,
            ),
          ),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              _messaging.unsubscribeFromTopic(userId);
              _messaging.unsubscribeFromTopic('offer');
              Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
