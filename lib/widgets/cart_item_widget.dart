import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  CartItemWidget({@required this.cartItem});

  void removeItem(){

  }
  @override
  Widget build(BuildContext context) {
//    final cartItem = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(cartItem.id), //cart id to be unique
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
      ),
//      secondaryBackground: Container(
//        color: Colors.green,
//      ),
    direction: DismissDirection.endToStart,
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(cartItem.id);
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
