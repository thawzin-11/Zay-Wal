import 'package:clone_zay_chin/components/text_form_field.dart';
import 'package:clone_zay_chin/pages/checkout_complete_page.dart';
import 'package:clone_zay_chin/pages/order_finished_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:clone_zay_chin/data_models/cart.dart';

enum DeliveryDate { Tomorrow, TwoDayDelivery, TodayDate, Custom }

enum PaymentMethod { CashOnDelivery, AYAPay, KBZPay, VisaMaster }

class NewOrderDetailPage extends StatefulWidget {
  const NewOrderDetailPage({Key? key}) : super(key: key);
  static const route = '/new-order-detail';

  @override
  _NewOrderDetailPageState createState() => _NewOrderDetailPageState();
}

class _NewOrderDetailPageState extends State<NewOrderDetailPage> {
  DeliveryDate _dayDelivery = DeliveryDate.TwoDayDelivery;
  PaymentMethod _cashOnDelivery = PaymentMethod.CashOnDelivery;

  final _addressController = TextEditingController();
  final _townshipController = TextEditingController();
  var _deliveryDateController = TextEditingController();
  var _deliveryTimeController = TextEditingController();
  var _paymentMethodController = TextEditingController();
  final _promoCodeController = TextEditingController();
  final _noteController = TextEditingController();

  late String userName = "";
  late String phNumber = "";

  // Future getSessionData() async {
  //   Map<String, dynamic> userSession =
  //       await FlutterSession().get("sessionData");
  //   userName = userSession["userName"];
  //   phNumber = userSession["phNumber"];
  // }

  void changeDeliveryDateState(DeliveryDate? value) {
    setState(() {
      _dayDelivery = value!;
      _deliveryDateController = TextEditingController(
        text: describeEnum(value),
      );
    });
  }

  void changePaymentMethodState(PaymentMethod? value) {
    setState(() {
      _cashOnDelivery = value!;
      _paymentMethodController = TextEditingController(
        text: describeEnum(value),
      );
    });
  }

  Row _buildDeliveryDateRadioWidget(
    DeliveryDate value,
    DeliveryDate groupValue,
    void Function(DeliveryDate?)? onChanged,
    String deliveryDateOption,
  ) {
    return Row(
      children: [
        Radio(value: value, groupValue: groupValue, onChanged: onChanged),
        Text(deliveryDateOption)
      ],
    );
  }

  Row _buildPaymentMethodRadioWidget(
    PaymentMethod value,
    PaymentMethod groupValue,
    void Function(PaymentMethod?)? onChanged,
    String paymentMethodOption,
  ) {
    return Row(
      children: [
        Radio(value: value, groupValue: groupValue, onChanged: onChanged),
        Text(paymentMethodOption)
      ],
    );
  }

  String addOrder = """
    mutation Mutation(\$addOrderOrder: OrderInput) {
      addOrder(order: \$addOrderOrder) {
        id
        success
        message
      }
    }
    """;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // need data from cartModel (readonly is enough)
    var cartModel = Provider.of<CartModel>(context, listen: false);

    // load data from token;
    return Mutation(
        options: MutationOptions(
            document: gql(addOrder),
            onCompleted: (dynamic resultData) {
              Navigator.pushNamed(context, CheckOutCompletePage.route);
            }),
        builder: (RunMutation runMutation, result) {
          if (result?.isLoading == true) {
            //display loading widget
            //return SomeWidget();
          }
          if (result?.hasException == true) {
            //display error widget
            //return SomeErrorWidget();
          }
          if (result?.data != null) {
            //display result widget
            return OrderFinishedPage();
          }

          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sub Total'),
                            Text(cartModel.totalPrice.toString() + ' Ks')
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Delivery'), Text('0 Ks')],
                        )
                      ],
                    ),
                    color: Colors.amber,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [Text("Address")],
                      ),
                      CustomTextFormField(
                          hintText: "Address",
                          controller: _addressController,
                          icon: Icon(Icons.location_on))
                    ],
                  ),
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [Text("Township")],
                      ),
                      CustomTextFormField(
                          hintText: "Township",
                          controller: _townshipController,
                          icon: Icon(Icons.location_on))
                    ],
                  ),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [Text('Delivery Date')],
                      ),
                      Row(
                        children: [
                          _buildDeliveryDateRadioWidget(
                              DeliveryDate.Tomorrow,
                              _dayDelivery,
                              changeDeliveryDateState,
                              "Tomorrow"),
                          _buildDeliveryDateRadioWidget(
                              DeliveryDate.TwoDayDelivery,
                              _dayDelivery,
                              changeDeliveryDateState,
                              "2 Day Delivery"),
                        ],
                      ),
                      Row(
                        children: [
                          _buildDeliveryDateRadioWidget(
                              DeliveryDate.TodayDate,
                              _dayDelivery,
                              changeDeliveryDateState,
                              "Today Date"),
                          _buildDeliveryDateRadioWidget(DeliveryDate.Custom,
                              _dayDelivery, changeDeliveryDateState, "Custom"),
                        ],
                      )
                    ],
                  ),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [Text('Delivery Time')],
                      ),
                      Row(
                        children: [
                          Icon(Icons.timelapse),
                          Text('Anytime'),
                        ],
                      )
                    ],
                  ),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [Text('Payment Method')],
                      ),
                      _buildPaymentMethodRadioWidget(
                          PaymentMethod.CashOnDelivery,
                          _cashOnDelivery,
                          changePaymentMethodState,
                          "Cash On Delivery"),
                      _buildPaymentMethodRadioWidget(PaymentMethod.AYAPay,
                          _cashOnDelivery, changePaymentMethodState, "AYA Pay"),
                      _buildPaymentMethodRadioWidget(PaymentMethod.KBZPay,
                          _cashOnDelivery, changePaymentMethodState, "KBZ Pay"),
                      _buildPaymentMethodRadioWidget(
                          PaymentMethod.VisaMaster,
                          _cashOnDelivery,
                          changePaymentMethodState,
                          "Visa / Master"),
                    ],
                  ),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: CustomTextFormField(
                      hintText: 'Add Promo Code',
                      controller: _promoCodeController,
                      icon: Icon(Icons.add)),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: CustomTextFormField(
                      hintText: 'Add note or special instruction',
                      controller: _noteController,
                      icon: Icon(Icons.add)),
                  color: Colors.blue,
                )
              ],
            ),
            bottomNavigationBar: Row(
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
                          Text('Success'),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                      ),
                      Text('dummy'),
                      ElevatedButton(
                        onPressed: () => {
                          runMutation({
                            "addOrderOrder": {
                              "address": _addressController.text,
                              "deliveryData": _deliveryDateController.text,
                              "deliveryTime": _deliveryTimeController.text,
                              "note": _noteController.text,
                              "paymentMethod": _paymentMethodController.text,
                              "promoCode": _promoCodeController.text,
                              "township": _townshipController.text,
                              "products": cartModel.products,
                              "user": {
                                "name": userName,
                                "phNumber": phNumber,
                              }
                            }
                          })
                          // Navigator.pushNamed(
                          //     context, OrderFinishedPage.route)
                        },
                        child: Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(350, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      )
                    ],
                  ),
                )),
              ],
            ),
          );
        });
  }
}
