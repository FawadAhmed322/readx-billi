import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readx/catagory.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/home_page.dart';
import 'package:readx/login.dart';
import 'package:readx/main.dart';
import 'package:readx/models/note_model.dart';
import 'package:readx/models/user_model.dart';
import 'package:readx/utils/toast_util.dart';
import 'package:translator/translator.dart';

import 'models/Book_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<BookModel> books = [];
  List<String> categories = [];

  @override
  void initState() {
    getAllBooks();
    // addDummyData();
    super.initState();
  }

  Future getAllBooks() async {
    books.addAll(await getIt<FirebaseCrud>().getAllBooks());
    for (int i = 0; i < books.length; i++) {
      categories.addAll(books[i].genre ?? []);
    }
    categories.removeWhere((element) => element == '');
    categories = categories.toSet().toList();
    setState(() {});
  }

  addDummyData() async {
    await getIt<FirebaseCrud>().addUser(
      UserModel(
        id: 101,
        name: 'Talha',
        image: 'https://statinfer.com/wp-content/uploads/dummy-user.png',
      ),
    );

    await getIt<FirebaseCrud>().addUser(
      UserModel(
        id: 102,
        name: 'Ammar',
        image: 'https://avatars.githubusercontent.com/u/40992581?v=4',
      ),
    );

    await getIt<FirebaseCrud>().addUser(
      UserModel(
        id: 103,
        name: 'Muneeb',
        image:
            'https://enphamedbiotech.com/wp-content/uploads/2021/02/article_51_7-18-20181-15-10PM.jpg',
      ),
    );

    await getIt<FirebaseCrud>().addBook(
      BookModel(
          id: 2002,
          name: 'Rings',
          writer: 'J.R.R Tolkien',
          genre: [
            'fiction',
            'fantasy',
            'adventure',
            'romance',
          ],
          isTrending: true,
          price: 350,
          rating: 4.2,
          image:
              'https://orion-uploads.openroadmedia.com/sm_f7e651-tolkien-lordoftherings.jpg'),
    );

    await getIt<FirebaseCrud>().addBook(
      BookModel(
        id: 2003,
        name: 'Pinocchio',
        writer: 'Carlo Collodi',
        genre: [
          'fantasy',
          'animation',
        ],
        isTrending: true,
        price: 380,
        rating: 3.8,
        image: 'https://book-assets.openroadmedia.com/9781497679276.jpg',
      ),
    );

    await getIt<FirebaseCrud>().addBook(
      BookModel(
        id: 2004,
        name: 'The Da Vinci Code',
        writer: 'Dan Brown',
        genre: [
          'thriller',
          'mystery',
          'crime',
          'conspiracy',
        ],
        isTrending: true,
        price: 680,
        rating: 4.3,
        image:
            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTKbOIl7MrHrrt4MxSxbQ7Ml9UlQ8CnoGcT0aHX2fEAEwJWn7Mz',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor2 = null;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOTE: header
            Header(
                books: books
                    .where((element) => element.isTrending == false)
                    .toList()),
            SizedBox(height: spacer),
            CategoryList(categories: categories),
            SizedBox(height: spacer),
            SectionTitle(
              title: "Trending Now",
              backgroundColor: backgroundColor2,
            ),
            TrendingList(
              trendingBooks:
                  books.where((element) => element.isTrending == true).toList(),
            )
          ],
        ),
      ),
    );
  }
}

//setting

//feedback
class UI22 extends StatefulWidget {
  @override
  _UI22State createState() => _UI22State();
}

