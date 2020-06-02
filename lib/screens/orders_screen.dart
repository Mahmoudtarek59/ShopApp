import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/drawer_items.dart';
import 'package:shopapp/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: DrawerItems(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchingOrder(),
          builder: (context, dataSnapshot) {

            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                final ordersData = Provider.of<Orders>(context);
                return ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (context, index) => OrderItemWidget(
                    orderItem: ordersData.orders[index],
                  ),
                );
              }
            }
          }),
    );
  }
}
