// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/pages/login.dart';
import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/maps.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

////IN FIRST PAGE WE WILL GET THE EMAIL AND PASSWORD AND VERIFY IF THE USER EXISTS OR NOT
class UserSignUpPageOne extends StatefulWidget {
  const UserSignUpPageOne({super.key});

  @override
  State<UserSignUpPageOne> createState() => _UserSignUpPageOneState();
}

class _UserSignUpPageOneState extends State<UserSignUpPageOne> {
  //This _formKey will help us validate the inputs (check whether the user has entered the correct input or not)
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = colorPrimary;
  final emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Image(image: AssetImage('images/eatopia.png'), height: 50),
            SizedBox(width: 10),
            Text(
              'HOMEFOOD',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ])),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng ký',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    //EMAIL TEXT FIELD
                    CustomTextField(
                        icon: const Icon(
                          Icons.email,
                          color: Colors.black,
                          size: 20,
                        ),
                        labelText: 'Email',
                        hintText: 'Nhập email của bạn',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập email của bạn';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'Vui lòng nhập email hợp lệ';
                          }
                          return null;
                        },
                        emailController: emailController,
                        boxH: 100,
                        primaryColor: _primaryColor),
                    const SizedBox(height: 20),
                  ],
                )),
            //NEXT SCREEN BUTTON
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(_primaryColor),
                  fixedSize: WidgetStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width / 3,
                      MediaQuery.of(context).size.height / 18)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                setState(() {
                  isLoading = true;
                });
                bool res =
                    await AuthServices().emailExists(emailController.text);
                if (res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: appRed,
                      elevation: 10,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      content: const Text('Email đã tồn tại'),
                    ),
                  );
                  setState(() {
                    isLoading = false;
                  });
                  return;
                }
                Navigator.pushNamed(context, '/UserSignUpPageTwo', arguments: {
                  'email': emailController.text,
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 1.2,
                      color: Colors.white,
                    )
                  : const Text(
                      'Tiếp tục',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Đã có tài khoản?'),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(_primaryColor),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/LoginPage');
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//USER SIGN - UP PAGE TWO TAKE INPUT FOR USERNAME, PHONE NUMBER AND ADDRESS AND THEN THE SIGN UP IS COMPLETE

class UserSignUpPageTwo extends StatefulWidget {
  const UserSignUpPageTwo({super.key});

  @override
  State<UserSignUpPageTwo> createState() => _UserSignUpPageTwoState();
}

class _UserSignUpPageTwoState extends State<UserSignUpPageTwo> {
  Map userData = {};
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = colorPrimary;
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    userNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //We got this data from first page of sign up
    userData = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Image(image: AssetImage('images/eatopia.png'), height: 50),
            SizedBox(width: 10),
            Text(
              'HOMEFOOD',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            )
          ])),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Đăng ký',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //USER NAME TEXT FIELD
                        CustomTextField(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelText: 'Tên của bạn',
                            hintText: 'Nhập tên của bạn',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập tên của bạn';
                              }
                              return null;
                            },
                            emailController: userNameController,
                            boxH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),
                        //PASSWORD TEXT FIELD
                        PasswordTextField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập mật khẩu của bạn';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 chữ số';
                              }
                              return null;
                            },
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu của bạn',
                            passwordController: passwordController,
                            boxPassH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),
                        //Confirm PASSWORD TEXT FIELD
                        PasswordTextField(
                          labelText: 'Xác nhận',
                          hintText: 'Nhập lại mật khẩu của bạn',
                          passwordController: confirmPasswordController,
                          boxPassH: 100,
                          primaryColor: _primaryColor,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập lại mật khẩu của bạn';
                            }
                            if (value != passwordController.text) {
                              return 'Mật khẩu không khớp';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        //Phone Number Text Field
                        CustomTextField(
                            inputType: TextInputType.phone,
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.black,
                            ),
                            labelText: 'Số điện thoại',
                            hintText: 'Nhập lại số điện thoại của bạn',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập số điện thoại của bạn';
                              } else if (int.tryParse(value) == null ||
                                  value.length < 10) {
                                return 'Vui lòng nhập số điện thoại hợp lệ';
                              }
                              return null;
                            },
                            emailController: phoneController,
                            boxH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),

                        //Address Text Field
                        CustomTextField(
                            readOnly: true,
                            inputType: TextInputType.streetAddress,
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                            labelText: 'Địa chỉ',
                            hintText: 'Chọn địa chỉ của bạn',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng chọn địa chỉ của bạn';
                              }
                              return null;
                            },
                            emailController: addressController,
                            boxH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 10),
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        fixedSize: const Size(210, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () async {
                      String? locTxt = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapScreen(),
                        ),
                      );
                      if (locTxt != null) {
                        setState(() {
                          addressController.text = locTxt;
                        });
                      }
                    },
                    child: Text(
                      'Chọn vị trí từ bản đồ',
                      style: TextStyle(
                        color: colorPrimary,
                        fontFamily: 'ubuntu-bold',
                      ),
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(_primaryColor),
                      fixedSize: WidgetStateProperty.all<Size>(Size(
                          MediaQuery.of(context).size.width / 3,
                          MediaQuery.of(context).size.height / 18)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    await AuthServices().signUpwithEmail(
                        userData['email'], passwordController.text);
                    await AuthServices().addCustomers({
                      'name': userNameController.text,
                      'email': userData['email'],
                      'phone': phoneController.text,
                      'stAddress': addressController.text,
                    });
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text('Đã đăng ký thành công'),
                            content: const Text(
                              'Bạn đã đăng ký tài khoản thành công',
                            ),
                          );
                        });
                    await Future.delayed(Duration(seconds: 1));

                    Navigator.pop(context);

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.white,
                        )
                      : const Text(
                          'Đăng ký',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
