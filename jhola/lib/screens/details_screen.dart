import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../provider/names.dart' show Names;
import './../widgets/menu_list.dart';
import 'package:provider/provider.dart';
import './../widgets/menu_list_pic.dart';

class DetailsScreen extends StatelessWidget {
  final String shopId;
  final String category;

  DetailsScreen({
    @required this.shopId,
    @required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // String shopName;
    var restaurant = Provider.of<Names>(context).getRestaurantMenu(shopId);
    if (restaurant.isEmpty) {
      restaurant = Provider.of<Names>(context).getShopMenu(shopId);
    }
    var menuDisplay;

    if (category == 'menu') {
      menuDisplay = restaurant[0].menu;
    } else {
      menuDisplay = restaurant[0].deal;
    }

    // shopName = restaurant[0].name;
//    print(shopId);

    return Scaffold(
      body: ListView(
        children: menuDisplay
            .map<Widget>((item) => MealListPic(
                  shopId: shopId,
                  // shopName:shopName,
                  productId: item.id,
                  name: item.name,
                  price: item.price,
                  description: item.description,
                  img: item.image,
                ))
            .toList(),
      ),
    );
  }
}
