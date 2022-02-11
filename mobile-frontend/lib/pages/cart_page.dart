import 'package:clone_zay_chin/auth/auth.dart';
import 'package:clone_zay_chin/data_models/auth.dart';
import 'package:clone_zay_chin/data_models/cart.dart';
import 'package:clone_zay_chin/pages/auth_page.dart';
import 'package:clone_zay_chin/pages/checkout_page.dart';
import 'package:clone_zay_chin/pages/home_page.dart';
import 'package:clone_zay_chin/pages/new_order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  static const route = '/cart';

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(builder: (context, cartModel, child) {
      Card _buildItemCart(CartItem cartItem) {
        return Card(
            child: ListTile(
                leading: Image(
                  image: NetworkImage(cartItem.product.image),
                ),
                title: Text(cartItem.product.name),
                subtitle: Text(cartItem.product.price.toString() + ' Ks'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          cartModel.removeProduct(cartItem.product);
                        },
                        icon: Icon(Icons.remove)),
                    Text(cartItem.count.toString()),
                    IconButton(
                        onPressed: () {
                          cartModel.addProduct(cartItem.product);
                        },
                        icon: Icon(Icons.add))
                  ],
                )));
      }

      Row _buildBottomSheetRow(CartModel cartModel) {
        print('cartModel=');
        return Row(
          children: [
            Expanded(
                child: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Divider(
                    thickness: 1,
                    height: 1,
                    indent: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Cart'),
                      Icon(Icons.arrow_forward_ios),
                      Text('Checkout'),
                      Icon(Icons.arrow_forward_ios),
                      Text('Success')
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  Text(cartModel.totalPrice.toString() + ' Ks'),
                  ElevatedButton(
                    onPressed: () async {
                      var authModel =
                          Provider.of<AuthModel>(context, listen: false);
                      if (!authModel.isLoggedIn()) {
                        // perform authentication procedure

                        performLogin(context, authModel);

                        //continue
                        Navigator.pushNamed(context, NewOrderDetailPage.route);
                      } else {
                        Navigator.pushNamed(context, NewOrderDetailPage.route);
                      }
                    },
                    child: Text('Continue to checkout'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(350, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              ),
            )),
          ],
        );
      }

      Center _buildEmptyItemCart(BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_shopping_cart_outlined,
                size: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Your cart is empty'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);
                },
                child: Text('Continue Shopping'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
        );
      }

      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Cart',
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
            ],
          ),
          body: ListView(
            children: cartModel
                .getCartItems()
                .map((cartItem) => _buildItemCart(cartItem))
                .toList(),
          ),
          bottomNavigationBar: cartModel.selectedProductOrNot()
              ? _buildEmptyItemCart(context)
              : _buildBottomSheetRow(cartModel));
    });
  }
}
