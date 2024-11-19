import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/other/other_model.dart';

class OtherService {
  static Future<void> add(OtherModel other) async => await FirebaseFirestore.instance.collection('other_v03').add(other.toJson());

  static Future<String> addGetId(OtherModel other) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('other_v03').add(other.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('other_v03').doc(id).delete();

  static Future<void> edit({
    required String id,
    required List<String> subjectRelevance,
    // required String question,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('other_v03').doc(id);

    final updates = <String, dynamic>{
      'subjectRelevance': subjectRelevance,
      // 'question': question,
    };

    await docRef.update(updates);
  }
}
