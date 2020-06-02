import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
//        ChangeNotifierProvider<Products>(
//          create: (context) => Products(),
//        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          //use proxy when provider depends on another provider here products depends on auth
//          create: (_)=>Products(),
          update: (_, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null
                  ? List<Product>()
                  : previousProducts.itemsData),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
//        ChangeNotifierProvider(
//          create: (context) => Orders(),
//        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (_, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null
                    ? List<OrderItem>()
                    : previousOrders.orders)),
      ],
      child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'MyShop',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: "Lato",
                ),
                home: auth.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.autoLogIn(),
                        builder: (context, dataSnapshot) =>
                            dataSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SpalshScreen()
                                : AuthScreen()),
              )),
    );
  }
}
