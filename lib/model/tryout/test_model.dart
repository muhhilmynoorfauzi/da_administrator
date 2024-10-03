import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/subtest_model.dart';

class TestModel {
  String nameTest;
  List<SubtestModel> listSubtest;

  TestModel({
    required this.nameTest,
    required this.listSubtest,
  });

  Map<String, dynamic> toJson() => {
        'nameTest': nameTest,
        'listSubtest': listSubtest.map((content) => content.toJson()).toList(),
      };

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        nameTest: json['nameTest'],
        listSubtest: (json['listSubtest'] as List<dynamic>).map((content) => SubtestModel.fromJson(content)).toList(),
      );

  factory TestModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => TestModel.fromJson(snapshot.data()!);
}
