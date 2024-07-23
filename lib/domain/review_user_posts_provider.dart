import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/gen/review_data.dart';

final fetchUserReviews = FutureProvider<List<Review>>((ref) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return [];
  final service = FetchUserReviews();
  return await service.fetchReviews(userId);
});

class FetchUserReviews {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteReview(Review review) async {
    List<String> collections = [
      'keiei',
      'kiban',
      'kougakubu',
      'kyouiku',
      'kyousyoku',
      'rigaku',
      'seibutu',
      'seimei',
      'zyouhou',
      'zyuui',
    ];

    for (String collection in collections) {
      final querySnapshot = await _firestore
          .collection(collection)
          .where('accountuid', isEqualTo: review.accountuid)
          .where('ID', isEqualTo: review.ID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        break;
      }
    }
  }

  Future<List<Review>> fetchReviews(String userId) async {
    List<Review> reviews = [];
    List<String> collections = [
      'keiei',
      'kiban',
      'kougakubu',
      'kyouiku',
      'kyousyoku',
      'rigaku',
      'seibutu',
      'seimei',
      'zyouhou',
      'zyuui',
    ];

    final futures = collections.map((collection) {
      return _firestore
          .collection(collection)
          .where('accountuid', isEqualTo: userId)
          .get();
    }).toList();

    final querySnapshots = await Future.wait(futures);

    for (var querySnapshot in querySnapshots) {
      // デバッグ用にクエリ結果を出力
      print('クエリ結果のドキュメント数: ${querySnapshot.docs.length}');
      for (var doc in querySnapshot.docs) {
        print('ドキュメントデータ: ${doc.data()}');
        reviews.add(Review.fromJson(doc.data()));
      }
    }
    return reviews;
  }

  Future<void> updateReview(Review review) async {
    List<String> collections = [
      'keiei',
      'kiban',
      'kougakubu',
      'kyouiku',
      'kyousyoku',
      'rigaku',
      'seibutu',
      'seimei',
      'zyouhou',
      'zyuui',
    ];

    for (String collection in collections) {
      final querySnapshot = await _firestore
          .collection(collection)
          .where('accountuid', isEqualTo: review.accountuid)
          .where('ID', isEqualTo: review.ID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(review.toJson());
        break;
      }
    }
  }
}
