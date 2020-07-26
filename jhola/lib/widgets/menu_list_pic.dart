import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jhola/provider/cart.dart';
import 'package:provider/provider.dart';

class MealListPic extends StatefulWidget {
  final String shopId;
  final String productId;
  final String name;
  final double price;
  final String description;
  final String img;

  MealListPic({
    @required this.shopId,
    @required this.productId,
    @required this.name,
    @required this.price,
    @required this.description,
    @required this.img,
  });

  @override
  _MealListPicState createState() => _MealListPicState();
}

// var urlPic;

class _MealListPicState extends State<MealListPic> {
  // Future<String> _getImage() async {
  //   print(widget.productId);
  //   final ref =
  //       FirebaseStorage.instance.ref().child('images/${widget.productId}.jpg');
  //   urlPic = await ref.getDownloadURL();
  //   print(urlPic);
  //   return urlPic;
  // }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // return FutureBuilder(
    //   future: _getImage(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  widget.img != null
                      ? widget.img
                      : 'https://banner.uclipart.com/20200112/vwo/restaurant-fast-food-food-plant.png',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Container(
                  width: 300,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.attach_money),
                    SizedBox(
                      width: 6,
                    ),
                    Text(widget.price.toString()),
                    SizedBox(
                      width: 100,
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        cart.addItem(
                          widget.productId,
                          widget.shopId,
                          // shopName,
                          widget.price,
                          widget.name,
                          widget.description,
                        );
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Item added to the cart!',
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cart.removeSingleItem(widget.productId);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
    //   },
    // );
  }
}
