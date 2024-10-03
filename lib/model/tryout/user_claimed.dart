import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/test_model.dart';

class UserClaimed {
  String userUID;
  int payment;
  DateTime created;
  String tryoutID;
  bool approval;
  String name;
  String imgFollow;
  int price;

  UserClaimed({
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

  factory UserClaimed.fromJson(Map<String, dynamic> json) => UserClaimed(
        userUID: json['userUID'],
        payment: json['payment'],
        created: DateTime.parse(json['created']),
        tryoutID: json['tryoutID'],
        approval: json['approval'],
        name: json['name'],
        imgFollow: json['imgFollow'],
        price: json['price'],
      );

  factory UserClaimed.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => UserClaimed.fromJson(snapshot.data()!);
}
