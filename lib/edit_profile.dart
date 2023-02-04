import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? profilePic;
  String? emailAddress;
  String? password;
  String? name;
  late final userController;
  var profileImage;

  void initState() {
    userController = Get.find<UserController>();
    emailAddress = userController.loggedInUser!.email;
    password = userController.loggedInUser!.password;
    name = userController.loggedInUser!.name;
    nameController.text = name.toString();
    passwordController.text = password.toString();
    profileImage = NetworkImage(userController.loggedInUser!.image.toString());
  }

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
                const Text('Edit Profile', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    profilePic = await imagePicker();
                    setState(() {});
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: profilePic == null
                        ? profileImage
                        : FileImage(File(profilePic!)),
                    // child: profilePic == null
                    //     ? const Icon(Icons.person, size: 35)
                    //     : null,
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
                  // controller: emailController,
                  // validator: (text) => isValidEmail((text ?? '').trim())
                  //     ? null
                  //     : "Please enter a valid email",
                  // decoration: InputDecoration(
                  //   hintText: 'Email',
                  // ),
                  initialValue: emailAddress,
                  enabled: false,
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
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      showToast('Please fill in all the fields');
                    } else {
                      final existsUsers =
                          await getIt<FirebaseCrud>().getAllUsers();
                      UserModel newUser = UserModel(
                        id: userController.loggedInUser.id,
                        name: nameController.text,
                        email: emailAddress,
                        password: passwordController.text,
                      );
                      final userRef = FirebaseDatabase.instance
                          .ref('readx')
                          .child('users')
                          .child(userController.loggedInUser.id.toString());
                      await userRef.update({
                        'name': nameController.text,
                        'password': passwordController.text
                      });
                      if (profilePic != null) {
                        final uploadedImage = await uploadImageToStorage(
                          File(profilePic!),
                          newUser.id!,
                        );
                        // newUser = newUser.copyWith(image: uploadedImage);
                        await userRef.update({'image': uploadedImage});
                      }

                      // await getIt<FirebaseCrud>().updateUser(
                      //   newUser,
                      // );
                      // Get.find<UserController>().loggedInUser = newUser;
                      // Get.find<UserController>().isLoggedIn.value = true;

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => HomePage()));
                      Navigator.pop(context);
                      // Get.find<UserController>().loggedInUser;
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
