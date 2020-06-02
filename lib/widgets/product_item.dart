import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final authData=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailScreen(item: item))),
          child: Hero(
            tag: item.id,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon:
                Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              item.toggleFavoriteStatus(authData.token,authData.userId);
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(item.id, item.title, item.price);
              Scaffold.of(context).hideCurrentSnackBar();//remove old snackBar
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart!',),
                action: SnackBarAction(label: 'UNDO',onPressed: (){
                  print('object');
                  cart.removeSingleItem(cartProductID: item.id);
                },),
                duration: Duration(seconds: 2),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
