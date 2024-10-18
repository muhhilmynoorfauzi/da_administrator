import 'package:cloud_firestore/cloud_firestore.dart';

class RationalizationModel {
  int value;
  String jurusan;
  String univ;

  RationalizationModel({
    required this.value,
    required this.jurusan,
    required this.univ,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'jurusan': jurusan,
        'univ': univ,
      };

  factory RationalizationModel.fromJson(Map<String, dynamic> json) => RationalizationModel(
        value: json['value'],
        jurusan: json['jurusan'],
        univ: json['univ'],
      );

  factory RationalizationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => RationalizationModel.fromJson(snapshot.data()!);
}
