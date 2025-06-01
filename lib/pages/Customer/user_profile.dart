// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User _user;
  String? _name;
  String? _phoneNumber;
  String? _address;
  String? _email;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _getUserData();
  }

  Future<void> _getUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(_user.uid)
        .get();
    setState(() {
      _name = userData['name'];
      _phoneNumber = userData['phone'];
      _address = userData['stAddress'];
      _email = userData['email'];
    });
  }

  void _editUserData() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chỉnh sửa dữ liệu người dùng'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tên',
                    hintText: _name,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: _phoneNumber,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    hintText: _address,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save the edited data to Firebase
                  final userDataRef = FirebaseFirestore.instance
                      .collection('Customers')
                      .doc(_user.uid);
                  await userDataRef.update({
                    'name': _name,
                    'phone': _phoneNumber,
                    'stAddress': _address,
                  });
                  // Update the UI to reflect the edited data
                  _getUserData();
                  Navigator.of(context).pop();
                },
                child: const Text('Lưu'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin'),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      backgroundImage: AssetImage('images/user.png'),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      _name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                buildCard(
                  title: 'Thông tin',
                  child: Column(
                    children: [
                      buildInfoRow(
                        label: 'Email',
                        value: _email ?? '',
                      ),
                      buildInfoRow(
                        label: 'Số điện thoại',
                        value: _phoneNumber ?? 'Not set',
                      ),
                      buildInfoRow(
                        label: 'Địa chỉ',
                        value: _address ?? '',
                      ),
                      const SizedBox(height: 20),
                      OverflowBar(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _editUserData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Chỉnh sửa'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // make a floating button
        ],
      ),
    );
  }
}

Widget buildCard({
  required String title,
  required Widget child,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    ),
  );
}

Widget buildInfoRow({
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
