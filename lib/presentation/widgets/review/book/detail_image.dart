// Flutter imports:
import 'package:flutter/material.dart';
import 'package:ous/gen/book_data.dart';

class DetailImage extends StatelessWidget {
  const DetailImage({super.key, required this.bookData}) : super();
  final BookData bookData;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      bookData.imageUrl,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            Icons.broken_image,
            size: 100,
            color: Colors.grey[500],
          ),
        );
      },
    );
  }
}
