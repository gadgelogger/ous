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
    for (String collection in collections) {
      var querySnapshot = await _firestore
          .collection(collection)
          .where('accountuid', isEqualTo: userId)
          .get();
      for (var doc in querySnapshot.docs) {
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
