// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/services/maps.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_services.dart';

////IN FIRST PAGE WE WILL GET THE EMAIL AND PASSWORD AND VERIFY IF THE USER EXISTS OR NOT
class BuisnessSignup extends StatefulWidget {
  const BuisnessSignup({super.key});

  @override
  State<BuisnessSignup> createState() => _BuisnessSignupState();
}

class _BuisnessSignupState extends State<BuisnessSignup> {
  //This _formKey will help us validate the inputs (check whether the user has entered the correct input or not)
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = colorPrimary;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ownerController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final restaurantController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    ownerController.dispose();
    phoneController.dispose();
    addressController.dispose();
    confirmPasswordController.dispose();
    restaurantController.dispose();
    super.dispose();
  }

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
                fontSize: 2,
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
                  'Thiết lập tài khoản doanh nghiệp',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //Owner NAME TEXT FIELD
                        CustomTextField(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelText: 'Tên chủ sở hữu',
                            hintText: 'Nhập tên của bạn',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập tên của bạn';
                              }
                              return null;
                            },
                            emailController: ownerController,
                            boxH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),

                        //Restaurant NAME TEXT FIELD
                        CustomTextField(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelText: 'Tên nhà hàng',
                            hintText: 'Nhập tên nhà hàng của bạn',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập tên nhà hàng';
                              }
                              return null;
                            },
                            emailController: restaurantController,
                            boxH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),

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

                        PasswordTextField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập mật khẩu của bạn';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              return null;
                            },
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu của bạn',
                            passwordController: passwordController,
                            boxPassH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),

                        //CONFIRM PASSWORD TEXT FIELD
                        PasswordTextField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập mật khẩu của bạn';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              if (value != passwordController.text) {
                                return 'Mật khẩu không khớp';
                              }
                              return null;
                            },
                            labelText: 'Xác nhận mật khẩu',
                            hintText: 'Xác nhận mật khẩu của bạn',
                            passwordController: confirmPasswordController,
                            boxPassH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),

                        //Phone Number Text Field
                        CustomTextField(
                            inputType: TextInputType.phone,
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.black,
                            ),
                            labelText: 'Số điện thoại',
                            hintText: 'Nhập số điện thoại của bạn',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập số điện thoại của bạn';
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
                              builder: (context) => const MapScreen()));
                      if (locTxt != null) {
                        setState(() {
                          addressController.text = locTxt;
                        });
                      }
                    },
                    child: Text(
                      'Chọn vị trí từ bản đồ',
                      style: TextStyle(
                          color: colorPrimary, fontFamily: 'ubuntu-bold'),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
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
                      bool exists = await AuthServices()
                          .emailExists(emailController.text);

                      if (exists) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                content: Text('Email already in use')));
                        return;
                      }

                      await AuthServices().signUpwithEmail(
                          emailController.text, passwordController.text);

                      await AuthServices().addRestaurant({
                        'owner': ownerController.text,
                        'restaurant': restaurantController.text,
                        'phone': phoneController.text,
                        'address': addressController.text,
                        'Categories': [],
                        'email': emailController.text,
                      });

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.pushNamedAndRemoveUntil(
                          context, '/ResHomePage', (route) => false);
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          )
                        : const Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
