import 'package:flutter/material.dart';
import 'package:jhola/provider/names.dart';
import 'package:jhola/widgets/category_selected.dart';

class CategoryGridItem extends StatelessWidget {
  final String category;
  final String categorySelected;
  final List<MenuItem> menu;
  final List<DealItem> deal;
  final String shopId;

  CategoryGridItem({
    this.category,
    this.categorySelected,
    this.menu,
    this.deal,
    this.shopId,
  });
  // const CategoryGridItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CategorySelected(
            category: category,
            categorySelected: categorySelected,
            menu: menu,
            deal: deal,
            shopId: shopId,
          ),
        ),
      ),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        // color: Colors.yellow,
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            categorySelected,
            // style: Theme.of(context).textTheme.title,
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
              spreadRadius: 0,
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
      ),
    );
  }
}
