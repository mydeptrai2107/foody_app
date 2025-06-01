import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/formatter.dart';
import 'package:foody_app/utilities/order_item.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
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
            offset: const Offset(2, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Image.network(
            CartList.list[widget.index].imageURL,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  CartList.list[widget.index].title,
                  style: const TextStyle(
                    fontFamily: 'ubuntu-bold',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  Formatter.formatCurrency(
                      CartList.list[widget.index].basePrice),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text('Add Ons',
                    style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 15)),
                const SizedBox(height: 5),
                ...CartList.list[widget.index].addOns.keys.map((e) =>
                    Text('Rs ${CartList.list[widget.index].addOns[e]}    $e')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        String orderItemId = CartList.list[widget.index].id;
                        if (CartList.list[widget.index].quantity != 0) {
                          setState(() {
                            CartList.list[widget.index].quantity--;
                          });
                          await Db()
                              .db
                              .collection('Customers')
                              .doc(AuthServices().auth.currentUser!.uid)
                              .collection('Cart')
                              .doc(orderItemId)
                              .update({
                            'quantity': CartList.list[widget.index].quantity
                          });
                        }
                        if (CartList.list[widget.index].quantity == 0) {
                          setState(() {
                            CartList.list.removeAt(widget.index);
                          });

                          await Db()
                              .db
                              .collection('Customers')
                              .doc(AuthServices().auth.currentUser!.uid)
                              .collection('Cart')
                              .doc(orderItemId)
                              .delete();
                        }
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: CartList.list[widget.index].quantity != 0
                              ? colorPrimary
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${CartList.list[widget.index].quantity}',
                      style: const TextStyle(
                          fontSize: 15, fontFamily: 'ubuntu-bold'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          CartList.list[widget.index].quantity++;
                        });
                        await Db()
                            .db
                            .collection('Customers')
                            .doc(AuthServices().auth.currentUser!.uid)
                            .collection('Cart')
                            .doc(CartList.list[widget.index].id)
                            .update({
                          'quantity': CartList.list[widget.index].quantity
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Formatter.formatCurrency(
                          CartList.list[widget.index].totalPrice),
                      style: const TextStyle(
                        fontFamily: 'ubuntu-bold',
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
