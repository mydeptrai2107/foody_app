// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/services/maps.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Hiện tại bạn chưa đăng nhập!',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
              'Vui lòng Đăng nhập hoặc Tạo tài khoản để truy cập tính năng này \n',
              style: TextStyle(
                fontSize: 16.0,
              )),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/UserSignUpPageOne');
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              // change background color of button
              backgroundColor: colorPrimary, // change text color of button
            ),
            child: const Text('Đăng ký'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/LoginPage');
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              // change background color of button
              backgroundColor: colorPrimary, // change text color of button
            ),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }
}

class UserMore extends StatefulWidget {
  const UserMore({super.key});
  @override
  State<UserMore> createState() => _UserMoreState();
}

class _UserMoreState extends State<UserMore> {
  List<String> value = [
    'Hồ sơ',
    'Địa chỉ',
    'Tạo tài khoản doanh nghiệp',
    'Điều khoản và chính sách',
    'Về chúng tôi',
    'Đăng xuất'
  ];

  //create a list containing the name and icon
  List<IconData> icons = [
    Icons.person,
    Icons.location_on,
    Icons.business,
    Icons.policy,
    Icons.info,
    Icons.logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hồ sơ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  value[index],
                  style: const TextStyle(fontSize: 15),
                ),
                tileColor: colorPrimary,
                textColor: Colors.white,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(icons[index]),
                iconColor: Colors.white,
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  if (value[index] == 'Hồ sơ') {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const PopupDialog();
                        },
                      );
                    } else {
                      Navigator.pushNamed(context, '/User_profile');
                    }
                  } else if (value[index] == 'Tạo tài khoản doanh nghiệp') {
                    Navigator.pushNamed(context, '/BuisnessSignup');
                  } else if (value[index] == 'Điều khoản và chính sách') {
                    Navigator.pushNamed(context, '/Terms_policy');
                  } else if (value[index] == 'Về chúng tôi') {
                    Navigator.pushNamed(context, '/About_us');
                  } else if (value[index] == 'Đăng xuất') {
                    await AuthServices().auth.signOut();
                    Navigator.pushReplacementNamed(context, '/WelcomePage');
                  } else if (value[index] == 'Địa chỉ') {
                    String? locTxt = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapScreen(),
                        ));
                    if (locTxt != null &&
                        AuthServices().auth.currentUser != null) {
                      await Db().updateUserAddress(
                          AuthServices().auth.currentUser!.uid, locTxt);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: colorPrimary,
                          content: const Text('Address Updated!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