class _UI22State extends State<UI22> {
  List<bool> isTypeSelected = [false, false, false, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Please select the type of the feedback",
                style: TextStyle(
                  color: Color(0xFFC5C5C5),
                ),
              ),
              SizedBox(height: 25.0),
              GestureDetector(
                child: buildCheckItem(
                    title: "Login trouble", isSelected: isTypeSelected[0]),
                onTap: () {
                  setState(() {
                    isTypeSelected[0] = !isTypeSelected[0];
                  });
                },
              ),
              GestureDetector(
                child: buildCheckItem(
                    title: "Phone number related", isSelected: isTypeSelected[1]),
                onTap: () {
                  setState(() {
                    isTypeSelected[1] = !isTypeSelected[1];
                  });
                },
              ),
              GestureDetector(
                child: buildCheckItem(
                    title: "Personal profile", isSelected: isTypeSelected[2]),
                onTap: () {
                  setState(() {
                    isTypeSelected[2] = !isTypeSelected[2];
                  });
                },
              ),
              GestureDetector(
                child: buildCheckItem(
                    title: "Other issues", isSelected: isTypeSelected[3]),
                onTap: () {
                  setState(() {
                    isTypeSelected[3] = !isTypeSelected[3];
                  });
                },
              ),
              GestureDetector(
                child: buildCheckItem(
                    title: "Suggestions", isSelected: isTypeSelected[4]),
                onTap: () {
                  setState(() {
                    isTypeSelected[4] = !isTypeSelected[4];
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              buildFeedbackForm(),
              SizedBox(height: 20.0),
              buildNumberField(),
              // Spacer(),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildNumberField() {
    return TextField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0.0),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 1.0,
                    color: Color(0xFFC5C5C5),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "+60",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC5C5C5),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.cyan,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: Color(0xFFC5C5C5),
        ),
        hintText: "Phone Number",
        border: OutlineInputBorder(),
      ),
    );
  }

  buildFeedbackForm() {
    return Container(
      height: 200,
      child: Stack(
        children: [
          TextField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "Please briefly describe the issue",
              hintStyle: TextStyle(
                fontSize: 13.0,
                color: Color(0xFFC5C5C5),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE5E5E5),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color(0xFFA6A6A6),
                  ),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Color(0xFFA5A5A5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Upload screenshot (optional)",
                    style: TextStyle(
                      color: Color(0xFFC5C5C5),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCheckItem({required String title, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey),
          ),
        ],
      ),
    );
  }
}

//notes
class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final userController = Get.find<UserController>();
  final List<NoteModel> notes = [];

  getUserNotes() async {
    notes.clear();
    final allNotes = await getIt<FirebaseCrud>().getUserNotes(
      userController.loggedInUser!.id!,
    );
    notes.addAll(allNotes
        .where((element) => element.userId == userController.loggedInUser!.id!)
        .toList());
    setState(() {});
  }

  @override
  void initState() {
    getUserNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomBar(
         fetchAllNotes: getUserNotes,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          // app bar seaction
          CustomAppBar(),
          //search section
          SearchBar(),
          ListButtonContainer(),
          // now we create add list data
// we are using grid inside column thats why we are facing error
// use  shrinkWrap and physics widget to solve this error
          Listdata(
              userId: userController.loggedInUser!.id!,
              notes: notes,
              fetchAllUserNotes: getUserNotes,
          ),
          // now we craete add list data page
        ],
      )),
    );
  }
}

//logout class
class logout extends StatefulWidget {
  @override
  _logoutState createState() => _logoutState();
}

class _logoutState extends State<logout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("logout page"),
      ),
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(251, 80, 14, 45),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: userController.loggedInUser?.image != null
                ? BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(userController.loggedInUser!.image!),
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
          Text(
            "${userController.loggedInUser?.name}",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "${userController.loggedInUser?.email}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

final translator = GoogleTranslator();
String? _dropDownvalue;
String? translated_text;
TextEditingController myController = TextEditingController();

class TranslatorDemo extends StatefulWidget {
  @override
  _TranslatorDemoState createState() => _TranslatorDemoState();
}

class _TranslatorDemoState extends State<TranslatorDemo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dictionary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(title: Text("Translator App")),
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            controller: myController,
                            focusNode: FocusNode(canRequestFocus: false),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Text',
                            ))),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: _dropDownvalue == null
                              ? Text('Select language')
                              : Text(_dropDownvalue!,
                                  style: TextStyle(color: Colors.blue)),
                          items: <String>[
                            'English',
                            'Spanish',
                            'Chineese',
                            'German'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _dropDownvalue = newValue;
                            });

                            if (_dropDownvalue == 'English') {
                              translate_text('en');
                            } else if (_dropDownvalue == 'Spanish') {
                              translate_text('es');
                            } else if (_dropDownvalue == 'Chineese') {
                              translate_text('zh-cn');
                            } else if (_dropDownvalue == 'German') {
                              translate_text('de');
                            }
                          },
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 30),
                        child: translated_text != null
                            ? Text(translated_text!,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold))
                            : Text('')),
                  ],
                ))));
  }

  void translate_text(String locale) {
    translator.translate(myController.text, to: locale).then((value) {
      setState(() {
        translated_text = value.text;
      });
    });
  }
}

