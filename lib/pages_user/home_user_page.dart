import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        leadingWidth: 200,
        leading: SvgPicture.asset('assets/logo1.svg'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Home',
              style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Feature', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
          ),
          TextButton(
            onPressed: () {},
            child: Text('About', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
          ),
          const SizedBox(width: 30),
          Container(
            height: 50,
            // width: 200,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () {},
                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () {},
                  child: Text('Register', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
      body: Scrollbar(
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
            //image
            Container(
              height: 700,
              width: lebar(context),
              alignment: Alignment.center,
              child: Container(height: 500, width: 900, color: Colors.black.withOpacity(.1)),
            ),
            //100+ pelajar
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
                                            const CircleAvatar(backgroundColor: Colors.grey),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: List.generate(
                                  4,
                                  (index) {
                                    var title = [
                                      'Pembahasan Soal Lengkap',
                                      'Sistem CBT',
                                      'Akses dimana saja',
                                      'Perangkingan Jurusan',
                                    ];
                                    var subTitle = [
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    ];
                                    return SizedBox(
                                      height: 130,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          CircleAvatar(backgroundColor: Colors.transparent, radius: 40, child: SvgPicture.asset('assets/logo2.svg')),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(title[index], style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
                                                Text(subTitle[index], style: TextStyle(color: Colors.black, fontSize: h3)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: List.generate(
                                  4,
                                  (index) {
                                    var title = [
                                      'Hasil Instan',
                                      'Tes minat, bakat dan jurusan',
                                      'Repot TO',
                                      'Pembobotan Nilai / IRT',
                                    ];
                                    var subTitle = [
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                      'Membuat kamu makin paham konsep dalam mengerjakan soal-soal',
                                    ];
                                    return SizedBox(
                                      height: 130,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          CircleAvatar(backgroundColor: Colors.transparent, radius: 40, child: SvgPicture.asset('assets/logo2.svg')),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(title[index], style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
                                                Text(subTitle[index], style: TextStyle(color: Colors.black, fontSize: h3)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //
            SizedBox(
              height: 400,
              width: lebar(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) {
                    var onHover = false;
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onHover: (value) => setState(() => onHover = value),
                          onTap: () {},
                          child: AnimatedContainer(
                            margin: const EdgeInsets.all(10),
                            duration: const Duration(milliseconds: 200),
                            height: onHover ? 300 : 250,
                            width: onHover ? 250 : 200,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: onHover ? 200 : 150,
                                  width: onHover ? 200 : 150,
                                  child: SvgPicture.asset('assets/logo2.svg'),
                                ),
                                Text('Bank Soal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h3)),
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
            Container(
              height: 200,
              width: lebar(context),
              color: Colors.black.withOpacity(.1),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/logo1.svg', width: 300, height: 60),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.facebook, color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.facebook, color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.facebook, color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.facebook, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                              TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
