import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../widgets/drawer.dart';
import '../providers/orders.dart';

class OrderScreen extends StatelessWidget {
  static const routName = '/order';
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context,listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: order.fetchOrders().catchError((error) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('$error'),
              ),
            );
          }),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                    onRefresh: order.fetchOrders,
                    child: ListView.builder(
                        itemCount: order.order.length,
                        itemBuilder: (ctx, i) => OrderItems(order.order[i]),
                      ),
                  ),
        ));
  }
}
