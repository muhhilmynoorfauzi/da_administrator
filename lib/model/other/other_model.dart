import 'package:cloud_firestore/cloud_firestore.dart';

class OtherModel {
  List<String> subjectRelevance;

  OtherModel({
    required this.subjectRelevance,
  });

  Map<String, dynamic> toJson() => {
    'subjectRelevance': subjectRelevance,
  };

  factory OtherModel.fromJson(Map<String, dynamic> json) => OtherModel(
    subjectRelevance: List<String>.from(json['subjectRelevance']),
  );

  factory OtherModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => OtherModel.fromJson(snapshot.data()!);
}
