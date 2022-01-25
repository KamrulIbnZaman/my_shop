import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/product_provider.dart';
import './screen/product_overview_screen.dart';
import './screen/product_detail_screen.dart';
import './providers/cart.dart';
import './screen/cart_screen.dart';
import './providers/orders.dart';
import './screen/orde_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/user_product_overview.dart';
import './screen/auth_screen.dart';
import './providers/auth.dart';
import './screen/intro_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (context, auth, prevOrder) => Order(
            auth.token,
            auth.userId,
            prevOrder == null ? [] : prevOrder.order,
          ),
        )
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'My Shop',
                theme: ThemeData(
                  primarySwatch: Colors.red,
                  accentColor: Colors.yellowAccent,
                ),
                home: auth.isAuth ? ProductOverViewScreen() : FutureBuilder(
                  future: auth.autoLogin(),
                  builder:(context, snapShot)=> 
                  snapShot.connectionState==ConnectionState.waiting? IntroScreen():
                   AuthScreen()),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrderScreen.routName: (ctx) => OrderScreen(),
                  UserProductOverview.routeName: (ctx) => UserProductOverview(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                },
              )),
    );
  }
}
