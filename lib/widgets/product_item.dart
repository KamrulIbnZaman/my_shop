import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screen/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child:
           Hero(
             tag: product.id,
             child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
                     ),
           ),
          footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer(
                builder: (ctx, Product product, child) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    product
                        .toggleFavorite(auth.userId, auth.token)
                        .catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                  },
                ),
              ),
              title: Text(product.title),
              trailing: Consumer<Cart>(
                builder: (ctx, cart, child) => IconButton(
                  onPressed: () {
                    cart.addtoCart(product.id, product.title, product.price);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Item added to the cart.'),
                        action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              cart.removeSingleProduct(product.id);
                            }),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
