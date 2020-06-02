import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class Product extends ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; // not final because it is changeable anytime

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(String token,String userId)async{
    final oldStatus =isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url= 'https://shopapp-c506a.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try{
      final response=await http.put(url,body: json.encode(
        isFavorite,
      ));
      if(response.statusCode>=400){
        isFavorite=oldStatus;
        notifyListeners();
      }
    }catch(e){
      isFavorite=oldStatus;
      notifyListeners();
    }
  }
}
