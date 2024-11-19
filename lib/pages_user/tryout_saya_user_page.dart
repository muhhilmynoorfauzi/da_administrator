import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/example.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/profile/nav_profile_user_page.dart';
import 'package:da_administrator/pages_user/tryout_selengkapnya_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:da_administrator/service/component.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TryoutSayaUserPage extends StatefulWidget {
  final List<TryoutModel> allTryout;
  final List<String> idAllTryout;

  final List<QuestionsModel> allSubtest;
  final List<String> idAllSubtest;

  final List<TryoutReviewModel> allReview;
  final List<String> idAllReview;

  const TryoutSayaUserPage({
    super.key,
    required this.idAllTryout,
    required this.allTryout,
    required this.idAllSubtest,
    required this.allSubtest,
    required this.allReview,
    required this.idAllReview,
  });

  @override
  State<TryoutSayaUserPage> createState() => _TryoutSayaUserPageState();
}

class _TryoutSayaUserPageState extends State<TryoutSayaUserPage> {
  final user = FirebaseAuth.instance.currentUser;

  TextEditingController foundController = TextEditingController();

  List<RationalizationUserModel> rationalUser = [];
  List<double> onlyValue = [];

  List<TryoutModel> allTryout = [];
  List<String> idAllTryout = [];

  List<TryoutModel> myTryout = [];
  List<String> idMyTryout = [];

  List<TryoutModel> doneTryout = [];
  List<String> idDoneTryout = [];

