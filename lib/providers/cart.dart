import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double prices, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (exitstingCartIrem) => CartItem(
              id: exitstingCartIrem.id,
              title: exitstingCartIrem.title,
              price: exitstingCartIrem.price,
              quantity: exitstingCartIrem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: prices,
              quantity: 1));
    }

    notifyListeners();
  }

  void removeItem(String prouductId) {
    _items.remove(prouductId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (exeitinCartIem) => CartItem(
              id: exeitinCartIem.id,
              title: exeitinCartIem.title,
              quantity: exeitinCartIem.quantity - 1,
              price: exeitinCartIem.price));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
