import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/user_to/leaderboard_model.dart';
import 'package:da_administrator/model/user_to/rationalization_model.dart';
import 'package:da_administrator/model/user_to/user_test_model.dart';
import 'package:da_administrator/model/user_to/user_to_model.dart';

class UserToService {
  static Future<void> add(UserToModel userTryout) async => await FirebaseFirestore.instance.collection('user_to_v1').add(userTryout.toJson());

  static Future<String> addGetId(UserToModel userTryout) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('user_to_v1').add(userTryout.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('user_to_v1').doc(id).delete();

  static Future<void> edit({
    required String id,
    required String userUID,
    required String idTryOut,
    required String toName,
    required int valuesDiscussion,
    required int average,
    required int correctAnswer,
    required int wrongAnswer,
    required DateTime startWork,
    required DateTime endWork,
    required DateTime created,
    required List<LeaderBoardModel> leaderBoard,
    required List<RationalizationModel> rationalization,
    required List<UserTestModel> listTest,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('user_to_v1').doc(id);

    final updates = <String, dynamic>{
      'userUID': userUID,
      'idTryOut': idTryOut,
      'toName': toName,
      'valuesDiscussion': valuesDiscussion,
      'average': average,
      'correctAnswer': correctAnswer,
      'wrongAnswer': wrongAnswer,
      'startWork': startWork.toIso8601String(),
      'endWork': endWork.toIso8601String(),
      'created': created.toIso8601String(),
      'leaderBoard': leaderBoard.map((content) => content.toJson()).toList(),
      'rationalization': rationalization.map((content) => content.toJson()).toList(),
      'listTest': listTest.map((content) => content.toJson()).toList(),
    };

    await docRef.update(updates);
  }
}
