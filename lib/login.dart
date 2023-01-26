import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/main.dart';
import 'package:readx/models/user_model.dart';
import 'package:readx/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        TextEditingController(text: 'musaddiq101@gmail.com');
    final passwordController = TextEditingController(text: 'Test@1234');
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text('Login', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  validator: (text) => isValidEmail((text ?? '').trim())
                      ? null
                      : "Please enter a valid email",
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  validator: (text) => (text ?? '').trim().isNotEmpty
                      ? null
                      : "Please enter Password",
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      showToast('Please fill in all the fields');
                    } else {
                      bool userFound = false;
                      final existsUsers =
                          await getIt<FirebaseCrud>().getAllUsers();
                      for (int i = 0; i < existsUsers.length; i++) {
                        if (existsUsers[i].email ==
                            emailController.text.trim()) {
                          print('existsUsers[i] ${existsUsers[i]}');
                          print('existsUsers[i] ${existsUsers[i].toJson()}');
                          Get.find<UserController>()
                            ..loggedInUser = existsUsers[i]
                            ..isLoggedIn.value = true;
                          userFound = true;
                          break;
                        }
                      }
                      if (userFound) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      } else {
                        showToast('Invalid email or password');
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text('Not having an account? SignUp'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  showToast(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.withOpacity(.5),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  bool isValidEmail(String text) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
  }
}
