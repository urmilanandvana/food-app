import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app_bloc/screen/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/account/login_page.dart';
import 'screen/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp();
  final preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: (email == null) ? 'login_page' : '/',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: const Color(0xff942D17)),
      ),
      routes: {
        '/': (context) => const HomePage(),
        'login_page': (context) => const LoginPage(),
        'cart_page': (context) => const CartPage(),
      },
    ),
  );
}
