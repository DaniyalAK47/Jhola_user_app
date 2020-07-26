import 'package:jhola/provider/cart.dart';

import './../widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:jhola/screens/details_screen.dart';
import 'package:provider/provider.dart';
import './../provider/cart.dart';
import './cart_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs_screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String shopId;
  var _loadingData = false;

  @override
  void didChangeDependencies() {
    if (!_loadingData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      shopId = routeArgs['shopId'];
      // print(shopId);
      _loadingData = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xfffbb448),
            elevation: 0,
            centerTitle: false,
            actions: [
              Consumer<Cart>(
                builder: (ctx, cartData, ch) => Badge(
                  child: ch,
                  value: cartData.itemCount.toString(),
                  color: Colors.deepOrange,
                ),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ],
            title: Text('KFC'),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.menu),
                text: "Menu",
              ),
              Tab(
                icon: Icon(Icons.local_offer),
                text: 'Deals',
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              DetailsScreen(
                shopId: shopId,
                category: "menu",
                // shopCategory:shopCategory
              ),
              DetailsScreen(
                shopId: shopId,
                category: 'deal',
              ),
            ],
          ),
        ));
  }
}
