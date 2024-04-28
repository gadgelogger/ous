import 'package:flutter/material.dart';
import 'package:ous/gen/book_data.dart';
import 'package:ous/presentation/widgets/review/book/detail_info.dart';

class BookDetailPage extends StatelessWidget {
  final BookData bookData;

  const BookDetailPage({Key? key, required this.bookData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本の詳細'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bookData.imageUrl.isNotEmpty)
              Image.network(
                bookData.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            const SizedBox(height: 30),
            Text(
              bookData.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            DetailInfo(
              icon: Icons.people,
              info: '著者',
              text: bookData.author,
            ),
            DetailInfo(
              icon: Icons.money,
              info: '価格',
              text: bookData.price,
            ),
            DetailInfo(
              icon: Icons.settings,
              info: '出版日',
              text: bookData.publishedDate,
            ),
            DetailInfo(
              icon: Icons.settings,
              info: 'ページ数',
              text: bookData.extent,
            ),
            DetailInfo(
              icon: Icons.settings,
              info: 'ISBN',
              text: bookData.isbn,
            ),
          ],
        ),
      ),
    );
  }
}
