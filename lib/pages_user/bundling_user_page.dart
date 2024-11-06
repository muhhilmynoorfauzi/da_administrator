import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BundlingUserPage extends StatefulWidget {
  const BundlingUserPage({super.key});

  @override
  State<BundlingUserPage> createState() => _BundlingUserPageState();
}

class _BundlingUserPageState extends State<BundlingUserPage> {
  final List<Map<String, dynamic>> listDetailPaket = [
    {
      'image': 'assets/bayar_gratis.svg',
      'title': 'Bayar Gratis (syarat dan ketentuan berlaku)',
      'price': 'Rp 0',
      'desk': 'Latihan pemahamanmu dengan 20x TryOut UTBK yang bikin belajarmu makin seru!',
      'info': [
        '20x TryOut Premium (80 Diamond)',
        'Pembahasan Lengkap Teks + Video',
        'Analisis materi yang belum dikuas.ai melalui Smart Analysis',
        'Rasionalisasi Nilai TO',
        'Leaderboard Nasianal dan Jurusan',
      ],
    },
    {
      'image': 'assets/koin.svg',
      'title': 'Bayar Pakai Koin',
      'price': '4 DA Coin',
      'desk': 'Latihan pemahamanmu dengan 20x TryOut UTBK yang bikin belajarmu makin seru!',
      'info': [
        '20x TryOut Premium (80 Diamond)',
        'Pembahasan Lengkap Teks + Video',
        'Analisis materi yang belum dikuas.ai melalui Smart Analysis',
        'Rasionalisasi Nilai TO',
        'Leaderboard Nasianal dan Jurusan',
      ],
    },
    {
      'image': 'assets/e_wallet.svg',
      'title': 'Bayar Pakai E-Wallet',
      'price': 'Rp 20.000',
      'desk': 'Latihan pemahamanmu dengan 20x TryOut UTBK yang bikin belajarmu makin seru!',
      'info': [
        '20x TryOut Premium (80 Diamond)',
        'Pembahasan Lengkap Teks + Video',
        'Analisis materi yang belum dikuas.ai melalui Smart Analysis',
        'Rasionalisasi Nilai TO',
        'Leaderboard Nasianal dan Jurusan',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryWhite,
      body: ListView(
        children: [
          const SizedBox(height: 50),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text('Detail Paket', style: TextStyle(fontSize: h1, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          const SizedBox(height: 30),
          //card
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: List.generate(
              listDetailPaket.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 700,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Row(
                        children: [
                          Container(height: 100, width: 100, padding: const EdgeInsets.all(25), child: SvgPicture.asset(listDetailPaket[index]['image'])),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listDetailPaket[index]['title'], style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
                              Text(listDetailPaket[index]['price'], style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    width: 670,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: secondary.withOpacity(.3), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listDetailPaket[index]['desk'], style: TextStyle(fontSize: h4, color: Colors.black)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              listDetailPaket[index]['info'].length,
                              (index1) {
                                List<String> info = listDetailPaket[index]['info'];
                                return Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: primary, size: 25),
                                    const SizedBox(width: 10),
                                    Text(info[index1], style: TextStyle(fontSize: h4, color: Colors.black)),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),

          //footer
          footerDesk(context: context),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryWhite,
      body: ListView(
        children: [
          const SizedBox(height: 50),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text('Detail Paket', style: TextStyle(fontSize: h1, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          const SizedBox(height: 30),
          //card
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: List.generate(
              listDetailPaket.length,
              (index) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 700,
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Row(
                          children: [
                            Container(height: 100, width: 100, padding: const EdgeInsets.all(25), child: SvgPicture.asset(listDetailPaket[index]['image'])),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    listDetailPaket[index]['title'],
                                    style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(listDetailPaket[index]['price'], style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 250,
                      width: 670,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(color: secondary.withOpacity(.3), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listDetailPaket[index]['desk'], style: TextStyle(fontSize: h4, color: Colors.black)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                listDetailPaket[index]['info'].length,
                                (index1) {
                                  List<String> info = listDetailPaket[index]['info'];
                                  return Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded, color: primary, size: 25),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(info[index1], style: TextStyle(fontSize: h4, color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 2),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),

          //footer
          footerMo(context: context)
        ],
      ),
    );
  }
}
