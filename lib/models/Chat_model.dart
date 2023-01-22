import 'package:readx/models/user_model.dart';

class ChatModel {
  ChatModel({
      this.id, 
      this.sender, 
      this.receiver, 
      this.message, 
      this.timestamp, 
      this.isUnread,});

  ChatModel.fromJson(dynamic json) {
    id = json['id'];
    sender = UserModel.fromJson(json['sender']);
    receiver = UserModel.fromJson(json['receiver']);
    message = json['message'];
    timestamp = json['timestamp'];
    isUnread = json['is_unread'];
  }
  int? id;
  UserModel? sender;
  UserModel? receiver;
  String? message;
  dynamic timestamp;
  bool? isUnread;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sender'] = sender?.toJson();
    map['receiver'] = receiver?.toJson();
    map['message'] = message;
    map['timestamp'] = timestamp.toString();
    map['is_unread'] = isUnread;
    return map;
  }

}