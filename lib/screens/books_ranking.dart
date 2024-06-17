import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:books_ranking/models/book.dart';
import 'package:books_ranking/screens/book_details.dart';

class BooksRanking extends StatefulWidget {
  const BooksRanking({super.key});

  @override
  State<BooksRanking> createState() => _BooksRankingState();
}

class _BooksRankingState extends State<BooksRanking> {
  List<Book> books = [];
  String errorMessage = '';

  Future<void> fetchBooks({String categoryId = '001'}) async {
    final String url =
        'https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&booksGenreId=${categoryId}&sort=sales&applicationId=${dotenv.get('API_KEY')}';

    try {
      final res = await Dio().get(url);
      if (res.statusCode == 200) {
        setState(() {
          books = res.data['Items'].map<Book>((item) {
            final bookData = item['Item'];
            if (bookData == null) {
              throw Exception('Invalid item data');
            }
            return Book.fromMap(bookData);
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
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category name"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('001005'),
              onTap: () {
                fetchBooks(categoryId: '001005');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('001006'),
              onTap: () {
                fetchBooks(categoryId: '001006');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (ctx, index) {
            return SizedBox(
              height: 110,
              child: ListTile(
                hoverColor: const Color.fromARGB(255, 168, 210, 245),
                leading: SizedBox(
                  width: 30,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 29, 29, 29),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Image.network(
                      books[index].smallImageUrl,
                      width: 60,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 13,
                          ),
                          Text(
                            books[index].title,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            books[index].author,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) {
                    return BookDetails();
                  }));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
