import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text('Total'),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    // SizedBox(width: 5),
                    FlatButton(
                      onPressed: () {
                        Provider.of<Order>(context, listen: false).addtoOrder(
                          cart.cart.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.cart.length,
              itemBuilder: (ctx, i) => CarItems(
                cart.cart.values.toList()[i].id,
                cart.cart.keys.toList()[i],
                cart.cart.values.toList()[i].title,
                cart.cart.values.toList()[i].price,
                cart.cart.values.toList()[i].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}
