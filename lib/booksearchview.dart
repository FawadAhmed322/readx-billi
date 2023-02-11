import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/main.dart';
import 'package:readx/models/Chat_model.dart';
import 'package:readx/models/user_model.dart';

import 'detail_screenforhomepage.dart';
import 'models/Book_model.dart';

class BooksSearchView extends StatefulWidget {
  @override
  State<BooksSearchView> createState() => _BooksSearchViewState();

  final List<BookModel> books;

  const BooksSearchView({
    Key? key,
    required this.books,
  }) : super(key: key);
}

class _BooksSearchViewState extends State<BooksSearchView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 247, 242, 244),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(251, 80, 14, 45),
        elevation: 8,
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   color: Colors.white,
        //   onPressed: () {},
        // ),
        title: Text(
          'Searched Books',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     color: Colors.white,
        //     onPressed: () {},
        //   ),
        // ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView.builder(
        itemCount: widget.books.length,
        itemBuilder: (BuildContext context, int index) {
          // final Message chat = users[index];
          // final UserModel chat = users[index];
          final BookModel book = widget.books[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(trend: widget.books[index]),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2),
                    // decoration: chat.unread
                    decoration: true
                        ? BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            // shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          )
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                    child: widget.books[index].image != null
                        ? CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                NetworkImage(widget.books[index].image!),
                          )
                        : CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage('assets/user.png'),
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.books[index].name ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // chat.sender.isOnline
                                true
                                    ? Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Container(
                                        child: null,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final UserModel secondUser;

  ChatScreen({required this.secondUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  get prevUserId3 => null;
  final List<ChatModel> chats = [];
  final userController = Get.find<UserController>();

  @override
  void initState() {
    // fixAllChat();
    // getAllChats();
    getUserChats();
    super.initState();
  }

  fixAllChat() async {
    await getIt<FirebaseCrud>().fixChats();
  }

  getUserChats() async {
    chats.clear();
    print(userController.loggedInUser!.id!.toString() +
        " " +
        widget.secondUser.id!.toString());
    final allChats = await getIt<FirebaseCrud>().getAllUsersChats(
      userController.loggedInUser!.id!,
      widget.secondUser.id!,
    );
    // print(allChats);
    chats.addAll(allChats);
    setState(() {});
  }

  getAllChats() async {
    chats.clear();
    final allChats = await getIt<FirebaseCrud>().getAllChats(
      // userController.loggedInUser!.id!,
      widget.secondUser.id!,
    );
    chats.addAll(allChats);
    setState(() {});
  }

  _chatBubble(ChatModel chat, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                chat.message ?? '',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      chat.timestamp ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: chat.sender?.image != null
                          ? CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  NetworkImage(chat.sender!.image!),
                            )
                          : CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage('assets/user.png'),
                            ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                chat.message ?? '',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: chat.sender?.image != null
                          ? CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  NetworkImage(chat.sender!.image!),
                            )
                          : CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage('assets/user.png'),
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      chat.timestamp ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  _sendMessageArea() {
    final messageController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              await getIt<FirebaseCrud>().addChat(ChatModel(
                id: DateTime.now().millisecondsSinceEpoch,
                isUnread: true,
                message: messageController.text,
                sender: userController.loggedInUser!,
                receiver: widget.secondUser,
                timestamp: DateTime.now(),
              ));
              messageController.clear();
              await getUserChats();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int prevUserId;
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 87, 17, 35),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(169, 63, 11, 11),
        brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.secondUser.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              TextSpan(text: '\n'),
              widget.secondUser.isOnline == true
                  ? TextSpan(
                      text: 'Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    )
                  : TextSpan(
                      text: 'Offline',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    )
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromARGB(255, 12, 12, 12),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: EdgeInsets.all(20),
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                chats.sort((a, b) =>
                    a.timestamp.toString().compareTo(b.timestamp.toString()));
                final ChatModel message = chats[index];
                final bool isMe =
                    message.sender!.id == userController.loggedInUser!.id;
                var prevUserId2 = prevUserId3;
                final bool isSameUser = prevUserId2 == message.sender!.id;
                prevUserId = message.sender!.id!;
                return _chatBubble(message, isMe, isSameUser);
              },
            ),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }
}
