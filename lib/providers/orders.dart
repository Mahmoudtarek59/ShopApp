import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];

  final String token;
  final String userId;
  Orders(this.token,this.userId,this._orders);

  Future<void> fetchingOrder() async {
    final url = 'https://shopapp-c506a.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      var response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);
      if(data ==null){
        return;
      }
      final List<OrderItem> loadedOrders = [];
      data.forEach((orderId, values) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: values['amount'],
          dateTime: DateTime.parse(values['dateTime']),
          products: (values['products'] as List<dynamic>)
              .map((cartProduct) => CartItem(
                  id: cartProduct['id'],
                  title: cartProduct['title'],
                  quantity: cartProduct['quantity'],
                  price: cartProduct['price']))
              .toList(),
        ));
        _orders=loadedOrders.reversed.toList();
        notifyListeners();
      });
    } catch (e) {}
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shopapp-c506a.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      var response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map((cProduct) => {
                      'id': cProduct.id,
                      'price': cProduct.price,
                      'quantity': cProduct.quantity,
                      'title': cProduct.title,
                    })
                .toList(),
          }));
      print(json.decode(response.body).toString());
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()),
      ); //to add last order top of the list
//    Provider.of<Cart>(context).clear();
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
