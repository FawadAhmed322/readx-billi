import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readx/book_upload.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/detail_screenforhomepage.dart';
import 'package:readx/detail_screenforuserbooks.dart';
import 'package:readx/main.dart';
import 'package:readx/messenger.dart';
import 'package:readx/models/Book_model.dart';
import 'package:readx/models/user_model.dart';
import 'package:readx/proportinate.dart';
import 'package:readx/edit_profile.dart';
import 'package:readx/utils/toast_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:readx/firebase_crud.dart';
import 'package:image_picker/image_picker.dart';

class FriendProfilePage extends StatefulWidget {
  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();

  final UserModel frienduser;

  const FriendProfilePage({
    Key? key,
    required this.frienduser,
  }) : super(key: key);
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();

  late final userController;

  var name;
  var image;

  late List<BookModel> bookModel;

  late String? profilePic;

  void initState() {
    getAllBooksByUserListner();
    // userListener();
    // bookModel = getIt<FirebaseCrud>().getAllBooksByUser(userController.loggedInUser?.id);
  }

  void getAllBooksByUserListner() {
    List<BookModel> bookModels = [];

    final databaseReference = FirebaseDatabase.instance
        .ref("readx")
        .child("books")
        .child(widget.frienduser.id.toString());
    databaseReference.onValue.listen((DatabaseEvent event) {
      final booksevent = event.snapshot.children;
      booksevent.forEach((book) {
        // BookModel tempBookModel = BookModel();
        // tempBookModel.id = book.child('id').value as int;
        // tempBookModel.name = book.child("name").value as String;
        // tempBookModel.writer = book.child("writer").value as String;
        // tempBookModel.image = book.child("image").value as String;
        // tempBookModel.filename = book.child("filename").value as String;
        BookModel tempBookModel = BookModel.fromJson(book.value);

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

  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
    //
    // BookModel bookModel = getIt<FirebaseCrud>().getAllBooksByUser(userController.)

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              // decoration: userController.loggedInUser?.image != null
              decoration: widget.frienduser.image != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image:
                            // NetworkImage(userController.loggedInUser!.image!),
                            NetworkImage(widget.frienduser.image.toString()),
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
                      builder: (_) => DetailScreen(trend: bookModel[index])),
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
        // Visibility(
        //   visible: !_isOpen,
        //   child: Expanded(
        //     child: OutlinedButton(
        //       onPressed: () => _panelController.open(),
        //       child: Text(
        //         'Follow',
        //         style: TextStyle(
        //           fontFamily: 'NimbusSanL',
        //           fontSize: 12,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(
                                secondUser: widget.frienduser,
                              )));
                },
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
    return Column(
      children: <Widget>[
        Text(
          // '${userController.loggedInUser?.name}',
          '${widget.frienduser.name}',
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
      ],
    );
  }
}
