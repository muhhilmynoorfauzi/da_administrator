import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';

class UnivService {
  static Future<void> add(UnivModel univ) async => await FirebaseFirestore.instance.collection('univ_v2').add(univ.toJson());

  static Future<String> addGetId(UnivModel univ) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('univ_v2').add(univ.toJson());
    return docRef.id;
  }

  static Future<void> delete(String id) async => await FirebaseFirestore.instance.collection('univ_v2').doc(id).delete();

  static Future<void> edit({
    required String id,
    required String namaUniv,
    required String lokasiUniv,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('univ_v2').doc(id);

    final updates = <String, dynamic>{
      'namaUniv': namaUniv,
      'lokasiUniv': lokasiUniv,
    };

    await docRef.update(updates);
  }
}
