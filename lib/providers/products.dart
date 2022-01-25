import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String userId, String token) async {
    final url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/favoriteData/$userId/$id.json?auth=$token';
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      print(response.statusCode);
      if (response.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();

      }
    } catch (error) {
      isFavorite = oldFavorite;
      notifyListeners();
      throw error;
    }
  }
}
