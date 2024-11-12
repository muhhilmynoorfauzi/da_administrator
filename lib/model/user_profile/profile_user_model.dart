import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUserModel {
  String userUID;
  String imageProfile;
  String userName;
  String email;
  String role;
  int koin;
  String uniqueUserName;
  String asalSekolah;
  List<PlanOptions> listPlan;
  String kontak;
  String motivasi;
  String tempatTinggal;
  DateTime update;
  DateTime created;

  ProfileUserModel({
    required this.userUID,
    required this.imageProfile,
    required this.userName,
    required this.email,
    required this.role,
    required this.koin,
    required this.uniqueUserName,
    required this.asalSekolah,
    required this.listPlan,
    required this.kontak,
    required this.motivasi,
    required this.tempatTinggal,
    required this.update,
    required this.created,
  });

  Map<String, dynamic> toJson() => {
        'userUID': userUID,
        'imageProfile': imageProfile,
        'userName': userName,
        'email': email,
        'role': role,
        'koin': koin,
        'uniqueUserName': uniqueUserName,
        'asalSekolah': asalSekolah,
        'listPlan': listPlan.map((content) => content.toJson()).toList(),
        'kontak': kontak,
        'motivasi': motivasi,
        'tempatTinggal': tempatTinggal,
        'update': update.toIso8601String(),
        'created': created.toIso8601String(),
      };

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) => ProfileUserModel(
        userUID: json['userUID'],
        imageProfile: json['imageProfile'],
        userName: json['userName'],
        email: json['email'],
        role: json['role'],
        koin: json['koin'],
        uniqueUserName: json['uniqueUserName'],
        asalSekolah: json['asalSekolah'],
        listPlan: (json['listPlan'] as List<dynamic>).map((content) => PlanOptions.fromJson(content)).toList(),
        kontak: json['kontak'],
        motivasi: json['motivasi'],
        tempatTinggal: json['tempatTinggal'],
        update: DateTime.parse(json['update']),
        created: DateTime.parse(json['created']),
      );

  factory ProfileUserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => ProfileUserModel.fromJson(snapshot.data()!);
}

class PlanOptions {
  String universitas;
  String jurusan;

  PlanOptions({required this.universitas, required this.jurusan});

  Map<String, dynamic> toJson() => {
        'universitas': universitas,
        'jurusan': jurusan,
      };

  factory PlanOptions.fromJson(Map<String, dynamic> json) => PlanOptions(
        universitas: json['universitas'],
        jurusan: json['jurusan'],
      );

  factory PlanOptions.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) => PlanOptions.fromJson(snapshot.data()!);
}
