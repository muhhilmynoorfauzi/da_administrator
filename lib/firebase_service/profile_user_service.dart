import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';

class ProfileUserService {
  static Future<void> add(ProfileUserModel userProfile) async => await FirebaseFirestore.instance.collection('profile_v2').add(userProfile.toJson());

  static Future<String> addGetId(ProfileUserModel userProfile) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('profile_v2').add(userProfile.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('profile_v2').doc(id).delete();

  static Future<void> edit({
    required String id,
    required String userUID,
    required String imageProfile,
    required String userName,
    required String email,
    required String role,
    required int koin,
    required String uniqueUserName,
    required String asalSekolah,
    required List<PlanOptions> listPlan,
    required String kontak,
    required String motivasi,
    required String tempatTinggal,
    required DateTime update,
    required DateTime created,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('profile_v2').doc(id);

    final updates = <String, dynamic>{
      'userUID': userUID,
      'imageProfile': imageProfile,
      'userName': userName,
      'email': email,
      'role': role,
      'koin': koin,
      'uniqueUserName': uniqueUserName,
      'asalSekolah': asalSekolah,
      'listPlan': listPlan.map((content) => content.toJson()).toList(),
      'kontak': kontak,
      'motivasi': motivasi,
      'tempatTinggal': tempatTinggal,
      'update': update.toIso8601String(),
      'created': created.toIso8601String(),
    };

    await docRef.update(updates);
  }
}
