import 'package:flutter/cupertino.dart';
import 'package:shopapp/code/dummy_data.dart';
import 'package:shopapp/providers/product.dart';


class Products extends ChangeNotifier{
  List<Product> _items=DUMMY_PRODUCTS;

  List<Product> get itemsData{
    return [..._items];//to return copy , can't change it anywhere , you can use item
  }

  List<Product> get favoriteItems{
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  void addProduct(Product item){
    _items.add(item);
    notifyListeners();
  }

  void updateProduct(Product item){
    final productIndex=_items.indexWhere((element) => element.id==item.id);
//    if(productIndex>=0){
      _items[productIndex]=item;
      notifyListeners();

//    }
 }

 void deleteProduct(Product item){
   final productIndex=_items.indexWhere((element) => element.id==item.id);
   _items.removeAt(productIndex);
   notifyListeners();
 }

}