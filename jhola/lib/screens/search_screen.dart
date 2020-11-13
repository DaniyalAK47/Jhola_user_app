import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/widgets/menu_list.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search_screen";
  final List<MenuItem> menuDisplay;

  final List<DealItem> dealDisplay;

  final String category;

  final String shopId;

  SearchScreen({
    this.menuDisplay,
    this.dealDisplay,
    this.category,
    this.shopId,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    // var category;
    // var shopId;

    Future<List<MenuItem>> searchMenu(String search) async {
      // await Future.delayed(Duration(seconds: 2));
      print(search);
      // List<MenuItem> searchMenuDisplay = widget.menuDisplay;
      List<MenuItem> searchMenuDisplay = [];
      widget.menuDisplay.forEach((item) {
        if (item.name.contains(search)) {
          searchMenuDisplay.add(item);
        }
      });
      return searchMenuDisplay;
    }

    Future<List<DealItem>> searchDeal(String search) async {
      // await Future.delayed(Duration(seconds: 10));
      print(search);
      List<DealItem> searchDealDisplay = widget.dealDisplay;
      print(searchDealDisplay.length);
      searchDealDisplay.forEach((item) {
        print(item.name);
        if (!item.name.contains(search)) {
          print("item name not matched");
          searchDealDisplay.remove(item);
        }
      });
      return searchDealDisplay;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Positioned(
              top: 13,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 0,
                    left: 32,
                  ),
                  child: widget.category == 'menu'
                      ? SearchBar<MenuItem>(
                          minimumChars: 1,
                          emptyWidget: Text("Nothing matched..."),
                          // onError: (error) => ,
                          shrinkWrap: true,
                          searchBarStyle: SearchBarStyle(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSearch: searchMenu,
                          onItemFound: (MenuItem item, int index) {
                            print(item.name);
                            return MenuList(
                              shopId: widget.shopId,
                              // shopName:shopName,
                              productId: item.id,
                              name: item.name,
                              price: item.price,
                              description: item.description,
                              img: item.image,
                              stock: item.stock,
                            );
                            // return ListTile(
                            //   title: Text(item.name),
                            // );
                          },
                        )
                      : SearchBar<DealItem>(
                          minimumChars: 1,
                          emptyWidget: Text("Nothing matched..."),
                          shrinkWrap: true,
                          onSearch: searchDeal,
                          onItemFound: (DealItem item, int index) {
                            print(item);
                            return MenuList(
                              shopId: widget.shopId,
                              // shopName:shopName,
                              productId: item.id,
                              name: item.name,
                              price: item.price,
                              description: item.description,
                              img: item.image,
                              stock: item.stock,
                            );
                            // return ListTile(
                            //   title: Text(item.name),
                            // );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
