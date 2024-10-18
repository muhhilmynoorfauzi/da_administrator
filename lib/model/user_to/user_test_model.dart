import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/subtest_model.dart';
import 'package:da_administrator/model/user_to/user_subtest_model.dart';

class UserTestModel {
  String nameTest;
  bool done;
  List<UserSubtestModel> listSubtest;

  UserTestModel({
    required this.nameTest,
    required this.done,
    required this.listSubtest,
  });

  Map<String, dynamic> toJson() => {
    'nameTest': nameTest,
    'done': done,
    'listSubtest': listSubtest.map((content) => content.toJson()).toList(),
  };

  factory UserTestModel.fromJson(Map<String, dynamic> json) => UserTestModel(
    nameTest: json['nameTest'],
    done: json['done'],
    listSubtest: (json['listSubtest'] as List<dynamic>).map((content) => UserSubtestModel.fromJson(content)).toList(),
  );

  factory UserTestModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => UserTestModel.fromJson(snapshot.data()!);
}
