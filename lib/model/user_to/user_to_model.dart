import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/user_to/leaderboard_model.dart';
import 'package:da_administrator/model/user_to/rationalization_model.dart';
import 'package:da_administrator/model/user_to/user_test_model.dart';

class UserToModel {
  String userUID;
  String idTryOut;
  String toName;
  int valuesDiscussion;
  int average;
  int correctAnswer;
  int wrongAnswer;
  DateTime startWork;
  DateTime endWork;
  DateTime created;
  List<LeaderBoardModel> leaderBoard;
  List<RationalizationModel> rationalization;
  List<UserTestModel> listTest;

  UserToModel({
    required this.userUID,
    required this.idTryOut,
    required this.toName,
    required this.valuesDiscussion,
    required this.average,
    required this.correctAnswer,
    required this.wrongAnswer,
    required this.startWork,
    required this.endWork,
    required this.created,
    required this.leaderBoard,
    required this.rationalization,
    required this.listTest,
  });

  Map<String, dynamic> toJson() {
    return {
      'userUID': userUID,
      'idTryOut': idTryOut,
      'toName': toName,
      'valuesDiscussion': valuesDiscussion,
      'average': average,
      'correctAnswer': correctAnswer,
      'wrongAnswer': wrongAnswer,
      'startWork': startWork.toIso8601String(),
      'endWork': endWork.toIso8601String(),
      'created': created.toIso8601String(),
      'leaderBoard': leaderBoard.map((content) => content.toJson()).toList(),
      'rationalization': rationalization.map((content) => content.toJson()).toList(),
      'listTest': listTest.map((content) => content.toJson()).toList(),
    };
  }

  factory UserToModel.fromJson(Map<String, dynamic> json) {
    return UserToModel(
      userUID: json['userUID'],
      idTryOut: json['idTryOut'],
      toName: json['toName'],
      valuesDiscussion: json['valuesDiscussion'],
      average: json['average'],
      correctAnswer: json['correctAnswer'],
      wrongAnswer: json['wrongAnswer'],
      startWork: DateTime.parse(json['startWork']),
      endWork: DateTime.parse(json['endWork']),
      created: DateTime.parse(json['created']),
      leaderBoard: (json['leaderBoard'] as List<dynamic>).map((content) => LeaderBoardModel.fromJson(content)).toList(),
      rationalization: (json['rationalization'] as List<dynamic>).map((content) => RationalizationModel.fromJson(content)).toList(),
      listTest: (json['listTest'] as List<dynamic>).map((content) => UserTestModel.fromJson(content)).toList(),
    );
  }

  factory UserToModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserToModel.fromJson(snapshot.data()!);
  }
}
