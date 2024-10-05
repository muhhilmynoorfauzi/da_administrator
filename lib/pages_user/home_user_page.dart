import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  var isLogin = true;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return homeUserMobile(context);
    } else {
      return homeUserDesk(context);
    }
  }

  Widget homeUserDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, homeActive: true, isLogin: isLogin),
      floatingActionButton: SizedBox(
        width: 180,
        height: 40,
        child: FloatingActionButton(
          backgroundColor: primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/whatsapp.svg', height: 25),
              const SizedBox(width: 10),
              Text('Hubungi Kami', style: TextStyle(color: Colors.white, fontSize: h4)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset('assets/bg1.png', width: lebar(context), fit: BoxFit.cover),
          Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            interactive: false,
            child: ListView(
              children: [
                SizedBox(
                  height: 700,
                  width: lebar(context),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dream Academy', style: TextStyle(color: Colors.black, fontSize: h1 + 20, fontWeight: FontWeight.bold)),
                              Text('Dream AcademyDream AcademyDream Academy', style: TextStyle(color: Colors.grey, fontSize: h3, fontWeight: FontWeight.normal)),
                              Text(
                                'Dream AcademyDream AcademyDream Academy'
                                'Dream AcademyDream AcademyDream Academy'
                                'Dream AcademyDream AcademyDream Academy'
                                'Dream AcademyDream AcademyDream Academy'
                                'Dream AcademyDream AcademyDream Academy',
                                style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(40),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //image dialog vector
                Container(
                  height: 500,
                  width: lebar(context),
                  margin: const EdgeInsets.all(100),
                  child: Image.asset('assets/vec1.png'),
                ),
                //100+ pelajar telah berproses bersama kami
                Container(
                  height: 500,
                  width: lebar(context),
                  decoration: BoxDecoration(gradient: primaryGradient),
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: List.generate(
                            2,
                            (index) => Expanded(
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                reverse: (index == 1) ? true : false,
                                children: List.generate(
                                  4,
                                  (index) => SizedBox(
                                    height: 200,
                                    child: Card(
                                      margin: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 70,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: Image.network('https://avatars.githubusercontent.com/u/61872710?v=4'),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Muh. Hilmy Noor Fauzi', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                                    Text('20 Juli 2024', style: TextStyle(color: Colors.black, fontSize: h4)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 110,
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              'Saya sangat senang belajar di Dream Academy karena memiliki banyak contoh soal dan penjelasan mudah dipahami',
                                              style: TextStyle(color: Colors.black, fontSize: h4),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('1000++ Pelajar Telah', style: TextStyle(color: Colors.white, fontSize: h4 + 5, fontWeight: FontWeight.bold)),
                              Text('Berproses bersama kami', style: TextStyle(color: Colors.white, fontSize: h1 + 5, fontWeight: FontWeight.bold)),
                              Text(
                                'Berproses bersama kami'
                                'Berproses bersama kami'
                                'Berproses bersama kami'
                                'Berproses bersama kami',
                                style: TextStyle(color: Colors.white, fontSize: h4 + 5, fontWeight: FontWeight.w100),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30)),
                                  child: Text('Daftar sekarang', style: TextStyle(color: Colors.black, fontSize: h4)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //persiapkan semua untuk ujianmu
                Container(
                  height: 800,
                  width: lebar(context),
                  alignment: Alignment.center,
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 3,
                    child: Container(
                      height: 700,
                      width: 1000,
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Text('SIAP MELEWATI RINTANGAN SNBT', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h4, fontWeight: FontWeight.bold)),
                          Text('Persiapkan semua untuk Ujianmu', style: TextStyle(color: Colors.black, fontSize: h2, fontWeight: FontWeight.bold)),
                          Text('Fitur TryOut', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h4, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: List.generate(
                                8,
                                (index) {
                                  var title = [
                                    'Pembahasan Soal Lengkap',
                                    'Hasil Instan',
                                    'Sistem CBT',
                                    'Tes minat, bakat dan jurusan',
                                    'Akses dimana saja',
                                    'Repot TO',
                                    'Perangkingan Jurusan',
                                    'Pembobotan Nilai / IRT',
                                  ];
                                  var subTitle = [
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                  ];
                                  var img = [
                                    'assets/fitur1.svg',
                                    'assets/fitur5.svg',
                                    'assets/fitur2.svg',
                                    'assets/fitur6.svg',
                                    'assets/fitur3.svg',
                                    'assets/fitur7.svg',
                                    'assets/fitur4.svg',
                                    'assets/fitur8.svg',
                                  ];
                                  return SizedBox(
                                    height: 130,
                                    width: 450,
                                    child: Row(
                                      children: [
                                        CircleAvatar(backgroundColor: Colors.transparent, radius: 40, child: SvgPicture.asset(img[index])),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(title[index], style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                              Text(subTitle[index], style: TextStyle(color: Colors.black, fontSize: h4)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Fitur Utama
                SizedBox(
                  height: 400,
                  width: lebar(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        var onHover = false;
                        var title = [
                          'Bank Soal',
                          'TryOut',
                          'Rekomendasi Belajar',
                        ];
                        var img = [
                          'assets/bank.svg',
                          'assets/tryout.svg',
                          'assets/rekomendasi.svg',
                        ];
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onHover: (value) => setState(() => onHover = value),
                              onTap: () {},
                              child: AnimatedContainer(
                                margin: const EdgeInsets.all(10),
                                duration: const Duration(milliseconds: 150),
                                height: onHover ? 300 : 250,
                                width: onHover ? 250 : 200,
                                decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10), color: Colors.white),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      height: onHover ? 150 : 100,
                                      width: onHover ? 150 : 100,
                                      child: SvgPicture.asset(img[index]),
                                    ),
                                    Text(title[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: h4), textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                //footer
                footerDesk(context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget homeUserMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
