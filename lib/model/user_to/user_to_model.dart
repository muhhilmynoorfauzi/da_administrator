import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';

class UserToModel{
  String UserUID;
  String idTryOut;
  List<dynamic> listQuestions;


  UserToModel({
    required this.UserUID,
    required this.idTryOut,
    required this.listQuestions,
  });

  Map<String, dynamic> toJson() => {
    'UserUID': UserUID,
    'idTryOut': idTryOut,
    'listQuestions': listQuestions.map((content) => content.toJson()).toList(),
  };

  factory UserToModel.fromJson(Map<String, dynamic> json) => UserToModel(
    UserUID: json['UserUID'],
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

  factory UserToModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => UserToModel.fromJson(snapshot.data()!);
}