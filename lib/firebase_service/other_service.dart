import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/other/other_model.dart';

class OtherService {
  static Future<void> add(OtherModel other) async => await FirebaseFirestore.instance.collection('other_v2').add(other.toJson());

  static Future<String> addGetId(OtherModel other) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('other_v2').add(other.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('other_v2').doc(id).delete();

  static Future<void> edit({
    required String id,
    required List<String> subjectRelevance,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('other_v2').doc(id);

    final updates = <String, dynamic>{
      'subjectRelevance': subjectRelevance,
    };

    await docRef.update(updates);
  }
}
