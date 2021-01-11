import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 125, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Total Amount ${widget.order.amount}',
              ),
              subtitle: Text(
                  DateFormat('dd MM yyyy hh:mm').format(widget.order.datetime)),
              trailing: IconButton(
                icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height:
                  _expanded ? min(widget.order.products.length * 25.0, 100) : 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                //height: min(widget.order.products.length * 25.0 + 100, 150),
                child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('${prod.quantity}x \$${prod.price}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey))
                            ],
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
