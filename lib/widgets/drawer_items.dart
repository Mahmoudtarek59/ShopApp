import 'package:flutter/material.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("ShopApp"),
            automaticallyImplyLeading: false,//never add back button
          ),
          Divider(),
          ListTile(
            onTap: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>ProductsOverviewScreen())),
            leading: Icon(Icons.shop),
            title: Text("Shop"),
          ),
          ListTile(
            onTap: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>OrdersScreen())),
            leading: Icon(Icons.payment),
            title: Text("Orders"),
          ),
        ],
      ),
    );
  }
}
