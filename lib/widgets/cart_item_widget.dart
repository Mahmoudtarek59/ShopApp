import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final String productID;
  CartItemWidget({@required this.cartItem, @required this.productID});

  void removeItem() {}
  @override
  Widget build(BuildContext context) {
//    final cartItem = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(cartItem.id), //cart id to be unique
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
//      secondaryBackground: Container(
//        color: Colors.green,
//      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context,builder: (context)=>AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove the item from the cart?'),
          actions: [
            FlatButton(onPressed: ()=>Navigator.of(context).pop(false), child: Text('No')),
            FlatButton(onPressed: ()=>Navigator.of(context).pop(true), child: Text('Yes')),
          ],
        ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeProduct(cartProductID: productID);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$${cartItem.price}')),
              ),
            ),
            title: Text('${cartItem.title}'),
            subtitle: Text('Total: \$${cartItem.price * cartItem.quantity}'),
            trailing: Text('${cartItem.quantity} X'),
          ),
        ),
      ),
    );
  }
}
