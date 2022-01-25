import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem(
    this.id,
    this.title,
    this.price,
    this.quantity,
  );
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  int get itemCount {
    return _cart.length;
  }

  double get totalAmount {
    double total = 0.0;
    cart.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addtoCart(String id, String title, double price) {
    if (_cart.containsKey(id)) {
      _cart.update(
        id,
        (value) => CartItem(
          value.id,
          value.title,
          value.price,
          value.quantity + 1,
        ),
      );
    } else {
      _cart.putIfAbsent(
          id,
          () => CartItem(
                DateTime.now().toString(),
                title,
                price,
                1,
              ));
    }
    notifyListeners();
  }

  void rmoveItem(String id) {
    _cart.remove(id);
    notifyListeners();
  }

  void clear() {
    _cart = {};
    notifyListeners();
  }

  void removeSingleProduct(String id) {
    final index = _cart.containsKey(id);
    if (!index) {
      return;
    }
    if (_cart[id].quantity == 1) {
      _cart.remove(id);
      notifyListeners();
    }
    if (_cart[id].quantity > 2) {
      _cart.update(
          id,
          (value) => CartItem(
                value.id,
                value.title,
                value.price,
                value.quantity - 1,
              ));
    }
    notifyListeners();
  }
}
