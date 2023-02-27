import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/global.dart';
import '../../helper/firebase_helper/firebase_auth_helper.dart';
import '../../helper/product_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: loginKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Your Email.......";
                  }
                },
                onSaved: (val) {
                  email = val!;
                },
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Email...',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Your Password.......";
                  }
                },
                onSaved: (val) {
                  password = val!;
                },
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Password...',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final preferences = await SharedPreferences.getInstance();
                    await preferences.setString("email", email);
                    if (loginKey.currentState!.validate()) {
                      loginKey.currentState!.save();
                      User? user = await FireBaseAuthHelper.fireBaseAuthHelper
                          .signIn(email: email, password: password);
                      await FireBaseAuthHelper.fireBaseAuthHelper
                          .setUpData(email, password);

                      if (user != null) {
                        Global.allProduct
                            .map((e) => productDB.insertRecord(e))
                            .toSet()
                            .toList();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Login Successfully....$email"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xff942D17),
                          ),
                        );
                        Navigator.of(context).pushReplacementNamed('/');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login Fail...."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
