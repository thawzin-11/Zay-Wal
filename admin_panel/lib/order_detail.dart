import 'package:admin_panel/models/order.dart';
import 'package:admin_panel/models/product.dart';
import 'package:admin_panel/models/address.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OrderDetail extends StatelessWidget {
  final Order order;
  final List<Product> products;
  // final User user;
  final Address address;
  const OrderDetail(
      {Key? key,
      required this.products,
      required this.address,
      required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataRow> listsOfDataRow = order.products.map(
      (product) {
        return DataRow(
          cells: [
            // const DataCell(Text('null')),
            DataCell(
              Text(product.name),
            ),
            DataCell(
              Text(product.priceUnit),
            ),
            DataCell(
              Text(
                product.price.toString(),
              ),
            ),
            DataCell(
              Text(address.streetNo),
            ),
            DataCell(
              Text(address.township),
            ),
          ],
        );
      },
    ).toList();

    int _getTotalAmt() {
      int value = 0;
      for (var element in products) {
        value += element.price;
      }
      return value;
    }

    String confirmOrder = """
          mutation Mutation(\$orderId: ID) {
            confirmOrder(orderId: \$orderId) {
              status
            }
          }
        """;

    return Dialog(
      child: Mutation(
          options: MutationOptions(document: gql(confirmOrder)),
          builder: (runMutation, result) {
            print(result);
            if (result!.hasException) {
              return const Text("Something wrong with request");
            }
            return ListView(
              children: [
                DataTable(
                  columns: const [
                    DataColumn(
                      label: Text('Product Name'),
                    ),
                    DataColumn(
                      label: Text('PriceUnit'),
                    ),
                    DataColumn(
                      label: Text('Price'),
                    ),
                    DataColumn(
                      label: Text('Street No'),
                    ),
                    DataColumn(
                      label: Text('Township'),
                    ),
                  ],
                  rows: listsOfDataRow,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: const [
                        Text('Subtotal'),
                        Text('Shipping & Handling'),
                        Text('Discount'),
                        Text('Tax')
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(_getTotalAmt().toString() + ' MMK'),
                        const Text('0 MMK'),
                        const Text('0 MMK'),
                        const Text('150 MMK'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                result.isLoading
                    ? const CircularProgressIndicator()
                    : result.data != null
                        ? const Text('confirmed')
                        : TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        // title: const Text("Confirmation"),
                                        content: const Text("Are you sure"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                runMutation(
                                                    {'orderId': order.id});
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("OK")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"))
                                        ],
                                      ));
                            },
                            child: const Text('Confirm Order')),
                TextButton(onPressed: () {}, child: const Text('Go Back'))
              ],
            );
          }),
    );
  }
}
