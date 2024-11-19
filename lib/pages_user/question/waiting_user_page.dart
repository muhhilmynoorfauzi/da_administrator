import 'dart:async';
import 'package:da_administrator/model/user_to/user_to_model.dart';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingUserPage extends StatefulWidget {
  const WaitingUserPage({super.key, required this.second, required this.isLast, required this.idUserTo, required this.userTo});

  final String idUserTo;
  final double second;
  final bool isLast;
  final UserToModel userTo;

  @override
  _WaitingUserPageState createState() => _WaitingUserPageState();
}

class _WaitingUserPageState extends State<WaitingUserPage> {
  late Timer _timer;
  late double _remainingTime; // Menyimpan waktu yang tersisa dalam detik
  final imageVec = 'assets/vec3.png';

  int questId = 0;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    super.initState();
    testKe = 0;
    subTestKe = 0;

    _remainingTime = widget.second;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const int interval = 1000; // 1000 milidetik atau 1 detik
    _timer = Timer.periodic(const Duration(milliseconds: interval), (timer) {
      setState(() {
        _remainingTime -= 1; // Kurangi 1 detik setiap interval
        if (_remainingTime <= 0) {
          timer.cancel();
          print("Waktu habis");
          kembaliTryOutSaya(context);
        }
      });
    });
  }

  void lanjutKerja(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, FadeRoute1(NavQuestUserPage(idUserTo: widget.idUserTo,userTo: widget.userTo)), (Route<dynamic> route) => false);
  }

  Future<void> kembaliTryOutSaya(BuildContext context) async {
    Navigator.pushAndRemoveUntil(context, FadeRoute1(const TryoutUserPage(idPage: 0)), (Route<dynamic> route) => false);
  }

  String formatMinute(double seconds) {
    int totalSeconds = seconds.round();
    int minutes = totalSeconds ~/ 60;
    int secondsPart = totalSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = secondsPart.toString().padLeft(2, '0');

    return secondsStr;
  }

  @override
  Widget build(BuildContext context) {
    return onDesk(context);
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: tinggi(context) * .1),
          Column(
            children: [
              Icon(Icons.timer, color: primary, size: 100),
              Text(formatMinute(_remainingTime), style: TextStyle(fontSize: h1, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(
                'Lanjutkan TryOut atau Tunggu hingga\nwaktu selesai untuk kembali ke TryOut saya',
                style: TextStyle(fontSize: h3, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: TextButton(
                        onPressed: () => kembaliTryOutSaya(context),
                        style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20)),
                        child: Text('Kembali ke TryOut saya', style: TextStyle(fontSize: h4, color: Colors.white)),
                      ),
                    ),
                    if (!widget.isLast) const SizedBox(width: 10),
                    if (!widget.isLast)
                      SizedBox(
                        width: 220,
                        child: TextButton(
                          onPressed: () => lanjutKerja(context),
                          style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20)),
                          child: Text('Lanjut Kerja TryOut', style: TextStyle(fontSize: h4, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: tinggi(context) * .15),
          Center(child: SizedBox(height: 300, width: 300, child: Image.asset(imageVec))),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
