import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

class NamesItem {
  final String id;
  final String name;
  final String description;
  final List<MenuItem> menu;
  final List<DealItem> deal;
  final String namesLat;
  final String namesLong;
  final String address;
  final String contact;
  final String status;
  final List<String> category;

  NamesItem({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.menu,
    @required this.deal,
    this.namesLat,
    this.namesLong,
    this.address,
    this.contact,
    this.status,
    this.category,
  });
}

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String stock;
  final String category;

  MenuItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.description,
    this.image,
    this.stock,
    this.category,
  });
}

class DealItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String stock;
  final String category;

  DealItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.description,
    this.image,
    this.stock,
    this.category,
  });
}

class Names with ChangeNotifier {
  List<NamesItem> _restaurantNames = [];
  List<NamesItem> _shopNames = [];

//Calculates distance in km
  double calculateDistance(userLat, userLong, resLat, resLong) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((resLat - userLat) * p) / 2 +
        c(userLat * p) * c(resLat * p) * (1 - c((resLong - userLong) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // List<NamesItem> get restaurantNames {
  //   return [..._restaurantNames];
  // }

  List<NamesItem> restaurantNames(String userLat, String userLong) {
    List<NamesItem> nearestRestaurant = [];
    _restaurantNames.forEach((element) {
      var distanceBetween = calculateDistance(
        double.parse(userLat),
        double.parse(userLong),
        double.parse(element.namesLat),
        double.parse(element.namesLong),
      );

      //1000 km in distance range will find restaurat
      if (distanceBetween < 10) {
        nearestRestaurant.add(element);
      }
    });
    return [...nearestRestaurant];
  }

  List<NamesItem> shopNames(String userLat, String userLong) {
    List<NamesItem> nearestShop = [];
    _shopNames.forEach((element) {
      var distanceBetween = calculateDistance(
        double.parse(userLat),
        double.parse(userLong),
        double.parse(element.namesLat),
        double.parse(element.namesLong),
      );
      //1000 km in distance range will find restaurat
      print("$distanceBetween is the distance between 2 places");
      if (distanceBetween < 10) {
        nearestShop.add(element);
      }
    });
    return [...nearestShop];
  }

  // List<NamesItem> get shopNames {
  //   return [..._shopNames];
  // }

  Map<String, String> getShopInfo(String shopId) {
    String name;
    String address;
    String contact;
    _restaurantNames.forEach((element) {
      if (element.id == shopId) {
        name = element.name;
        address = element.address;
        contact = element.contact;
      }
    });
    if (name == null) {
      _shopNames.forEach((element) {
        if (element.id == shopId) {
          name = element.name;
          address = element.address;
          contact = element.contact;
        }
      });
    }
    Map<String, String> info = {
      "name": name,
      "address": address,
      "contact": contact
    };
    return info;
  }

  List<NamesItem> getRestaurantMenu(String id) {
    return _restaurantNames.where((item) => item.id == id).toList();
  }

  List<NamesItem> getShopMenu(String id) {
    return _shopNames.where((item) => item.id == id).toList();
  }

  List<String> getCategoryOptions(String id) {
    List<String> categoryOptions;
    _restaurantNames.forEach((rest) {
      if (rest.id == id) {
        print(rest.category);
        categoryOptions = rest.category;
      }
    });
    _shopNames.forEach((shop) {
      if (shop.id == id) {
        categoryOptions = shop.category;
      }
    });
    return categoryOptions;
  }

  // List<String> getShopCategoryOptions(String id) {
  //   _shopNames.forEach((shop) {
  //     if (shop.id == id) {
  //       return shop.category;
  //     }
  //   });
  //   return null;
  // }

  List<String> getLocation(String shopId) {
    String lat;
    String lng;

    _restaurantNames.forEach((item) {
      if (item.id == shopId) {
        lat = item.namesLat;
        lng = item.namesLong;
      }
    });

    _shopNames.forEach((item) {
      if (item.id == shopId) {
        lat = item.namesLat;
        lng = item.namesLong;
      }
    });

    return [lat, lng];
  }

  Future<void> fetchAndSetNames() async {
    final urlRestaurant =
        'https://jhola-e90ff.firebaseio.com/registeredShops/restaurants.json';
    var responseRestaurant = await http.get(urlRestaurant);
    print(responseRestaurant.body);
    final List<NamesItem> loadedRestaurant = [];
    var extractedRestaurant =
        json.decode(responseRestaurant.body) as Map<String, dynamic>;
    // print(extractedRestaurant);
    if (extractedRestaurant != null) {
      extractedRestaurant.forEach((resId, resData) {
        // List<DealItem> loadedDeals = [];
        loadedRestaurant.add(
          NamesItem(
            id: resId.toString(),
            name: resData['name'].toString(),
            description: resData['address'].toString(),
            namesLat: resData['lat'].toString(),
            namesLong: resData['long'].toString(),
            status: resData["loggedIn"].toString(),
            address: resData['address'].toString(),
            contact: resData['phone'].toString(),
            menu: resData["menu"] == null
                ? []
                : (resData["menu"] as Map<String, dynamic>)
                    .values
                    .map((e) => MenuItem(
                          id: e["productId"].toString(),
                          name: e["productName"].toString(),
                          price: double.parse(e["productPrice"].toString()),
                          description: e["productDescription"].toString(),
                          stock: e["stock"].toString(),
                          category: e["category_name"].toString(),
                          image:
                              "https://firebasestorage.googleapis.com/v0/b/jhola-e90ff.appspot.com/o/images%2F${e['productId'].toString()}?alt=media&token=37e96ab0-172d-4387-88a5-18c508abe70b",
                        ))
                    .toList(),
            deal: resData["deals"] == null
                ? []
                : (resData["deals"] as Map<String, dynamic>)
                    .values
                    .map((e) => DealItem(
                          id: e["productId"].toString(),
                          name: e["productName"].toString(),
                          price: double.parse(e["productPrice"].toString()),
                          description: e["productDescription"].toString(),
                          stock: e["stock"].toString(),
                          category: e["category_name"].toString(),
                          image:
                              "https://firebasestorage.googleapis.com/v0/b/jhola-e90ff.appspot.com/o/images%2F${e['productId'].toString()}?alt=media&token=37e96ab0-172d-4387-88a5-18c508abe70b",
                        ))
                    .toList(),
            category: resData["categories"] == null
                ? []
                : (resData["categories"] as Map<String, dynamic>)
                    .values
                    .map(
                      (e) => e["category_name"].toString(),
                    )
                    .toList(),
          ),
        );
      });
    }

    final urlShops =
        'https://jhola-e90ff.firebaseio.com/registeredShops/grocery.json';
    var responseShops = await http.get(urlShops);
    print(responseShops.body);
    final List<NamesItem> loadedShops = [];
    var extractedShops =
        json.decode(responseShops.body) as Map<String, dynamic>;
    // print(extractedShops);
    if (extractedShops != null) {
      extractedShops.forEach((shopId, shopData) {
        // List<DealItem> loadedDeals = [];
        loadedShops.add(
          NamesItem(
            id: shopId.toString(),
            name: shopData['name'].toString(),
            description: shopData['address'].toString(),
            status: shopData["loggedIn"].toString(),
            namesLat: shopData['lat'].toString(),
            namesLong: shopData['long'].toString(),
            address: shopData['address'].toString(),
            contact: shopData['phone'].toString(),
            menu: shopData["items"] == null
                ? []
                : (shopData["items"] as Map<String, dynamic>)
                    .values
                    .map((e) => MenuItem(
                          id: e["productId"].toString(),
                          name: e["productName"].toString(),
                          price: double.parse(e["productPrice"].toString()),
                          description: e["productDescription"].toString(),
                          stock: e["stock"].toString(),
                          image:
                              "https://firebasestorage.googleapis.com/v0/b/jhola-e90ff.appspot.com/o/images%2F${e['productId'].toString()}?alt=media&token=37e96ab0-172d-4387-88a5-18c508abe70b",
                        ))
                    .toList(),
            deal: shopData["deals"] == null
                ? []
                : (shopData["deals"] as Map<String, dynamic>)
                    .values
                    .map((e) => DealItem(
                        id: e["productId"].toString(),
                        name: e["productName"].toString(),
                        price: double.parse(e["productPrice"].toString()),
                        description: e["productDescription"].toString(),
                        stock: e['stock'].toString(),
                        image:
                            "https://firebasestorage.googleapis.com/v0/b/jhola-e90ff.appspot.com/o/images%2F${e['productId'].toString()}?alt=media&token=37e96ab0-172d-4387-88a5-18c508abe70b"))
                    .toList(),
          ),
        );
      });
    }
    print("helooooooooo");

    _restaurantNames = loadedRestaurant.toList();

    _restaurantNames.forEach((element) {
      print(element.name);
    });
    _shopNames = loadedShops.toList();
  }
}
