import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/orderItem.dart';

import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapShot.error != null) {
                  return Text('There is something wrong');
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData , child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(orderData.orders[i])),
                  );
                }
              }
            }));
  }
}
