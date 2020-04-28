import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalPrice.toStringAsFixed(2)}',style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(onPressed: (){
                    Provider.of<Orders>(context,listen: false).addOrder(cartData.items.values.toList(), cartData.totalPrice);
                    cartData.clear();
                  }, child: Text('ORDER NOW'),textColor: Theme.of(context).primaryColor,),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(itemCount: cartData.items.length,itemBuilder: (context,index){
            return CartItemWidget(cartItem: cartData.items.values.toList()[index],);//convert map to list
          },)),
        ],
      ),
    );
  }
}
