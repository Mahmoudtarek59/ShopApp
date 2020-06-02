import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
//  List<Product> _items = DUMMY_PRODUCTS;
  List<Product> _items = [];
  final String token;
  final String userId;
  Products(this.token,this.userId,this._items);


  Future<void> fetchData([bool filterByUser=false]) async {
    final String filter= filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
    final url = 'https://shopapp-c506a.firebaseio.com/products.json?auth=$token&$filter';
    try {
      var response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);
      if(data ==null){
        return;
      }
      final favoriteUrl= 'https://shopapp-c506a.firebaseio.com/userFavorites/$userId.json?auth=$token';
      var favResponse= await http.get(favoriteUrl);
      final favoriteData=json.decode(favResponse.body);

      final List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
//        print(prodId);
//        print(prodData['title']);
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: favoriteData == null?false:favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List<Product> get itemsData {
//    fetchData();
    return [
      ..._items
    ]; //to return copy , can't change it anywhere , you can use item
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> addProduct(Product item) async {
    final url = 'https://shopapp-c506a.firebaseio.com/products.json?auth=$token';
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'imageUrl': item.imageUrl,
          'price': item.price,
          'creatorId':userId,
        }),
      ); //response return with map {name : id}

      print(json.decode(response.body));
      _items.add(Product(
        //to add product after store in server
        id: json.decode(response.body)['name'],
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        description: item.description,
      ));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(Product item) async {
    final url = 'https://shopapp-c506a.firebaseio.com/products/${item.id}.json?auth=$token';
    final productIndex = _items.indexWhere((element) => element.id == item.id);
    try {
      await http.patch(url,
          body: json.encode({
            'description': item.description,
            'imageUrl': item.imageUrl,
            'price': item.price,
            'title': item.title,
          }));
    } catch (e) {
      print(e);
    }
    _items[productIndex] = item;
    notifyListeners();
  }

  Future<bool> deleteProduct(Product item) async {
    final url = 'https://shopapp-c506a.firebaseio.com/products/${item.id}.json?auth=$token';
    final productIndex = _items.indexWhere((element) => element.id == item.id);
    var existingProduct=_items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response= await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(productIndex, existingProduct);
        notifyListeners();
        return false;
      }

      existingProduct=null;
      return true;
  }
}
