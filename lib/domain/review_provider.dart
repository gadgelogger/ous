import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/gen/review_data.dart';

final reviewsProvider = StreamProvider.family<
    List<Review>,
    (
      String,
      String,
      String,
      String,
      String,
      String,
      String,
      String
    )>((ref, params) {
  final (
    gakubu,
    selectedBumon,
    selectedGakki,
    selectedTanni,
    selectedZyugyoukeisiki,
    selectedSyusseki,
    searchQuery,
    selectedDateOrder // 追加
  ) = params;

  Query<Map<String, dynamic>> query =
      FirebaseFirestore.instance.collection(gakubu);

  if (selectedBumon.isNotEmpty) {
    query = query.where('bumon', isEqualTo: selectedBumon);
  }

  if (selectedGakki.isNotEmpty) {
    query = query.where('gakki', isEqualTo: selectedGakki);
  }

  if (selectedTanni.isNotEmpty) {
    query = query.where('tannisuu', isEqualTo: selectedTanni);
  }

  if (selectedZyugyoukeisiki.isNotEmpty) {
    query = query.where('zyugyoukeisiki', isEqualTo: selectedZyugyoukeisiki);
  }

  if (selectedSyusseki.isNotEmpty) {
    query = query.where('syusseki', isEqualTo: selectedSyusseki);
  }

  if (searchQuery.isNotEmpty) {
    query = query
        .where('zyugyoumei', isGreaterThanOrEqualTo: searchQuery)
        .where('zyugyoumei', isLessThan: '${searchQuery}z');
  }

  if (selectedDateOrder == 'newest') {
    query = query.orderBy('date', descending: true);
  } else if (selectedDateOrder == 'oldest') {
    query = query.orderBy('date', descending: false);
  }

  return query.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList(),
      );
});
