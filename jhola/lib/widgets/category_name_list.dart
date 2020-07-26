import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhola/screens/tabs_screen.dart';
import './../screens/category_screen.dart';

class CategoryNameList extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;

  CategoryNameList({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.status,
  });

//  final String description = "KFC has been an American fried chicken staple since Colonel Sanders took his signature spices and fried goodness to the masses in the 1950s. According to Forbes, the brand is valued at 8.5 billion and places 86th on their World's Most Valuable Brands 2019 list.";
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.deepOrange,
      onTap: status == "false"
          ? () {}
          : () => Navigator.of(context)
              .pushNamed(TabsScreen.routeName, arguments: {'shopId': id}),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      status == "false" ? "closed" : "open",
                      textAlign: TextAlign.left,
                      style: status == "false"
                          ? TextStyle(color: Colors.grey, fontSize: 15)
                          : TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    Spacer(),
                    Icon(
                      type == CategoryScreen.restaurant
                          ? Icons.restaurant
                          : Icons.store,
                      color: Colors.deepOrange,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
//            Divider(color: Colors.deepOrange,),
            Container(
                height: 30,
                color: status == "false" ? Colors.grey : Colors.deepOrange,
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      type == CategoryScreen.restaurant
                          ? 'Menu and Deals'
                          : 'Items and Deals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
