import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/pay_coin_user_page.dart';
import 'package:da_administrator/pages_user/pay_ewallet_user_page.dart';
import 'package:da_administrator/pages_user/pay_free_user_page.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/question/result_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailMytryoutUserPage extends StatefulWidget {
  const DetailMytryoutUserPage({super.key});

  @override
  State<DetailMytryoutUserPage> createState() => _DetailMytryoutUserPageState();
}

class _DetailMytryoutUserPageState extends State<DetailMytryoutUserPage> {
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';
  var isLogin = true;
  var isComplite = true;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  void onPressMulai(BuildContext context) {
    Navigator.pushReplacement(context, FadeRoute1(const NavQuestUserPage(minutes: 1)));
  }

  void onPressResult(BuildContext context) {
    Navigator.pushReplacement(context, FadeRoute1(const ResultQuestUserPage()));
  }

  Future<void> showDaftarSekarang({required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.all(20),
              content: SizedBox(
                width: 700,
                child: ListView(
                  children: [
                    // Keluar
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.black)),
                    ),
                    // detail keuntungan
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 350,
                            child: Column(
                              children: List.generate(
                                6,
                                (index) {
                                  var title = ['', 'Akses semua modul', 'Hasil nilai benar dan salah', 'Pembahasan soal', 'Rasionalisasi PTS', 'Report TO Analisis'];
                                  return Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: index != 5 ? Colors.black.withOpacity(.1) : Colors.transparent)),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(title[index], style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                6,
                                (index) {
                                  var icon = [Icons.info, Icons.check_circle, Icons.check_circle, Icons.check_circle, Icons.check_circle, Icons.check_circle];
                                  return Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: index != 5 ? Colors.black.withOpacity(.1) : Colors.transparent))),
                                      alignment: Alignment.center,
                                      child: index == 0
                                          ? Text('Premium', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))
                                          : Icon(icon[index], color: (icon[index] == Icons.cancel) ? Colors.red : primary),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: secondary.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                6,
                                (index) {
                                  var icon = [Icons.info, Icons.check_circle, Icons.check_circle, Icons.cancel, Icons.cancel, Icons.cancel];
                                  return Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: index != 5 ? Colors.black.withOpacity(.1) : Colors.transparent))),
                                      alignment: Alignment.center,
                                      child: index == 0
                                          ? Text('Gratis', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))
                                          : Icon(icon[index], color: (icon[index] == Icons.cancel) ? Colors.red : primary),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Pilihan Pembayaran
                    Center(
                      child: Container(
                        height: 110,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pakai TryOut Gratis', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                            Text('(Syarat dan ketentuan berlaku)', style: TextStyle(color: Colors.black, fontSize: h4)),
                            SizedBox(
                              height: 35,
                              width: 250,
                              child: TextButton(
                                onPressed: () {
                                  context.read<CounterProvider>().setTitleUserPage('Dream Academy - Payment');
                                  Navigator.push(context, FadeRoute1(const PayFreeUserPage()));
                                },
                                style: TextButton.styleFrom(backgroundColor: primary),
                                child: Text('Daftar', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 110,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pakai Dream Academy Coin', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text('4 DA Coin', style: TextStyle(color: Colors.black, fontSize: h4)),
                              SizedBox(
                                height: 35,
                                width: 250,
                                child: TextButton(
                                  onPressed: () {
                                    context.read<CounterProvider>().setTitleUserPage('Dream Academy - Payment');
                                    Navigator.push(context, FadeRoute1(const PayCoinUserPage()));
                                  },
                                  style: TextButton.styleFrom(backgroundColor: primary),
                                  child: Text('Gunakan', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 110,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pakai E-Wallet', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text('Rp 20.000', style: TextStyle(color: Colors.black, fontSize: h4)),
                              SizedBox(
                                height: 35,
                                width: 250,
                                child: TextButton(
                                  onPressed: () {
                                    context.read<CounterProvider>().setTitleUserPage('Dream Academy - Payment');
                                    Navigator.push(context, FadeRoute1(const PayEwalletUserPage()));
                                  },
                                  style: TextButton.styleFrom(backgroundColor: primary),
                                  child: Text('Bayar', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //
                    Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: Text('Lebih mudah dengan Bundling TryOut Dream Academy', style: TextStyle(color: primary, fontSize: h4, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.zero,
            );
          },
        );
      },
    );
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true, isLogin: isLogin),
      body: ListView(
        children: [
          //tombol kembali
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              width: 1000,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                      child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                    ),
                  ),
                  Text('TryOut Saya', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
                ],
              ),
            ),
          ),
          //Image dan deskripsi
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Container(
              width: 1000,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: urlImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Try Out UTBK 2024 #9 - SNBT', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                              Text('20 Desember 2024 12:00 WITA s.d. 24 Desember 2024', style: TextStyle(fontSize: h4, color: Colors.black)),
                              const SizedBox(height: 30),
                              Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy"
                                " text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
                                "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
                                "It was popularised in the 1960s w",
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                              ),
                              const Expanded(child: SizedBox()),
                              Row(
                                children: [
                                  if (isComplite)
                                    SizedBox(
                                      height: 30,
                                      child: OutlinedButton(
                                        onPressed: () => onPressMulai(context),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: primary),
                                          padding: const EdgeInsets.symmetric(horizontal: 30),
                                          backgroundColor: primary,
                                        ),
                                        child: Text('Mulai Mengerjakan', style: TextStyle(fontSize: h4, color: Colors.white)),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    height: 30,
                                    child: OutlinedButton(
                                      onPressed: () => onPressResult(context),
                                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), padding: const EdgeInsets.symmetric(horizontal: 30)),
                                      child: Text('Detail Pengerjaan', style: TextStyle(fontSize: h4, color: Colors.black)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          //Rincian Test
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SizedBox(
              width: 1000,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //fase
                  Container(
                    height: 200,
                    width: 300,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) {
                          var icon = [Icons.calendar_month_rounded, Icons.timer, Icons.note_alt_rounded];
                          var title = ['Fase TO', 'Total Waktu', 'Jumlah Soal'];
                          var deks = ['Selesai', '95 Menit', '155 Soal'];
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: index != 2 ? Colors.black.withOpacity(.1) : Colors.transparent))),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                    child: Icon(icon[index], color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(title[index], style: TextStyle(fontSize: h4, color: Colors.black)),
                                  const Expanded(child: SizedBox()),
                                  Text(deks[index], style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: primary, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('TPS', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            4,
                            (index) {
                              var title = ['Kemampuan Penalaran Umum', 'Pengetahuan dan Pemahaman Umum', 'Kemampuan Memahami Bacaan dan Menulis', 'Pengetahuan Kuantitatif'];
                              var time = ['30 Menit', '30 Menit', '30 Menit', '30 Menit'];
                              var quest = ['30 Soal', '30 Soal', '30 Soal', '30 Soal'];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(title[index], style: TextStyle(fontSize: h4, color: Colors.black)),
                                    Text('${time[index]} | ${quest[index]}', style: TextStyle(fontSize: h5 + 1, fontWeight: FontWeight.bold, color: primary))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: primary, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('Test Literasi', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            4,
                            (index) {
                              var title = ['Kemampuan Penalaran Umum', 'Pengetahuan dan Pemahaman Umum', 'Kemampuan Memahami Bacaan dan Menulis', 'Pengetahuan Kuantitatif'];
                              var time = ['30 Menit', '30 Menit', '30 Menit', '30 Menit'];
                              var quest = ['30 Soal', '30 Soal', '30 Soal', '30 Soal'];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(title[index], style: TextStyle(fontSize: h4, color: Colors.black)),
                                    Text('${time[index]} | ${quest[index]}', style: TextStyle(fontSize: h5 + 1, fontWeight: FontWeight.bold, color: primary))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
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

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
