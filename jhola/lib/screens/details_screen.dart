// import 'package:flappy_search_bar/flappy_search_bar.dart';
// import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jhola/screens/search_screen.dart';
import 'package:jhola/widgets/category_grid_view.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
// import 'package:jhola/widgets/search_bar.dart';
import './../provider/names.dart' show DealItem, MenuItem, Names;
import './../widgets/menu_list.dart';
import 'package:provider/provider.dart';
import './../widgets/menu_list_pic.dart';

class DetailsScreen extends StatefulWidget {
  final String shopId;
  final String category;

  DetailsScreen({
    @required this.shopId,
    @required this.category,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // String shopName;
    var restaurant =
        Provider.of<Names>(context).getRestaurantMenu(widget.shopId);
    if (restaurant.isEmpty) {
      restaurant = Provider.of<Names>(context).getShopMenu(widget.shopId);
    }
    // List menuDisplay;
    // if(category == 'menu'){
    //   List<MenuItem> menuDisplay;
    // }
    // List menuDisplay;

    // category=='menu':List<MenuItem> menuDisplay?List<MenuItem> menuDisplay;

    List<MenuItem> menuDisplay;
    List<DealItem> dealDisplay;

    if (widget.category == 'menu') {
      // List<MenuItem> menuDisplay;
      menuDisplay = restaurant[0].menu;
    } else {
      // List<DealItem> menuDisplay;
      dealDisplay = restaurant[0].deal;
    }

    // shopName = restaurant[0].name;
//    print(shopId);

    // Widget itemFound(Post menu,int index) {}

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.of(context).push(SearchScreen.routeName);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      category: widget.category,
                      dealDisplay: dealDisplay,
                      menuDisplay: menuDisplay,
                      shopId: widget.shopId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 60,
                  // color: Colors.white,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Search Items...",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CategoryGridView(
              category: widget.category,
              menu: menuDisplay,
              deal: dealDisplay,
              shopId: widget.shopId,
            ),
            SingleChildScrollView(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: widget.category == 'menu'
                    ? menuDisplay
                        .map<Widget>((item) => MenuList(
                              shopId: widget.shopId,
                              // shopName:shopName,
                              productId: item.id,
                              name: item.name,
                              price: item.price,
                              description: item.description,
                              img: item.image,
                              stock: item.stock,
                            ))
                        .toList()
                    : dealDisplay
                        .map<Widget>((item) => MenuList(
                              shopId: widget.shopId,
                              // shopName:shopName,
                              productId: item.id,
                              name: item.name,
                              price: item.price,
                              description: item.description,
                              img: item.image,
                              stock: item.stock,
                            ))
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
