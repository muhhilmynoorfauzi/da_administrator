import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/pay_coin_user_page.dart';
import 'package:da_administrator/pages_user/pay_ewallet_user_page.dart';
import 'package:da_administrator/pages_user/pay_free_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailTryoutUserPage extends StatefulWidget {
  const DetailTryoutUserPage({super.key});

  @override
  State<DetailTryoutUserPage> createState() => _DetailTryoutUserPageState();
}

class _DetailTryoutUserPageState extends State<DetailTryoutUserPage> {
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';
  var isLogin = true;
  final imageVec2 = 'assets/vec2.png';
  final imageVec4 = 'assets/vec4.png';
  var jurusanNotReady = false;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
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
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: SizedBox(
              width: 1000,
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
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 200,
                    width: 300,
                    margin: const EdgeInsets.symmetric(vertical: 20),
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
                ],
              ),
            ),
          ),
          //Rincian Test
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: SizedBox(
              width: 1000,
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
          ),
          //Rincian Test
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (jurusanNotReady)
                      ? Container(
                          height: 300,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CachedNetworkImage(
                                    imageUrl: imageVec2,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Target yang diinginkan', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      children: List.generate(
                                        4,
                                        (index) {
                                          var jurusan = ['Teknik Informatika', 'Matematika', 'Sasta Inggris', 'Desain Komunikasi Visual'];
                                          var univ = ['Universitas Hasanudin', 'Universitas Hasanudin', 'Universitas Muslim Indonesia', 'Universitas Muslim Indonesia'];
                                          return Container(
                                            width: 300,
                                            padding: const EdgeInsets.all(3),
                                            child: Row(
                                              children: [
                                                Icon(Icons.check_circle, color: primary, size: 30),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        jurusan[index],
                                                        style: TextStyle(fontSize: h4, color: primary, fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      Text(
                                                        univ[index],
                                                        style: TextStyle(fontSize: h5, color: Colors.black, fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      width: 450,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(color: primary.withOpacity(.1), borderRadius: BorderRadius.circular(50)),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info, color: primary),
                                          const SizedBox(width: 10),
                                          Text('Jurusan yang kamu pilih akan mempengaruhi progressmu loh', style: TextStyle(fontSize: h5 + 3, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Column(
                                      children: [
                                        Text('Ingin mengubah target yang kamu atur sebelumnya?', style: TextStyle(fontSize: h4, color: Colors.black)),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                                            child: Text('Ubah Sekarang', style: TextStyle(fontSize: h4, color: primary)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            height: 150,
                            width: 700,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                      imageUrl: imageVec4,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Anda belum mengatur target Jurusan Anda',
                                        style: TextStyle(fontSize: h2, color: Colors.black, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Expanded(child: SizedBox(width: 10)),
                                      Text('Ingin mengubah target yang kamu atur sebelumnya?', style: TextStyle(fontSize: h4, color: Colors.black)),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 30,
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                                          child: Text('Ubah Sekarang', style: TextStyle(fontSize: h4, color: primary)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      onPressed: () => showDaftarSekarang(context: context),
                      style: TextButton.styleFrom(backgroundColor: primary),
                      child: Text('Daftar Sekarang', style: TextStyle(fontSize: h4, color: Colors.white)),
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
