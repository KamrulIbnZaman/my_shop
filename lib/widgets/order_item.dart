import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/orders.dart';

class OrderItems extends StatefulWidget {
  final OrderItem order;

  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded?min(widget.order.cart.length * 20.0 + 110, 200): 80,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Column(
          children: [
            ListTile(
                title: Text('\$${widget.order.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                    icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    })),
              AnimatedContainer(
                  duration: Duration(milliseconds: 305),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  height: expanded? min(widget.order.cart.length * 20.0 + 10, 70):0,
                  child: ListView(
                      children: widget.order.cart
                          .map(
                            (pod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${pod.title}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('${pod.quantity}x\$${pod.price}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          )
                          .toList()),
                ),
            
          ],
        ),
      ),
    );
  }
}
