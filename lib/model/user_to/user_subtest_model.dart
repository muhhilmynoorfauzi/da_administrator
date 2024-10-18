import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';

import '../questions/stuffing_model.dart';

class UserSubtestModel {
  String nameSubTest;
  bool done;
  List<dynamic> listQuestions;


  UserSubtestModel({
    required this.nameSubTest,
    required this.done,
    required this.listQuestions,
  });

  Map<String, dynamic> toJson() => {
    'nameSubTest': nameSubTest,
    'done': done,
    'listQuestions': listQuestions.map((content) => content.toJson()).toList(),
  };

  factory UserSubtestModel.fromJson(Map<String, dynamic> json) => UserSubtestModel(
    nameSubTest: json['nameSubTest'],
    done: json['done'],
    listQuestions: (json['listQuestions'] as List<dynamic>).map((content) {
      switch (content['type']) {
        case 'banyak_pilihan':
          return CheckModel.fromJson(content);
        case 'pilihan_ganda':
          return PgModel.fromJson(content);
        case 'isian':
          return StuffingModel.fromJson(content);
        case 'benar_salah':
          return TrueFalseModel.fromJson(content);
        default:
          throw Exception('Unknown type: ${content['type']}');
      }
    }).toList(),
  );

  factory UserSubtestModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => UserSubtestModel.fromJson(snapshot.data()!);
}
