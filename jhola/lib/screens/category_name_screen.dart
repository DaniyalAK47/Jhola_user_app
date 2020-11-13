import 'package:flutter/material.dart';
import 'package:jhola/provider/auth.dart';
import 'package:jhola/screens/category_screen.dart';
import './../provider/names.dart' show Names;
import 'package:provider/provider.dart';
import './../widgets/category_name_list.dart';
import './../widgets/app_drawer.dart';
import './../provider/cart.dart';
import './../widgets/badge.dart';
import './cart_screen.dart';

class CategoryNameScreen extends StatefulWidget {
  static const routeName = '/category_name';

  @override
  _CategoryNameScreenState createState() => _CategoryNameScreenState();
}

class _CategoryNameScreenState extends State<CategoryNameScreen> {
  String categoryTitle;
  var _loadingData = false;
  var _isLoading = false;
  var _initData = true;
  String userLat;
  String userLong;

  var displayNames = [];

  @override
  void didChangeDependencies() async {
    if (!_loadingData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['category'];
      // print(categoryTitle);

      _loadingData = false;
    }
    if (_initData) {
      setState(() {
        _isLoading = true;
      });
      userLat = await Provider.of<Auth>(context, listen: false).userLat;
      userLong = await Provider.of<Auth>(context, listen: false).userLong;
      print("$userLat and $userLong");
      // print(userLat);
      // print(userLong);
      await Provider.of<Names>(context, listen: false).fetchAndSetNames();
      final nameData = Provider.of<Names>(context, listen: false);
      if (categoryTitle == CategoryScreen.restaurant) {
        displayNames = nameData.restaurantNames(userLat, userLong);
      } else if (categoryTitle == CategoryScreen.shop) {
        displayNames = nameData.shopNames(userLat, userLong);
      }
      setState(() {
        _isLoading = false;
      });
    }
    _initData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfffbb448),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/company_logo_editted.png',
          height: 100,
          width: 100,
        ),
        centerTitle: false,
        actions: [
          Consumer<Cart>(
            builder: (ctx, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
              color: Colors.orange,
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : displayNames.isEmpty
              ? Center(
                  child: Text("No one close to you is registered!"),
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/welcome.jpg',
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      // child: Container(
                      //   margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      //   width: double.infinity,
                      //   height: 200,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //     image: AssetImage(
                      //         categoryTitle == CategoryScreen.restaurant
                      //             ? 'assets/images/restaurant_category.jpg'
                      //             : 'assets/images/shop_category.jpg'),
                      //     fit: BoxFit.fill,
                      //   )),
                      // ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                          ),
                        ),
                        child: Container(
                          width: 375,
                          child: ListView(
                            shrinkWrap: true,
                            children: displayNames
                                .map((item) => CategoryNameList(
                                      id: item.id,
                                      title: item.name,
                                      description: item.description,
                                      type: categoryTitle,
                                      status: item.status,
                                      lat: item.namesLat,
                                      lng: item.namesLong,
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
