import 'dart:async';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingUserPage extends StatefulWidget {
  const WaitingUserPage({super.key, required this.minutes, this.isLast = false});

  final int minutes;
  final bool isLast;

  @override
  _WaitingUserPageState createState() => _WaitingUserPageState();
}

class _WaitingUserPageState extends State<WaitingUserPage> {
  late int totalTimeInMinutes;
  late int remainingTimeInSeconds; // 30 minutes in seconds
  Timer? timer;

  int questId = 0;

  @override
  void initState() {
    super.initState();
    totalTimeInMinutes = widget.minutes;
    remainingTimeInSeconds = widget.minutes * 60;

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (remainingTimeInSeconds > 0) {
          remainingTimeInSeconds--;
        } else {
          timer.cancel();
          lanjutKerja();
        }
      });
    });
  }

  void lanjutKerja() {
    context.read<CounterProvider>().setTitleUserPage('Dream Academy');
    Navigator.pushAndRemoveUntil(context, FadeRoute1(const NavQuestUserPage(minutes: 1)), (Route<dynamic> route) => false);
  }

  Future<void> kembaliTryOutSaya() async {
    context.read<CounterProvider>().setTitleUserPage('Dream Academy - TryOut Saya');
    Navigator.pushAndRemoveUntil(context, FadeRoute1(const TryoutUserPage(idPage: 0)), (Route<dynamic> route) => false);
    Navigator.push(context, FadeRoute1(const DetailMytryoutUserPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    int minutes = remainingTimeInSeconds ~/ 60;
    int seconds = remainingTimeInSeconds % 60;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: tinggi(context) * .1),
          Column(
            children: [
              Icon(Icons.timer, color: primary, size: 100),
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: h1, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'Otomatis melanjutkan TryOut atau\nTunggu hingga waktu selesai untuk melanjutkan TryOut',
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
                        onPressed: () => kembaliTryOutSaya(),
                        style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20)),
                        child: Text('Kembali ke TryOut saya', style: TextStyle(fontSize: h4, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!widget.isLast)
                      SizedBox(
                        width: 220,
                        child: TextButton(
                          onPressed: () => lanjutKerja(),
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
          Center(
            child: Container(
              height: 300,
              width: 300,
              color: Colors.grey,
              //image vector
            ),
          ),
        ],
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}