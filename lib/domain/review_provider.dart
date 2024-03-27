import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/gen/review_data.dart';

final reviewsProvider =
    StreamProvider.family<List<Review>, String>((ref, gakubu) {
  return FirebaseFirestore.instance.collection(gakubu).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList(),
      );
});
