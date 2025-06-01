// ignore_for_file: use_build_context_synchronously

import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

////IN FIRST PAGE WE WILL GET THE EMAIL AND PASSWORD AND VERIFY IF THE USER EXISTS OR NOT
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //This _formKey will help us validate the inputs (check whether the user has entered the correct input or not)
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = colorPrimary;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                fontSize: 25,
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
              'Đăng nhập',
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
                        hintText: 'Nhập email',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập email';
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
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                        labelText: 'Mật khẩu',
                        hintText: 'Nhập mật khẩu của bạn',
                        passwordController: passwordController,
                        boxPassH: 100,
                        primaryColor: _primaryColor),
                    const SizedBox(height: 20),
                  ],
                )),
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

                String? res = await AuthServices().signInWithEmail(
                    emailController.text, passwordController.text, context);

                if (res == null) {
                  if (await AuthServices().isCustomer()) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/UserHomePage', (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/ResHomePage', (route) => false);
                  }
                } else {
                  if (res == 'user-not-found') {
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
                        content: const Text('No user found for that email'),
                      ),
                    );
                  } else if (res == 'wrong-password') {
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
                        content: const Text('Wrong password'),
                      ),
                    );
                  }
                }

                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1,
                    )
                  : const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Chưa có tài khoản'),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(_primaryColor),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/UserSignUpPageOne');
                  },
                  child: const Text(
                    'Đăng ký',
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
