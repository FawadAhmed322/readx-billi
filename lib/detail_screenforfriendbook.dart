import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readx/home_page.dart';
import 'package:readx/models/Book_model.dart';
import 'package:readx/trend.dart';
import 'package:readx/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:readx/mypdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DetailFriendBooksScreen extends StatefulWidget {
  const DetailFriendBooksScreen({
    Key? key,
    required this.trend,
  }) : super(key: key);

  final BookModel trend;

  @override
  _DetailFriendBooksScreenState createState() =>
      _DetailFriendBooksScreenState();
}

class _DetailFriendBooksScreenState extends State<DetailFriendBooksScreen> {
  Future<void> _launchUrl() async {
    print(Uri.parse(widget.trend.filename.toString()));
    if (!await launchUrl(Uri.parse(widget.trend.filename.toString()))) {
      throw Exception('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor100,
      appBar: DetailAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.trend.image != null)
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.trend.image!,
                    width: 175,
                    height: 267,
                  ),
                ),
              ),
            SizedBox(height: 25),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacer),
                  constraints: BoxConstraints(
                    minHeight: 370 * 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderDetail(trend: widget.trend),
                      SizedBox(height: spacer),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Enchantment, as defined by bestselling business guru Guy Kawasaki, is not about manipulating people. It transforms situations and relationships. ",
                        style: TextStyle(
                          fontSize: 12,
                          color: greyColor400,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: greyColor100,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SectionDetail(
                              title: 'Rating',
                              // value: '${widget.trend.rating}',
                              value: '',
                            ),
                            LineSection(),
                            SectionDetail(
                              title: 'Number of pages',
                              value: '180 Page',
                            ),
                            LineSection(),
                            SectionDetail(
                              title: 'Language',
                              value: 'ENG',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacer),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPdfViewer(
                                title: widget.trend.name.toString(),
                                url: widget.trend.filename.toString(),
                              ),
                            ),
                          );

                          // print(widget.trend.filename.toString());
                          //
                          // final httpsReference = FirebaseStorage.instance.refFromURL(widget.trend.filename.toString());
                          // final downloadTask = httpsReference.writeToFile(file);
                          // downloadTask.snapshotEvents.listen((taskSnapshot) {
                          //   switch (taskSnapshot.state) {
                          //     case TaskState.running:
                          //     // TODO: Handle this case.
                          //       break;
                          //     case TaskState.paused:
                          //     // TODO: Handle this case.
                          //       break;
                          //     case TaskState.success:
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(builder: (context) => MyPdfViewer(filePath)),
                          //       );
                          //     // TODO: Handle this case.
                          //       break;
                          //     case TaskState.canceled:
                          //     // TODO: Handle this case.
                          //       break;
                          //     case TaskState.error:
                          //     // TODO: Handle this case.
                          //       break;
                          //   }
                          // });

                          // _launchUrl();
                        },
                        minWidth: double.infinity,
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: greenColor,
                        elevation: 0,
                        child: Text(
                          "Read Now",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Positioned(
                //   top: -25,
                //   right: 30,
                //   child: MaterialButton(
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return AlertDialog(
                //             title: Text("Delete Book"),
                //             content: Text("Do you want to delete this book?"),
                //             actions: <Widget>[
                //               MaterialButton(
                //                 child: Text("No"),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               ),
                //               MaterialButton(
                //                 child: Text("Yes"),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                   FirebaseDatabase.instance
                //                       .ref('readx')
                //                       .child("books")
                //                       .child(widget.trend.id.toString())
                //                       .remove();
                //                   showToast(widget.trend.name.toString() +
                //                       "has been removed!");
                //                   Navigator.of(context).pop();
                //                 },
                //               ),
                //             ],
                //           );
                //         },
                //       );
                //     },
                //     minWidth: 50,
                //     height: 50,
                //     color: greenColor,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //     padding: EdgeInsets.all(18),
                //     child: Icon(
                //       Icons.delete,
                //       color: whiteColor,
                //     ),
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// NOW am going to create trend catagory and recent classes
class Category {
  final String title;

  Category(this.title);
}

// List<Category> categories = [
//   Category("All Book"),
//   Category("IT"),
//   Category("Novel"),
//   Category("LAW"),
//   Category("English"),
// ];

class Recent {
  final String title, image;
  final int percent;

  Recent({
    required this.title,
    required this.image,
    required this.percent,
  });
}

// List<Recent> recents = [
//   Recent(image: "assets/recent1.png", title: "The Magic", percent: 50),
//   Recent(image: "assets/recent2.png", title: "The Martian", percent: 80),
// ];

class Trend {
  final String image, title, creator;

  Trend({
    required this.image,
    required this.title,
    required this.creator,
  });
}

// List<Trend> trends = [
//   Trend(image: "assets/dsa-book-1-638.webp", title: "Data structure and algorithms", creator: "Narasimha Karumanchi"),
//   Trend(image: "assets/big0764119982.jpg", title: "Calculus", creator: "Michael Spivak."),
//   Trend(image: "assets/AI-World.webp", title: "Artificial intelligence ", creator: " Dr. Lee "),
// ];
