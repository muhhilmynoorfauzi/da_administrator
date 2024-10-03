import 'package:cloud_firestore/cloud_firestore.dart';

class StuffingModel {
  String question;
  String trueAnswer;
  String type;
  List<String> yourAnswer;
  List<String?> image;
  int? value;
  int? rating;
  String urlVideoExplanation;
  String explanation;

  StuffingModel({
    required this.question,
    required this.trueAnswer,
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
        'trueAnswer': trueAnswer,
        'type': type,
        'yourAnswer': yourAnswer,
        'image': image,
        'value': value,
        'rating': rating,
        'urlVideoExplanation': urlVideoExplanation,
        'explanation': explanation,
      };

  factory StuffingModel.fromJson(Map<String, dynamic> json) => StuffingModel(
        question: json['question'],
        trueAnswer: json['trueAnswer'],
        type: json['type'],
        yourAnswer: List<String>.from(json['yourAnswer']),
        image: List<String>.from(json['image']),
        value: json['value'],
        rating: json['rating'],
        urlVideoExplanation: json['urlVideoExplanation'],
        explanation: json['explanation'],
      );

  factory StuffingModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => StuffingModel.fromJson(snapshot.data()!);
}
