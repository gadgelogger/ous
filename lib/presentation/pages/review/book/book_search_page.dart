import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/gen/book_data.dart';
import 'package:ous/presentation/pages/review/book/book_detail_page.dart';
import 'package:ous/presentation/pages/review/book/book_scan_page.dart';
import 'package:xml/xml.dart';

class BookSearchView extends StatefulWidget {
  const BookSearchView({super.key});

  @override
  _BookSearchViewState createState() => _BookSearchViewState();
}

class _BookSearchViewState extends State<BookSearchView> {
  String searchQuery = '';
  List<BookData> bookList = [];
  bool isSearching = false;
  bool isLoading = false;
  bool isInitialState = true;

  Future<void> fetchBookInfo(String query) async {
    if (query.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
      isInitialState = false;
    });

    final dio = Dio();
    final url =
        'https://iss.ndl.go.jp/api/sru?operation=searchRetrieve&version=1.2&recordSchema=dcndl&onlyBib=true&recordPacking=xml&query=title="$query" OR creator="$query"';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);
        final List<BookData> fetchedBooks = [];

        for (final record in document.findAllElements('record')) {
          final isbn = record
              .findAllElements('dcterms:identifier')
              .firstWhere(
                (element) => element.text.startsWith('978-'),
                orElse: () => XmlElement(XmlName('dcterms:identifier')),
              )
              .text
              .replaceAll('-', '');

          final thumbnailUrl = isbn.isNotEmpty
              ? 'https://ndlsearch.ndl.go.jp/thumbnail/$isbn.jpg'
              : '';

          final publishedDate = record
              .findAllElements('dcterms:date')
              .map((node) => node.text)
              .firstWhere((date) => date.isNotEmpty, orElse: () => '');

          final extent = record
              .findAllElements('dcterms:extent')
              .map((node) => node.text)
              .join(', ');

          final subject = record
              .findAllElements('dcterms:subject')
              .map((node) => node.text)
              .toList();

          final bookModel = BookData(
            title: record
                    .findAllElements('dcterms:title')
                    .map((node) => node.text)
                    .join(', ')
                    .isNotEmpty
                ? record
                    .findAllElements('dcterms:title')
                    .map((node) => node.text)
                    .join(', ')
                : '不明',
            author: record
                    .findAllElements('dc:creator')
                    .map((node) => node.text)
                    .join(', ')
                    .isNotEmpty
                ? record
                    .findAllElements('dc:creator')
                    .map((node) => node.text)
                    .join(', ')
                : '不明',
            price: record
                    .findAllElements('dcndl:price')
                    .map((node) => node.text)
                    .join(', ')
                    .isNotEmpty
                ? record
                    .findAllElements('dcndl:price')
                    .map((node) => node.text)
                    .join(', ')
                : '不明',
            catalogingStatus: record
                .findAllElements('dcndl:catalogingStatus')
                .map((node) => node.text)
                .join(', '),
            catalogingRule: record
                .findAllElements('dcndl:catalogingRule')
                .map((node) => node.text)
                .join(', '),
            managementDescription: record
                .findAllElements('dcterms:description')
                .where(
                  (element) =>
                      element.parentElement?.name.local == 'BibAdminResource',
                )
                .map((node) => node.text)
                .join(', '),
            bibRecordCategory: record
                .findAllElements('dcndl:bibRecordCategory')
                .map((node) => node.text)
                .join(', '),
            bibRecordSubCategory: record
                .findAllElements('dcndl:bibRecordSubCategory')
                .map((node) => node.text)
                .join(', '),
            imageUrl: thumbnailUrl,
            isbn: isbn,
            publishedDate: publishedDate,
            extent: extent,
            subject: subject,
          );

          fetchedBooks.add(bookModel);
        }

        setState(() {
          bookList = fetchedBooks;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load book data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error: $e');
      throw Exception('Failed to load book data');
    }
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchQuery = '';
        bookList.clear();
        isInitialState = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                onSubmitted: (value) {
                  fetchBookInfo(searchQuery);
                },
                decoration: const InputDecoration(
                  hintText: 'タイトルまたは著者名で検索',
                  border: InputBorder.none,
                ),
              )
            : const Text('本の検索'),
        actions: [
          IconButton(
            onPressed: toggleSearch,
            icon: isSearching
                ? const Icon(Icons.close)
                : const Icon(Icons.search),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isInitialState
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(
                          image: AssetImage(Assets.icon.search.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        '右上の虫眼鏡マークから検索をしてください',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : bookList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Image(
                              image: AssetImage(Assets.icon.found.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            '結果が見つかりませんでした\n別の条件で再度検索をしてみてください。',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: bookList.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final book = bookList[index];
                        return ListTile(
                          leading: book.imageUrl.isNotEmpty
                              ? Image.network(
                                  book.imageUrl,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                    );
                                  },
                                )
                              : const Icon(Icons.book, size: 50),
                          title: Text(
                            book.title,
                            maxLines: 2,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '著者: ${book.author}',
                                maxLines: 2,
                              ),
                              Text(
                                '価格: ${book.price}',
                                maxLines: 1,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailPage(bookData: book),
                              ),
                            );
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('バーコードでも検索できます'),
        icon: const Icon(Icons.qr_code),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookScanView()),
          );
        },
      ),
    );
  }
}
