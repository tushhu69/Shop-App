import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routename = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your total',
                    style: TextStyle(fontSize: 20),
                  ),
                  //here spacer widget takes all the availablwe space
                  Spacer(),
                  //CHip is a typ eof Card ,there shows the total price in the app
                  Chip(
                    label: Text(
                      '\$${cart.totalaAmount.toStringAsPrecision(2)}',
                      style: TextStyle(
                          color:
                              // ignore: deprecated_member_use
                              Theme.of(context)
                                  .primaryTextTheme
                                  .headline1
                                  .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // ignore: deprecated_member_use
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //ListView  directly inside a coulmn doesn't work
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => Cartitem(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  quantity: cart.items.values.toList()[i].quantity,
                  price: cart.items.values.toList()[i].price,
                  title: cart.items.values.toList()[i].title),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: widget.cart.totalaAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addorder(
                  widget.cart.items.values.toList(), widget.cart.totalaAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
    );
  }
}
