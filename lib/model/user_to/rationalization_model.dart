import 'package:cloud_firestore/cloud_firestore.dart';

class RationalizationModel {
  int value;
  String jurusan;
  String universitas;

  RationalizationModel({
    required this.value,
    required this.jurusan,
    required this.universitas,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'jurusan': jurusan,
        'univ': universitas,
      };

  factory RationalizationModel.fromJson(Map<String, dynamic> json) => RationalizationModel(
        value: json['value'],
        jurusan: json['jurusan'],
        universitas: json['univ'],
      );

  factory RationalizationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => RationalizationModel.fromJson(snapshot.data()!);
}
