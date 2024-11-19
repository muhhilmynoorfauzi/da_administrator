import 'package:cloud_firestore/cloud_firestore.dart';

class OtherModel {
  List<String> subjectRelevance;
  // String question;

  OtherModel({
    required this.subjectRelevance,
    // required this.question,
  });

  Map<String, dynamic> toJson() => {
        'subjectRelevance': subjectRelevance,
        // 'question': question,
      };

  factory OtherModel.fromJson(Map<String, dynamic> json) => OtherModel(
        subjectRelevance: List<String>.from(json['subjectRelevance']),
        // question: json['question'] ?? 'question kosong',
      );

  factory OtherModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => OtherModel.fromJson(snapshot.data()!);
}
