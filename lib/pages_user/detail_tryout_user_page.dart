import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/pay_coin_user_page.dart';
import 'package:da_administrator/pages_user/pay_ewallet_user_page.dart';
import 'package:da_administrator/pages_user/pay_free_user_page.dart';
import 'package:da_administrator/pages_user/profile/nav_profile_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/show_image_page.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailTryoutUserPage extends StatefulWidget {
  final String idTryout;
  final TryoutModel tryoutUser;
  final List<QuestionsModel> allSubtest;
  final List<String> idAllSubtest;
  final List<TryoutReviewModel> allReview;
  final List<String> idAllReview;

  const DetailTryoutUserPage({
    super.key,
    required this.idTryout,
    required this.tryoutUser,
    required this.allSubtest,
    required this.idAllSubtest,
    required this.allReview,
    required this.idAllReview,
  });

  @override
  State<DetailTryoutUserPage> createState() => _DetailTryoutUserPageState();
}

class _DetailTryoutUserPageState extends State<DetailTryoutUserPage> {
  // bool isLogin = true;
  final imageVec2 = 'assets/vec2.png';
  final imageVec4 = 'assets/vec4.png';
  var claimed = false;
  final user = FirebaseAuth.instance.currentUser;

  ProfileUserModel? profile;

  TryoutModel? tryoutUser;
  List<QuestionsModel> allSubtest = [];
  List<String> idAllSubtest = [];

  List<TryoutReviewModel> listReviewThisTryout = [];

  @override
  Widget build(BuildContext context) {
    if (tryoutUser != null) {
      if (lebar(context) <= 700) {
        return onMo(context);
      } else {
        return onDesk(context);
      }
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
    }
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    final profider = Provider.of<CounterProvider>(context, listen: false);
    profile = profider.getProfile;
    setDataQuestion();
    setDataReview();
    allSubtest = widget.allSubtest;
    idAllSubtest = widget.idAllSubtest;
    tryoutUser = widget.tryoutUser;
  }

  void setDataReview() async {
    List<TryoutReviewModel> listAll = widget.allReview;
    var idListAll = widget.idAllReview;

    for (int i = 0; i < listAll.length; i++) {
      if (listAll[i].idTryOut == widget.idTryout) {
        listReviewThisTryout.add(listAll[i]);
      }
    }

    setState(() {});
  }

  String formatMinutes(double seconds) {
    double minutes = seconds / 60; // Konversi detik ke menit
    return minutes.toStringAsFixed(1); // Mengembalikan nilai string dengan 1 angka di belakang koma
  }

  void setDataQuestion() async {
    setState(() {});
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');

    return formatter.format(dateTime);
  }

