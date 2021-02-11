import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavValues(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url =
          'https://my-shop-project-flutter-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _setFavValues(oldStatus);
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
