import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/questions_model.dart';

class QuestionsService {
  static Future<void> add(QuestionsModel soal) async => await FirebaseFirestore.instance.collection('questions_v2').add(soal.toJson());

  static Future<String> addGetId(QuestionsModel soal) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('questions_v2').add(soal.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('questions_v2').doc(id).delete();

  static Future<void> edit({
    required String id,
    required String idTryOut,
    required List<dynamic> listQuestions,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('questions_v2').doc(id);

    final updates = <String, dynamic>{
      'idTryOut': idTryOut,
      'listQuestions': listQuestions.map((content) => content.toJson()).toList(),
    };

    await docRef.update(updates);
  }
}
