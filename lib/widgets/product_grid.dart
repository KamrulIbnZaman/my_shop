import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/product_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool isFav;
  ProductGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final product = isFav ? productData.showOnlyFavorite : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: product.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(),
      ),
    );
  }
}
