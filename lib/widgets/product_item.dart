import 'package:flutter/material.dart';
import '../screens/products_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(
  //   this.id,
  //   this.imageUrl,
  //   this.title,
  // );
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final datatoken = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.togglefavstatus(datatoken.token, datatoken.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              //scaffold is used to control hte whole page, using it with of(content) it reaches out to the nearest scaffold (like nearest 0parent)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item Added to Cart!!'),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      cart.removrSingle(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
