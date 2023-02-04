import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:readx/models/Book_model.dart';
import 'package:readx/models/Chat_model.dart';
import 'package:readx/models/note_model.dart';
import 'package:readx/models/user_model.dart';

class FirebaseCrud {
  final _dbUsers = FirebaseDatabase.instance.ref('readx').child('users');
  final _dbBooks = FirebaseDatabase.instance.ref('readx').child('books');
  final _dbChats = FirebaseDatabase.instance.ref('readx').child('chats');
  final _dbMessages = FirebaseDatabase.instance.ref('readx').child('messages');
  final _dbNotes = FirebaseDatabase.instance.ref('readx').child('notes');

  ///USERS CRUD
  Future addUser(UserModel user) async {
    try {
      await _dbUsers.child((user.id ?? 0).toString()).set(user.toJson());
      log('User Added: ${user.toJson()}');
    } catch (e) {
      log('Error on adding user: ${e.toString()}');
    }
  }

  Future getUser(int userId) async =>
      await _dbUsers.child(userId.toString()).get();

  Future<List> getAllChatUsers(int? userid) async {
    final  users = (await _dbMessages.child(userid.toString()).get()).value;
    if (users is Map) {
      try {
        // print(users);
        // var a = UserModel.fromJson(users['receiver']);
        // print(a);
        // print(users.keys);
        // return users.keys
        //     .toList()
        //     .map((e) => UserModel.fromJson(users['$e']))
        //     .toList();

        return users.keys.toList();

      } catch (e) {
        log('Some Error in parsing users: $e');
        return [];
      }
    }
    return [];
  }

  Future<List<UserModel>> getAllUsers() async {
    final  users = (await _dbUsers.get()).value;
    if (users is Map) {
      try {
        return users.keys
            .toList()
            .map((e) => UserModel.fromJson(users['$e']))
            .toList();
      } catch (e) {
        log('Some Error in parsing users: $e');
        return [];
      }
    }
    return [];
  }

  Future updateUser(UserModel user) async {
    try {
      await _dbUsers.child((user.id ?? 0).toString()).update(user.toJson());
    } catch (e) {
      log('Error on updating user: ${e.toString()}');
    }
  }

  Future deleteUser(int userId) async {
    await _dbUsers.child(userId.toString()).remove();
  }

  ///BOOKS CRUD
  Future addBook(BookModel book) async {
    try {
      await _dbBooks.child((book.id ?? 0).toString()).set(book.toJson());
      log('Book Added: ${book.toJson()}');
    } catch (e) {
      log('Error on adding book: ${e.toString()}');
    }
  }

  Future getBook(int bookId) async =>
      await _dbBooks.child(bookId.toString()).get();

  Future<List<BookModel>> getAllBooks() async {
    final bookusers = (await _dbBooks.get()).value;

    final List<BookModel> bookModels = [];

    // if (bookusers is Map) {
    //   try {
    //     print(bookusers.keys.toList());
    //     bookusers.keys.toList().forEach((key) async {
    //        var tempbooks = (await _dbBooks.child(key).get()).value;
    //        if(tempbooks is Map) {
    //          tempbooks.values.toList().forEach((book) {
    //            BookModel tempBookModel = new BookModel();
    //
    //            tempBookModel.id = book['id'] as int;
    //            tempBookModel.name = book["name"] as String;
    //            tempBookModel.writer = book["writer"] as String;
    //            tempBookModel.image = book["image"] as String;
    //            tempBookModel.filename = book["filename"] as String;
    //
    //            print(tempBookModel.name);
    //
    //            bookModels.add(tempBookModel);
    //          });
    //        }
    //     });
    //     return bookModels;
    //     // return bookusers.keys
    //     //     .toList()
    //     //     .map((e) => BookModel.fromJson(bookusers['$e']))
    //     //     .toList();
    //   } catch (e) {
    //     log('Some Error in parsing users: $e');
    //     return [];
    //   }
    // }
    // return [];

    final databaseReference = FirebaseDatabase.instance.ref("readx").child("books");
    databaseReference.onValue.listen((DatabaseEvent event) {
      final books = event.snapshot.children;
      books.forEach((user) {
        user.children.forEach((book) {
          BookModel tempBookModel = new BookModel();

          tempBookModel.id = book.child('id').value as int;
          tempBookModel.name = book.child("name").value as String;
          tempBookModel.writer = book.child("writer").value as String;
          tempBookModel.image = book.child("image").value as String;
          tempBookModel.filename = book.child("filename").value as String;

          bookModels.add(tempBookModel);
        });
      });
    });

    return bookModels;

    // if (books is Map) {
    //   try {
    //
    //     return books.keys
    //         .toList()
    //         .map((e) => BookModel.fromJson(books['$e']))
    //         .toList();
    //   } catch (e) {
    //     log('Some Error in parsing books: $e');
    //     return [];
    //   }
    // }
    // return [];
  }

