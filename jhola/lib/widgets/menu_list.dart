import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import './../provider/cart.dart';
import 'package:provider/provider.dart';

class MenuList extends StatelessWidget {
  final String shopId;
  // final String shopName;
  final String productId;
  final String name;
  final double price;
  final String description;

  MenuList({
    @required this.shopId,
    // @required this.shopName,
    @required this.productId,
    @required this.name,
    @required this.price,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
//    print(shopId);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
//        strokeCap: StrokeCap.butt,
        dashPattern: [8, 4],
        child: Container(
          color: Colors.orangeAccent,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '\$$price',
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
