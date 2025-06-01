// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/services/maps.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:flutter/material.dart';

class ResMore extends StatefulWidget {
  const ResMore({super.key});
  @override
  State<ResMore> createState() => _ResMoreState();
}

class _ResMoreState extends State<ResMore> {
  List<String> value = [
    'Hồ sơ',
    'Địa chỉ',
    'Điều khoản và chính sách',
    'Về chúng tôi',
    'Đăng xuất'
  ];

  //create a list containing the name and icon
  List<IconData> icons = [
    Icons.person,
    Icons.location_on,
    Icons.policy,
    Icons.info,
    Icons.logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Navigator.pushNamed(context, '/Res_profile');
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
                            builder: (context) => const MapScreen()));
                    if (locTxt != null) {
                      await Db().updateRestaurantAddress(
                          AuthServices().auth.currentUser!.uid, locTxt);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: colorPrimary,
                          content: const Text('Address Updated !'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
            );
          }),
    ));
  }
}
