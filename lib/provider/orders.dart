import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:shop_app/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double price) async {
    final url =
        'https://flutter-project-37940-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final timestamp = DateTime.now();
    print(price);
    final resp = await http.post(url,
        body: jsonEncode({
          'amount': price,
          'datetime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  })
              .toList(),
        }));
    print(resp.body);
    _orders.insert(
        0,
        OrderItem(
            id: jsonDecode(resp.body)['name'],
            amount: price,
            products: cartProducts,
            datetime: timestamp));

    notifyListeners();
  }

  Future<void> fetchandSetProduct() async {
    final url =
        'https://flutter-project-37940-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      List<OrderItem> loadedorders = [];
      if (extractedData == null) return;
      extractedData.forEach((key, value) {
        //  print(key);
        loadedorders.add(OrderItem(
          id: key,
          amount: value['amount'],
          datetime: DateTime.parse(value['datetime']),
          products: (value['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price']))
              .toList(),
        ));
        // print('ss $loadedorders');
      });
      _orders = loadedorders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
