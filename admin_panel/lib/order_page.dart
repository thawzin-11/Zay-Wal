import 'package:admin_panel/models/address.dart';
import 'package:admin_panel/models/order.dart';
import 'package:admin_panel/models/product.dart';
import 'package:admin_panel/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OrderPanel extends StatefulWidget {
  const OrderPanel({Key? key}) : super(key: key);

  @override
  State<OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<OrderPanel> {
  List<Product> products = [];
  late Address address;

  @override
  Widget build(BuildContext context) {
    String orderQuery = """
        query Query {
          orders {
            _id
            status
            customerName
            deliveryPhNumber
            address {
              houseOrApartmentNo
              streetNo
              quarter
              township
              city
            }
            deliveryDate
            paymentMethod
            promoCode
            note
            products {
              productId
              name
              description
              priceUnit
              price
              image
              qty
            }
          }
        }
      """;

    return Query(
      options: QueryOptions(document: gql(orderQuery)),
      builder: (QueryResult result, {refetch, fetchMore}) {
        if (result.isLoading) {
          return const Center(
            child: Text('Loading'),
          );
        }

        if (result.source != null) {
          List results = result.data?['orders'];
          List<Order> orders =
              results.map((each) => Order.fromJson(each)).toList();

          // print(results);
          // print(orders);
          return Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: OrderTable(
                  orders: orders,
                )),
          );
        }
        return const Text('Dummy');
      },
    );
  }
}

// Row _builElevatedButton() {
//   return Row(
//     children: [
//       ElevatedButton(
//         onPressed: () {},
//         child: const Text("Back"),
//       )
//     ],
//   );
// }

// List<DataColumn> _buildOrderDetailDataColumn() {
//   return const [
//     DataColumn(
//       label: Text('Product Name'),
//     ),
//     DataColumn(
//       label: Text('PriceUnit'),
//     ),
//     DataColumn(
//       label: Text('Price'),
//     ),
//     DataColumn(
//       label: Text('Street No'),
//     ),
//     DataColumn(
//       label: Text('Township'),
//     ),
//   ];
// }

// List<DataRow> _buildOrderDetailDataRow(
//     List<Product> products, Address address) {
//   List<DataRow> listsOfDataRow = products.map(
//     (product) {
//       return DataRow(
//         cells: [
//           DataCell(
//             Text(product.name),
//           ),
//           DataCell(
//             Text(product.priceUnit),
//           ),
//           DataCell(
//             Text(
//               product.price.toString(),
//             ),
//           ),
//           DataCell(
//             Text(address.streetNo),
//           ),
//           DataCell(
//             Text(address.township),
//           ),
//         ],
//       );
//     },
//   ).toList();
//   return listsOfDataRow;
// }

// Row _buildRow() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Column(
//         children: const [
//           Text('Subtotal'),
//           Text('Shipping & Handling'),
//           Text('Discount'),
//           Text('Tax')
//         ],
//       ),
//       const SizedBox(
//         width: 20,
//       ),
//       Column(
//         children: [
//           Text(_getTotalAmt().toString() + ' MMK'),
//           const Text('0 MMK'),
//           const Text('0 MMK'),
//           const Text('150 MMK')
//         ],
//       ),
//     ],
//   );
// }

// int _getTotalAmt() {
//   int value = 0;
//   for (var element in products) {
//     value += element.price;
//   }
//   return value;
// }

class OrderTable extends StatelessWidget {
  const OrderTable({Key? key, required this.orders}) : super(key: key);

  final List<Order> orders;

  List<DataColumn> _buildOrderDataColumn() {
    return const [
      DataColumn(
        label: Text('ID'),
      ),
      DataColumn(
        label: Text('Status'),
      ),
      DataColumn(
        label: Text('Customer Name'),
      ),
      DataColumn(
        label: Text('Delivery PhNumber'),
      ),
      DataColumn(
        label: Text('Delivery Date'),
      ),
      DataColumn(
        label: Text('Payment Method'),
      ),
      DataColumn(
        label: Text('Promo Code'),
      ),
      DataColumn(
        label: Text('Note'),
      ),
      DataColumn(
        label: Text('Actions'),
      ),
    ];
  }

  List<DataRow> _buildOrderDataRow(BuildContext context) {
    List<DataRow> listsOfDataRow = orders.map(
      (order) {
        return DataRow(
          cells: [
            DataCell(
              Text(order.id),
            ),
            DataCell(
              Text(order.status),
            ),
            DataCell(
              Text(order.customerName),
            ),
            DataCell(
              Text(order.deliveryPhNumber),
            ),
            DataCell(
              Text(order.deliveryDate),
            ),
            DataCell(
              Text(order.paymentMethod),
            ),
            DataCell(
              Text(order.promoCode ?? "Null"),
            ),
            DataCell(
              Text(order.note ?? "Null"),
            ),
            DataCell(
              ElevatedButton(
                onPressed: () {
                  //Use id from Order to show order detail popup
                  // var orderId = order.id;

                  //todo
                  //buid a modal dialog using orderId
                  //Call graphql query inside modal dialog widget

                  showDialog(
                      context: context,
                      builder: (context) {
                        return OrderDetail(
                            order: order,
                            products: order.products,
                            address: order.address);
                      });
                },
                child: const Text('View'),
              ),
            ),
          ],
        );
      },
    ).toList();
    return listsOfDataRow;
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: _buildOrderDataColumn(),
      rows: _buildOrderDataRow(context),
    );
  }
}
