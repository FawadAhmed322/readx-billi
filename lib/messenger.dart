import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/main.dart';
import 'package:readx/models/Chat_model.dart';
import 'package:readx/models/user_model.dart';

class Messenger extends StatefulWidget {
  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  List<UserModel> users = [];
  List<ChatModel> chats = [];
  final userController = Get.find<UserController>();

  @override
  void initState() {
    getAllUsers();
    // getAllChats();
    super.initState();
  }

  Future getAllUsers() async {
    print('my id ${userController.loggedInUser!.id}');
    final allUsers = await getIt<FirebaseCrud>().getAllUsers();
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].id != userController.loggedInUser!.id &&
          (allUsers[i].friendIds ?? [])
              .contains(userController.loggedInUser!.id)) {
        users.add(allUsers[i]);
      }
    }
    setState(() {});
  }

  // getAllChats() async {
  //   chats.clear();
  //   final allChats = await getIt<FirebaseCrud>().getAllChats(
  //     userController.loggedInUser!.id!,
  //   );
  //   chats.addAll(allChats);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 247, 242, 244),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(251, 80, 14, 45),
        elevation: 8,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Messenger',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          // final Message chat = users[index];
          final UserModel chat = users[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  secondUser: users[index],
                ),
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
                    child: chat.image != null
                        ? CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(chat.image!),
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
                                  chat.name ?? '',
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
                            // Text(
                            //   // chat.time,
                            //   'chat.time',
                            //   style: TextStyle(
                            //     fontSize: 11,
                            //     fontWeight: FontWeight.w300,
                            //     color: Colors.black54,
                            //   ),
                            // ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     // chat.text,
                        //     'chat.text',
                        //     style: TextStyle(
                        //       fontSize: 13,
                        //       color: Colors.black54,
                        //     ),
                        //     overflow: TextOverflow.ellipsis,
                        //     maxLines: 2,
                        //   ),
                        // ),
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
    getAllChats();
    super.initState();
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
              await getAllChats();
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
              reverse: true,
              padding: EdgeInsets.all(20),
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
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

// message model.dart
// class Message {
//   final UserModel sender;
//   final String
//       time; // Would usually be type DateTime or Firebase Timestamp in production apps
//   final String text;
//   final bool unread;
//
//   Message({
//     required this.sender,
//     required this.time,
//     required this.text,
//     required this.unread,
//   });
// }

// EXAMPLE CHATS ON HOME SCREEN
// List<Message> chats = [
//   Message(
//     sender: ironMan,
//     time: '5:30 PM',
//     text: 'Hey dude! Even dead I\'m the hero. Love you 3000 guys.',
//     unread: true,
//   ),
//   Message(
//     sender: captainAmerica,
//     time: '4:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     unread: true,
//   ),
//   Message(
//     sender: blackWindow,
//     time: '3:30 PM',
//     text: 'WOW! this soul world is amazing, but miss you guys.',
//     unread: false,
//   ),
//   Message(
//     sender: spiderMan,
//     time: '2:30 PM',
//     text: 'I\'m exposed now. Please help me to hide my identity.',
//     unread: true,
//   ),
//   Message(
//     sender: hulk,
//     time: '1:30 PM',
//     text: 'HULK SMASH!!',
//     unread: false,
//   ),
//   Message(
//     sender: thor,
//     time: '12:30 PM',
//     text: 'I\'m hitting gym bro. I\'m immune to mortal deseases. Are you coming?',
//     unread: false,
//   ),
//   Message(
//     sender: scarletWitch,
//     time: '11:30 AM',
//     text: 'My twins are giving me headache. Give me some time please.',
//     unread: false,
//   ),
//   Message(
//     sender: captainMarvel,
//     time: '12:45 AM',
//     text: 'You\'re always special to me nick! But you know my struggle.',
//     unread: false,
//   ),
// ];

// EXAMPLE MESSAGES IN CHAT SCREEN
// List<Message> messages = [
//   Message(
//     sender: ironMan,
//     time: '5:30 PM',
//     text: 'Hey dude! Event dead I\'m the hero. Love you 3000 guys.',
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     time: '4:30 PM',
//     text: 'We could surely handle this mess much easily if you were here.',
//     unread: true,
//   ),
//   Message(
//     sender: ironMan,
//     time: '3:45 PM',
//     text: 'Take care of peter. Give him all the protection & his aunt.',
//     unread: true,
//   ),
//   Message(
//     sender: ironMan,
//     time: '3:15 PM',
//     text: 'I\'m always proud of her and blessed to have both of them.',
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     time: '2:30 PM',
//     text:
//         'But that spider kid is having some difficulties due his identity reveal by a blog called daily bugle.',
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     time: '2:30 PM',
//     text:
//         'Pepper & Morgan is fine. They\'re strong as you. Morgan is a very brave girl, one day she\'ll make you proud.',
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     time: '2:30 PM',
//     text: 'Yes Tony!',
//     unread: true,
//   ),
//   Message(
//     sender: ironMan,
//     time: '2:00 PM',
//     text: 'I hope my family is doing well.',
//     unread: true,
//   ),
// ];

// class User {
//   final int id;
//   final String name;
//   final String imageUrl;
//   final bool isOnline;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.isOnline,
//   });
// }

// YOU - current user
// final User currentUser = User(
//   id: 0,
//   name: 'Nick Fury',
//   imageUrl: 'assets/nick-fury.jpg',
//   isOnline: true,
// );
//
// // USERS
// final User ironMan = User(
//   id: 1,
//   name: 'Iron Man',
//   imageUrl: 'assets/ironman.jpeg',
//   isOnline: true,
// );
// final User captainAmerica = User(
//   id: 2,
//   name: 'Captain America',
//   imageUrl: 'assets/captain-america.jpg',
//   isOnline: true,
// );
// final User hulk = User(
//   id: 3,
//   name: 'Hulk',
//   imageUrl: 'assets/hulk.jpg',
//   isOnline: false,
// );
// final User scarletWitch = User(
//   id: 4,
//   name: 'Scarlet Witch',
//   imageUrl: 'assets/scarlet-witch.jpg',
//   isOnline: false,
// );
// final User spiderMan = User(
//   id: 5,
//   name: 'Spider Man',
//   imageUrl: 'assets/spiderman.jpg',
//   isOnline: true,
// );
// final User blackWindow = User(
//   id: 6,
//   name: 'Black Widow',
//   imageUrl: 'assets/black-widow.jpg',
//   isOnline: false,
// );
// final User thor = User(
//   id: 7,
//   name: 'Thor',
//   imageUrl: 'assets/thor.png',
//   isOnline: false,
// );
// final User captainMarvel = User(
//   id: 8,
//   name: 'Captain Marvel',
//   imageUrl: 'assets/captain-marvel.jpg',
//   isOnline: false,
// );
