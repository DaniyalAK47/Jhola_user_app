import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import './../screens/category_screen.dart';

class CategoryNameList extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String lat;
  final String lng;

  CategoryNameList({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.status,
    @required this.lat,
    @required this.lng,
  });

  @override
  _CategoryNameListState createState() => _CategoryNameListState();
}

class _CategoryNameListState extends State<CategoryNameList> {
  @override
  Widget build(BuildContext context) {
    // List<String> location =
    //     Provider.of<Names>(context, listen: false).getLocation(widget.id);
    // double lat = double.parse(location[0]);
    // double lng = double.parse(location[1]);

    // print(widget.lat);
    // print(widget.lng);

    double userLat =
        Provider.of<CurrentLocation>(context, listen: false).latitude;
    double userLng =
        Provider.of<CurrentLocation>(context, listen: false).logitude;

    bool _loading = false;
    bool _init = true;
    // double distanceBetween;

    String distanceBetween = Provider.of<Names>(context, listen: false)
        .calculateDistance(
          double.parse(widget.lat),
          double.parse(widget.lng),
          userLat,
          userLng,
        )
        .toStringAsFixed(0);

    print(distanceBetween);

    // @override
    // void didChangeDependencies() async {
    //   // if (_init) {
    //   // _loading = true;
    //   distanceBetween = await Geolocator().distanceBetween(
    //       userLat, userLng, double.parse(widget.lat), double.parse(widget.lng));
    //   print(distanceBetween);
    //   super.didChangeDependencies();
    //   // _loading = false;
    //   // _init = false;
    //   // }
    // }

    return InkWell(
      splashColor: Colors.deepOrange,
      onTap: widget.status == "false"
          ? () {}
          : () =>
              Navigator.of(context).pushNamed(TabsScreen.routeName, arguments: {
                'shopId': widget.id,
                'shopTitle': widget.title,
              }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),
        elevation: 6,
        // margin: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/restaurantCategory.png',
                  height: 100,
                  width: 150,
                ),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 40),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      // overflow: TextOverflow.,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.location_on),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "${distanceBetween.toString()} km",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Spacer(),
                      Text(
                        widget.status == "false" ? "CLOSED" : "OPEN",
                        textAlign: TextAlign.left,
                        style: widget.status == "false"
                            ? TextStyle(color: Colors.grey, fontSize: 20)
                            : TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
//         Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Row(
//                   children: [
//                     Text(
//                       title,
//                       textAlign: TextAlign.left,
//                       style: TextStyle(color: Colors.deepOrange, fontSize: 20),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       status == "false" ? "closed" : "open",
//                       textAlign: TextAlign.left,
//                       style: status == "false"
//                           ? TextStyle(color: Colors.grey, fontSize: 15)
//                           : TextStyle(color: Colors.green, fontSize: 15),
//                     ),
//                     Spacer(),
//                     Icon(
//                       type == CategoryScreen.restaurant
//                           ? Icons.restaurant
//                           : Icons.store,
//                       color: Colors.deepOrange,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Text(
//                   description,
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//             ),
// //            Divider(color: Colors.deepOrange,),
//             Container(
//                 height: 30,
//                 color: status == "false" ? Colors.grey : Colors.deepOrange,
//                 child: Row(
//                   children: [
//                     Spacer(),
//                     Text(
//                       type == CategoryScreen.restaurant
//                           ? 'Menu and Deals'
//                           : 'Items and Deals',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.white,
//                     )
//                   ],
//                 ))
//           ],
//         ),
      ),
    );
  }
}