  @override
  Widget build(BuildContext context) {
    if (allTryout.isNotEmpty) {
      if (lebar(context) <= 800) {
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
    super.initState();
    if (user != null) {
      getDataRational();
      setDataTryout();
    }
    setState(() {});
  }

  void getDataRational() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('rationalization_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.where('userUID', isEqualTo: user!.uid).get();

      var allRationalUser = querySnapshot.docs.map((doc) => RationalizationUserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      // var idAllRationalUser = querySnapshot.docs.map((doc) => doc.id).toList();

      // Sorting berdasarkan created
      allRationalUser.sort((a, b) => a.created.compareTo(b.created));
      allRationalUser = allRationalUser.reversed.toList();

      //mencari yang punya user
      for (int i = 0; i < allRationalUser.length; i++) {
        if (allRationalUser[i].created.year == DateTime.now().year) {
          rationalUser.add(allRationalUser[i]);
        }
      }

      for (int i = 0; i < rationalUser.length; i++) {
        for (int j = 0; j < rationalUser[i].jurusan.length; j++) {
          onlyValue.add(rationalUser[i].jurusan[j].value);
        }
      }
    } catch (e) {
      print('salah getDataRational : $e');
    }
    setState(() {});
  }

  void setDataTryout() async {
    allTryout = widget.allTryout;
    idAllTryout = widget.idAllTryout;

    for (int i = 0; i < allTryout.length; i++) {
      if (allTryout[i].claimedUid.isNotEmpty && allTryout[i].public) {
        for (int j = 0; j < allTryout[i].claimedUid.length; j++) {
          if (allTryout[i].claimedUid[j].userUID == user!.uid) {
            if (!(allTryout[i].phase)) {
              myTryout.add(allTryout[i]);
              idMyTryout.add(idAllTryout[i]);
            } else if (allTryout[i].phase) {
              doneTryout.add(allTryout[i]);
              idDoneTryout.add(idAllTryout[i]);
            }
          }
        }
      }
    }
    setState(() {});
  }

  void selengkapnya(BuildContext context, {required List<TryoutModel> allTryout, required List<String> idAllTryout}) {
    Navigator.push(
      context,
      FadeRoute1(
        TryoutSelengkapnyaUserPage(
          allTryout: allTryout,
          idAllTryout: idAllTryout,
          allSubtest: widget.allSubtest,
          idAllSubtest: widget.idAllSubtest,
          allReview: widget.allReview,
          idAllReview: widget.idAllReview,
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(dateTime);
  }

  Widget cardTryout({
    required String imageUrl,
    required String title,
    required String desk,
    required bool readyOnFree,
    required bool claimed,
    required bool phase,
    required VoidCallback onTap,
    required DateTime started,
    required DateTime ended,
  }) {
    return SizedBox(
      width: 495,
      height: 170,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                      Text(
                        '${formatDateTime(started)} - ${formatDateTime(ended)}',
                        style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(desk, style: TextStyle(fontSize: h4, color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 3, textAlign: TextAlign.justify),
                      const Expanded(child: SizedBox()),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                              decoration: BoxDecoration(color: claimed ? primary : secondary, borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                claimed ? 'Joined' : 'Process',
                                style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            if (phase)
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(50)),
                                child: Text('Tryout Selesai', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            color: primary,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grafik Nilai Try Out UTBK', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                Text('Lihat Progresmu disini', style: TextStyle(color: Colors.white, fontSize: h4)),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: 1000,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(child: _LineChart(rationalUser: rationalUser, onlyValue: onlyValue)),
                        if (rationalUser.isNotEmpty)
                          SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text('Jurusan', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, color: Colors.pink, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                    Expanded(
                                      child: Text(rationalUser.first.jurusan[0].namaJurusan, style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 30)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, color: Colors.green, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                    Expanded(
                                      child: Text(rationalUser.first.jurusan[1].namaJurusan, style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 30)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, color: Colors.yellow, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                    Expanded(
                                      child: Text(rationalUser.first.jurusan[2].namaJurusan, style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 30)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, color: Colors.blue, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                    Expanded(
                                      child: Text(rationalUser.first.jurusan[3].namaJurusan, style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 30)
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Belum Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (myTryout.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: OutlinedButton.icon(
                            onPressed: () => selengkapnya(context, idAllTryout: idMyTryout, allTryout: myTryout),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(Icons.keyboard_double_arrow_right, color: primary, size: 20),
                            label: Text('Selengkapnya', style: TextStyle(fontSize: h4, color: primary)),
                          ),
                        ),
                    ],
                  ),
                  Text('Lihat somua TO kamu milikl korjakan TO nya sokarang!', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      myTryout.length,
                      (index) {
                        var approval = false;
                        for (int i = 0; i < myTryout[index].claimedUid.length; i++) {
                          if (myTryout[index].claimedUid[i].userUID == user!.uid) {
                            approval = myTryout[index].claimedUid[i].approval;
                          }
                        }
                        return cardTryout(
                          imageUrl: myTryout[index].image,
                          title: myTryout[index].toName,
                          desk: myTryout[index].desk,
                          readyOnFree: myTryout[index].showFreeMethod,
                          claimed: approval,
                          phase: myTryout[index].phase,
                          ended: myTryout[index].ended,
                          started: myTryout[index].started,
                          onTap: () {
                            Navigator.push(
                              context,
                              FadeRoute1(
                                DetailMytryoutUserPage(
                                  idMyTryout: idMyTryout[index],
                                  myTryout: myTryout[index],
                                  approval: approval,
                                  allSubtest: widget.allSubtest,
                                  idAllSubtest: widget.idAllSubtest,
                                  allReview: widget.allReview,
                                  idAllReview: widget.idAllReview,
                                  rationalUser: rationalUser,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (doneTryout.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: OutlinedButton.icon(
                            onPressed: () => selengkapnya(context, allTryout: doneTryout, idAllTryout: idDoneTryout),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(Icons.keyboard_double_arrow_right, color: primary, size: 20),
                            label: Text('Selengkapnya', style: TextStyle(fontSize: h4, color: primary)),
                          ),
                        ),
                    ],
                  ),
                  Text('Lihat semua TryOut yang telah kamu ikuti', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      doneTryout.length,
                      (index) {
                        var approval = false;

                        for (int i = 0; i < doneTryout[index].claimedUid.length; i++) {
                          if (doneTryout[index].claimedUid[i].userUID == user!.uid) {
                            approval = doneTryout[index].claimedUid[i].approval;
                          }
                        }
                        return cardTryout(
                          imageUrl: doneTryout[index].image,
                          title: doneTryout[index].toName,
                          desk: doneTryout[index].desk,
                          readyOnFree: doneTryout[index].showFreeMethod,
                          claimed: approval,
                          phase: doneTryout[index].phase,
                          started: doneTryout[index].started,
                          ended: doneTryout[index].ended,
                          onTap: () {
                            Navigator.push(
                              context,
                              FadeRoute1(
                                DetailMytryoutUserPage(
                                  idMyTryout: idDoneTryout[index],
                                  myTryout: doneTryout[index],
                                  approval: approval,
                                  allSubtest: widget.allSubtest,
                                  idAllSubtest: widget.idAllSubtest,
                                  allReview: widget.allReview,
                                  idAllReview: widget.idAllReview,
                                  rationalUser: rationalUser,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          footerDesk(context: context),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            color: primary,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Grafik Nilai Try Out UTBK', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Lihat Progresmu disini', style: TextStyle(color: Colors.white, fontSize: h4)),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 700,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(child: _LineChart(rationalUser: rationalUser, onlyValue: onlyValue)),
                          if (rationalUser.isNotEmpty)
                            SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text('Jurusan', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                    children: [
                                      Container(height: 10, width: 10, color: Colors.pink, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                      Expanded(
                                        child: Text(
                                          rationalUser.first.jurusan[0].namaJurusan,
                                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 30)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(height: 10, width: 10, color: Colors.green, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                      Expanded(
                                        child: Text(
                                          rationalUser.first.jurusan[1].namaJurusan,
                                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 30)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(height: 10, width: 10, color: Colors.yellow, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                      Expanded(
                                        child: Text(
                                          rationalUser.first.jurusan[2].namaJurusan,
                                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 30)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(height: 10, width: 10, color: Colors.blue, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                      Expanded(
                                        child: Text(
                                          rationalUser.first.jurusan[3].namaJurusan,
                                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 30)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 30),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Belum Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (myTryout.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: OutlinedButton.icon(
                            onPressed: () => selengkapnya(context, allTryout: myTryout, idAllTryout: idMyTryout),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(Icons.keyboard_double_arrow_right, color: primary, size: 20),
                            label: Text('Selengkapnya', style: TextStyle(fontSize: h4, color: primary)),
                          ),
                        ),
                    ],
                  ),
                  Text('Lihat somua TO kamu milikl korjakan TO nya sokarang!', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      myTryout.length,
                      (index) {
                        var approval = false;
                        for (int i = 0; i < myTryout[index].claimedUid.length; i++) {
                          if (myTryout[index].claimedUid[i].userUID == user!.uid) {
                            approval = myTryout[index].claimedUid[i].approval;
                          }
                        }
                        return cardTryout(
                          imageUrl: myTryout[index].image,
                          title: myTryout[index].toName,
                          desk: myTryout[index].desk,
                          readyOnFree: myTryout[index].showFreeMethod,
                          claimed: approval,
                          phase: myTryout[index].phase,
                          ended: myTryout[index].ended,
                          started: myTryout[index].started,
                          onTap: () {
                            Navigator.push(
                              context,
                              FadeRoute1(
                                DetailMytryoutUserPage(
                                  idMyTryout: idMyTryout[index],
                                  myTryout: myTryout[index],
                                  approval: approval,
                                  allSubtest: widget.allSubtest,
                                  idAllSubtest: widget.idAllSubtest,
                                  allReview: widget.allReview,
                                  idAllReview: widget.idAllReview,
                                  rationalUser: rationalUser,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 50),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (doneTryout.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: OutlinedButton.icon(
                            onPressed: () => selengkapnya(context, idAllTryout: idDoneTryout, allTryout: doneTryout),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(Icons.keyboard_double_arrow_right, color: primary, size: 20),
                            label: Text('Selengkapnya', style: TextStyle(fontSize: h4, color: primary)),
                          ),
                        ),
                    ],
                  ),
                  Text('Lihat semua TryOut yang telah kamu ikuti', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      doneTryout.length,
                      (index) {
                        var approval = false;

                        for (int i = 0; i < doneTryout[index].claimedUid.length; i++) {
                          if (doneTryout[index].claimedUid[i].userUID == user!.uid) {
                            approval = doneTryout[index].claimedUid[i].approval;
                          }
                        }
                        return cardTryout(
                          imageUrl: doneTryout[index].image,
                          title: doneTryout[index].toName,
                          desk: doneTryout[index].desk,
                          readyOnFree: doneTryout[index].showFreeMethod,
                          claimed: approval,
                          phase: doneTryout[index].phase,
                          started: doneTryout[index].started,
                          ended: doneTryout[index].ended,
                          onTap: () {
                            Navigator.push(
                              context,
                              FadeRoute1(
                                DetailMytryoutUserPage(
                                  idMyTryout: idDoneTryout[index],
                                  myTryout: doneTryout[index],
                                  approval: approval,
                                  allSubtest: widget.allSubtest,
                                  idAllSubtest: widget.idAllSubtest,
                                  allReview: widget.allReview,
                                  idAllReview: widget.idAllReview,
                                  rationalUser: rationalUser,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          footerMo(context: context)
        ],
      ),
    );
  }
}

class _LineChart extends StatefulWidget {
  const _LineChart({required this.rationalUser, required this.onlyValue});

  final List<RationalizationUserModel> rationalUser;
  final List<double> onlyValue;

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  final imageVec4 = 'assets/vec4.png';
  List<RationalizationUserModel> rationalUser = [];

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    rationalUser = widget.rationalUser;
  }

  @override
  Widget build(BuildContext context) {
    // if (false) {
    if (rationalUser.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: LineChart(sampleData1, duration: const Duration(milliseconds: 200)),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(imageVec4, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              Text('Anda belum mengatur target Jurusan Anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h4)),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.push(context, FadeRoute1(const NavProfileUserPage())),
                child: Text('Ubah Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h4)),
              )
            ],
          ),
        ),
      );
    }
  }

  LineChartData get sampleData1 {
    double maxNumber = widget.onlyValue.reduce((current, next) => current > next ? current : next);
    return LineChartData(
        minX: 0,
        maxX: 12 + 1,
        maxY: maxNumber + 3,
        minY: 0,
        gridData: const FlGridData(show: true),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(getTooltipColor: (touchedSpot) => Colors.black.withOpacity(0)),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35, interval: 1, getTitlesWidget: bottomTitleWidgets)),
          rightTitles: const AxisTitles(sideTitles: SideTitles()),
          topTitles: const AxisTitles(sideTitles: SideTitles()),
          leftTitles: AxisTitles(sideTitles: SideTitles(getTitlesWidget: leftTitleWidgets, showTitles: true, interval: 1, reservedSize: 40)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.8), width: 2),
            left: const BorderSide(color: Colors.transparent),
            right: const BorderSide(color: Colors.transparent),
            top: const BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.pink,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: List.generate(
              rationalUser.length,
              (index1) {
                return FlSpot(rationalUser[index1].created.month.toDouble(), rationalUser[index1].jurusan[0].value);
              },
            ),
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: List.generate(
              rationalUser.length,
              (index1) {
                return FlSpot(rationalUser[index1].created.month.toDouble(), rationalUser[index1].jurusan[1].value);
              },
            ),
          ),
          LineChartBarData(
            isCurved: true,
            barWidth: 2,
            color: Colors.orangeAccent,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: List.generate(
              rationalUser.length,
              (index1) {
                return FlSpot(rationalUser[index1].created.month.toDouble(), rationalUser[index1].jurusan[2].value);
              },
            ),
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: List.generate(
              rationalUser.length,
              (index1) {
                return FlSpot(rationalUser[index1].created.month.toDouble(), rationalUser[index1].jurusan[3].value);
              },
            ),
          ),
        ]);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = '$value';
    return Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5), textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text = Text(value.toDouble().toString(), style: TextStyle(fontSize: h5));
    switch (value.toInt()) {
      case 1:
        text = Text('Jan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 2:
        text = Text('Feb', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 3:
        text = Text('Mar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 4:
        text = Text('Apr', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 5:
        text = Text('May', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 6:
        text = Text('Jun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 7:
        text = Text('Jul', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 8:
        text = Text('Aug', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 9:
        text = Text('Sep', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 10:
        text = Text('Oct', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 11:
        text = Text('Nov', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      case 12:
        text = Text('Dec', style: TextStyle(fontWeight: FontWeight.bold, fontSize: h5));
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
