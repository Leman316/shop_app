import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import 'products.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  Product findbyId(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get items {
    return [..._items];
  }

  final String authtoken;
  final String userId;
  Products(this.authtoken, this.userId, this._items);

  Future<void> fetchandSetProduct() async {
    var url =
        'https://flutter-project-37940-default-rtdb.firebaseio.com/products.json?auth=$authtoken';

    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      List<Product> loadedproducts = [];
      if (extractedData == null) return;

      url =
          'https://flutter-project-37940-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authtoken';
      final favresponse = await http.get(url);
      final favdata = jsonDecode(favresponse.body);
      extractedData.forEach((key, value) {
        //  print(key);
        loadedproducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: favdata == null ? false : favdata[key] ?? false,
        ));
      });
      _items = loadedproducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product prod) async {
    final url =
        'https://flutter-project-37940-default-rtdb.firebaseio.com/products.json?auth=$authtoken';

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': prod.title,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
            //  'isFavorite': prod.isFavorite,
          }));

      print(jsonDecode(response.body));
      final newproduct = Product(
          id: jsonDecode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);

      _items.add(newproduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    //
  }

  Future<void> updateProduct(String id, Product newprod) async {
    final index = _items.indexWhere((element) => element.id == id);
    print(' Yo $id');
    print(index);
    if (index >= 0) {
      final url =
          'https://flutter-project-37940-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';

      await http.patch(url,
          body: jsonEncode({
            'title': newprod.title,
            'description': newprod.description,
            'price': newprod.price,
            'imageUrl': newprod.imageUrl,
          }));
      _items[index] = newprod;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    //  _items.removeWhere((element) => element.id == id);

    final url =
        'https://flutter-project-37940-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';

    final existingProdIndex = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);

      notifyListeners();
      throw HttpException('Could not delete.');
    }
    existingProd = null;
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }
}
