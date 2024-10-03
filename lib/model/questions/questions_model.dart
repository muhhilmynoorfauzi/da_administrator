import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';

class QuestionsModel {
  String idTryOut;
  List<dynamic> listQuestions;

  QuestionsModel({
    required this.idTryOut,
    required this.listQuestions,
  });

  Map<String, dynamic> toJson() => {
    'idTryOut': idTryOut,
    'listQuestions': listQuestions.map((content) => content.toJson()).toList(),
  };

  factory QuestionsModel.fromJson(Map<String, dynamic> json) => QuestionsModel(
    idTryOut: json['idTryOut'],
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

  factory QuestionsModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => QuestionsModel.fromJson(snapshot.data()!);
}
