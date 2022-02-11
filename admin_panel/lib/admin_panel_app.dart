import 'package:admin_panel/dashboard.dart';
import 'package:admin_panel/models/order.dart';
import 'package:admin_panel/order_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum CurrentView {
  dashboard,
  order,
}

class AdminPanelApp extends StatefulWidget {
  const AdminPanelApp({Key? key}) : super(key: key);

  @override
  State<AdminPanelApp> createState() => _AdminPanelAppState();
}

class _AdminPanelAppState extends State<AdminPanelApp> {
  CurrentView currentView = CurrentView.dashboard;

  Widget _buildSidePanel() {
    switch (currentView) {
      case CurrentView.dashboard:
        return const Dashboard();
      case CurrentView.order:
        return const OrderPanel();
      default:
        return const Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Row(
        children: [
          Drawer(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    setState(() {
                      currentView = CurrentView.dashboard;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Orders'),
                  onTap: () {
                    setState(() {
                      currentView = CurrentView.order;
                    });
                  },
                )
              ],
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          _buildSidePanel(),
        ],
      ),
    );
  }
}
