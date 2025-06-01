import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:foody_app/utilities/formatter.dart';
import 'package:foody_app/utilities/order_item.dart';
import 'package:flutter/material.dart';

class ResOrders extends StatefulWidget {
  const ResOrders({super.key});

  @override
  State<ResOrders> createState() => _ResOrdersState();
}

class _ResOrdersState extends State<ResOrders> {
  bool isChanged = true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
                    CurrentOrder(onTap: () {
                      setState(() {
                        isChanged = !isChanged;
                      });
                    }),
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
  const CurrentOrder({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<CurrentOrder> createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  bool isLoading = true;
  List<DocumentSnapshot> orders = [];
  List<String> userNames = [];

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Orders')
        .where('status',
            whereIn: ['Đang xử lý', 'Đang chuẩn bị', 'Đang giao']).get();
    orders = querySnapshot.docs;
    for (var order in orders) {
      final userDoc =
          await Db().db.collection('Customers').doc(order['custId']).get();
      userNames.add(userDoc['name']);
    }
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
              String selectedStatus = orders.isEmpty
                  ? 'Đang xử lý'
                  : orders[index]['status'] as String;
              if (orders.isEmpty) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Không có đơn hàng hiện tại!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết khách hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tên: ${userNames[index]}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Địa chỉ: ${orders[index]['userAddress'] ?? 'Not Provided'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Số điện thoại: ${orders[index]['phone'] ?? 'Not Provided'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tổng quan đơn hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      orders[index]['payMentMethod'] == " COD"
                          ? "Thanh toán khi nhận hàng"
                          : "Đã thanh toán",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders[index]['orderItems'].length,
                      itemBuilder: (context, index2) {
                        OrderItem orderItem = OrderItem(
                          restId: orders[index]['orderItems'][index2]['restId'],
                          itemId: orders[index]['orderItems'][index2]['itemId'],
                          id: '',
                          imageURL: orders[index]['orderItems'][index2]
                              ['imageURL'],
                          category: orders[index]['orderItems'][index2]
                              ['category'],
                          title: orders[index]['orderItems'][index2]['title'],
                          spcInstr: orders[index]['orderItems'][index2]
                              ['spcInstr'],
                          quantity: orders[index]['orderItems'][index2]
                              ['quantity'],
                          basePrice: orders[index]['orderItems'][index2]
                              ['basePrice'],
                          addOns: orders[index]['orderItems'][index2]['addOns'],
                        );
                        return ListTile(
                          leading: Image.network(
                            orderItem.imageURL,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            orderItem.title,
                            style: const TextStyle(fontSize: 15),
                          ),
                          subtitle: Text(
                            Formatter.formatCurrency(orderItem.totalPrice),
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Text(
                            'x${orderItem.quantity}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 15),
                    Row(
                      children: [
                        const Text(
                          'Tổng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Formatter.formatCurrency(
                            orders[index]['orderItems'].fold(
                              0.0,
                              (p, c) {
                                OrderItem orderItem = OrderItem(
                                  restId: c['restId'],
                                  itemId: c['itemId'],
                                  id: '',
                                  imageURL: c['imageURL'],
                                  category: c['category'],
                                  title: c['title'],
                                  spcInstr: c['spcInstr'],
                                  quantity: c['quantity'],
                                  basePrice: c['basePrice'],
                                  addOns: c['addOns'],
                                );
                                return p + orderItem.totalPrice;
                              },
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 15),
                    const Text(
                      'Trạng thái:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                        onChanged: (value) async {
                          //Show a Dialog Box to Confirm
                          bool? result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text(
                                      'Bạn có chắc chắn muốn thay đổi trạng thái'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Không')),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Có'),
                                    ),
                                  ],
                                );
                              });
                          if (result == null || !result) {
                            return;
                          } else {
                            await Db().updateOrderStatus(
                              value.toString(),
                              orders[index]['restId'],
                              orders[index]['custId'],
                              orders[index].id,
                            );
                            setState(() {});
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: selectedStatus,
                        items: [
                          'Đang xử lý',
                          'Đang chuẩn bị',
                          'Đang giao',
                          'Đã giao'
                        ].map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      onPressed: () async {
                        //Show a Dialog Box to Confirm
                        bool? result = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Xác nhận'),
                              content: const Text(
                                'Bạn có chắc chắn muốn hủy đơn hàng',
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('No')),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('Yes')),
                              ],
                            );
                          },
                        );

                        if (result == null || !result) {
                          return;
                        } else {
                          await Db().updateOrderStatus(
                            'cancelled',
                            orders[index]['restId'],
                            orders[index]['custId'],
                            orders[index].id,
                          );
                          widget.onTap();
                        }
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
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
  List<String> userNames = [];

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['Đã giao', 'Hủy']).get();
    orders = querySnapshot.docs;
    for (var order in orders) {
      final userDoc =
          await Db().db.collection('Customers').doc(order['custId']).get();
      userNames.add(userDoc['name']);
    }
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
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (orders.isEmpty) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(50),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(2, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Không có đơn hàng nào',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết khách hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: ${userNames[index]}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address: ${orders[index]['userAddress'] ?? 'Not Provided'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Phone: ${orders[index]['phone'] ?? 'Not Provided'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tóm tắt đơn hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders[index]['orderItems'].length,
                      itemBuilder: (context, index2) {
                        OrderItem orderItem = OrderItem(
                          restId: orders[index]['orderItems'][index2]['restId'],
                          itemId: orders[index]['orderItems'][index2]['itemId'],
                          id: '',
                          imageURL: orders[index]['orderItems'][index2]
                              ['imageURL'],
                          category: orders[index]['orderItems'][index2]
                              ['category'],
                          title: orders[index]['orderItems'][index2]['title'],
                          spcInstr: orders[index]['orderItems'][index2]
                              ['spcInstr'],
                          quantity: orders[index]['orderItems'][index2]
                              ['quantity'],
                          basePrice: orders[index]['orderItems'][index2]
                              ['basePrice'],
                          addOns: orders[index]['orderItems'][index2]['addOns'],
                        );
                        return ListTile(
                          leading: Image.network(
                            orderItem.imageURL,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            orderItem.title,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            Formatter.formatCurrency(orderItem.totalPrice),
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Text(
                            'x${orderItem.quantity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 15),
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Formatter.formatCurrency(
                            orders[index]['orderItems'].fold(
                              0.0,
                              (p, c) {
                                OrderItem orderItem = OrderItem(
                                  restId: c['restId'],
                                  itemId: c['itemId'],
                                  id: '',
                                  title: c['title'],
                                  imageURL: c['imageURL'],
                                  category: c['category'],
                                  spcInstr: c['spcInstr'],
                                  quantity: c['quantity'],
                                  basePrice: c['basePrice'],
                                  addOns: c['addOns'],
                                );
                                return p + orderItem.totalPrice;
                              },
                            ),
                          ),
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 15),
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          orders[index]['status'],
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
