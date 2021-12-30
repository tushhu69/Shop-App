import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjop_app/providers/product_providers.dart';
import 'package:sjop_app/widgets/app_drawer.dart';

import '../widgets/User_product_item.dart';
import './edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  static const routename = '/Userproduct';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchandsetproducts();
  }

  Widget build(BuildContext context) {
    final productsdata = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your product!!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditedProduct.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return refreshProducts(context);
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(children: [
              UserProductItem(
                id: productsdata.items[i].id,
                imageurl: productsdata.items[i].imageUrl,
                title: productsdata.items[i].title,
              ),
              Divider(
                color: Theme.of(context).accentColor,
              )
            ]),
            itemCount: productsdata.items.length,
          ),
        ),
      ),
    );
  }
}
