import 'package:flutter/cupertino.dart';

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

class Cart extends ChangeNotifier {
  Map<String, CartItem> _items = Map<String, CartItem>();

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    int count = 0;
    _items.forEach((productId, cartItem) {
      count += cartItem.quantity;
    });
//    return _items.length;
    return count;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((productId, cartItem) {
      total += (cartItem.price * cartItem.quantity);
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      //change quantity
      _items.update(
          productId,
          (cartItem) => CartItem(
                id: cartItem.id,
                title: cartItem.title,
                quantity: cartItem.quantity + 1,
                price: cartItem.price,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeProduct({String cartProductID}) {
    _items.remove(cartProductID);
    notifyListeners();
  }

  void removeSingleItem({String cartProductID}) {
    if (!_items.containsKey(cartProductID)) {
      return;
    }
    if (_items[cartProductID].quantity > 1) {
      _items.update(
          cartProductID,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
                price: existingCartItem.price,
              ));
    }else{
      removeProduct(cartProductID: cartProductID);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
