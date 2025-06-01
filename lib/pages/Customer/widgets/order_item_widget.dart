import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foody_app/services/dialog.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/formatter.dart';
import 'package:foody_app/utilities/order_item.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget(this.item, this.onTap, {super.key});
  final DocumentSnapshot item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item['orderItems'].length,
            itemBuilder: (context, index2) {
              OrderItem orderItem = OrderItem(
                restId: item['orderItems'][index2]['restId'],
                itemId: item['orderItems'][index2]['itemId'],
                imageURL: item['orderItems'][index2]['imageURL'],
                category: item['orderItems'][index2]['category'],
                id: '',
                title: item['orderItems'][index2]['title'],
                spcInstr: item['orderItems'][index2]['spcInstr'],
                quantity: item['orderItems'][index2]['quantity'],
                basePrice: item['orderItems'][index2]['basePrice'],
                addOns: item['orderItems'][index2]['addOns'],
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
          const Divider(),
          Text(
            item['payMentMethod'] == "COD"
                ? "Thanh toán khi nhận hàng"
                : "Đã thanh toán",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                item['status'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                Formatter.formatCurrency(item['orderItems'].fold(0.0, (p, c) {
                  OrderItem orderItem = OrderItem(
                    restId: c['restId'],
                    itemId: c['itemId'],
                    category: c['category'],
                    imageURL: c['imageURL'],
                    id: '',
                    title: c['title'],
                    spcInstr: c['spcInstr'],
                    quantity: c['quantity'],
                    basePrice: c['basePrice'],
                    addOns: c['addOns'],
                  );
                  return p + orderItem.totalPrice;
                })),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: colorPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (item['status'] == "Đang xử lý")
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () async {
                final userId = FirebaseAuth.instance.currentUser!.uid;
                final db = FirebaseFirestore.instance;
                await db
                    .collection('Customers')
                    .doc(userId)
                    .collection('Orders')
                    .doc(item.id)
                    .delete();
                await db
                    .collection('Restaurants')
                    .doc(item['orderItems'][0]['restId'])
                    .collection('Orders')
                    .doc(item.id)
                    .delete();
                onTap.call();
                if (!context.mounted) return;
                showDialogSuccess(context, "Hủy đơn hàng thành công");
              },
              child: Text("Hủy"),
            ),
        ],
      ),
    );
  }
}
