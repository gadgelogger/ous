import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/gen/review_data.dart';

final reviewsProvider =
    StreamProvider.family<List<Review>, (String, String)>((ref, params) {
  final (gakubu, selectedBumon) = params;

  Query<Map<String, dynamic>> query =
      FirebaseFirestore.instance.collection(gakubu);

  if (selectedBumon.isNotEmpty) {
    query = query.where('bumon', isEqualTo: selectedBumon);
  }

  return query.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList(),
      );
});
