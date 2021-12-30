import 'package:flutter/material.dart';
import '../providers/product_providers.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final showfav;
  ProductGrid(this.showfav);
  // @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<ProductProvider>(context);
    final product = productsdata.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: product[index],
        child: ProductItem(
            // product[index].id,
            // product[index].imageUrl,
            // product[index].title,
            ),
      ),
      itemCount: product.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
