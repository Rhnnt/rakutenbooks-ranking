import 'package:books_ranking/models/genre.dart';
import 'package:books_ranking/screens/books_ranking.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GenreList extends StatefulWidget {
  const GenreList({super.key, required this.onCallFunction});

  final void Function({required String categoryId})? onCallFunction;

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  List<Genre> genres = [];
  String errorMessage = '';

  //一回001の子ジャンル達をインスタンス化してリストに格納→
  Future<void> fetchGenres({String genreId = '001'}) async {
    String url =
        'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128?format=json&booksGenreId=${genreId}&applicationId=${dotenv.get('API_KEY')}';

    try {
      final res = await Dio().get(url);
      if (res.statusCode == 200) {
        final data = res.data;
        setState(() {
          genres = data['children'].map<Genre>((child) {
            if (child == null) {
              throw Exception('Invalid item data');
            }
            return Genre.fromMap(child['child']);
          }).toList();
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load images. Status code: ${res.statusCode}';
        });
        print('Error response: ${res.data}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load images: $e';
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: genres.length,
      itemBuilder: (ctx, index) {
        return ExpansionTile(
          title: Text(genres[index].name),
          onExpansionChanged: (value) {
            widget.onCallFunction!(categoryId: genres[index].id);
          },
        );
      },
    );
  }
}
