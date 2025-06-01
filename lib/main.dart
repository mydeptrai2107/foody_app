import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foody_app/pages/Restaurant/res_home.dart';
import 'package:foody_app/pages/loading.dart';
import 'package:foody_app/pages/login.dart';
import 'package:foody_app/pages/user_sign_up.dart';
import 'package:foody_app/services/maps.dart';
import 'package:foody_app/pages/buisness_sign_up.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'pages/Customer/about_us.dart';
import 'pages/Customer/user_home.dart';
import 'pages/Customer/user_profile.dart';
import 'pages/welcome_page.dart';
import 'pages/Customer/terms_policy.dart';
import 'package:foody_app/pages/Restaurant/res_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51OIMAyHdpKm7MB8qqvzh6yB053y1lg8vJlUhPZ05Omb93IrEljTl9pC4YAuay0jh1cvxfQfHAkWMnkiGhfB3l92Y00XANULzRX";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/UserSignUpPageOne': (context) => const UserSignUpPageOne(),
        '/UserSignUpPageTwo': (context) => const UserSignUpPageTwo(),
        '/WelcomePage': (context) => const WelcomePage(),
        '/MapScreen': (context) => const MapScreen(),
        '/UserHomePage': (context) => const UserHomePage(),
        '/LoginPage': (context) => const LoginPage(),
        '/BuisnessSignup': (context) => const BuisnessSignup(),
        '/ResHomePage': (context) => const ResHome(),
        '/User_profile': (context) => const UserProfile(),
        '/Terms_policy': (context) => const TermsPolicy(),
        '/About_us': (context) => const AboutUs(),
        '/Res_profile': (context) => const ResProfile(),
      },
      theme: ThemeData(
        fontFamily: 'ubuntu',
        primarySwatch: MaterialColor(0xFF016D39, {
          50: colorPrimary,
          100: colorPrimary,
          200: colorPrimary,
          300: colorPrimary,
          400: colorPrimary,
          500: colorPrimary,
          600: colorPrimary,
          700: colorPrimary,
          800: colorPrimary,
          900: colorPrimary,
        }),
      ),
    );
  }
}
