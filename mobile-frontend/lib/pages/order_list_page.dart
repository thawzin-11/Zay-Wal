import 'package:clone_zay_chin/pages/order_detail_page.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatelessWidget {
  OrderListPage({Key? key}) : super(key: key);
  static const route = '/orders';
  final orders = [
    {'id': '1', 'name': 'order1', 'summary': 'order1 summary'},
    {'id': '2', 'name': 'order2', 'summary': 'order2 summary'},
    {'id': '3', 'name': 'order3', 'summary': 'order3 summary'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: ListView(
          children: [
            ...orders
                .map((order) => ListTile(
                      title: Text(order['name']!),
                      subtitle: Text(order['summary']!),
                      onTap: () {
                        Navigator.of(context).pushNamed(OrderDetailPage.route,
                            arguments: order['id']!);
                      },
                    ))
                .toList()
          ],
        ));
  }
}
