import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/pages/login_page.dart';
import 'package:da_administrator/pages_user/bank_user_page.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/component/nav_buttom.dart';
import 'package:da_administrator/pages_user/rekomendasi_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';
import '../model/user_profile/profile_user_model.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  // bool isLogin = true;
  late YoutubePlayerController youtubeController;

  final ScrollController scrollController1 = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  bool scrollingDown1 = true; // Flag untuk menentukan arah scroll
  bool scrollingUp2 = true; // Flag untuk menentukan arah scroll

  final user = FirebaseAuth.instance.currentUser;
  ProfileUserModel? profile;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    super.initState();
    youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=VVarRhSsznY')!,
      params: const YoutubePlayerParams(color: 'red', strictRelatedVideos: true, showFullscreenButton: true, autoPlay: false),
    );
    if (user != null) {
      getDataProfile();
    }
  }

  Future<void> getDataProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final profider = Provider.of<CounterProvider>(context, listen: false);

    if (user == null) {
      print('User belum login.');
      return;
    }

    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('profile_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.where('userUID', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        profile = ProfileUserModel.fromSnapshot(querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>);

        profider.setProfile(profile);
        profider.setIdProfile(querySnapshot.docs.first.id);
        print('Data dengan userUID tersebut ditemukan.');
      } else {
        print('Data dengan userUID tersebut tidak ditemukan.');

        var profileBaru = ProfileUserModel(
          userUID: user.uid,
          imageProfile: '',
          userName: user.displayName!,
          uniqueUserName: 'user@${user.uid}',
          asalSekolah: '',
          listPlan: [
            PlanOptions(universitas: '', jurusan: ''),
            PlanOptions(universitas: '', jurusan: ''),
            PlanOptions(universitas: '', jurusan: ''),
            PlanOptions(universitas: '', jurusan: ''),
          ],
          email: user.email!,
          role: 'user',
          koin: 0,
          kontak: '',
          motivasi: '-',
          tempatTinggal: '',
          created: DateTime.now(),
          update: DateTime.now(),
        );
        String idProfileBaru = await ProfileUserService.addGetId(profileBaru);
        profider.setProfile(profileBaru);
        profider.setIdProfile(idProfileBaru);
        print('Data dengan userUID telah dibuat.');
      }
    } catch (e) {
      print('salah getDataProfile: $e');
    }
    setState(() {});
  }

  void autoScroll1() async {
    while (true) {
      if (scrollingDown1) {
        // Scroll ke bagian paling bawah
        await scrollController1.animateTo(scrollController1.position.maxScrollExtent, duration: const Duration(seconds: 3), curve: Curves.easeInOut);
      } else {
        // Scroll ke bagian paling atas
        await scrollController1.animateTo(scrollController1.position.minScrollExtent, duration: const Duration(seconds: 3), curve: Curves.easeInOut);
      }
      // Ubah arah scroll
      scrollingDown1 = !scrollingDown1;
    }
  }

  void autoScroll2() async {
    while (true) {
      if (scrollingUp2) {
        // Scroll ke bagian paling atas
        await scrollController2.animateTo(scrollController2.position.minScrollExtent, duration: const Duration(seconds: 3), curve: Curves.easeInOut);
      } else {
        // Scroll ke bagian paling bawah
        await scrollController2.animateTo(scrollController2.position.maxScrollExtent, duration: const Duration(seconds: 3), curve: Curves.easeInOut);
      }
      // Ubah arah scroll
      scrollingUp2 = !scrollingUp2;
    }
  }

  @override
  void dispose() {
    scrollController1.dispose();
    scrollController2.dispose();
    youtubeController.stop();
    super.dispose();
  }

  void openNewTab(String contact) {
    html.window.open('https://wa.me/+62$contact', '_blank');
  }

  Widget onDesk(BuildContext context) {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    bool isLogin = (user != null);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(
        context: context,
        homeActive: true,
        actionProfile: () {
          youtubeController.pause();
        },
      ),
      floatingActionButton: SizedBox(
        width: 180,
        height: 40,
        child: FloatingActionButton(
          backgroundColor: primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => openNewTab('82195012789'),
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
                  height: tinggi(context),
                  width: lebar(context),
                  child: Row(
                    children: [
                      Container(
                        width: lebar(context) * .5,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dream Academy', style: TextStyle(color: Colors.black, fontSize: h1 + 20, fontWeight: FontWeight.bold)),
                            Text('Dream AcademyDream AcademyDream Academy', style: TextStyle(color: Colors.grey, fontSize: h3, fontWeight: FontWeight.normal)),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  'Dream AcademyDream AcademyDream Academy'
                                  'Dream AcademyDream AcademyDream Academy'
                                  'Dream AcademyDream AcademyDream Academy'
                                  'Dream AcademyDream AcademyDream Academy'
                                  'Dream AcademyDream AcademyDream Academy',
                                  style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: lebar(context) * .5,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: YoutubePlayerIFramePlus(controller: youtubeController, aspectRatio: 16 / 9),
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
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      autoScroll1();
                      autoScroll2();
                    });
                    return Container(
                      height: 500,
                      width: lebar(context),
                      decoration: BoxDecoration(gradient: primaryGradient),
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView(
                                    controller: scrollController1,
                                    physics: const NeverScrollableScrollPhysics(),
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
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.grey,
                                                        child: Image.network('https://avatars.githubusercontent.com/u/61872710?v=4'),
                                                      ),
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
                                Expanded(
                                  child: ListView(
                                    controller: scrollController2,
                                    physics: const NeverScrollableScrollPhysics(),
                                    reverse: true,
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
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.grey,
                                                        child: Image.network('https://avatars.githubusercontent.com/u/61872710?v=4'),
                                                      ),
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
                                )
                              ],
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
                                  if (!isLogin)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(context, FadeRoute1(const LoginPage()));
                                        },
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
                    );
                  },
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
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CircleAvatar(backgroundColor: Colors.transparent, radius: 40, child: SvgPicture.asset(img[index])),
                                        ),
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
                              onTap: () {
                                if (index == 0) {
                                  Navigator.pushReplacement(context, FadeRoute1(const BankUserPage()));
                                } else if (index == 1) {
                                  Navigator.pushReplacement(context, FadeRoute1(const TryoutUserPage()));
                                } else if (index == 2) {
                                  Navigator.pushReplacement(context, FadeRoute1(const RekomendasiUserPage()));
                                }
                              },
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

  Widget onMo(BuildContext context) {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    bool isLogin = (user != null);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarMo(
        context: context,
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          backgroundColor: primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () => openNewTab('82195012789'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/whatsapp.svg', height: 25),
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
                Container(
                  height: tinggi(context) * .6,
                  width: lebar(context),
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dream Academy', style: TextStyle(color: Colors.black, fontSize: h1, fontWeight: FontWeight.bold)),
                      Text('Dream Academy Dream Academy Dream Academy', style: TextStyle(color: Colors.grey, fontSize: h3, fontWeight: FontWeight.normal)),
                      Text(
                        'Dream Academy Dream Academy Dream Academy '
                        'Dream Academy Dream Academy Dream Academy '
                        'Dream Academy Dream Academy Dream Academy '
                        'Dream Academy Dream Academy Dream Academy '
                        'Dream Academy Dream Academy Dream Academy',
                        style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                //youtube
                Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: YoutubePlayerIFramePlus(controller: youtubeController, aspectRatio: 16 / 9),
                  ),
                ),
                //image dialog vector
                Container(
                  height: 300,
                  width: lebar(context),
                  margin: const EdgeInsets.all(10),
                  child: Image.asset('assets/vec1.png'),
                ),
                //100+ pelajar telah berproses bersama kami
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      autoScroll1();
                      autoScroll2();
                    });
                    return Container(
                      height: 800,
                      width: lebar(context),
                      decoration: BoxDecoration(gradient: primaryGradient),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 400,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.black12,
                                    child: ListView(
                                      controller: scrollController1,
                                      physics: const NeverScrollableScrollPhysics(),
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
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.grey,
                                                            child: Image.network('https://avatars.githubusercontent.com/u/61872710?v=4'),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Muh. Hilmy Noor Fauzi',
                                                              style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold),
                                                            ),
                                                            Text('20 Juli 2024', style: TextStyle(color: Colors.black, fontSize: h4)),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 110,
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(10),
                                                  child: Text(
                                                    'Saya sangat senang belajar di Dream Academy karena memiliki banyak contoh soal dan penjelasan mudah dipahami',
                                                    style: TextStyle(color: Colors.black, fontSize: h4),
                                                    textAlign: TextAlign.justify,
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
                                Expanded(
                                  child: Container(
                                    color: Colors.black12,
                                    child: ListView(
                                      controller: scrollController2,
                                      physics: const NeverScrollableScrollPhysics(),
                                      reverse: true,
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
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.grey,
                                                            child: Image.network('https://avatars.githubusercontent.com/u/61872710?v=4'),
                                                          ),
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
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: lebar(context),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
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
                                  if (!isLogin)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(context, FadeRoute1(const LoginPage()));
                                        },
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
                    );
                  },
                ),
                //persiapkan semua untuk ujianmu
                Container(
                  // height: 800,
                  width: lebar(context),
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 3,
                    child: Container(
                      // height: 1000,
                      width: 1000,
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Text('SIAP MELEWATI RINTANGAN SNBT', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h4, fontWeight: FontWeight.bold)),
                          Text('Persiapkan semua untuk Ujianmu', style: TextStyle(color: Colors.black, fontSize: h2, fontWeight: FontWeight.bold)),
                          Text('Fitur TryOut', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h4, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Wrap(
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CircleAvatar(backgroundColor: Colors.transparent, radius: 40, child: SvgPicture.asset(img[index])),
                                      ),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.pushReplacement(context, FadeRoute1(const BankUserPage()));
                                  } else if (index == 1) {
                                    Navigator.pushReplacement(context, FadeRoute1(const TryoutUserPage()));
                                  } else if (index == 2) {
                                    Navigator.pushReplacement(context, FadeRoute1(const RekomendasiUserPage()));
                                  }
                                },
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
                ),
                //footer
                footerMo(context: context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBottomMo(context: context, homeActive: true),
    );
  }
}
