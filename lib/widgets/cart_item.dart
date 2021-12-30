import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class Cartitem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;
  Cartitem({
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      //confrimDissmiss need a futre type in return ,and herer show Dialouge returns a
      //future so we will return the result of
      //of show Dialouge or simply return show Dialouge
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do yo u want to remove item from the cart?'),
            // ignore: deprecated_member_use
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  //here navigator.pop()will pop the dialouge and return type passed to it,
                  //i  this case it is false and true
                  Navigator.of(context).pop(false);
                },
                child: Text('NO'),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('YES'))
            ],
          ),
        );
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
        padding: EdgeInsets.only(right: 20),
      ),
      //here onDissmissed give the direction of tyhe the sliding ir dissmissing the value as a parameter
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeId(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: FittedBox(child: Text('\$$price'))),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
