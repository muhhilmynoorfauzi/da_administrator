import 'package:cloud_firestore/cloud_firestore.dart';

//ini untuk mengatur model review user
class TryoutReviewModel {
  String userUID;
  String userName;
  String text;
  String image;
  String idTryOut;
  int rating;
  DateTime created;
  bool isPublic;

  TryoutReviewModel({
    required this.userUID,
    required this.userName,
    required this.text,
    required this.idTryOut,
    required this.image,
    required this.rating,
    required this.created,
    required this.isPublic,
  });

  Map<String, dynamic> toJson() => {
        'userUID': userUID,
        'userName': userName,
        'text': text,
        'idTryOut': idTryOut,
        'image': image,
        'rating': rating,
        'created': created.toIso8601String(),
        'isPublic': isPublic,
      };

  factory TryoutReviewModel.fromJson(Map<String, dynamic> json) => TryoutReviewModel(
        userUID: json['userUID'],
        userName: json['userName'],
        text: json['text'],
        idTryOut: json['idTryOut'],
        image: json['image'],
        rating: json['rating'],
        created: DateTime.parse(json['created']),
        isPublic: json['isPublic'],
      );

  factory TryoutReviewModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => TryoutReviewModel.fromJson(snapshot.data()!);
}
