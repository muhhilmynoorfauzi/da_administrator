import 'package:cloud_firestore/cloud_firestore.dart';

class CheckModel {
  String question;
  List<String> options;
  List<String> trueAnswer;
  String type;
  List<String> yourAnswer;
  List<String?> image;
  int value;
  int rating;
  String urlVideoExplanation;
  String explanation;

  CheckModel({
    required this.question,
    required this.options,
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
        'options': options,
        'trueAnswer': trueAnswer,
        'type': type,
        'yourAnswer': yourAnswer,
        'image': image,
        'value': value,
        'rating': rating,
        'urlVideoExplanation': urlVideoExplanation,
        'explanation': explanation,
      };

  factory CheckModel.fromJson(Map<String, dynamic> json) => CheckModel(
        question: json['question'],
        options: List<String>.from(json['options']),
        trueAnswer: List<String>.from(json['trueAnswer']),
        type: json['type'],
        yourAnswer: List<String>.from(json['yourAnswer']),
        image: List<String>.from(json['image']),
        value: json['value'],
        rating: json['rating'],
        urlVideoExplanation: json['urlVideoExplanation'],
        explanation: json['explanation'],
      );

  factory CheckModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => CheckModel.fromJson(snapshot.data()!);
}