// notepad class
class Product {
  final String title, desc;
  final Color color;

  Product({
    required this.title,
    required this.desc,
    required this.color,
  });
}

// List<Product> products = [
//   Product(
//     title: "Monday Schedule",
//     color: Color(0xFF71b8ff),
//     desc: "First chapter of OOAD",
//   ),
//   Product(
//     title: "Tuesday Schedule",
//     color: Color(0xFFff6374),
//     desc: " 3rd chapter of System programing",
//   ),
//   Product(
//     title: "friday",
//     color: Color(0xFFffaa5b),
//     desc: "Cheatday",
//   ),
//   Product(
//     title: "Team meeting",
//     color: Color(0xFF9ba0fc),
//     desc: "Fyp group meeting",
//   ),
// ];

//class add to data

class Addtodo extends StatefulWidget {
  // final List<NoteModel> notes;

  const Addtodo({
    Key? key,
    // required this.notes,
  }) : super(key: key);

  @override
  _AddtodoState createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.push_pin_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.dashboard_outlined,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 2.0,
            blurRadius: 8.0,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Spacer(),
                InkWell(
                  onTap: () async {
                    await getIt<FirebaseCrud>().addNote(
                        userController.loggedInUser!.id!,
                        NoteModel(
                          id: Random().nextInt(1000),
                          userId: userController.loggedInUser!.id!,
                          title: titleController.text,
                          description: descriptionController.text,
                        ));
                    titleController.text = '';
                    descriptionController.text = '';
                    showToast('Note Added');
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 8.0,
                          )
                        ]),
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(
                      Icons.check,
                    ),
                  ),
                ),
                Spacer(),
                // Row(
                //   children:
                //       List.generate(widget.notes.length, (index) => colorSelection()),
                // ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //title
            TextFormField(
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Enter title",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            TextFormField(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Enter description",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding colorSelection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Colors.primaries[Random().nextInt(
                Colors.primaries.length,
              )],
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}

//bottom appbar
class CustomBottomBar extends StatelessWidget {
  final Function fetchAllNotes;
  const CustomBottomBar({
    Key? key,
    required this.fetchAllNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.5),
          spreadRadius: 2.0,
          blurRadius: 8.0,
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.space_dashboard_rounded)),
          InkWell(
            onTap: () async{
              await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Addtodo()));
              await fetchAllNotes();
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue[400],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.person_outline_rounded)),
        ],
      ),
    );
  }
}

//cutomappbar
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hi ${userController.loggedInUser?.name},",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8.0)),
            child: userController.loggedInUser?.image != null
                ? Image.network(
                    userController.loggedInUser!.image!,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/user.png',
                    fit: BoxFit.contain,
                  ),
          ),
        ],
      ),
    );
  }
}

// search screen
class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

//list button
class ListButtonContainer extends StatelessWidget {
  const ListButtonContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          LitsButton(
            isActive: true,
            press: () {},
            title: "Notes",
          ),
        ],
      ),
    );
  }
}

class LitsButton extends StatelessWidget {
  LitsButton({
    Key? key,
    this.isActive = false,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String title;
  final VoidCallback press;
  bool isActive;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: press,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 19,
              color: isActive == true ? Colors.blue[400] : Colors.black54,
              fontWeight:
                  isActive == true ? FontWeight.bold : FontWeight.normal),
        ));
  }
}
//listdata.dart

class Listdata extends StatelessWidget {
  final int userId;
  final List<NoteModel> notes;
  final Function fetchAllUserNotes;

  const Listdata({
    Key? key,
    required this.notes,
    required this.userId,
    required this.fetchAllUserNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: notes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) => ListCard(
            userId: userId,
                note: notes[index],
                press: () {},
              fetchAllUserNotes: fetchAllUserNotes,
              )),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
    required this.userId,
    required this.note,
    required this.press,
    required this.fetchAllUserNotes,
  }) : super(key: key);
  final int userId;
  final NoteModel note;
  final VoidCallback press;
  final Function fetchAllUserNotes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: press,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Text(
                  note.title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
                Text(
                  note.description ?? '',
                  maxLines: 5,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: ()async {
            await getIt<FirebaseCrud>().deleteNote(userId, note.id!);
            await fetchAllUserNotes();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.delete,size: 25,color: Colors.red,),
            ),
          ),
        )
      ],
    );
  }
}

//listmodel=fst class in this page
