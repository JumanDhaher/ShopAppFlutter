import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/products.dart';
class ProductsGrid extends StatelessWidget {
  bool showFavorite;
  ProductsGrid(this.showFavorite);
  @override
  Widget build(BuildContext context) {
    final productsData= Provider.of<Products>(context);
    final products = showFavorite? productsData.favoriteItem :productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i] ,
          child: ProductItem(),
            ), 
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      );
  }
}