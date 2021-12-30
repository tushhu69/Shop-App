import 'package:flutter/material.dart';
import 'package:sjop_app/screens/auth_screen.dart';
import 'package:sjop_app/screens/cart_screen.dart';
import 'package:sjop_app/screens/edit_product_screen.dart';
import 'package:sjop_app/screens/orders_screen.dart';
import 'package:sjop_app/screens/products_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/product_providers.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        //here if we want vasluies of other class like here we need Auth,then it (Auth) should be the first provide
        //if we are not using context in create in changenotifierprovider ,
        //we will use value inplace of create
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          update: (ctx, auth, previouisProducts) => ProductProvider(
              auth.token,
              previouisProducts == null ? [] : previouisProducts.items,
              auth.userId),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (ct) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousorders) => Orders(
              previousorders == null ? [] : previousorders.orders, auth.token),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SHOP App',
          theme: ThemeData(
            // appBarTheme: AppBarTheme(
            //     textTheme: TextTheme(title: TextStyle(color: Colors.red))),
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.deepOrangeAccent,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageRouteTranssions()
            }),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryautologin(),
                  builder: (ctx, authreslutsnapshot) =>
                      authreslutsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            OrdersScreen.routename: (ctx) => OrdersScreen(),
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartScreen.routename: (ctx) => CartScreen(),
            UserProduct.routename: (ctx) => UserProduct(),
            EditedProduct.routeName: (cxt) => EditedProduct(),
          },
        ),
      ),
    );
  }
}
