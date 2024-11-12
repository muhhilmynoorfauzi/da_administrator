import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';

class RationalizationUserService {
  static Future<void> add(RationalizationUserModel rationalizationUser) async => await FirebaseFirestore.instance.collection('rationalization_v2').add(rationalizationUser.toJson());

  static Future<String> addGetId(RationalizationUserModel rationalizationUser) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('rationalization_v2').add(rationalizationUser.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('rationalization_v2').doc(id).delete();

  static Future<void> edit({
    required String id,
    required List<JurusanModel> jurusan,
    required DateTime created,
    required String userUID,
    required String idTryout,
    required String idUserTo,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('rationalization_v2').doc(id);

    final updates = <String, dynamic>{
      'jurusan': jurusan.map((content) => content.toJson()).toList(),
      'created': created.toIso8601String(),
      'userUID': userUID,
      'idTryout': idTryout,
      'idUserTo': idUserTo,
    };

    await docRef.update(updates);
  }
}
