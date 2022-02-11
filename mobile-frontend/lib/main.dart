import 'package:clone_zay_chin/data_models/auth.dart';
import 'package:clone_zay_chin/pages/auth_page.dart';
import 'package:clone_zay_chin/pages/cart_page.dart';
import 'package:clone_zay_chin/pages/checkout_complete_page.dart';
import 'package:clone_zay_chin/pages/checkout_page.dart';
import 'package:clone_zay_chin/pages/home_page.dart';
import 'package:clone_zay_chin/pages/new_order_detail_page.dart';
import 'package:clone_zay_chin/pages/order_detail_page.dart';
import 'package:clone_zay_chin/pages/order_finished_page.dart';
import 'package:clone_zay_chin/pages/order_list_page.dart';
import 'package:clone_zay_chin/pages/order_status_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:clone_zay_chin/data_models/cart.dart';

void main() async {
  print('start main');
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  final HttpLink httpLink =
      HttpLink(dotenv.env['GRAPH_URL'] ?? "http://localhost:4000/graphql");

  CartModel storeModel = CartModel();
  AuthModel authModel = AuthModel();

  await authModel.loadToken();

  final AuthLink authLink = AuthLink(getToken: () => authModel.token);

  final link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore())));

  var rootWidget = MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: storeModel,
        ),
        ChangeNotifierProvider.value(value: authModel)
      ],
      child: GraphQLProvider(
        client: client,
        child: MyApp(),
      ));

  runApp(rootWidget);

  print('finish');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zay Wal',
      theme: ThemeData(
        primaryColor: Color(0xFFEAEDEF),
        // scaffoldBackgroundColor: Color(0xFFEFEFD0))
        // primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        AuthPage.route: (context) => AuthPage(),
        CartPage.route: (context) => CartPage(),
        CheckOutCompletePage.route: (context) => CheckOutCompletePage(),
        CheckOutPage.route: (context) => CheckOutPage(),
        NewOrderDetailPage.route: (context) => NewOrderDetailPage(),
        OrderFinishedPage.route: (context) => OrderFinishedPage(),
        OrderStatusPage.route: (context) => OrderStatusPage(),
        OrderListPage.route: (context) => OrderListPage(),
        OrderDetailPage.route: (context) => OrderDetailPage(),
      },
    );
  }
}
