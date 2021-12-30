import 'package:flutter/foundation.dart';

class CartItem {
  final String title;
  final String id;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalaAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length == null ? 0 : _items.length;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          //here in update we are provided with the exisngkey beforehand in flutter
          (existingProductId) => CartItem(
                id: existingProductId.id,
                price: existingProductId.price,
                quantity: existingProductId.quantity + 1,
                title: existingProductId.title,
              ));
    } else {
      //.putifAbesent takes an key and a function to add the new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeId(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removrSingle(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          title: existingCartItem.title,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
