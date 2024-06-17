class Book {
  Book({
    required this.title,
    required this.author,
    required this.itemPrice,
    required this.itemUrl,
    required this.smallImageUrl,
    required this.itemCaption,
  });

  String title;
  String author;
  int itemPrice;
  String itemUrl;
  String smallImageUrl;
  String itemCaption;

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      author: map['author'],
      itemPrice: map['itemPrice'],
      itemUrl: map['itemUrl'],
      smallImageUrl: map['smallImageUrl'],
      itemCaption: map['itemCaption'],
    );
  }
}
