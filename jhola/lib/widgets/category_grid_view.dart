import 'package:flutter/material.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/widgets/category_grid_item.dart';
import 'package:provider/provider.dart';

class CategoryGridView extends StatelessWidget {
  final String category;
  final List<MenuItem> menu;
  final List<DealItem> deal;
  final String shopId;
  // final List<String> categoryOptions;
  // const CategoryGridView({Key key}) : super(key: key);

  CategoryGridView({
    this.category,
    this.menu,
    this.deal,
    this.shopId,
    // this.categoryOptions,
  });

  @override
  Widget build(BuildContext context) {
    // Load categoryOptions list from database in initState
    List<String> categoryOptions;
    categoryOptions =
        Provider.of<Names>(context, listen: false).getCategoryOptions(shopId);
    print("$categoryOptions are the options");

    // [
    //   "Chinese",
    //   "Italian",
    //   "Desi",
    //   "Fast Food",
    //   "Deals",
    //   "Other",
    // ];

    // List<String> categoryOptions = category;
    return Container(
      child: GridView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        children: categoryOptions
            .map((item) => CategoryGridItem(
                  category: category,
                  categorySelected: item,
                  menu: menu,
                  deal: deal,
                ))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
