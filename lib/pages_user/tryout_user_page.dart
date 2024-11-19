import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/pages/login_page.dart';
import 'package:da_administrator/pages_user/bundling_user_page.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/component/nav_buttom.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/pages_user/tryout_public_user_page.dart';
import 'package:da_administrator/pages_user/tryout_saya_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../model/tryout/tryout_model.dart';

class TryoutUserPage extends StatefulWidget {
  final int idPage;

  const TryoutUserPage({super.key, this.idPage = 1});

  @override
  State<TryoutUserPage> createState() => _TryoutUserPageState();
}

class _TryoutUserPageState extends State<TryoutUserPage> {
  bool onLoadingDetail = false;

  // bool onLoading = true;
  var idPage = 1;
  final user = FirebaseAuth.instance.currentUser;

  List<QuestionsModel> allSubtest = [];
  List<String> idAllSubtest = [];

  List<TryoutModel> allTryout = [];
  List<String> idAllTryout = [];

  List<TryoutReviewModel> allReview = [];
  List<String> idAllReview = [];

  var listHeaders = ['TryOut Saya', 'TryOut Dream Academy', 'Bundling TryOut Dream Academy'];
  List<StatefulWidget> listPage = [];

  @override
  Widget build(BuildContext context) {
    bool isLogin = (user != null);
    if (isLogin) {
      if (allSubtest.isNotEmpty && allTryout.isNotEmpty && allReview.isNotEmpty) {
        listPage = [
          TryoutSayaUserPage(idAllTryout: idAllTryout, allTryout: allTryout, idAllSubtest: idAllSubtest, allSubtest: allSubtest, allReview: allReview, idAllReview: idAllReview),
          TryoutPublicUserPage(idAllTryout: idAllTryout, allTryout: allTryout, idAllSubtest: idAllSubtest, allSubtest: allSubtest, allReview: allReview, idAllReview: idAllReview),
          const BundlingUserPage(),
        ];
        if (lebar(context) <= 800) {
          return onMo(context);
        } else {
          return onDesk(context);
        }
      } else {
        return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
      }
    } else {
      if (lebar(context) <= 800) {
        return onMoNotLogin(context);
      } else {
        return onDeskNotLogin(context);
      }
    }
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    idPage = widget.idPage;
    if (user != null) {
      getDataSubtest();
      getDataTryout();
      getDataReview();
    }
    if (allSubtest.isNotEmpty && allTryout.isNotEmpty && allReview.isNotEmpty) {
      // onLoading = false;
      // setState(() => onLoading = false);
    }
    setState(() {});
  }

  void getDataReview() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('review_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.where('isPublic', isEqualTo: true).get();

      // Gabungkan data dan ID
      List<Map<String, dynamic>> combined = querySnapshot.docs.map((doc) {
        return {"data": TryoutReviewModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>), "id": doc.id};
      }).toList();

      // Sorting berdasarkan waktu created
      combined.sort((a, b) => (a["data"] as TryoutReviewModel).created.compareTo((b["data"] as TryoutReviewModel).created));

      // Balik urutan agar yang terbaru berada di awal
      combined = combined.reversed.toList();

