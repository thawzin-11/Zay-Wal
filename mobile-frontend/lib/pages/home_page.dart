import 'package:clone_zay_chin/auth/auth.dart';
import 'package:clone_zay_chin/data_models/auth.dart';
import 'package:clone_zay_chin/data_models/cart.dart';
import 'package:clone_zay_chin/pages/cart_page.dart';
import 'package:clone_zay_chin/components/category_view.dart';
import 'package:clone_zay_chin/components/home_view.dart';
import 'package:clone_zay_chin/pages/order_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMenu extends StatelessWidget {
  HomeMenu(
      {Key? key, required this.homeMenuItems, required this.homeMenuActions})
      : super(key: key);
  final List<String> homeMenuItems;
  final List<Function()> homeMenuActions;

  @override
  Widget build(BuildContext context) {
    //converting homeMenuItems and homeMenuActions to widgets.
    final List<Widget> menus = [];
    for (var i = 0; i < homeMenuItems.length; i++) {
      menus.add(TextButton(
          onPressed: homeMenuActions[i], child: Text(homeMenuItems[i])));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: menus);
  }
}

class HomePage extends StatefulWidget {
  static const route = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      HomeView(),
      CategoryView(),
      MenuView(),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Zay Wal'),
          actions: [
            IconButton(
                onPressed: () {
                  print('search button');
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartPage.route);
                  print('shopping cart button');
                },
                icon: Icon(Icons.shopping_cart))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu')
          ],
        ),
        body: Center(child: widgetOptions.elementAt(selectedIndex)));
  }
}

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MenuView Depends on AuthModel
    return Consumer<AuthModel>(builder: (context, authModel, widget) {
      return authModel.isLoggedIn()
          ? HomeMenu(
              homeMenuItems: ['Profile', 'Your Orders', 'Logout'],
              homeMenuActions: [
                () {},
                () {
                  Navigator.of(context).pushNamed(OrderListPage.route);
                },
                () {}
              ],
            )
          : HomeMenu(homeMenuItems: [
              'Login'
            ], homeMenuActions: [
              () {
                performLogin(context, authModel);
              }
            ]);
    });
  }
}
