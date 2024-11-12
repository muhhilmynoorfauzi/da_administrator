import 'package:cloud_firestore/cloud_firestore.dart';

class UnivModel {
  String namaUniv;
  String lokasiUniv;

  UnivModel({
    required this.namaUniv,
    required this.lokasiUniv,
  });

  Map<String, dynamic> toJson() => {
        'namaUniv': namaUniv,
        'lokasiUniv': lokasiUniv,
      };

  factory UnivModel.fromJson(Map<String, dynamic> json) => UnivModel(
        namaUniv: json['namaUniv'],
        lokasiUniv: json['lokasiUniv'],
      );

  factory UnivModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => UnivModel.fromJson(snapshot.data()!);
}
