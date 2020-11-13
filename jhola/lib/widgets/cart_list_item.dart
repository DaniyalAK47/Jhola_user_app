import 'package:flutter/material.dart';
import 'package:jhola/provider/cart.dart';
import 'package:jhola/widgets/badge.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {
  // final Cart cart;
  final String cartId;
  final String shopId;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartListItem(
    // this.cart,
    this.cartId,
    this.shopId,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 50,
      // padding: EdgeInsets.only(left: 20, right: 20),
      // height: ,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/restaurant_category.jpg',
                width: 50,
                height: 50,
              ),
              Container(
                width: 100,
                child: Text(
                  // Provider.of<Cart>(context).getTitle(widget.productId),
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed:
                    // Provider.of<Cart>(context).getQuantity(widget.productId) == 1
                    //     ? () {
                    //         SnackBar(
                    //           content: Text(
                    //             'Slide the item to remove completely.',
                    //           ),
                    //           duration: Duration(
                    //             seconds: 2,
                    //           ),
                    //         );
                    //       }
                    //     :
                    () {
                  // setState(() {
                  // widget.cart.removeItem(widget.productId);
                  Provider.of<Cart>(context, listen: false)
                      .removeSingleItem(productId);
                  // });
                },
              ),
              Text(
                  Provider.of<Cart>(context).getQuantity(productId).toString()),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // setState(() {
                  Provider.of<Cart>(context, listen: false)
                      .addSingleItem(productId);
                  // });
                },
              ),
              Text((price * Provider.of<Cart>(context).getQuantity(productId))
                  .toString()),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