      // Pisahkan kembali menjadi dua list
      allReview = combined.map((item) => item["data"] as TryoutReviewModel).toList();
      idAllReview = combined.map((item) => item["id"] as String).toList();
    } catch (e) {
      print('salah getDataReview: $e');
    }
    setState(() {});
  }

  void getDataSubtest() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('subtest_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allSubtest = querySnapshot.docs.map((doc) => QuestionsModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllSubtest = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('salah detail_tryout_user_page data quest: $e');
    }
    setState(() {});
  }

  void getDataTryout() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('tryout_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('created', descending: false).get();

      allTryout = querySnapshot.docs.map((doc) => TryoutModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllTryout = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('salah public user: $e');
    }
    setState(() {});
  }

  Future<void> onRefresh(BuildContext context) async {
    // setState(() => onLoading = true);
    allSubtest = [];
    allTryout = [];
    allReview = [];
    setState(() {});

    getDataSubtest();
    getDataTryout();
    getDataReview();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {});
    // setState(() => onLoading = false);
  }

  Widget onDesk(BuildContext context) {
    // bool isLogin = (user != null);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true, elevation: 0),
      body: Column(
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: () => onRefresh(context), icon: const Icon(Icons.refresh_rounded, color: Colors.black)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    listHeaders.length,
                    (index) => InkWell(
                      onTap: () async {
                        setState(() => onLoadingDetail = true);

                        await Future.delayed(const Duration(milliseconds: 200));
                        final profider = Provider.of<CounterProvider>(context, listen: false);
                        profider.setTitleUserPage('Dream Academy - ${listPage[idPage]}');
                        idPage = index;
                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() => onLoadingDetail = false);
                      },
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: (index == idPage) ? Colors.black : Colors.transparent, width: 2))),
                        child: Text(listHeaders[index], style: TextStyle(color: Colors.black, fontSize: h4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: (onLoadingDetail) ? Center(child: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3))) : listPage[idPage],
          ),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarMo(context: context, elevation: 0),
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: () => onRefresh(context), icon: const Icon(Icons.refresh_rounded, color: Colors.black)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        listHeaders.length,
                        (index) => InkWell(
                          onTap: () async {
                            setState(() => onLoadingDetail = true);
                            final profider = Provider.of<CounterProvider>(context, listen: false);
                            profider.setTitleUserPage('Dream Academy - ${listPage[idPage]}');
                            idPage = index;
                            await Future.delayed(const Duration(milliseconds: 200));
                            setState(() => onLoadingDetail = false);
                          },
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: (index == idPage) ? Colors.black : Colors.transparent, width: 2)),
                            ),
                            child: Text(listHeaders[index], style: TextStyle(color: Colors.black, fontSize: h4)),
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
            child: (onLoadingDetail) ? Center(child: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3))) : listPage[idPage],
          ),
        ],
      ),
      bottomNavigationBar: NavBottomMo(context: context, elevation: 1, featureActive: true),
    );
  }

  Widget onDeskNotLogin(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarDesk(context: context, featureActive: true, elevation: 0),
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
                      width: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(height: 80, width: 80, decoration: BoxDecoration(color: secondary.withOpacity(.5), borderRadius: BorderRadius.circular(100))),
                          SvgPicture.asset('assets/tryout.svg', height: 60)
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.centerLeft,
                            child: Text('TryOut', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 10)),
                          ),
                          Text(
                            'Soal TryOut dibuat oleh alumni PTN terbaik dengan sistem penilaian IRT untuk membantu kamu masuk PTN impian!\n',
                            style: TextStyle(color: Colors.black, fontSize: h3),
                          ),
                          Text('Tunggu apa lagi? Yuk, Daftar Dream Academy!', style: TextStyle(color: Colors.black, fontSize: h3)),
                          const SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, FadeRoute1(const LoginPage()));
                            },
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

  Widget onMoNotLogin(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarMo(context: context, elevation: 0),
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
                      width: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(height: 80, width: 80, decoration: BoxDecoration(color: secondary.withOpacity(.5), borderRadius: BorderRadius.circular(100))),
                          SvgPicture.asset('assets/tryout.svg', height: 60)
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.centerLeft,
                            child: Text('TryOut', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 10)),
                          ),
                          Text(
                            'Soal TryOut dibuat oleh alumni PTN terbaik dengan sistem penilaian IRT untuk membantu kamu masuk PTN impian!\n',
                            style: TextStyle(color: Colors.black, fontSize: h3),
                          ),
                          Text('Tunggu apa lagi? Yuk, Daftar Dream Academy!', style: TextStyle(color: Colors.black, fontSize: h3)),
                          const SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, FadeRoute1(const LoginPage()));
                            },
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
            footerMo(context: context),
          ],
        ),
        bottomNavigationBar: NavBottomMo(context: context, elevation: 1, featureActive: true),
      );
}
