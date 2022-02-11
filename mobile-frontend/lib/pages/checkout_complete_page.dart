import 'package:clone_zay_chin/data_models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutCompletePage extends StatelessWidget {
  const CheckOutCompletePage({Key? key}) : super(key: key);
  static const route = '/checkout-complete';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Thanks You For Your Order! \n ZayWal Team Will Contact To You Soon.'),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Provider.of<CartModel>(context, listen: false).clearCart();
              },
              child: Text('Continue to Shopping'),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            )
          ],
        ),
      ),
    );
  }
}
