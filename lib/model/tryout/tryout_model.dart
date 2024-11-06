import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/tryout/claimed_model.dart';

class TryoutModel {
  DateTime created;
  DateTime updated;
  String toCode;
  String toName;
  DateTime started;
  DateTime ended;
  String desk;
  String image;
  bool phase;
  bool phaseIRT;
  bool expired;
  bool public;
  bool showFreeMethod;
  double totalTime;
  int numberQuestions;
  List<ClaimedModel> claimedUid;
  List<int> listPrice;
  List<TestModel> listTest;

  TryoutModel({
    required this.created,
    required this.updated,
    required this.toCode,
    required this.toName,
    required this.started,
    required this.ended,
    required this.desk,
    required this.image,
    required this.phase,
    required this.phaseIRT,
    required this.expired,
    required this.public,
    required this.showFreeMethod,
    required this.totalTime,
    required this.numberQuestions,
    required this.claimedUid,
    required this.listPrice,
    required this.listTest,
  });

  Map<String, dynamic> toJson() {
    return {
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'toCode': toCode,
      'toName': toName,
      'started': started.toIso8601String(),
      'ended': ended.toIso8601String(),
      'desk': desk,
      'image': image,
      'phase': phase,
      'phaseIRT': phaseIRT,
      'expired': expired,
      'public': public,
      'showFreeMethod': showFreeMethod,
      'totalTime': totalTime,
      'numberQuestions': numberQuestions,
      'claimedUid': claimedUid.map((content) => content.toJson()).toList(),
      'listPrice': listPrice,
      'listTest': listTest.map((content) => content.toJson()).toList(),
    };
  }

  factory TryoutModel.fromJson(Map<String, dynamic> json) {
    return TryoutModel(
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      toCode: json['toCode'],
      toName: json['toName'],
      started: DateTime.parse(json['started']),
      ended: DateTime.parse(json['ended']),
      desk: json['desk'],
      image: json['image'],
      phase: json['phase'],
      phaseIRT: json['phaseIRT'],
      expired: json['expired'],
      public: json['public'],
      showFreeMethod: json['showFreeMethod'],
      totalTime: (json['totalTime'] as num).toDouble(),
      numberQuestions: json['numberQuestions'],
      claimedUid: (json['claimedUid'] as List<dynamic>).map((content) => ClaimedModel.fromJson(content)).toList(),
      listPrice: List<int>.from(json['listPrice']),
      listTest: (json['listTest'] as List<dynamic>).map((content) => TestModel.fromJson(content)).toList(),
    );
  }

  factory TryoutModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return TryoutModel.fromJson(snapshot.data()!);
  }
}
