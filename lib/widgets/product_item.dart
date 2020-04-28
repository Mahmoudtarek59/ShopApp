import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Product item=Provider.of<Product>(context);
    Cart cart=Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDetailScreen(item: item))),
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(item.isFavorite?Icons.favorite:Icons.favorite_border),
            onPressed: () {
              item.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(item.id,item.title, item.price);
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
