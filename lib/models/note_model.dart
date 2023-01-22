/// id : 1
/// title : ""
/// description : ""
/// user_id : 11

class NoteModel {
  NoteModel({
      int? id, 
      String? title, 
      String? description, 
      int? userId,}){
    _id = id;
    _title = title;
    _description = description;
    _userId = userId;
}

  NoteModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _userId = json['user_id'];
  }
  int? _id;
  String? _title;
  String? _description;
  int? _userId;
NoteModel copyWith({  int? id,
  String? title,
  String? description,
  int? userId,
}) => NoteModel(  id: id ?? _id,
  title: title ?? _title,
  description: description ?? _description,
  userId: userId ?? _userId,
);
  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  int? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['user_id'] = _userId;
    return map;
  }

}