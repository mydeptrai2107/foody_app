import 'package:foody_app/pages/Customer/user_main_home.dart';
import 'package:foody_app/pages/Restaurant/all_res.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:flutter/material.dart';

class RestaurantHorizontal extends StatelessWidget {
  const RestaurantHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Text(
                  'Nhà hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllRes(),
                      ),
                    );
                  },
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(height: 200, child: RestaurantTiles()),
        ],
      ),
    );
  }
}
