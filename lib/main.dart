import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './widgets/splach_screen.dart';
import './helpers/custom_route.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProduct) => Products(
                auth.token,
                auth.userId,
                previousProduct == null ? [] : previousProduct.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrder) => Orders(auth.token,
                auth.userId, previousOrder == null ? [] : previousOrder.orders),
          )
        ],
        child: Consumer<Auth>(
            builder: (
          ctx,
          auth,
          _,
        ) =>
                MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'JumanShop',
                  theme: ThemeData(
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange,
                    fontFamily: 'Lato',
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android:CustomPageTranseionBuilder() ,
                        TargetPlatform.iOS: CustomPageTranseionBuilder()
                      }
                    )
                  ),
                  home: auth.isAuth
                      ? ProductsOverviewScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) => 
                          authResultSnapshot.connectionState == ConnectionState.waiting?
                          SplashScreen()
                         : AuthScreen()),
                  routes: {
                    ProductDetailScreen.routeName: (ctx) =>
                        ProductDetailScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    OrdersScreen.routeName: (ctx) => OrdersScreen(),
                    UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                    EditProductScreen.routeName: (ctx) => EditProductScreen(),
                  },
                )));
  }
}
