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
    @required this.imageUrl,
    @required this.description,
    @required this.id,
    this.isFavorite = false,
    @required this.price,
    @required this.title,
  });
  void _setFav(bool newfav) {
    isFavorite = newfav;
    notifyListeners();
  }

  void togglefavstatus(String token, String userId) async {
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-1f3ec-default-rtdb.firebaseio.com/userfav/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        // isFavorite = oldstatus;
        // notifyListeners();
        _setFav(oldstatus);
      }
    } catch (error) {
      _setFav(oldstatus);
    }
  }
}
