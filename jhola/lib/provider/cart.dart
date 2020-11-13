import 'package:flutter/material.dart';

class CartItem {
  final String cartId;
  final String shopId;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String description;

  CartItem({
    @required this.cartId,
    @required this.shopId,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.description,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

//  String get shopId{
//    return _items[0].shopId;
//  }

  int get itemCount {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  int getQuantity(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId].quantity;
    } else {
      return 0;
    }
  }

  String getTitle(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId].title;
    } else {
      return null;
    }
  }

  double getPrice(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId].price;
    } else {
      return 0;
    }
  }

  int get itemLength {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(
    String productId,
    String shopId,
    // String shopName,
    double price,
    String title,
    String description,
  ) {
    if (_items.containsKey(productId)) {
      //change the quantity
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                description: existingCartItem.description,
                cartId: existingCartItem.cartId,
                shopId: existingCartItem.shopId,
                productId: existingCartItem.productId,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity + 1,
                price: existingCartItem.price,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          cartId: DateTime.now().toString(),
          description: description,
          shopId: shopId,
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                description: existingCartItem.description,
                cartId: existingCartItem.cartId,
                shopId: existingCartItem.shopId,
                productId: existingCartItem.productId,
                title: existingCartItem.title,
                quantity: (existingCartItem.quantity - 1),
                price: existingCartItem.price,
              ));
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void addSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    // if (_items[productId].quantity > 1) {
    _items.update(
        productId,
        (existingCartItem) => CartItem(
              description: existingCartItem.description,
              cartId: existingCartItem.cartId,
              shopId: existingCartItem.shopId,
              productId: existingCartItem.productId,
              title: existingCartItem.title,
              quantity: (existingCartItem.quantity + 1),
              price: existingCartItem.price,
            ));
    // }
    notifyListeners();
  }
}
