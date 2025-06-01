import 'package:foody_app/pages/Customer/cart.dart';
import 'package:foody_app/pages/Customer/user_more.dart';
import 'package:foody_app/pages/Customer/user_order_page.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/pages/Customer/user_main_home.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<Widget> headings = [
    const Text('Trang chủ'),
    const Text('Giỏ hàng'),
    const Text('Đơn hàng'),
    const Text('Cài đặt')
  ];
  int selectedIndex = 0;
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Hồ sơ',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: colorPrimary,
        onTap: (index) => setState(() {
          selectedIndex = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          UserMainHome(),
          Cart(),
          UserOrder(),
          UserMore(),
        ],
      ),
    );
  }
}
