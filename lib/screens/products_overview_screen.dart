import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/code/dummy_data.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/drawer_items.dart';
import 'package:shopapp/widgets/product_item.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorite = false;

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(context);
    final products =
        _showFavorite ? loadedProduct.favoriteItems : loadedProduct.itemsData;
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showFavorite = true;
                } else {
                  _showFavorite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only Favorites'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Badge(
            child:
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: ()=>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CartScreen())),),
            value: Provider.of<Cart>(context).itemsCount.toString(),
          ),
        ],
      ),
      drawer: DrawerItems(),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ),
      ),

    );
  }
}
