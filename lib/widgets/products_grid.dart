import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    print(products);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
          //  create: (c) => products[index],
          child: ProductItem(
              //products[index].id, products[index].title,
              //  products[index].imageUrl
              )),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
