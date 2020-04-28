import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/providers/orders.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemWidget({@required this.orderItem});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                }),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 10.0 , 160), //minimum height fit values
              child: ListView(
                children: widget.orderItem.products.map((product) => Row(
                  children: [
                    Text('${product.title}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Text('${product.quantity}X \$${product.price}',style: TextStyle(fontSize: 18,color: Colors.grey),),
                  ],
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
