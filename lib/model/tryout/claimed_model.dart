import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';

class ClaimedModel {
  String userUID;
  String payment;
  DateTime created;
  String tryoutID;
  bool approval;
  String name;
  String imgFollow;
  int price;

  ClaimedModel({
    required this.userUID,
    required this.payment,
    required this.created,
    required this.tryoutID,
    required this.approval,
    required this.name,
    required this.imgFollow,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'userUID': userUID,
        'payment': payment,
        'created': created.toIso8601String(),
        'tryoutID': tryoutID,
        'approval': approval,
        'name': name,
        'imgFollow': imgFollow,
        'price': price,
      };

  factory ClaimedModel.fromJson(Map<String, dynamic> json) => ClaimedModel(
        userUID: json['userUID'],
        payment: json['payment'],
        created: DateTime.parse(json['created']),
        tryoutID: json['tryoutID'],
        approval: json['approval'],
        name: json['name'],
        imgFollow: json['imgFollow'],
        price: json['price'],
      );

  factory ClaimedModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => ClaimedModel.fromJson(snapshot.data()!);
}
