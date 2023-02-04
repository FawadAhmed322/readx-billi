import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readx/book_upload.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/detail_screenforuserbooks.dart';
import 'package:readx/main.dart';
import 'package:readx/models/Book_model.dart';
import 'package:readx/models/user_model.dart';
import 'package:readx/proportinate.dart';
import 'package:readx/edit_profile.dart';
import 'package:readx/utils/toast_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:readx/firebase_crud.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();

  late final userController;

  var name;
  var image;

  late List<BookModel> bookModel;

  String? profilePic;

  void initState() {
    userController = Get.find<UserController>();
    name = userController.loggedInUser!.name;
    image = userController.loggedInUser!.image;
    getAllBooksByUserListner();
    userListener();
    // bookModel = getIt<FirebaseCrud>().getAllBooksByUser(userController.loggedInUser?.id);
  }

  void userListener() {
    final userReference = FirebaseDatabase.instance
        .ref("readx")
        .child("users")
        .child(userController.loggedInUser!.id!.toString());
    userReference.onValue.listen((DatabaseEvent event) {
      final userEvent = event.snapshot;

      setState(() {
        userController.loggedInUser = UserModel.fromJson(userEvent.value);
        name = userEvent.child('name').value.toString();
        image = userEvent.child('image').value.toString();
      });
    });
  }

  void getAllBooksByUserListner() {
    List<BookModel> bookModels = [];

    final databaseReference = FirebaseDatabase.instance
        .ref("readx")
        .child("books")
        .child(userController.loggedInUser!.id!.toString());
    databaseReference.onValue.listen((DatabaseEvent event) {
      final booksevent = event.snapshot.children;
      booksevent.forEach((book) {
        // BookModel tempBookModel = BookModel();
        // tempBookModel.id = book.child('id').value as int;
        // tempBookModel.name = book.child("name").value as String;
        // tempBookModel.writer = book.child("writer").value as String;
        // tempBookModel.image = book.child("image").value as String;
        // tempBookModel.filename = book.child("filename").value as String;
        BookModel tempBookModel = BookModel.fromJson(book);

        print("Value");
        print(book.child("name").value as String);

        bookModels.add(tempBookModel);
      });
    });
    setState(() {
      print("State in bracket");
      bookModel = bookModels;
      print(bookModel);
    });
  }

  // ignore: prefer_final_fields
  var _imageList = [
    'assets/AI-World.webp',
    'assets/dsa-book-1-638.webp',
    'assets/book2.png',
    'assets/book3.png',
    'assets/book1.png',
    'assets/big0764119982.jpg',
    // 'assets/7.jpeg',
    // 'assets/8.jpg',
    // 'assets/9.jpg',
    // 'assets/10.jpeg',
    // 'assets/11.png',
    // 'assets/12.jpeg',
    // 'assets/13.jpg',
    'assets/14.jpg',
    // 'assets/15.jpg',
    // 'assets/16.jpeg',
    'assets/17.jpg',
    'assets/18.jpeg',
  ];

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************
  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
    //
    // BookModel bookModel = getIt<FirebaseCrud>().getAllBooksByUser(userController.)

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.cyanAccent,
          backgroundColor: Colors.indigo,
          label: const Text("Upload  Book"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BookUpload()));
          }),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              // decoration: userController.loggedInUser?.image != null
              decoration: image != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image:
                            // NetworkImage(userController.loggedInUser!.image!),
                            NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/user.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),

          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
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

  Future<void> updateProfileImageToStorage() async {
    final uploadedImage = await uploadImageToStorage(
      File(profilePic!),
      userController.id!,
    );

    final databaseRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(userController.id!);
    final updatedData = {"image": uploadedImage};
    databaseRef.update(updatedData);
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************
  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: bookModel.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) => Container(
              child: GestureDetector(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailUserBooksScreen(
                          trend: bookModel[index],
                          userid: userController.loggedInUser!.id!.toString())),
                );
              }),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(bookModel[index].image.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Action Section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlinedButton(
              onPressed: () => _panelController.open(),
              child: Text(
                'Follow',
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 16,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: OutlinedButton(
                onPressed: () => print('Message tapped'),
                child: Text(
                  'MESSAGE',
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _infoCell(
            title: 'Total Books Uploaded', value: bookModel.length.toString()),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        // _infoCell(title: 'price per Book', value: "\$14"),
        // Container(
        //   width: 1,
        //   height: 40,
        //   color: Colors.grey,
        // ),
        // _infoCell(title: 'Location', value: 'Jhelum'),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
    final userController = Get.find<UserController>();
    return Column(
      children: <Widget>[
        Text(
          // '${userController.loggedInUser?.name}',
          '${name}',
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Freelancer',
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfile()),
          ),
          child: Text('Edit Profile'),
        )
        // MaterialButton(
        //   color: Colors.indigo,
        //   child: Text("Change Profile Picture", style: TextStyle(
        //     color: Colors.white,
        //   )),
        //   onPressed: () {
        //   },
        // ),
      ],
    );
  }
}
