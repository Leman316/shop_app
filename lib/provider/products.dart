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

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldstatus = isFavorite;
    print(userId);
    final url =
        'https://flutter-project-37940-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final resp = await http.put(url,
          body: jsonEncode(
            isFavorite,
          ));

      if (resp.statusCode >= 400) {
        isFavorite = oldstatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldstatus;
      notifyListeners();
    }
  }
}