  List<BookModel> getAllBooksByUser(int userid) {
    // final books = (await _dbBooks.child(userid.toString()).get()).value;

    final List<BookModel> userBookModels = [];

    final databaseReference = FirebaseDatabase.instance.ref("readx").child("books").child(userid.toString());
    databaseReference.onValue.listen((DatabaseEvent event) {
      final books = event.snapshot.children;
      books.forEach((book) {
          BookModel tempBookModel = new BookModel();

          tempBookModel.id = book.child('id').value as int;
          tempBookModel.name = book.child("name").value as String;
          tempBookModel.writer = book.child("writer").value as String;
          tempBookModel.image = book.child("image").value as String;
          tempBookModel.filename = book.child("filename").value as String;

          userBookModels.add(tempBookModel);
        });
    });

    return userBookModels;

  }

  Future updateBook(BookModel book) async {
    try {
      await _dbBooks.child((book.id ?? 0).toString()).update(book.toJson());
    } catch (e) {
      log('Error on updating book: ${e.toString()}');
    }
  }

  Future deleteBook(int bookId) async {
    await _dbBooks.child(bookId.toString()).remove();
  }

  Future fixChats() async {
    
    final chats = (await _dbChats.get()).value;
    if(chats is Map) {
      var receiver, sender;
      // chats.keys
      //     .toList()
      //     .map((e) => ChatModel.fromJson(chats['$e']))
      //     .toList().forEach((chat) async {
      //       receiver = chat.receiver;
      //       sender = chat.sender;
      //       print(chat);
      //       print("Sending...");
      //       await _dbMessages.child(receiver.id.toString()).child(sender.id.toString()).child(chat.id.toString()).set(chat);
      //       await _dbMessages.child(sender.id.toString()).child(receiver.id.toString()).child(chat.id.toString()).set(chat);
      // });
      chats.values
          .toList().forEach((chat) async {
        receiver = chat['receiver'];
        sender = chat['sender'];
        print("Sending...");
        // await _dbMessages.child(receiver['id'].toString()).child(sender['id'].toString()).child(chat['id'].toString()).set(chat);
        await _dbMessages.child(sender['id'].toString()).child(receiver['id'].toString()).child(chat['id'].toString()).set(chat);
        // print(chat['id']);
      });
    }
  }

