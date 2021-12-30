import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItems {
  final String title;
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItems({this.amount, this.datetime, this.id, this.products, this.title});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders;
  final String authToken;
  Orders(this._orders, this.authToken);
  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchandsetorders() async {
    print('i ran');
    final url = Uri.parse(
        'https://shop-app-1f3ec-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final res = await http.get(url);

    final List<OrderItems> loadorders = [];
    final extracted =
        json.decode(res.body) as Map<String, dynamic>; //here dynamic is a map<>
    if (extracted == null) {
      return;
    }

    extracted.forEach((orderId, orderData) {
      loadorders.add(OrderItems(
        id: orderId,
        amount: orderData['amount'],
        datetime: DateTime.parse(orderData['datetime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (f) => CartItem(
                  id: f['id'],
                  price: f['price'],
                  quantity: f['quantity'],
                  title: f['title']),
            )
            .toList(),
      ));
      _orders = loadorders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addorder(
    List<CartItem> cartproducts,
    double total,
  ) async {
    final timestamp = DateTime.now();
    final url = Uri.parse(
        'https://shop-app-1f3ec-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'datetime': timestamp.toIso8601String(),
        'products': cartproducts
            .map((element) => {
                  'id': element.id,
                  'quantity': element.quantity,
                  'title': element.title,
                  'price': element.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItems(
        //title: titile,
        id: json.decode(response.body)['name'],
        amount: total,
        datetime: timestamp,
        products: cartproducts,
      ),
    );
    notifyListeners();
  }
}