  void handleBackNavigation(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(context, FadeRoute1(const TryoutUserPage()));
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true),
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
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: TextButton(
                      onPressed: () => handleBackNavigation(context),
                      style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                      child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                    ),
                  ),
                  Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
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
                        child: InkWell(
                          onTap: () => Navigator.push(context, FadeRoute1(ShowImagePage(image: tryoutUser!.image))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: tryoutUser!.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    tryoutUser!.toName,
                                    style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                if (claimed) Icon(Icons.check_circle_rounded, color: primary, size: 15),
                                const SizedBox(width: 5),
                                if (claimed) Text('JOINED', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: primary)),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Text(
                              '${formatDateTime(tryoutUser!.started)} s.d ${formatDateTime(tryoutUser!.ended)}',
                              style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              tryoutUser!.desk,
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
                          var deks = [
                            (tryoutUser!.phase) ? 'Selesai' : 'Belum Selesai',
                            '${formatMinutes(tryoutUser!.totalTime)} Menit',
                            '${tryoutUser!.numberQuestions} Soal',
                          ];
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
                children: List.generate(
                  tryoutUser!.listTest.length,
                  (index0) {
                    var test = tryoutUser!.listTest[index0];
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: primary, size: 15),
                            const SizedBox(width: 10),
                            Expanded(child: Text(test.nameTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            test.listSubtest.length,
                            (index1) {
                              String jumlahSoal = '0';
                              var subTest = test.listSubtest[index1];
                              for (int i = 0; i < idAllSubtest.length; i++) {
                                if (idAllSubtest[i] == subTest.idQuestions) {
                                  jumlahSoal = '${allSubtest[i].listQuestions.length}';
                                }
                              }
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subTest.nameSubTest, style: TextStyle(fontSize: h4, color: Colors.black)),
                                    Text(
                                      '${formatMinutes(subTest.timeMinute)} Menit | $jumlahSoal Soal',
                                      style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          //

          if (!claimed)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: SizedBox(
                width: 1000,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (profile != null)
                        ? (profile!.listPlan.every((element) => element.jurusan.isEmpty))
                            ? JurusanEmpty(context)
                            : JurusanNotEmpty(context)
                        : JurusanEmpty(context),
                    if (profile != null)
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

          //
          if (listReviewThisTryout.isNotEmpty)
            Center(
              child: SizedBox(
                width: 1000,
                child: Text('Review Tryout', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          if (listReviewThisTryout.isNotEmpty)
            Center(
              child: SizedBox(
                height: 200,
                width: 1000,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listReviewThisTryout.length,
                  itemBuilder: (context, index) => SizedBox(
                    width: 350,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: listReviewThisTryout[index].image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listReviewThisTryout[index].userName,
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      formatDateTime(listReviewThisTryout[index].created),
                                      style: TextStyle(color: Colors.black, fontSize: h4 - 2),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(listReviewThisTryout[index].rating, (index) => const Icon(Icons.star, color: Colors.orange, size: 15)),
                            ),
                            Text(
                              listReviewThisTryout[index].text,
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              textAlign: TextAlign.justify,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
          //tombol kembali
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () => handleBackNavigation(context),
                  style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                  child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                ),
              ),
              Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
            ],
          ),

          //Image
          SizedBox(
            height: 200,
            child: InkWell(
              onTap: () => Navigator.push(context, FadeRoute1(ShowImagePage(image: tryoutUser!.image))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: tryoutUser!.image,
                    fit: BoxFit.fitHeight,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          //deskripsi
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
                      Expanded(
                        child: Text(
                          tryoutUser!.toName,
                          style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (claimed) Icon(Icons.check_circle_rounded, color: primary, size: 15),
                      const SizedBox(width: 5),
                      if (claimed) Text('JOINED', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: primary)),
                      const SizedBox(width: 5),
                    ],
                  ),
                  Text(
                    '${formatDateTime(tryoutUser!.started)} s.d ${formatDateTime(tryoutUser!.ended)}',
                    style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    tryoutUser!.desk,
                    style: TextStyle(fontSize: h4, color: Colors.black),
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
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
                          var deks = [
                            (tryoutUser!.phase) ? 'Selesai' : 'Belum Selesai',
                            '${formatMinutes(tryoutUser!.totalTime)} Menit',
                            '${tryoutUser!.numberQuestions} Soal',
                          ];
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
                children: List.generate(
                  tryoutUser!.listTest.length,
                  (index0) {
                    var test = tryoutUser!.listTest[index0];
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: primary, size: 15),
                            const SizedBox(width: 10),
                            Expanded(child: Text(test.nameTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            test.listSubtest.length,
                            (index1) {
                              String jumlahSoal = '0';
                              var subTest = test.listSubtest[index1];
                              for (int i = 0; i < idAllSubtest.length; i++) {
                                if (idAllSubtest[i] == subTest.idQuestions) {
                                  jumlahSoal = '${allSubtest[i].listQuestions.length}';
                                }
                              }
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subTest.nameSubTest, style: TextStyle(fontSize: h4, color: Colors.black)),
                                    Text(
                                      '${formatMinutes(subTest.timeMinute)} Menit | $jumlahSoal Soal',
                                      style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // atur jurusan
          if (!claimed)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: SizedBox(
                width: 1000,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (profile != null)
                        ? (profile!.listPlan.every((element) => element.jurusan.isEmpty))
                            ? JurusanEmpty(context)
                            : JurusanNotEmpty(context)
                        : JurusanEmpty(context),
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
          footerMo(context: context)
        ],
      ),
    );
  }

  Widget JurusanNotEmpty(BuildContext context) {
    bool onMo = (lebar(context) <= 700);
    if (onMo) {
      return Container(
        // height: 500,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imageVec2, fit: BoxFit.cover, width: lebar(context) * .7),
              ),
            ),
            const SizedBox(height: 30),
            Text('Target yang diinginkan', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              children: List.generate(
                4,
                (index) {
                  var jurusan = List.generate(profile!.listPlan.length, (index) => profile!.listPlan[index].jurusan);
                  var univ = List.generate(profile!.listPlan.length, (index) => profile!.listPlan[index].universitas);
                  return Container(
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Icon(
                          (jurusan[index].isEmpty) ? Icons.cancel : Icons.check_circle,
                          color: (jurusan[index].isEmpty) ? secondary : primary,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (jurusan[index].isEmpty) ? '-' : jurusan[index],
                                style: TextStyle(fontSize: h4, color: primary, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                (univ[index].isEmpty) ? '-' : univ[index],
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
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                // width: 450,
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
            ),
            const SizedBox(height: 30),
            Text('Ingin mengubah target yang kamu atur sebelumnya?', style: TextStyle(fontSize: h4, color: Colors.black), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                child: Text('Ubah Sekarang', style: TextStyle(fontSize: h4, color: primary)),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 350,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(aspectRatio: 1, child: Image.asset(imageVec2, fit: BoxFit.cover)),
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
                        var jurusan = List.generate(profile!.listPlan.length, (index) => profile!.listPlan[index].jurusan);
                        var univ = List.generate(profile!.listPlan.length, (index) => profile!.listPlan[index].universitas);
                        return Container(
                          width: 300,
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(
                                (jurusan[index].isEmpty) ? Icons.cancel : Icons.check_circle,
                                color: (jurusan[index].isEmpty) ? secondary : primary,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (jurusan[index].isEmpty) ? '-' : jurusan[index],
                                      style: TextStyle(fontSize: h4, color: primary, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      (univ[index].isEmpty) ? '-' : univ[index],
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
      );
    }
  }

  Widget JurusanEmpty(BuildContext context) {
    bool onMo = (lebar(context) <= 700);
    if (onMo) {
      return Center(
        child: Container(
          // height: 180,
          width: 700,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imageVec4, fit: BoxFit.cover, width: lebar(context) * .7),
              ),
              const SizedBox(height: 30),
              Text(
                'Anda belum mengatur target Jurusan Anda',
                style: TextStyle(fontSize: h2, color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text('Ingin mengubah target yang kamu atur sebelumnya?', style: TextStyle(fontSize: h4, color: Colors.black), textAlign: TextAlign.center),
              SizedBox(
                height: 40,
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
      );
    } else {
      return Center(
        child: Container(
          height: 180,
          width: 700,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(aspectRatio: 1, child: Image.asset(imageVec4, fit: BoxFit.cover)),
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
      );
    }
  }

  Future<void> showDaftarSekarang({required BuildContext context}) async {
    final profider = Provider.of<CounterProvider>(context, listen: false);
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
              contentPadding: const EdgeInsets.all(10),
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
                    // Pilihan Pembayaran Gratis
                    if (tryoutUser!.showFreeMethod)
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
                                    profider.setTitleUserPage('Dream Academy - Payment');
                                    Navigator.push(context, FadeRoute1(PayFreeUserPage(idTryout: widget.idTryout, tryoutUser: tryoutUser)));
                                  },
                                  style: TextButton.styleFrom(backgroundColor: primary),
                                  child: Text('Daftar', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (lebar(context) <= 700)
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
                              Text('Pakai Dream Academy Coin', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text('4 DA Coin', style: TextStyle(color: Colors.black, fontSize: h4)),
                              SizedBox(
                                height: 35,
                                width: 250,
                                child: TextButton(
                                  onPressed: () {
                                    profider.setTitleUserPage('Dream Academy - Payment');
                                    Navigator.push(context, FadeRoute1(PayCoinUserPage(idTryout: widget.idTryout, tryoutUser: tryoutUser)));
                                  },
                                  style: TextButton.styleFrom(backgroundColor: primary),
                                  child: Text('Gunakan', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (lebar(context) <= 700)
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
                              Text('Pakai E-Wallet', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text(
                                NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(tryoutUser!.listPrice.first),
                                style: TextStyle(color: Colors.black, fontSize: h4),
                              ),
                              SizedBox(
                                height: 35,
                                width: 250,
                                child: TextButton(
                                  onPressed: () {
                                    profider.setTitleUserPage('Dream Academy - Payment');
                                    Navigator.push(context, FadeRoute1(PayEwalletUserPage(idTryout: widget.idTryout, tryoutUser: tryoutUser)));
                                  },
                                  style: TextButton.styleFrom(backgroundColor: primary),
                                  child: Text('Bayar', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!(lebar(context) <= 700))
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
                                      profider.setTitleUserPage('Dream Academy - Payment');
                                      Navigator.push(context, FadeRoute1(PayCoinUserPage(idTryout: widget.idTryout, tryoutUser: tryoutUser)));
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
                                Text(
                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(tryoutUser!.listPrice.first),
                                  style: TextStyle(color: Colors.black, fontSize: h4),
                                ),
                                SizedBox(
                                  height: 35,
                                  width: 250,
                                  child: TextButton(
                                    onPressed: () {
                                      profider.setTitleUserPage('Dream Academy - Payment');
                                      Navigator.push(context, FadeRoute1(PayEwalletUserPage(idTryout: widget.idTryout, tryoutUser: tryoutUser)));
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
}
