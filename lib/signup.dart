import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/main.dart';
import 'package:readx/models/user_model.dart';
import 'package:readx/utils/toast_util.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text('Sign Up', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    profilePic = await imagePicker();
                    setState(() {});
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: profilePic == null
                        ? null
                        : FileImage(File(profilePic!)),
                    child: profilePic == null
                        ? const Icon(Icons.person, size: 35)
                        : null,
                    // Image.file(File(profilePic!)),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  validator: (text) => (text ?? '').trim().isNotEmpty
                      ? null
                      : "Please enter Name",
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
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
                    } else if (profilePic == null) {
                      showToast('Please upload profile pic');
                    } else {
                      final existsUsers =
                          await getIt<FirebaseCrud>().getAllUsers();
                      if (existsUsers
                          .map((e) => e.email)
                          .toList()
                          .contains(emailController.text.trim())) {
                        showToast('Email Already Exists');
                      } else {
                        UserModel newUser = UserModel(
                          id: Random().nextInt(100),
                          name: nameController.text,
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                        await getIt<FirebaseCrud>().addUser(newUser);
                        // await getIt<FirebaseCrud>().getAllUsers();
                        // for (int i = 0; i < existsUsers.length; i++) {
                        //   if (existsUsers[i].email ==
                        //       emailController.text.trim()) {
                        //     Get.find<UserController>()
                        //       ..loggedInUser = existsUsers[i]
                        //       ..isLoggedIn.value = true;
                        //     break;
                        //   }
                        // }

                        final uploadedImage = await uploadImageToStorage(
                          File(profilePic!),
                          newUser.id!,
                        );
                        newUser = newUser.copyWith(image: uploadedImage);
                        await getIt<FirebaseCrud>().updateUser(
                          newUser,
                        );
                        Get.find<UserController>().loggedInUser = newUser;
                        Get.find<UserController>().isLoggedIn.value = true;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                        Get.find<UserController>().loggedInUser;
                      }
                    }
                  },
                  child: const Text('Sign Up'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String text) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
  }

  Future<String?> imagePicker() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<String> uploadImageToStorage(File imageFile, int userId) async {
    final reference = FirebaseStorage.instance.ref('users').child('$userId');
    await reference.putFile(imageFile);
    //waiting for some more milliseconds to upload the image successfully
    await Future.delayed(const Duration(milliseconds: 300));
    return await reference.getDownloadURL();
  }
}
