import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody_app/pages/Customer/widgets/order_item_widget.dart';
import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';

class UserOrder extends StatefulWidget {
  const UserOrder({super.key});

  @override
  State<UserOrder> createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Đơn hàng"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                labelColor: colorPrimary,
                indicatorColor: colorPrimary,
                tabs: [
                  Tab(
                    child: Text(
                      'Đang diễn ra',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Lịch sử',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    CurrentOrder(),
                    PastOrder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentOrder extends StatefulWidget {
  const CurrentOrder({super.key});

  @override
  State<CurrentOrder> createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  bool isLoading = true;
  List<DocumentSnapshot> orders = [];

  void getOrders() async {
    if (AuthServices().auth.currentUser == null) {
      orders = [];
      return;
    }
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(uid)
        .collection('Orders')
        .where('status',
            whereIn: ['Đang xử lý', 'Đang chuẩn bị', 'Đang giao']).get();
    orders = querySnapshot.docs;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomShimmer(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : ListView.builder(
            itemCount: orders.isEmpty ? 1 : orders.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (orders.isEmpty) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).width,
                  child: const Center(
                    child: Text(
                      'Không có đơn hàng trước đây!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return OrderItemWidget(orders[index], () {
                getOrders();
              });
            },
          );
  }
}

class PastOrder extends StatefulWidget {
  const PastOrder({super.key});

  @override
  State<PastOrder> createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  bool isLoading = true;
  List<DocumentSnapshot> orders = [];

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['Đã giao', 'Hủy']).get();
    orders = querySnapshot.docs;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomShimmer(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : ListView.builder(
            itemCount: orders.isEmpty ? 1 : orders.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (orders.isEmpty) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).width,
                  child: const Center(
                    child: Text(
                      'Không có đơn hàng trước đây!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return OrderItemWidget(orders[index], () {});
            },
          );
  }
}
