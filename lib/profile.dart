import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readx/book_upload.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();

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
    final userController = Get.find<UserController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.cyanAccent,
          backgroundColor: Colors.indigo,
          label: const Text("Upload  Book"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookUpload()));
          }),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: userController.loggedInUser?.image != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage(userController.loggedInUser!.image!),
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
            itemCount: _imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_imageList[index]),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(title: 'Total Books Uploaded', value: '6'),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'price per Book', value: "\$14"),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Location', value: 'Jhelum'),
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
          '${userController.loggedInUser?.name}',
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
