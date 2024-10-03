import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/tryout/user_claimed.dart';


class TryoutService {
  static Future<void> add(TryoutModel tryout) async => await FirebaseFirestore.instance.collection('tryout_v1').add(tryout.toJson());

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('tryout_v1').doc(id).delete();

  static Future<void> edit({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String toCode,
    required String toName,
    required DateTime started,
    required DateTime ended,
    required String desk,
    required String image,
    required bool phase,
    required bool expired,
    required bool public,
    required bool showFreeMethod,
    required int totalTime,
    required int numberQuestions,
    required List<TestModel> listTest,
    required List<UserClaimed> claimedUid,
    required List<int> listPrice,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('tryout_v1').doc(id);

    final updates = <String, dynamic>{
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'toCode': toCode,
      'toName': toName,
      'started': started.toIso8601String(),
      'ended': ended.toIso8601String(),
      'startWork': started.toIso8601String(),
      'endWork': ended.toIso8601String(),
      'desk': desk,
      'image': image,
      'phase': phase,
      'expired': expired,
      'public': public,
      'showFreeMethod': showFreeMethod,
      'totalTime': totalTime,
      'numberQuestions': numberQuestions,
      'listTest': listTest.map((content) => content.toJson()).toList(),
      'claimedUid': claimedUid.map((content) => content.toJson()).toList(),
      'listPrice': listPrice,
    };

    await docRef.update(updates);
  }
}
