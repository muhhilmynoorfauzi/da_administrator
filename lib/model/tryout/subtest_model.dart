import 'package:cloud_firestore/cloud_firestore.dart';

import '../questions/stuffing_model.dart';

class SubtestModel {
  String nameSubTest;
  int timeMinute;
  String idQuestions;

  SubtestModel({
    required this.nameSubTest,
    required this.timeMinute,
    required this.idQuestions,
  });

  Map<String, dynamic> toJson() => {
        'name': nameSubTest,
        'timeMinute': timeMinute,
        'idQuestions': idQuestions,
      };

  factory SubtestModel.fromJson(Map<String, dynamic> json) => SubtestModel(
        nameSubTest: json['name'],
        timeMinute: json['timeMinute'],
        idQuestions: json['idQuestions'],
      );

  factory SubtestModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => SubtestModel.fromJson(snapshot.data()!);
}
