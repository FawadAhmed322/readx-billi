/// id : 111
/// name : "Musaddiq"
/// image : ""
/// book_ids : [1,2,3,4,5]
/// friend_ids : [111,222,333,444]
/// sent_friend_ids : [555,666,777]
/// received_friend_ids : [555,666,777]
/// notes : ["a","b"]
/// feedbacks : ["a","b"]
/// book_read_count : {"book_id":1,"count":5}

class UserModel {
  UserModel({
      int? id, 
      String? name,
      bool? isOnline,
      String? email,
      String? password,
      String? image,
      List<int>? bookIds, 
      List<int>? friendIds, 
      List<int>? sentFriendIds, 
      List<int>? receivedFriendIds,
      List<String>? notes,
      List<String>? feedbacks, 
      BookReadCount? bookReadCount,}){
    _id = id;
    _name = name;
    _isOnline = isOnline;
    _email = email;
    _password = password;
    _image = image;
    _bookIds = bookIds;
    _friendIds = friendIds;
    _sentFriendIds = sentFriendIds;
    _receivedFriendIds = receivedFriendIds;
    _notes = notes;
    _feedbacks = feedbacks;
    _bookReadCount = bookReadCount;
}

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _isOnline = json['is_online'];
    _email = json['email'];
    _password = json['password'];
    _image = json['image'];
    _bookIds = json['book_ids'] != null ? json['book_ids'].cast<int>() : [];
    _friendIds = json['friend_ids'] != null ? json['friend_ids'].cast<int>() : [];
    _sentFriendIds = json['sent_friend_ids'] != null ? json['sent_friend_ids'].cast<int>() : [];
    _receivedFriendIds = json['received_friend_ids'] != null ? json['received_friend_ids'].cast<int>() : [];
    _notes = json['notes'] != null ? json['notes'].cast<String>() : [];
    _feedbacks = json['feedbacks'] != null ? json['feedbacks'].cast<String>() : [];
    _bookReadCount = json['book_read_count'] != null ? BookReadCount.fromJson(json['book_read_count']) : null;
  }
  int? _id;
  String? _name;
  bool? _isOnline;
  String? _email;
  String? _password;
  String? _image;
  List<int>? _bookIds;
  List<int>? _friendIds;
  List<int>? _sentFriendIds;
  List<int>? _receivedFriendIds;
  List<String>? _notes;
  List<String>? _feedbacks;
  BookReadCount? _bookReadCount;
UserModel copyWith({  int? id,
  String? name,
  bool? isOnline,
  String? email,
  String? password,
  String? image,
  List<int>? bookIds,
  List<int>? friendIds,
  List<int>? sentFriendIds,
  List<int>? receivedFriendIds,
  List<String>? notes,
  List<String>? feedbacks,
  BookReadCount? bookReadCount,
}) => UserModel(  id: id ?? _id,
  name: name ?? _name,
  isOnline: isOnline ?? _isOnline,
  email: email ?? _email,
  password: password ?? _password,
  image: image ?? _image,
  bookIds: bookIds ?? _bookIds,
  friendIds: friendIds ?? _friendIds,
  sentFriendIds: sentFriendIds ?? _sentFriendIds,
  receivedFriendIds: receivedFriendIds ?? _receivedFriendIds,
  notes: notes ?? _notes,
  feedbacks: feedbacks ?? _feedbacks,
  bookReadCount: bookReadCount ?? _bookReadCount,
);
  int? get id => _id;
  String? get name => _name;
  bool? get isOnline => _isOnline;
  String? get email => _email;
  String? get password => _password;
  String? get image => _image;
  List<int>? get bookIds => _bookIds;
  List<int>? get friendIds => _friendIds;
  List<int>? get sentFriendIds => _sentFriendIds;
  List<int>? get receivedFriendIds => _receivedFriendIds;
  List<String>? get notes => _notes;
  List<String>? get feedbacks => _feedbacks;
  BookReadCount? get bookReadCount => _bookReadCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['is_online'] = _isOnline;
    map['email'] = _email;
    map['password'] = _password;
    map['image'] = _image;
    map['book_ids'] = _bookIds;
    map['friend_ids'] = _friendIds;
    map['sent_friend_ids'] = _sentFriendIds;
    map['received_friend_ids'] = _receivedFriendIds;
    map['notes'] = _notes;
    map['feedbacks'] = _feedbacks;
    if (_bookReadCount != null) {
      map['book_read_count'] = _bookReadCount?.toJson();
    }
    return map;
  }

}

/// book_id : 1
/// count : 5

class BookReadCount {
  BookReadCount({
      int? bookId, 
      int? count,}){
    _bookId = bookId;
    _count = count;
}

  BookReadCount.fromJson(dynamic json) {
    _bookId = json['book_id'];
    _count = json['count'];
  }
  int? _bookId;
  int? _count;
BookReadCount copyWith({  int? bookId,
  int? count,
}) => BookReadCount(  bookId: bookId ?? _bookId,
  count: count ?? _count,
);
  int? get bookId => _bookId;
  int? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['book_id'] = _bookId;
    map['count'] = _count;
    return map;
  }

}