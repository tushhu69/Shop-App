import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
//is used whej name clashes in imported classes like as,
//show keyword only will load or import  orders here
import '../widgets/ordereditems.dart';
import '../widgets/app_drawer.dart';

// ignore: must_be_immutable
class OrdersScreen extends StatelessWidget {
  static const routename = '/ordersscreen';

  // ignore: unused_field
  var _isLoading = false;
  @override
  //void initState() {
  // Future.delayed(Duration.zero).then((value) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await Provider.of<Orders>(context, listen: false).fetchandsetorders();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // });

  // // ignore: todo

  //super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('only 1 run');
    // final orderdata = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchandsetorders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('AnError Ocurred!!'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderdata, child) => ListView.builder(
                        itemBuilder: (ctx, i) =>
                            OrderItems(orderdata.orders[i]),
                        itemCount: orderdata.orders.length));
              }
            }
          },
        ));
  }
}
