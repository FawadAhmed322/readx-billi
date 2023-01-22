class BookModel {
  BookModel({
      this.id, 
      this.name, 
      this.rating, 
      this.genre, 
      this.isTrending, 
      this.writer, 
      this.image, 
      this.price,});

  BookModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    genre = json['genre'] != null ? json['genre'].cast<String>() : [];
    isTrending = json['is_trending'];
    writer = json['writer'];
    image = json['image'];
    price = json['price'];
  }
  int? id;
  String? name;
  double? rating;
  List<String>? genre;
  bool? isTrending;
  String? writer;
  String? image;
  int? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['rating'] = rating;
    map['genre'] = genre;
    map['is_trending'] = isTrending;
    map['writer'] = writer;
    map['image'] = image;
    map['price'] = price;
    return map;
  }

}