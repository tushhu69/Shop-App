import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_providers.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;
  UserProductItem({this.id, this.imageurl, this.title});
  @override
  Widget build(BuildContext context) {
    final scaf = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      //here backgroundimage does not takes Image.neteor type(that is wodget),it does not takes widgets,
      //rather it takes a provider that yeilds a image
      //here on Networkimage we cant set up fit or anything beacause it is not a widget it is a provider
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditedProduct.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .deleteproduct(id);
                } catch (error) {
                  //here we can not use Scaffold inside a future,because of(context) updates the tree, it doesn't wait
                  //so to resolve this store Scaffold.of(context) inside someother variable
                  // ignore: deprecated_member_use
                  scaf.showSnackBar(
                      SnackBar(content: Text('Deleting Failed!!')));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
