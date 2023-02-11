import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/drawer_classes.dart';
import 'package:readx/detail_screenforhomepage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/login.dart';
import 'package:readx/main.dart';
import 'package:readx/models/Book_model.dart';
import 'package:image_network/image_network.dart';
import 'package:readx/utils/toast_util.dart';

import 'booksearchview.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _HomeAppBarState extends State<HomeAppBar> {
  var currentPage = DrawerSections.dashboard;
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = DashboardPage();
    } else if (currentPage == DrawerSections.notes) {
      container = NotesPage();
    } else if (currentPage == DrawerSections.Dictionary) {
      container = TranslatorDemo();
    } else if (currentPage == DrawerSections.notifications) {
      container = logout();
    } else if (currentPage == DrawerSections.send_feedback) {
      container = UI22();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(251, 80, 14, 45),
        elevation: 0,
        toolbarHeight: 80,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacer),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: userController.loggedInUser?.image != null
                      ? ImageNetwork(
                          image: userController.loggedInUser!.image!,
                          width: 50,
                          height: 50)
                      : Image.asset(
                          "assets/user.png",
                          width: 50,
                        ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello ${userController.loggedInUser?.name},",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Good Morning",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Image.asset("assets/menu.png",
                    width: 18,
                    height: 14,
                    color: Color.fromARGB(251, 80, 14, 45)),
              ],
            ),
          ),
        ),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(4, "Notes", Icons.notes,
              currentPage == DrawerSections.notes ? true : false),
          Divider(),
          menuItem(5, "Dictionary", Icons.search,
              currentPage == DrawerSections.Dictionary ? true : false),
          menuItem(6, "logout", Icons.logout_outlined,
              currentPage == DrawerSections.logout ? true : false),
          Divider(),
          menuItem(8, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Color.fromARGB(255, 224, 224, 224) : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.notes;
            } else if (id == 5) {
              currentPage = DrawerSections.Dictionary;
            } else if (id == 6) {
              Get.find<UserController>()
                ..loggedInUser = null
                ..isLoggedIn.value = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
              // currentPage = DrawerSections.notifications;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 8) {
              currentPage = DrawerSections.send_feedback;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  events,
  notes,
  Dictionary,
  notifications,
  privacy_policy,
  send_feedback,
  logout,
}

// search filed

class SearchField extends StatelessWidget {
  SearchField({
    Key? key,
    required this.books,
  }) : super(key: key);

  final List<BookModel> books;
  TextEditingController searchedText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(children: [
          TextField(
            controller: searchedText,
            onSubmitted: (value) {
              // showToast(searchedText.text);
              List<BookModel> similarbooks = books.where((book) {
                if (book.name == null) {
                  return false;
                }
                return book.name!
                    .toLowerCase()
                    .contains(searchedText.text.toLowerCase());
              }).toList();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BooksSearchView(books: similarbooks)));
              // print(similarbooks);
              // books.where((book) => book.name.contains(searchedText.text));
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFe6e6e6),
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.all(8.0),
                hintText: "Search your favorite book..",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none)),
          ),
          SizedBox(
            height: 20.0,
          )
        ]));
  }
}

//header home
class Header extends StatelessWidget {
  final List<BookModel> books;

