class Genre {
  final String id;
  final String name;
  final int level;
  List<Genre> children = [];

  Genre({
    required this.id,
    required this.name,
    required this.level,
    this.children = const [],
  });

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['booksGenreId'],
      name: map['booksGenreName'],
      level: map['genreLevel'],
    );
  }
}
