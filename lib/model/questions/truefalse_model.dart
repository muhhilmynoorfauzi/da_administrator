import 'package:cloud_firestore/cloud_firestore.dart';

class TrueFalseModel {
  String question;
  String subjectRelevance;
  String type;
  List<String?> image;
  List<TrueFalseOption> trueAnswer;
  List<TrueFalseOption> yourAnswer;
  int value;
  int rating;
  String urlVideoExplanation;
  String explanation;

  TrueFalseModel({
    required this.question,
    required this.subjectRelevance,
    required this.type,
    required this.image,
    required this.trueAnswer,
    required this.yourAnswer,
    required this.value,
    required this.rating,
    required this.urlVideoExplanation,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'subjectRelevance': subjectRelevance,
        'type': type,
        'image': image,
        'trueAnswer': trueAnswer.map((content) => content.toJson()).toList(),
        'yourAnswer': yourAnswer.map((content) => content.toJson()).toList(),
        'value': value,
        'rating': rating,
        'urlVideoExplanation': urlVideoExplanation,
        'explanation': explanation,
      };

  factory TrueFalseModel.fromJson(Map<String, dynamic> json) => TrueFalseModel(
        question: json['question'],
        subjectRelevance: json['subjectRelevance'],
        type: json['type'],
        image: List<String>.from(json['image']),
        trueAnswer: (json['trueAnswer'] as List<dynamic>).map((content) => TrueFalseOption.fromJson(content)).toList(),
        yourAnswer: (json['yourAnswer'] as List<dynamic>).map((content) => TrueFalseOption.fromJson(content)).toList(),
        value: json['value'],
        rating: json['rating'],
        urlVideoExplanation: json['urlVideoExplanation'],
        explanation: json['explanation'],
      );

  factory TrueFalseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => TrueFalseModel.fromJson(snapshot.data()!);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------
class TrueFalseOption {
  String option;
  bool trueAnswer;

  TrueFalseOption({
    required this.option,
    required this.trueAnswer,
  });

  Map<String, dynamic> toJson() => {
        'option': option,
        'trueAnswer': trueAnswer,
      };

  factory TrueFalseOption.fromJson(Map<String, dynamic> json) => TrueFalseOption(
        option: json['option'],
        trueAnswer: json['trueAnswer'],
      );

  factory TrueFalseOption.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => TrueFalseOption.fromJson(snapshot.data()!);
}
