import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> cart;
  final DateTime orderDate;

  OrderItem(this.id, this.price, this.cart, this.orderDate);
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String _userId;
  Order(this.token, this._userId, this._orders);

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> addtoOrder(List<CartItem> cart, double total) async {
    final url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$token';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'product': cart
                .map((tp) => {
                      'id': tp.id,
                      'title': tp.title,
                      'price': tp.price,
                      'quantity': tp.quantity,
                    })
                .toList(),
            'time': timeStamp.toIso8601String(),
          }));
          notifyListeners();
    } catch (error) {}
    // _orders.insert(0, OrderItem(DateTime.now().toString(), total, cart));

    // notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$token';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['error']!=null) {
        throw responseData['error']['message'];
      }
      List<OrderItem> loadedOrders=[];
      responseData.forEach((id, orderData) {
        loadedOrders.add(
          OrderItem(
            id,
            orderData['amount'],
            (orderData['product'] as List<dynamic>)
                .map(
                  (prod) => CartItem(
                    prod['id'],
                    prod['title'],
                    prod['price'],
                    prod['quantity'],
                  ),
                )
                .toList(),
            DateTime.parse(orderData['time']),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
