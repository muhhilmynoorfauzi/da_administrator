import 'package:cloud_firestore/cloud_firestore.dart';

class PgModel {
  String question;
  List<String> options;
  String trueAnswer;
  String subjectRelevance;
  String type;
  List<String> yourAnswer;
  List<String?> image;
  int value;
  int rating;
  String urlVideoExplanation;
  String explanation;

  PgModel({
    required this.question,
    required this.options,
    required this.trueAnswer,
    required this.subjectRelevance,
    required this.type,
    required this.yourAnswer,
    required this.image,
    required this.value,
    required this.rating,
    required this.urlVideoExplanation,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'trueAnswer': trueAnswer,
        'subjectRelevance': subjectRelevance,
        'type': type,
        'yourAnswer': yourAnswer,
        'image': image,
        'value': value,
        'rating': rating,
        'urlVideoExplanation': urlVideoExplanation,
        'explanation': explanation,
      };

  factory PgModel.fromJson(Map<String, dynamic> json) => PgModel(
        question: json['question'],
        options: List<String>.from(json['options']),
        trueAnswer: json['trueAnswer'],
        subjectRelevance: json['subjectRelevance'],
        type: json['type'],
        yourAnswer: List<String>.from(json['yourAnswer']),
        image: List<String>.from(json['image']),
        value: json['value'],
        rating: json['rating'],
        urlVideoExplanation: json['urlVideoExplanation'],
        explanation: json['explanation'],
      );

  factory PgModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => PgModel.fromJson(snapshot.data()!);
}
