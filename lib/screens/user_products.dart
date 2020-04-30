import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/widgets/drawer_items.dart';
import 'package:shopapp/widgets/user_product_item.dart';

class UserProdicts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EditProductScreen()))),
        ],
      ),
      drawer: DrawerItems(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: productsData.itemsData.length,
            itemBuilder: (context, index) => UserProductItem(
                  product: productsData.itemsData[index],
                )),
      ),
    );
  }
}
