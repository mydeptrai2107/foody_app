// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/pages/Customer/widgets/cart_item.dart';
import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:foody_app/utilities/order_item.dart';
import 'package:flutter/material.dart';

import 'checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  void load() async {
    setState(() {
      isLoading = true;
    });
    await Db().loadCartItems(AuthServices().auth.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (AuthServices().auth.currentUser != null && CartList.list.isEmpty) {
      load();
    }
  }

  @override
  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
      ),
      body: isLoading
          ? CustomShimmer(
              height: MediaQuery.of(context).size.height,
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: CartList.list.length,
                      itemBuilder: (context, index) {
                        return CartItem(index: index);
                      },
                    ),
                  ),
                ),
                CartList.list.isEmpty
                    ? const SizedBox()
                    : ElevatedButton(
                        onPressed: () async {
                          final user = await Db().getUserInfo(
                              AuthServices().auth.currentUser!.uid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                userData: user,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width - 30, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Tiến hành thanh toán',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'ubuntu-bold',
                            color: Colors.white,
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
              ],
            ),
    );
  }
}
