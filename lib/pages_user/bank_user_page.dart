import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/component/nav_buttom.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BankUserPage extends StatefulWidget {
  const BankUserPage({super.key});

  @override
  State<BankUserPage> createState() => _BankUserPageState();
}

class _BankUserPageState extends State<BankUserPage> {
  // bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true),
      body: ListView(
        children: [
          Container(
            height: tinggi(context) - 200,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              width: 1000,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Container(height: 80, width: 80, decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(100)))],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [SvgPicture.asset('assets/bank.svg', height: 70)])
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.centerLeft,
                          child: Text('Bank Soal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 10)),
                        ),
                        Text(
                          'Uji kemampuanmu setelah belajar. Bank Soal ini cocok banget buat persiapan kamu sebelum ngerjain Tryout!\n',
                          style: TextStyle(color: Colors.black, fontSize: h3),
                        ),
                        Text('Tunggu apa lagi? Yuk, pake Dream Academy Sekarang!', style: TextStyle(color: Colors.black, fontSize: h3)),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                          child: Text('Daftar Sekarang', style: TextStyle(color: Colors.white, fontSize: h3, fontWeight: FontWeight.normal)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //footer
          footerDesk(context: context),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarMo(
        context: context, 
      ),
      body: ListView(
        children: [
          Container(
            height: tinggi(context) - 200,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              width: 1000,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Container(height: 50, width: 50, decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(100)))],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [SvgPicture.asset('assets/bank.svg', height: 50)])
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text('Bank Soal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1)),
                        ),
                        Text(
                          'Uji kemampuanmu setelah belajar. Bank Soal ini cocok banget buat persiapan kamu sebelum ngerjain Tryout!\n',
                          style: TextStyle(color: Colors.black, fontSize: h3),
                        ),
                        Text('Tunggu apa lagi? Yuk, pake Dream Academy Sekarang!', style: TextStyle(color: Colors.black, fontSize: h3)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 40)),
                            child: Text('Daftar Sekarang', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //footer
          footerMo(context: context),
        ],
      ),
      bottomNavigationBar: NavBottomMo(context: context, featureActive: true),
    );
  }
}
