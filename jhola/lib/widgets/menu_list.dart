// import 'package:dotted_border/dotted_border.dart';
import 'dart:ffi';

import 'package:flutter/material.dart';
import './../provider/cart.dart';
import 'package:provider/provider.dart';

class MenuList extends StatelessWidget {
  final String shopId;
  final String productId;
  final String name;
  final double price;
  final String description;
  final String img;
  final String stock;

  MenuList({
    @required this.shopId,
    @required this.productId,
    @required this.name,
    @required this.price,
    @required this.description,
    @required this.img,
    @required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
//    print(shopId);

    return Padding(
      padding: EdgeInsets.all(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            ClipRRect(
              child: Image.network(
                img,
                height: 120,
                width: 120,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                stock == "true"
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 10, left: 10),
                        child: Row(
                          children: [
                            Text(
                              "Avaliable",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.green),
                            ),
                            // Spacer(),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Out Of Stock",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("₹${price.toString()}"),
                    SizedBox(
                      width: 30,
                    ),
                    // Spacer(),
                    RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      // disabledColor: ,
                      onPressed: stock == "false"
                          ? () {}
                          : () {
                              cart.addItem(
                                productId,
                                shopId,
                                // shopName,
                                price,
                                name,
                                description,
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
                                      cart.removeSingleItem(productId);
                                    },
                                  ),
                                ),
                              );
                            },
                      child: Text("Add to cart"),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
