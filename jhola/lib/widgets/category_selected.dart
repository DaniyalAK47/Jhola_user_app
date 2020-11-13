import 'package:flutter/material.dart';
import 'package:jhola/provider/cart.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/screens/cart_screen.dart';
import 'package:jhola/widgets/menu_list.dart';
import 'package:provider/provider.dart';

import 'badge.dart';

class CategorySelected extends StatelessWidget {
  static const routeName = '/category_selected';
  final String category;
  final String categorySelected;
  final List<MenuItem> menu;
  final List<DealItem> deal;
  final String shopId;

  CategorySelected({
    this.category,
    this.categorySelected,
    this.shopId,
    this.deal,
    this.menu,
  });
  // const CategorySelected({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MenuItem> displayMenu = [];
    List<DealItem> displayDeal = [];

    print("$menu is the menu");
    print("$deal is the deal");

    List<MenuItem> menuToDisplay(String categorySelected) {
      List<MenuItem> menuFinal = [];
      menu.forEach((item) {
        if (item.category == categorySelected) {
          menuFinal.add(item);
        }
        // print(item.category);
      });

      return [...menuFinal];
    }

    List<DealItem> dealToDisplay(String categorySelected) {
      List<DealItem> dealFinal = [];
      deal.forEach((item) {
        if (item.category == categorySelected) {
          dealFinal.add(item);
        }
      });

      return [...dealFinal];
    }

    if (category == 'menu') {
      displayMenu = menuToDisplay(categorySelected);
    } else {
      displayDeal = dealToDisplay(categorySelected);
    }

    print("$displayMenu is the display menu");

    return Scaffold(
      appBar: AppBar(
        title: Text(categorySelected),
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
      ),
      body: ListView(
        children: category == 'menu'
            ? displayMenu
                .map((item) => MenuList(
                    shopId: shopId,
                    productId: item.id,
                    name: item.name,
                    price: item.price,
                    description: item.description,
                    img: item.image,
                    stock: item.stock))
                .toList()
            : displayDeal
                .map((item) => MenuList(
                    shopId: shopId,
                    productId: item.id,
                    name: item.name,
                    price: item.price,
                    description: item.description,
                    img: item.image,
                    stock: item.stock))
                .toList(),
      ),
    );
  }
}
