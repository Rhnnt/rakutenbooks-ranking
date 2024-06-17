class Genre {
  final String id;
  final String name;
  List<Genre> children = [];

  Genre({
    required this.id,
    required this.name,
    this.children = const [],
  });

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['booksGenreId'],
      name: map['booksGenreName'],
    );
  }
}
