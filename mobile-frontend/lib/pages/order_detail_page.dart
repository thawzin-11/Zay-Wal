import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);
  static const route = '/orderdetail';

  @override
  Widget build(BuildContext context) {
    var orderId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail for $orderId'),
      ),
      body: Center(
        child: Text('Order Detail Page for orderId $orderId'),
      ),
    );
  }
}
