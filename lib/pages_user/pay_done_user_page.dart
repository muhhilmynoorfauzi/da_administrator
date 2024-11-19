import 'dart:async';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayDoneUserPage extends StatefulWidget {
  const PayDoneUserPage({super.key, required this.second});

  final int second;

  @override
  _PayDoneUserPageState createState() => _PayDoneUserPageState();
}

class _PayDoneUserPageState extends State<PayDoneUserPage> {

  int remainingTime = 5; // Durasi awal 5 detik
  Timer? timerRun;
  final imageVec = 'assets/vec3.png';

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    super.initState();
    remainingTime = widget.second;
    startTimer();
  }

  @override
  void dispose() {
    timerRun?.cancel(); // Hentikan timer saat halaman ditutup
    super.dispose();
  }

  void startTimer() {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    timerRun = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timerRun?.cancel(); // Hentikan timer saat mencapai 0
        profider.setTitleUserPage('Dream Academy - TryOut Saya');
        Navigator.pushAndRemoveUntil(context, FadeRoute1(const TryoutUserPage(idPage: 0)), (Route<dynamic> route) => false);
      }
    });
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
              Icon(Icons.check_circle_rounded, color: primary, size: 70),
              Text('Pembayaran Selesai', style: TextStyle(fontSize: h1, fontWeight: FontWeight.bold, color: Colors.black)),
              Text('Otomatis kembali dalam $remainingTime', style: TextStyle(fontSize: h3, color: Colors.black)),
              const SizedBox(height: 10),
              SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, FadeRoute1(const TryoutUserPage(idPage: 0)), (Route<dynamic> route) => false);
                  },
                  style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20)),
                  child: Text('Kembali Ke TryOut Saya', style: TextStyle(fontSize: h4, color: Colors.white)),
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
}
