import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';

class JurusanService {
  static Future<void> add(JurusanModel jurusan) async => await FirebaseFirestore.instance.collection('jurusan_v03').add(jurusan.toJson());

  static Future<String> addGetId(JurusanModel jurusan) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('jurusan_v03').add(jurusan.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('jurusan_v03').doc(id).delete();

  static Future<void> edit({
    required String id,
    required String namaJurusan,
    required List<String> relevance,
    required double value,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('jurusan_v03').doc(id);

    final updates = <String, dynamic>{
      'namaJurusan': namaJurusan,
      'relevance': relevance,
      'value': value,
    };

    await docRef.update(updates);
  }
}