  const Header({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 406 - 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
        color: Color.fromARGB(206, 199, 55, 55),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(books: books),
          const SectionTitle(
            title: "Discover Latest Books",
            backgroundColor: Color.fromARGB(255, 100, 206, 103),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: books.map((book) {
                int index = books.indexOf(book);
                return CardRecent(book, index: index);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//card recent
class CardRecent extends StatelessWidget {
  const CardRecent(
    this.book, {
    Key? key,
    required this.index,
  }) : super(key: key);

  final BookModel book;
  final int index;

  loadImage() async {
    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("book_covers")
        .child(book.image.toString());

    //get image url from firebase storage
    var imageurl = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    print(imageurl);
    return imageurl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 228,
      height: 165,
      margin: EdgeInsets.only(
        right: 20,
        bottom: 10,
        top: 10,
        left: index == 0 ? 30 : 0,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 2,
            color: greyColor200,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(trend: book)),
          );
        },
        child: Row(
          children: [
            Container(
                child: new ImageNetwork(
                    image: book.image.toString(), height: 100, width: 100)),
            // if (book.image != null) Image.network(loadImage().toString()),
            SizedBox(width: 10),
            Container(
              width: 87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    book.name ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  ),
                  Text(
                    book.writer ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  ),
                  // CircularPercentIndicator(
                  //   radius: 50,
                  //   lineWidth: 6,
                  //   // percent: book.percent.toDouble() / 100,
                  //   percent: 0.5,
                  //   progressColor: greenColor,
                  //   reverse: true,
                  // ),
                  // Text(
                  //   // "${book.percent}% Completed",
                  //   "50% Completed",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: 12,
                  //     color: greyColor500,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// section title
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required backgroundColor,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: spacer, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}

//trending list.dart
class TrendingList extends StatelessWidget {
  final List<BookModel> trendingBooks;

  const TrendingList({
    Key? key,
    required this.trendingBooks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    trendingBooks.shuffle();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trendingBooks.map((trend) {
          int index = trendingBooks.indexOf(trend);
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(trend: trend)),
              );
            },
            child: Container(
              width: 110,
              height: 207,
              margin: EdgeInsets.only(
                right: 20,
                left: (index == 0) ? spacer : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (trend.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(trend.image!),
                    ),
                  Text(
                    trend.writer ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color.fromARGB(255, 46, 44, 63),
                    ),
                  ),
                  Text(
                    trend.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

//section detail.dart
class SectionDetail extends StatelessWidget {
  const SectionDetail({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: greyColor500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: blackColor,
          ),
        ),
      ],
    );
  }
}

class LineSection extends StatelessWidget {
  const LineSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: spacer,
      width: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: darkColor,
      ),
    );
  }
}

// header detail
class HeaderDetail extends StatelessWidget {
  const HeaderDetail({
    Key? key,
    required this.trend,
  }) : super(key: key);

  final BookModel trend;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trend.name ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            Text(
              trend.writer ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: greyColor400,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: greenColor,
          ),
        ),
      ],
    );
  }
}

//detail appbar.dart
class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: greyColor100,
      elevation: 0,
      toolbarHeight: 80,
      title: Text(
        "Book Details",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: darkColor,
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: spacer),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: darkColor,
            size: 20,
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(right: spacer),
            child: Icon(
              Icons.share_outlined,
              color: darkColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}

//catagory list .dart
class CategoryList extends StatefulWidget {
  final List<String> categories;

  const CategoryList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories.map((category) {
          int index = widget.categories.indexOf(category);
          return InkWell(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              alignment: Alignment.center,
              height: 41,
              margin: EdgeInsets.only(
                right: 10,
                left: index == 0 ? spacer : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: (selectedCategory == index)
                    ? greenColor
                    : Colors.transparent,
              ),
              child: Text(
                '${category.substring(0, 1).toUpperCase()}'
                '${category.substring(1)}',
                style: TextStyle(
                  fontSize: (selectedCategory == index) ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color:
                      (selectedCategory == index) ? whiteColor : greyColor400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

//color constant.dart
Color darkColor = Color(0xff2D2D2D);
Color whiteColor = Color(0xffFFFFFF);
Color greenColor = Color(0xff098B5C);
Color blackColor = Color(0xff000000);
Color greyColor100 = Color(0xffF8F8F8);
Color greyColor200 = Color(0xffF3F3F3);
Color greyColor300 = Color(0xffEDEDED);
Color greyColor400 = Color(0xffBDBDBD);
Color greyColor500 = Color(0xffAFAFAF);
double spacer = 30.0;
