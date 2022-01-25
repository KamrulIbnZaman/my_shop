import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/drawer.dart';
import '../providers/product_provider.dart';

enum FilterOptions {
  AllProducts,
  ShowOnlyFavorites,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool favoriteScreen = false;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dokan'),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              ch,
              cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedOption) {
              if (selectedOption == FilterOptions.AllProducts) {
                setState(() {
                  favoriteScreen = false;
                });
              } else {
                setState(() {
                  favoriteScreen = true;
                });
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('All Products'),
                value: FilterOptions.AllProducts,
              ),
              PopupMenuItem(
                child: Text('Faovrites'),
                value: FilterOptions.ShowOnlyFavorites,
              )
            ],
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: product.fetchProducts(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    semanticsLabel: 'Loading Products',
                    onRefresh: product.fetchProducts,
                    child: ProductGrid(favoriteScreen),
                  ),
      ),
    );
  }
}
