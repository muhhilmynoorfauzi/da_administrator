import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';

class TryoutReviewService {
  static Future<void> add(TryoutReviewModel toReview) async => await FirebaseFirestore.instance.collection('review_v03').add(toReview.toJson());

  static Future<String> addGetId(TryoutReviewModel toReview) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('review_v03').add(toReview.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('review_v03').doc(id).delete();

  static Future<void> edit({
    required String id,
    required String userUID,
    required String userName,
    required String text,
    required String image,
    required String idTryOut,
    required int rating,
    required DateTime created,
    required bool isPublic,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('review_v03').doc(id);

    final updates = <String, dynamic>{
      'userUID': userUID,
      'userName': userName,
      'text': text,
      'idTryOut': idTryOut,
      'image': image,
      'rating': rating,
      'created': created.toIso8601String(),
      'isPublic': isPublic,
    };

    await docRef.update(updates);
  }
}
