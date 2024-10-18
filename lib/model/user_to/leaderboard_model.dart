import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoardModel {
  int overallRating;
  int tryoutRating;

  LeaderBoardModel({required this.overallRating, required this.tryoutRating});

  Map<String, dynamic> toJson() => {'overallRating': overallRating, 'tryoutRating': tryoutRating};

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) => LeaderBoardModel(overallRating: json['overallRating'], tryoutRating: json['tryoutRating']);

  factory LeaderBoardModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => LeaderBoardModel.fromJson(snapshot.data()!);
}
