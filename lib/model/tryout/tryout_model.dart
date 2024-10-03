import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/tryout/user_claimed.dart';

class TryoutModel {
  DateTime created;
  DateTime updated;
  String toCode;
  String toName;
  DateTime started;
  DateTime ended;
  DateTime startWork;
  DateTime endWork;
  String desk;
  String image;
  bool phase;
  bool expired;
  bool public;
  bool showFreeMethod;
  int totalTime;
  int numberQuestions;
  List<TestModel> listTest;
  List<UserClaimed> claimedUid;
  List<int> listPrice;

  TryoutModel({
    required this.created,
    required this.updated,
    required this.toCode,
    required this.toName,
    required this.started,
    required this.ended,
    required this.startWork,
    required this.endWork,
    required this.desk,
    required this.image,
    required this.phase,
    required this.expired,
    required this.public,
    required this.showFreeMethod,
    required this.totalTime,
    required this.numberQuestions,
    required this.listTest,
    required this.claimedUid,
    required this.listPrice,
  });

  Map<String, dynamic> toJson() => {
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
        'toCode': toCode,
        'toName': toName,
        'started': started.toIso8601String(),
        'ended': ended.toIso8601String(),
        'startWork': started.toIso8601String(),
        'endWork': ended.toIso8601String(),
        'desk': desk,
        'image': image,
        'phase': phase,
        'expired': expired,
        'public': public,
        'showFreeMethod': showFreeMethod,
        'totalTime': totalTime,
        'numberQuestions': numberQuestions,
        'listTest': listTest.map((content) => content.toJson()).toList(),
        'claimedUid': claimedUid.map((content) => content.toJson()).toList(),
        'listPrice': listPrice,
      };

  factory TryoutModel.fromJson(Map<String, dynamic> json) => TryoutModel(
        created: DateTime.parse(json['created']),
        updated: DateTime.parse(json['updated']),
        toCode: json['toCode'],
        toName: json['toName'],
        started: DateTime.parse(json['started']),
        ended: DateTime.parse(json['ended']),
        startWork: DateTime.parse(json['startWork']),
        endWork: DateTime.parse(json['endWork']),
        desk: json['desk'],
        image: json['image'],
        phase: json['phase'],
        expired: json['expired'],
        public: json['public'],
        showFreeMethod: json['showFreeMethod'],
        totalTime: json['totalTime'],
        numberQuestions: json['numberQuestions'],
        listTest: (json['listTest'] as List<dynamic>).map((content) => TestModel.fromJson(content)).toList(),
        claimedUid: (json['claimedUid'] as List<dynamic>).map((content) => UserClaimed.fromJson(content)).toList(),
        listPrice: List<int>.from(json['listPrice']),
      );

  factory TryoutModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return TryoutModel.fromJson(snapshot.data()!);
  }
}
