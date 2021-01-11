import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeSingleItem(String prodID) {
    if (!_items.containsKey(prodID)) {
      return;
    }
    if (_items[prodID].quantity > 1) {
      _items.update(
          prodID,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    } else {
      _items.remove(prodID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
