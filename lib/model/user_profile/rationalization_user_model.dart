import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';

class RationalizationUserModel {
  List<JurusanModel> jurusan;
  DateTime created;
  String userUID;
  String idTryout;
  String idUserTo;

  RationalizationUserModel({
    required this.jurusan,
    required this.created,
    required this.userUID,
    required this.idTryout,
    required this.idUserTo,
  });

  Map<String, dynamic> toJson() => {
        'jurusan': jurusan.map((content) => content.toJson()).toList(),
        'created': created.toIso8601String(),
        'userUID': userUID,
        'idTryout': idTryout,
        'idUserTo': idUserTo,
      };

  factory RationalizationUserModel.fromJson(Map<String, dynamic> json) => RationalizationUserModel(
        jurusan: (json['jurusan'] as List<dynamic>).map((content) => JurusanModel.fromJson(content)).toList(),
        created: DateTime.parse(json['created']),
        userUID: json['userUID'],
        idTryout: json['idTryout'],
        idUserTo: json['idUserTo'],
      );

  factory RationalizationUserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => RationalizationUserModel.fromJson(snapshot.data()!);
}