  ///CHATS CRUD
  Future addChat(ChatModel chat) async {

    String messageid = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      String? senderid = chat.sender?.id.toString();
      String? receiverid = chat.receiver?.id.toString();

      print("object");
      await _dbMessages
          .child(senderid!)
          .child(receiverid!)
          .child(messageid)
          .set(chat.toJson());
      await _dbMessages
          .child(receiverid!)
          .child(senderid!)
          .child(messageid)
          .set(chat.toJson());
      log('Chat Added: ${chat.toJson()}');
    } catch (e) {
      log('Error on adding chat: ${e.toString()}');
    }
  }

  Future<List<ChatModel>> getAllUsersChats(int userId, int receiverid) async {
    final chats = (await _dbMessages.child(userId.toString()).child(receiverid.toString()).get()).value;
    if (chats is Map) {
      try {
        // print(chats.keys);
        return chats.keys
            .toList()
            .map((e) => ChatModel.fromJson(chats['$e']))
            .toList()
            .where((e) => e.sender?.id == userId || e.receiver?.id == userId)
            .toList();
      } catch (e) {
        log('Some Error in getting all chats: $e');
        return [];
      }
    }
    else{
      return [];
    }
  }

  Future<List<ChatModel>> getAllChats(int userId) async {
    final chats = (await _dbChats.child(userId.toString()).get()).value;
    if (chats is Map) {
      try {
        return chats.keys
            .toList()
            .map((e) => ChatModel.fromJson(chats['$e']))
            .toList()
            .where((e) => e.sender?.id == userId || e.receiver?.id == userId)
            .toList();
      } catch (e) {
        log('Some Error in getting all chats: $e');
        return [];
      }
    }
    else{
      return [];
    }
  }
  //
  // Future updateChat(ChatModel chat) async {
  //   try {
  //     await _dbChats
  //         .child('${chat.senderId}___${chat.receiverId}')
  //         .update(chat.toJson());
  //   } catch (e) {
  //     log('Error on updating chat: ${e.toString()}');
  //   }
  // }
  //
  // Future deleteChat(ChatModel chat) async {
  //   await _dbChats.child('${chat.senderId}___${chat.receiverId}').remove();
  // }

  Future sendFriendReq(
    int senderId,
    int receiverId,
    UserModel myUserModel,
  ) async {
    // try {
    final user = UserModel.fromJson((await _dbUsers
            .child(
              receiverId.toString(),
            )
            .get())
        .value);
    final rIds = (user.receivedFriendIds ?? []).toList();
    rIds.add(senderId);
    rIds.addAll(rIds.toSet().toList());
    final rUser = user.copyWith(receivedFriendIds: rIds);
    await _dbUsers.child(receiverId.toString()).update(rUser.toJson());
    final sIds = (myUserModel.sentFriendIds ?? []).toList();
    sIds.add(receiverId);
    sIds.addAll(sIds.toSet().toList());
    final sUser = myUserModel.copyWith(sentFriendIds: sIds);

    await _dbUsers.child(senderId.toString()).update(sUser.toJson());
    await _dbUsers.child(receiverId.toString()).update(rUser.toJson());
    // } catch (e) {
    //   log('Error on send friend req: ${e.toString()}');
    // }
  }

  Future acceptFriendReq(
    int myId,
    int anotherUserId,
    UserModel myUserModel,
  ) async {
    try {
      final anotherUser = UserModel.fromJson((await _dbUsers
              .child(
                anotherUserId.toString(),
              )
              .get())
          .value);

      ///
      final sIds = (anotherUser.sentFriendIds ?? []).toList();
      sIds.removeWhere((element) => element == myId);
      sIds.removeWhere(
          (element) => element == anotherUserId); //removing if any duplicate
      sIds.addAll(sIds.toSet().toList());
      final rIds = (anotherUser.receivedFriendIds ?? []).toList();
      rIds.removeWhere((element) => element == myId);
      rIds.removeWhere(
          (element) => element == anotherUserId); //removing if any duplicate
      rIds.addAll(rIds.toSet().toList());
      final fIds = (anotherUser.friendIds ?? []).toList();
      fIds.add(myId);
      fIds.addAll(fIds.toSet().toList());
      final anotherUserUpdated = anotherUser.copyWith(
        sentFriendIds: sIds,
        receivedFriendIds: rIds,
        friendIds: fIds,
      );

      ///
      final mySIds = (myUserModel.sentFriendIds ?? []).toList();
      mySIds.removeWhere((element) => element == anotherUserId);
      mySIds.removeWhere(
          (element) => element == myId); //removing if any duplicate
      mySIds.addAll(mySIds.toSet().toList());
      final myRIds = (myUserModel.receivedFriendIds ?? []).toList();
      myRIds.removeWhere((element) => element == anotherUserId);
      myRIds.removeWhere(
          (element) => element == myId); //removing if any duplicate
      myRIds.addAll(myRIds.toSet().toList());
      final myFIds = (myUserModel.friendIds ?? []).toList();
      myFIds.add(anotherUserId);
      myFIds.addAll(myFIds.toSet().toList());
      final userUpdated = myUserModel.copyWith(
        sentFriendIds: mySIds,
        receivedFriendIds: myRIds,
        friendIds: myFIds,
      );

      await _dbUsers
          .child(anotherUserId.toString())
          .update(anotherUserUpdated.toJson());
      await _dbUsers.child(myId.toString()).update(userUpdated.toJson());
    } catch (e) {
      log('Error on accept friend req: ${e.toString()}');
    }
  }

  Future removeFriendReq(
    int myId,
    int anotherUserId,
    UserModel myUserModel,
  ) async {
    try {
      final myRIds = (myUserModel.receivedFriendIds ?? [])
        ..remove(anotherUserId)
        ..toSet().toList();
      final userUpdated = myUserModel.copyWith(
        receivedFriendIds: myRIds,
      );
      await _dbUsers.child(myId.toString()).update(userUpdated.toJson());
    } catch (e) {
      log('Error on accept friend req: ${e.toString()}');
    }
  }

  ///AddBook
  Future addBookDB(int userid, BookModel bookModel) async {
    await _dbBooks.child('$userid').child(bookModel.id.toString()).update(bookModel.toJson());
  }

  ///NOTES CRUD
  Future addNote(int userId, NoteModel noteModel) async {
    await _dbNotes
        .child('$userId')
        .child(noteModel.id.toString())
        .update(noteModel.toJson());
  }

  Future<List<NoteModel>> getUserNotes(int userId) async {
    try {
      final notes = (await _dbNotes.child('$userId').get()).value;
      if (notes is Map) {
        try {
          return notes.keys
              .toList()
              .map((e) => NoteModel.fromJson(notes['$e']))
              .toList();
        } catch (e) {
          log('Some Error in parsing notes: $e');
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      log('Some Error in getting user notes: $e');
      return [];
    }
  }

  Future deleteNote(int userId, int noteId) async {
    await _dbNotes
        .child('$userId')
        .child('$noteId').remove();
  }
}
