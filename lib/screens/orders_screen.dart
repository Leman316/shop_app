import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders.dart' show Orders;
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routename = '/orderscreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) =>
        Provider.of<Orders>(context, listen: false).fetchandSetProduct());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) =>
            OrderItem(order: orderData.orders[index]),
      ),
    );
  }
}
