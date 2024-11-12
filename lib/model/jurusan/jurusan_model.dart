
import 'package:cloud_firestore/cloud_firestore.dart';

class JurusanModel {
  String namaJurusan;
  List<String> relevance;
  double value;

  JurusanModel({
    required this.namaJurusan,
    required this.relevance,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'namaJurusan': namaJurusan,
    'relevance': relevance,
    'value': value,
  };

  factory JurusanModel.fromJson(Map<String, dynamic> json) => JurusanModel(
    namaJurusan: json['namaJurusan'],
    value: (json['value'] as num).toDouble(),
    relevance: List<String>.from(json['relevance']),
  );

  factory JurusanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => JurusanModel.fromJson(snapshot.data()!);
}