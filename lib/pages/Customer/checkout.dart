import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foody_app/pages/Customer/user_home.dart';
import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/services/dialog.dart';
import 'package:foody_app/services/maps.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/formatter.dart';
import 'package:foody_app/utilities/order.dart';
import 'package:foody_app/utilities/order_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.userData});
  final Map<String, dynamic> userData;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;

  String paymentMethod = 'COD'; // 'COD' hoặc 'stripe'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //Information SHowing
              Container(
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin của bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 10),
                        const Text(
                          'Địa chỉ',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            String? add = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MapScreen();
                            }));
                            if (add != null) {
                              setState(() {
                                widget.userData['stAddress'] = add;
                              });
                            }
                          },
                          child: Text(
                            'Chỉnh sửa',
                            style: TextStyle(
                              fontSize: 16,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.userData['stAddress'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Phone NUmber Display
                    Row(
                      children: const [
                        Icon(Icons.phone),
                        SizedBox(width: 10),
                        Text(
                          'Số điện thoại',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.userData['phone'] ?? 'Not Provided',
                      style: const TextStyle(
                        fontFamily: 'ubuntu',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //Displaying Cart Items or Order Summary
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tóm tắt đơn hàng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: CartList.list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            CartList.list[index].imageURL,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            CartList.list[index].title,
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          subtitle: Text(
                            Formatter.formatCurrency(
                                CartList.list[index].totalPrice),
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Text(
                            'x${CartList.list[index].quantity}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Tổng cộng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Formatter.formatCurrency(
                            CartList.list.fold(0.0, (p, c) => p + c.totalPrice),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Box To Provide Radio List of Payment Methods
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile(
                      selected: true,
                      value: 'COD',
                      title: const Text(
                        'Tiền mặt khi giao hàng',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      selected: true,
                      value: 'Stripe',
                      title: const Text(
                        'Stripe',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      selected: true,
                      value: 'banking',
                      title: const Text(
                        'Ngân hàng',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                    if (paymentMethod == 'banking')
                      Center(
                        child: QrImageView(
                          data: '1234567890',
                          version: QrVersions.auto,
                          size: 150,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Button To Place Order
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width - 30, 50),
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  backgroundColor: colorPrimary,
                ),
                onPressed: () async {
                  makePayment(
                    context,
                    CartList.list
                        .fold(0.0, (p, c) => p + c.totalPrice)
                        .toInt()
                        .toString(),
                  );
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.2,
                      )
                    : const Text(
                        'Đặt hàng',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  _submitOrder(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Order order = Order(
      userAddress: widget.userData['stAddress'],
      payMentMethod: paymentMethod,
      phone: widget.userData['phone'],
      custId: AuthServices().auth.currentUser!.uid,
      restId: CartList.list[0].restId,
      createAt: DateTime.now(),
      status: 'Đang xử lý',
    );
    order.addAllOrderItems(CartList.list);
    await Db().addOrder(order);
    setState(() {
      isLoading = false;
    });

    if (!context.mounted) return;
    showDialogSuccess(context, 'Đơn hàng đã được đặt thành công');
    //Clear Cart
    CartList.list.clear();
    //Clear from database
    await Db().clearCart(AuthServices().auth.currentUser!.uid);
    //Redirect To Home Screen
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const UserHomePage(),
      ),
      (route) => false,
    );
  }

  Future<void> makePayment(BuildContext context, String price) async {
    if (paymentMethod == "COD" || paymentMethod == 'banking') {
      try {
        await _submitOrder(context);
        if (!context.mounted) return;
        showDialogSuccess(context, 'Đơn hàng đã được đặt thành công');
      } catch (e) {
        showDialogFail(context, 'Đơn hàng đã được đặt không thành công');
      }

      return;
    }
    try {
      await initPaymentSheet(context, price);
    } catch (err) {
      if (!context.mounted) return;
      showDialogFail(context, err.toString());
    }
  }

  Future<void> initPaymentSheet(BuildContext context, String price) async {
    try {
      final data = await createPaymentIntent(price, 'vnd');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Prospects',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          if (!context.mounted) return;
          await _submitOrder(context);
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialogFail(context, e.toString());
      rethrow;
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51OIMAyHdpKm7MB8qBrZGoxMpc6vV5DLsNr37XUCn0kAOgZ9S2UeEOFAvj0QjvyjWSEyZCCkjw1J39OtU11vnKnra00L0jED0P7',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
