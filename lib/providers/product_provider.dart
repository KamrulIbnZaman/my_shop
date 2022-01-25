import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './products.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];
  final String token;
  final String userId;
  Products(this.token, this.userId);
  List<Product> get items {
    return [..._items];
  }

  List<Product> get showOnlyFavorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findbyID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/products.json?auth=$token';

    try {
      final response = await http.post(url,
          body: json.encode({
            'creatorId': userId,
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      final responseData = json.decode(response.body);
      if (json.decode(response.body)['error'] != null) {
        throw responseData['error']['message'];
      }

      final _product = Product(
        id: responseData['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(_product);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = items.indexWhere((element) => element.id == id);
    final url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/products/$id.json?auth=$token';

    try {
      final response = await http.patch(url,
          body: json.encode({
            'creatorId': userId,
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      final responseData = json.decode(response.body);
      if (json.decode(response.body)['error'] != null) {
        throw responseData['error']['message'];
      }

      _items[index] = product;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteItem(String id) async {
    final url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    final existingProductIndex = _items.indexWhere(
      (element) => element.id == id,
    );
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items[existingProductIndex] = existingProduct;
      notifyListeners();
      throw 'Couldn\'t delete the product';
    }
    existingProduct = null;
  }

  Future<void> fetchProducts([bool filterProducts=false]) async {
    final filterText =
        filterProducts ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopping-d2457-default-rtdb.firebaseio.com/products.json?auth=$token&$filterText';
    try {
      final response = await http.get(
        url,
      );
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // print(responseData);
      if (responseData['error'] != null) {
        throw responseData['error']['massege'];
      }

      url =
          'https://shopping-d2457-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$token';
      final favResponse = await http.get(url);
      final favResponseData = jsonDecode(favResponse.body);

      List<Product> newProducts = [];
      responseData.forEach((key, value) {
        newProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite:
              favResponseData == null ? false : favResponseData[key] ?? false,
        ));
      });
      _items = newProducts;
      notifyListeners();
    } catch (er) {}
  }
}
