import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CarItems extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CarItems(
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are You Sure?'),
                content: Text('Do you want to remove this product?'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('NO')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('YES'))
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).rmoveItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text('title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text('\$${(price * quantity)}',
                style: TextStyle(color: Colors.grey)),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
