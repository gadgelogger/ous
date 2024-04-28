// // Flutter imports:
// import 'package:flutter/material.dart';

// class DetailImage extends StatelessWidget {
//   const DetailImage({super.key, required this.imageUrl});
//   final String imageUrl;

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(100),
//       child: Image.network(
//         imageUrl,
//         width: 200,
//         height: 200,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child: Icon(
//               Icons.broken_image,
//               size: 100,
//               color: Colors.grey[500],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
