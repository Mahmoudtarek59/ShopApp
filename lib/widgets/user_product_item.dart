import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  UserProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
//      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl),),
          title: Text(product.title),
          trailing: FittedBox(
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,), onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditProductScreen(EProduct: product,)));
                }),
                IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,), onPressed: (){
                  showDialog(context: context,builder: (context)=>AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to remove the item from the products?'),
                    actions: [
                      FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text('No')),
                      FlatButton(onPressed: (){
                        Provider.of<Products>(context,listen: false).deleteProduct(product);
                        Navigator.of(context).pop();}, child: Text('Yes')),
                    ],
                  ));

                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
