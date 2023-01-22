import 'dart:io';

import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/main.dart';
import 'package:readx/utils/toast_util.dart';

class BookUpload extends StatefulWidget {
  const BookUpload({Key? key}) : super(key: key);

  @override
  State<BookUpload> createState() => _BookUploadState();
}

class _BookUploadState extends State<BookUpload> {
  final userController = Get.find<UserController>();
  bool bookLocallyUploaded = false;
  bool coverLocallyUploaded = false;
  String? bookPath;
  String? coverPath;

  Future<String?> filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      return result.files.first.path;
    }
    return null;
  }

  Future<String?> imagePicker() async {
    PickedFile? result =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (result != null) {
      print(result);
      print(result.path);
      return result.path;
    }
    return null;
  }

  Future<Map<String, String>> uploadBook(
      File file, File file2, int userId) async {
    final reference = FirebaseStorage.instance
        .ref('books')
        .child('$userId')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    final coverReference = FirebaseStorage.instance
        .ref('book_covers')
        .child('$userId')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    await reference.putFile(file);
    await coverReference.putFile(file2);
    //waiting for some more milliseconds to upload the file successfully
    await Future.delayed(const Duration(milliseconds: 300));
    String book_url = await reference.getDownloadURL();
    String cover_url = await coverReference.getDownloadURL();
    print(book_url);
    print(cover_url);
    return {'book_url': book_url, 'cover_url': cover_url};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              //name, rating, writer, image, is trending
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Book Name',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Writer Name',
                ),
              ),
              SizedBox(height: 20),
              if (bookPath != null) Text('${bookPath?.split('/').last}'),
              TextButton(
                onPressed: () async {
                  final path = await filePicker();
                  if (path != null) {
                    bookLocallyUploaded = true;
                    bookPath = path;
                    showToast('Book Added');
                    // Navigator.pop(context);
                  }
                },
                child: Text('Upload Book'),
              ),
              TextButton(
                onPressed: () async {
                  final path = await imagePicker();
                  if (path != null) {
                    coverLocallyUploaded = true;
                    coverPath = path;
                    showToast('Book Cover Added');
                    // Navigator.pop(context);
                  }
                },
                child: Text('Upload Book Cover'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (bookPath != null) {
                    await uploadBook(
                      File(bookPath!),
                      File(coverPath!),
                      userController.loggedInUser!.id!,
                    );
                    showToast('Book Uploaded');
                  } else {
                    showToast('Upload Book first');
                  }
                },
                child: Text('Upload Book to DB'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
