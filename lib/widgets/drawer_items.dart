import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/code/custom_route.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_products.dart';

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
            onTap: ()=>Navigator.of(context).pushReplacement(CustomRoute(builder: (_)=>ProductsOverviewScreen())),
            leading: Icon(Icons.shop),
            title: Text("Shop"),
          ),
          ListTile(
            onTap: ()=>Navigator.of(context).pushReplacement(CustomRoute(builder: (_)=>OrdersScreen())),
            leading: Icon(Icons.payment),
            title: Text("Orders"),
          ),
          ListTile(
            onTap: ()=>Navigator.of(context).pushReplacement(CustomRoute(builder: (_)=>UserProducts())),
            leading: Icon(Icons.edit),
            title: Text("My Products"),
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(CustomRoute(builder: (_)=>MyApp()));
              Provider.of<Auth>(context,listen: false).logout();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
