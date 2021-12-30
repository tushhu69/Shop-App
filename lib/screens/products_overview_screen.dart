import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjop_app/providers/product_providers.dart';
import 'package:sjop_app/screens/cart_screen.dart';
import '../widgets/21.2 badge.dart';
import '../widgets/product_grid.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

// ignore: must_be_immutable
enum FiltersOption {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavorite = false;
  var _isinit = true; //to make didchangesdependices run only onece
  var _isloading = false;
  var _isError = false;
  @override
//   void initState() {
// //here we can not use of(context) directly in intisTATE BUT**** if we use listen:false  then we can use it
// //Provider.of<ProductProvider>(context).fetchandsetproducts();
//using Future.delayed will laso reslove the problem,****if we use listen false w\then we dont need Future.delayed
//     Future.delayed(Duration.zero).then((_) =>
//         Provider.of<ProductProvider>(context, listen: false)
//             .fetchandsetproducts());
//     super.initState();
//   }

  @override
  //this can also be used in place of initState()
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });

      Provider.of<ProductProvider>(context).fetchandsetproducts().then((_) {
        print('no error');
        setState(() {
          _isloading = false;
        });
      }).catchError((error) {
        setState(() {
          _isloading = false;
          _isError = true;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final show = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FiltersOption x) {
              setState(() {
                if (x == FiltersOption.Favorite) {
                  show.showFavorite = true;
                } else {
                  show.showFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isError
          ? Center(
              child: Text('An Error Ocurred!!!'),
            )
          : _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ProductGrid(show.showFavorite),
    );
  }
}
