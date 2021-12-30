import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjop_app/providers/product_providers.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';

  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedproduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedproduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedproduct.title),
              background: Hero(
                tag: loadedproduct.id,
                child: Image.network(
                  loadedproduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedproduct.price}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text(
                  loadedproduct.description,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
/*listen:....if we set it to "false" then the widget will not rebuild if some thing is changes
if it is true then all the Provider users will rebuild 
here we set it to false because the title ni app bar will not change uif something si changed uit there */
